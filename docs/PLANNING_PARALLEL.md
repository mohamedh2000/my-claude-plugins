# Planning Parallel: Deep Dive

A memory-safe, fault-tolerant parallel execution system for Claude Code. This document explains the architecture, error handling, and recovery mechanisms that make `/planning-parallel` robust.

---

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [The Three-File Memory System](#the-three-file-memory-system)
- [Parallel Execution Flow](#parallel-execution-flow)
- [Error Handling & Recovery](#error-handling--recovery)
- [Sub-Agent Handoffs](#sub-agent-handoffs)
- [Token Exhaustion Recovery](#token-exhaustion-recovery)
- [Final Quality Passes](#final-quality-passes)

---

## Architecture Overview

### The Problem

Claude Code operates within a finite context window. When executing complex multi-step tasks:
- Information discovered early can be "forgotten" as context fills
- Parallel execution risks race conditions on shared state
- Token exhaustion mid-task can cause incomplete work
- Errors in one task can cascade to dependent tasks

### The Solution

Planning-parallel treats the filesystem as persistent memory:

```
┌─────────────────────────────────────────────────────────────────┐
│                     ORCHESTRATOR (Main Claude)                   │
│                                                                  │
│  Context Window = RAM (volatile, limited)                       │
│  Filesystem = Disk (persistent, unlimited)                      │
│                                                                  │
│  → Anything important gets written to disk immediately          │
└─────────────────────────────────────────────────────────────────┘
```

---

## The Three-File Memory System

Every planning session uses three coordinated files:

```
project-root/
├── task_plan.md    ← Task tracking, statuses, decisions
├── findings.md     ← Research discoveries, technical notes
└── progress.md     ← Session log, file changes, test results
```

### Why Three Files?

| File | Purpose | Write Frequency |
|------|---------|-----------------|
| `task_plan.md` | Single source of truth for "what to do" | After each task/group |
| `findings.md` | Preserves discoveries that inform later work | After ANY discovery |
| `progress.md` | Audit trail + context for resume | Throughout session |

### The 2-Action Rule

> "After every 2 view/browser/search operations, IMMEDIATELY save to findings.md"

This prevents information loss when context gets crowded.

---

## Parallel Execution Flow

### High-Level Flow Diagram

```
                          ┌──────────────────┐
                          │   task_plan.md   │
                          │                  │
                          │ Group 1: BE, FE  │
                          │ Group 2: INT     │
                          │ Group 3: Polish  │
                          └────────┬─────────┘
                                   │
                    ┌──────────────┴──────────────┐
                    ▼                             ▼
           ┌────────────────┐           ┌────────────────┐
           │ SPAWN: BE-001  │           │ SPAWN: FE-001  │
           │ (background)   │           │ (background)   │
           └───────┬────────┘           └───────┬────────┘
                   │                            │
                   ▼                            ▼
        ┌─────────────────────┐    ┌─────────────────────┐
        │ findings_BE-001.md  │    │ findings_FE-001.md  │
        │ progress_BE-001.md  │    │ progress_FE-001.md  │
        └─────────┬───────────┘    └─────────┬───────────┘
                   │                          │
                   └───────────┬──────────────┘
                               ▼
                    ┌──────────────────┐
                    │  MERGE PROTOCOL  │
                    │                  │
                    │ 1. Read files    │
                    │ 2. Append to     │
                    │    findings.md   │
                    │    progress.md   │
                    │ 3. Delete temps  │
                    │ 4. Verify merge  │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │   NEXT GROUP     │
                    └──────────────────┘
```

### Isolated File Architecture

To prevent race conditions, each sub-agent gets isolated files:

```
SHARED (READ-ONLY for sub-agents):
├── task_plan.md      ← Orchestrator owns
├── findings.md       ← Previous groups' context
└── progress.md       ← Previous groups' changes

ISOLATED (WRITE per sub-agent):
├── findings_BE-001.md    ← BE agent's discoveries
├── progress_BE-001.md    ← BE agent's session log
├── findings_FE-001.md    ← FE agent's discoveries
└── progress_FE-001.md    ← FE agent's session log
```

### Why Background Execution?

```
WITHOUT run_in_background: true:
  → Orchestrator WAITS for agent
  → Agent's ENTIRE output returns to orchestrator
  → Orchestrator context fills up → OVERFLOW

WITH run_in_background: true:
  → Agent runs in separate process
  → Only file-based status updates
  → Orchestrator context stays lean
```

---

## Error Handling & Recovery

### The 3-Strike Protocol

```
┌─────────────────────────────────────────────────────────────────┐
│                     3-STRIKE ERROR PROTOCOL                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ATTEMPT 1: Diagnose & Fix                                      │
│    → Read error carefully                                        │
│    → Identify root cause                                         │
│    → Apply targeted fix                                          │
│                                                                  │
│  ATTEMPT 2: Alternative Approach                                 │
│    → Same error? Try different method                            │
│    → NEVER repeat exact same failing action                      │
│    → Log what was tried in progress.md                          │
│                                                                  │
│  ATTEMPT 3: Broader Rethink                                      │
│    → Question assumptions                                        │
│    → Search for solutions                                        │
│    → Consider architectural changes                              │
│                                                                  │
│  AFTER 3 FAILURES: Escalate to User                             │
│    → Explain what was tried                                      │
│    → Share the specific error                                    │
│    → Ask for guidance                                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Error Tracking

All errors are logged in `task_plan.md`:

```markdown
## Errors Encountered
| Error | Task | Attempt | Resolution |
|-------|------|---------|------------|
| Cannot connect to DB | BE-001 | 1 | Wrong port, fixed |
| Schema migration failed | BE-001 | 2 | Added missing column |
| Type mismatch in API | FE-INT-001 | 1 | Updated interface |
```

### Never Repeat Failures Rule

```python
if action_failed:
    next_action != same_action
```

The system tracks what was tried and forces approach mutation.

---

## Sub-Agent Handoffs

### The Problem

Sub-agents can exhaust their context mid-task. Traditional solutions:
- **Context compaction**: Risky, loses information
- **Hard stop**: Loses in-progress work

### The Solution: Checkpoint & Handoff

```
┌─────────────────────────────────────────────────────────────────┐
│                    SUB-AGENT HANDOFF PROTOCOL                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. DETECT: Agent approaching context limits                     │
│                                                                  │
│  2. CHECKPOINT: Write progress to isolated files                 │
│     findings_[TASK-ID].md:                                       │
│       - Completed subtasks                                       │
│       - Key decisions made                                       │
│       - In-progress work state                                   │
│                                                                  │
│     progress_[TASK-ID].md:                                       │
│       - Files created/modified                                   │
│       - Where to resume from                                     │
│       - ORCHESTRATOR STATUS: CONTINUATION_REQUIRED               │
│                                                                  │
│  3. RETURN: Agent returns control                                │
│     STATUS: PARTIAL_COMPLETE                                     │
│     CONTINUATION_REQUIRED: true                                  │
│     RESUME_FROM: "Subtask 3 - remaining endpoints"               │
│                                                                  │
│  4. ORCHESTRATOR DETECTS: Reads status marker                    │
│                                                                  │
│  5. RESPAWN: Fresh agent with checkpoint context                 │
│     "CONTINUATION - Read findings_BE-001.md first.               │
│      Previous agent completed subtasks 1-2.                      │
│      Resume from: [RESUME_FROM]"                                 │
│                                                                  │
│  6. CONTINUE: New agent picks up where old left off              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Status Markers

Sub-agents write a status marker at the end of their progress file:

```markdown
---
ORCHESTRATOR STATUS: IN_PROGRESS
```

Valid values:
- `IN_PROGRESS` - Still working
- `COMPLETE` - Finished successfully
- `BLOCKED` - Hit a blocker, needs help
- `CONTINUATION_REQUIRED` - Needs fresh agent to continue

The orchestrator polls only this marker (last 5 lines) to minimize context usage.

---

## Token Exhaustion Recovery

### Orchestrator-Level Recovery

If the main orchestrator runs low on context:

```
┌─────────────────────────────────────────────────────────────────┐
│               ORCHESTRATOR RECOVERY PROTOCOL                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. SAVE STATE:                                                  │
│     → Write current group to task_plan.md                        │
│     → Write in-memory findings to findings.md                    │
│     → Mark current task statuses                                 │
│                                                                  │
│  2. SESSION ENDS (context exhausted or user stops)               │
│                                                                  │
│  3. RESUME: User runs /planning-parallel again                   │
│     → Reads task_plan.md for current state                       │
│     → Reads findings.md for context                              │
│     → Reads progress.md for what was done                        │
│     → Continues from "Current Group" marker                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Seamless Resume

Because state is file-based, resumption is seamless:

```bash
# Session 1: Gets through Group 1, exhausts context
/planning-parallel

# Session 2: Automatically picks up at Group 2
/planning-parallel
```

The `task_plan.md` contains:
- `## Current Group` marker showing where to resume
- Task statuses showing what's complete
- Error history showing what was tried

### The 5-Question Reboot Test

To verify context is solid after resume:

| Question | Answer Source |
|----------|---------------|
| Where am I? | Current group/task in task_plan.md |
| Where am I going? | Remaining groups/tasks |
| What's the goal? | Goal statement in task_plan.md |
| What have I learned? | findings.md |
| What have I done? | progress.md |

---

## Final Quality Passes

After all task groups complete, two quality passes run:

### Code Simplification Pass

```
┌─────────────────────────────────────────────────────────────────┐
│                   CODE SIMPLIFICATION PASS                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. COLLECT: Gather all files created/modified                   │
│     → Read progress.md for file list                             │
│     → Deduplicate                                                │
│                                                                  │
│  2. PARTITION: Split into 5 batches                              │
│                                                                  │
│  3. SPAWN: 5 parallel code-simplifier agents                     │
│     ┌─────────────┐ ┌─────────────┐ ┌─────────────┐             │
│     │ Batch 1     │ │ Batch 2     │ │ Batch 3     │ ...         │
│     │ Simplify    │ │ Simplify    │ │ Simplify    │             │
│     └─────────────┘ └─────────────┘ └─────────────┘             │
│                                                                  │
│  Focus:                                                          │
│    → Remove duplication                                          │
│    → Improve naming                                              │
│    → Simplify logic                                              │
│    → Preserve all functionality                                  │
│                                                                  │
│  4. VERIFY: Run tests to confirm no regressions                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Code Review Pass

```
┌─────────────────────────────────────────────────────────────────┐
│                     CODE REVIEW PASS                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. SPAWN: 5 parallel code-reviewer agents                       │
│     ┌─────────────┐ ┌─────────────┐ ┌─────────────┐             │
│     │ Batch 1     │ │ Batch 2     │ │ Batch 3     │ ...         │
│     │ Review      │ │ Review      │ │ Review      │             │
│     └─────────────┘ └─────────────┘ └─────────────┘             │
│                                                                  │
│  Review for:                                                     │
│    → Bugs and logic errors                                       │
│    → Security vulnerabilities (OWASP top 10)                     │
│    → Performance issues                                          │
│    → Code quality and maintainability                            │
│    → Project convention adherence                                │
│                                                                  │
│  2. FILTER: Only report issues with ≥80% confidence              │
│                                                                  │
│  3. REPORT: Present findings by severity                         │
│     → CRITICAL (must fix)                                        │
│     → HIGH (should fix)                                          │
│     → MEDIUM (recommendations)                                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Complete Execution Flow

```
/planning-parallel
        │
        ▼
┌───────────────────┐
│ Read task_plan.md │
│ Find current group│
└─────────┬─────────┘
          │
          ▼
    ┌─────────────┐     ┌─────────────┐
    │ Group 1     │────►│ Group 2     │────► ... ────► Groups Complete
    │ BE + FE     │     │ Integration │
    │ (parallel)  │     │ (sequential)│
    └──────┬──────┘     └──────┬──────┘
           │                   │
           ▼                   ▼
      ┌─────────┐         ┌─────────┐
      │ Spawn   │         │ Execute │
      │ Agents  │         │ Task    │
      └────┬────┘         └────┬────┘
           │                   │
           ▼                   ▼
      ┌─────────┐         ┌─────────┐
      │ Monitor │         │ Update  │
      │ Status  │         │ Files   │
      └────┬────┘         └────┬────┘
           │                   │
           ▼                   ▼
      ┌─────────┐         ┌─────────┐
      │ Merge   │         │ Log     │
      │ Results │         │ Progress│
      └─────────┘         └─────────┘
          │
          ▼
┌──────────────────────────────────────┐
│        QUALITY PASSES                │
├──────────────────────────────────────┤
│  ┌─────────────────────────────────┐ │
│  │ 5x Code Simplifiers (parallel)  │ │
│  └─────────────────────────────────┘ │
│                 │                    │
│                 ▼                    │
│  ┌─────────────────────────────────┐ │
│  │       Run Tests                 │ │
│  └─────────────────────────────────┘ │
│                 │                    │
│                 ▼                    │
│  ┌─────────────────────────────────┐ │
│  │ 5x Code Reviewers (parallel)    │ │
│  └─────────────────────────────────┘ │
│                 │                    │
│                 ▼                    │
│  ┌─────────────────────────────────┐ │
│  │    Report Issues to User        │ │
│  └─────────────────────────────────┘ │
└──────────────────────────────────────┘
          │
          ▼
      COMPLETE
```

---

## Key Design Principles

1. **Filesystem as Memory**: Write early, write often
2. **Isolated Writes**: Parallel agents can't conflict
3. **Checkpoint Everything**: Enable seamless resume
4. **No Context Compaction**: Handoff to fresh agent instead
5. **Status Polling**: Minimal context for monitoring
6. **Mandatory Merge**: Never lose sub-agent work
7. **Quality Gates**: Simplification + Review before done

---

## Related Documentation

- [PRD Workflow](./PRD_WORKFLOW.md) - How `/prd` generates optimized task plans
- [README](../README.md) - Quick start and plugin overview
