# PRD Workflow: Deep Dive

A comprehensive guide to the `/prd` skill - how it generates optimized Product Requirements Documents and task plans designed for parallel execution.

---

## Table of Contents

- [The 6-Phase Workflow](#the-6-phase-workflow)
- [Codebase-Aware Discovery](#codebase-aware-discovery)
- [The task_plan.md Structure](#the-task_planmd-structure)
- [Optimization for Speed](#optimization-for-speed)
- [Mandatory Integration Phase](#mandatory-integration-phase)
- [Multi-Agent Review](#multi-agent-review)
- [Resuming Incomplete PRDs](#resuming-incomplete-prds)

---

## The 6-Phase Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                      /prd WORKFLOW                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Phase 1: EXPLORATION                                            │
│    → Read existing architecture knowledge                        │
│    → Spawn Explore agent for feature-relevant areas              │
│    → Update CODEBASE_ARCHITECTURE.md with findings               │
│                                                                  │
│  Phase 2: DISCOVERY                                              │
│    → Context-aware requirements gathering                        │
│    → Reference existing patterns: "I see you use X..."           │
│    → Collaborative refinement until user confirms                │
│                                                                  │
│  Phase 3: DOCUMENTATION                                          │
│    → Generate structured PRD.md                                  │
│    → Create user stories with dependencies                       │
│    → Break down into parallelizable tasks                        │
│                                                                  │
│  Phase 4: REVIEW                                                 │
│    → Spawn PM Reviewer (background)                              │
│    → Spawn Engineer Reviewer (background)                        │
│    → Parallel expert critique                                    │
│                                                                  │
│  Phase 5: REFINEMENT                                             │
│    → Present combined feedback                                   │
│    → Prioritize issues (Critical/Important/Nice-to-have)         │
│    → Update PRD with agreed changes                              │
│                                                                  │
│  Phase 6: HANDOFF                                                │
│    → Generate task_plan.md (execution plan)                      │
│    → Generate findings.md (architecture context)                 │
│    → Ready for /planning-parallel                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Why 6 Phases?

| Phase | Purpose | Output |
|-------|---------|--------|
| Exploration | Avoid reinventing the wheel | Updated architecture doc |
| Discovery | Get requirements right | User-confirmed scope |
| Documentation | Formalize the plan | PRD.md |
| Review | Catch issues early | Expert feedback |
| Refinement | Fix before building | Approved PRD |
| Handoff | Enable execution | task_plan.md + findings.md |

---

## Codebase-Aware Discovery

### The Problem with Traditional PRDs

Most PRD tools ask generic questions:
- "What problem are you solving?"
- "Who are the users?"
- "What features do you need?"

This misses crucial context: **what already exists in the codebase**.

### The Solution: Explore First

```
┌─────────────────────────────────────────────────────────────────┐
│                    EXPLORATION PHASE                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Read CODEBASE_ARCHITECTURE.md                                │
│     → Accumulated knowledge from previous explorations           │
│     → Known patterns, tech stack, conventions                    │
│                                                                  │
│  2. Get Feature Brief from User                                  │
│     "What feature would you like to build?"                      │
│                                                                  │
│  3. Spawn Explore Agent                                          │
│     → Find similar features in codebase                          │
│     → Identify reusable components                               │
│     → Map integration points                                     │
│     → Document patterns to follow                                │
│                                                                  │
│  4. Update Architecture Doc                                      │
│     → Add new discoveries                                        │
│     → Record exploration in history                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Context-Aware Questions

After exploration, questions reference the codebase:

**Generic (before exploration):**
> "How should user data be fetched?"

**Context-aware (after exploration):**
> "I see you use TanStack Query with a pattern in `services/api/`. Should the new feature follow this pattern, or do you need something different?"

### Benefits

- **Reuse**: Discover existing components that can be extended
- **Consistency**: Follow established patterns
- **Integration**: Know where the feature connects
- **Speed**: Don't rebuild what exists

---

## The task_plan.md Structure

The `task_plan.md` is optimized for parallel execution by `/planning-parallel`.

### Structure Overview

```markdown
# Task Plan: [Feature Name]

## Goal
[One sentence describing the end state]

## Current Group
Group 1                            ← Resume point marker

## PRD Reference
`./PRD.md`                         ← Link to full requirements

---

## Execution Groups

| Group | Tasks | Execution | Blocked By |
|-------|-------|-----------|------------|
| **Group 1** | BE-001, FE-001 | ⚡ PARALLEL | None |
| **Group 2** | BE-002, FE-002 | ⚡ PARALLEL | Group 1 |
| **Group 3** | FE-INT-001 | Sequential | Group 2 |

---

## Tasks

### [TASK-ID]: [Task Title]
- **Group:** [N] ⚡
- **Agent:** [senior-backend-engineer | ui-react-specialist]
- **Status:** pending
- **Blocked By:** [None | TASK-IDs]
- **Subtasks:**
  - [ ] Subtask 1
  - [ ] Subtask 2
- **Isolated Files:** findings_[TASK-ID].md, progress_[TASK-ID].md
```

### Why This Structure Works

| Element | Purpose | How It Helps |
|---------|---------|--------------|
| `Current Group` | Resume marker | Pick up after token exhaustion |
| `Execution Groups` | Parallelization map | Know what can run together |
| `Agent` field | Auto-routing | Spawn correct specialist |
| `Blocked By` | Dependency tracking | Prevent premature execution |
| `Isolated Files` | Race condition prevention | Parallel writes don't conflict |
| `Subtasks` | Granular tracking | Sub-agent knows exact scope |

---

## Optimization for Speed

### Parallel Track Design

The task plan maximizes parallelism by organizing work into independent tracks:

```
Sprint/Phase 1: Foundation (Parallel Tracks)
├── Track A (Backend):     [BE-001] → [BE-002]
├── Track B (Frontend):    [FE-001] → [FE-002]    ← Can use mocked data
└── Track C (Infra):       [INFRA-001]

Sprint/Phase 2: Additional Features (After Phase 1)
├── Track A (Backend):     [BE-003]
└── Track B (Frontend):    [FE-003]

Sprint/Phase 3: Integration (MANDATORY)
└── Track INT:             [FE-INT-001] → [FE-INT-002]

Sprint/Phase 4: Polish (After Phase 3)
└── All tracks converge:   [FE-004], [BE-004]
```

### Key Optimization Strategies

**1. Frontend Can Start Immediately**

Frontend UI components can be built with mocked data, in parallel with backend:

```
┌─────────────┐     ┌─────────────┐
│   Backend   │     │  Frontend   │
│  (real DB)  │     │ (mock data) │
└──────┬──────┘     └──────┬──────┘
       │                   │
       │     PARALLEL      │
       │                   │
       ▼                   ▼
┌─────────────────────────────────┐
│    Integration Phase            │
│    Replace mocks with real API  │
└─────────────────────────────────┘
```

**2. Group Size is Flexible**

Groups can have 2, 3, or 5+ tasks - whatever makes sense:

```markdown
| Group | Tasks | Execution |
|-------|-------|-----------|
| **1** | BE-001, BE-002, FE-001, FE-002, INFRA-001 | ⚡ PARALLEL |
| **2** | BE-003, FE-003 | ⚡ PARALLEL |
```

**3. Independent Tracks Run Together**

Backend and frontend are separate tracks that can progress independently until integration.

**4. Critical Path Identification**

The PRD identifies the longest dependency chain:

```markdown
Critical Path: BE-001 → BE-002 → FE-INT-001 → FE-INT-002 → FE-004
```

This shows the minimum time to completion.

---

## Mandatory Integration Phase

### The Problem

When backend and frontend are built in parallel:
- API contracts may drift
- Property names may not match
- Response shapes may differ from expectations
- Edge cases get missed

### The Solution: Mandatory FE-INT Tasks

When a PRD has BOTH backend AND frontend tasks, integration tasks are **required**:

```
┌─────────────────────────────────────────────────────────────────┐
│                 MANDATORY INTEGRATION TASKS                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  FE-INT-001: Connect Frontend to Backend Endpoints               │
│    → Replace mock data with actual API calls                     │
│    → Verify API response shape matches frontend expectations     │
│    → Ensure property names align (no mapping errors)             │
│    → Handle loading, error, and empty states                     │
│    → Test data renders correctly in UI                           │
│                                                                  │
│  FE-INT-002: Integration Verification                            │
│    → curl backend endpoints → verify response shape              │
│    → Browser test → verify data renders                          │
│    → Test all CRUD operations end-to-end                         │
│    → Trigger errors → confirm UI displays them                   │
│    → Check console for data/API errors                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Integration Task Placement

Integration tasks:
- Depend on ALL backend tasks
- Depend on ALL frontend UI tasks
- Go in a later execution group
- Have explicit acceptance criteria

```markdown
| Group | Tasks | Blocked By |
|-------|-------|------------|
| **1** | BE-001, BE-002, FE-001, FE-002 | None |
| **2** | BE-003, FE-003 | Group 1 |
| **3** | FE-INT-001, FE-INT-002 | Group 2 |  ← Integration
```

---

## Multi-Agent Review

### Parallel Expert Review

After the PRD is written, two specialized agents review it in parallel:

```
                    ┌──────────────┐
                    │   PRD.md     │
                    └──────┬───────┘
                           │
            ┌──────────────┴──────────────┐
            ▼                             ▼
   ┌─────────────────┐          ┌─────────────────┐
   │  PM Reviewer    │          │ Engineer Review │
   │  (background)   │          │  (background)   │
   └────────┬────────┘          └────────┬────────┘
            │                            │
            ▼                            ▼
   ┌─────────────────┐          ┌─────────────────┐
   │ • Completeness  │          │ • Feasibility   │
   │ • Task sizing   │          │ • Tech gaps     │
   │ • Dependencies  │          │ • API design    │
   │ • Risk assess   │          │ • Performance   │
   └────────┬────────┘          └────────┬────────┘
            │                            │
            └──────────────┬─────────────┘
                           ▼
                  ┌─────────────────┐
                  │ Combined Review │
                  │ Prioritized     │
                  │ Issues          │
                  └─────────────────┘
```

### Review Focus Areas

**PM Reviewer:**
- Are user stories complete?
- Are acceptance criteria clear?
- Are tasks properly sized?
- Are dependencies identified?
- What are the risks?

**Engineer Reviewer:**
- Is it technically feasible?
- Are there architectural concerns?
- Is the data model complete?
- Are API contracts defined?
- What about security/performance?

### Issue Prioritization

Review findings are categorized:

| Priority | Criteria | Action |
|----------|----------|--------|
| **Critical** | Blocks implementation or causes major rework | Must fix before starting |
| **Important** | Significant impact on quality or timeline | Should address |
| **Nice-to-have** | Would improve but not essential | Consider for later |

---

## Resuming Incomplete PRDs

### The Problem

PRD creation can be interrupted:
- User needs to think about a question
- Session ends mid-workflow
- Context exhaustion

### The Solution: File-Based Resume

PRDs can be resumed by passing the file path:

```bash
# Resume an existing PRD
/prd .claude/PRD-notifications

# Or the full file path
/prd .claude/PRD-notifications/PRD.md
```

### Resume Detection Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                      RESUME DETECTION                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Check PRD Status Field                                       │
│     - Draft → Continue from Discovery/Documentation              │
│     - In Review → Jump to Review Phase                           │
│     - Approved → Jump to Handoff (generate task_plan.md)         │
│                                                                  │
│  2. Analyze Completeness                                         │
│     ✓ Overview and goals                                         │
│     ✓ User stories (5 stories)                                   │
│     ⚠️ Technical requirements (incomplete)                       │
│     ✗ Tasks breakdown (not started)                              │
│                                                                  │
│  3. Report to User                                               │
│     "I've loaded the PRD for [Feature]. Here's what exists..."   │
│                                                                  │
│  4. Ask Clarifying Questions                                     │
│     "The API contracts section is empty. What format..."         │
│                                                                  │
│  5. Continue from Appropriate Phase                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Status-Based Routing

| PRD Status | Resume Action |
|------------|---------------|
| Draft | Continue Discovery/Documentation |
| In Review | Spawn PM + Engineer reviewers |
| Approved | Generate task_plan.md |
| Incomplete sections | Ask questions for gaps |

---

## Output Files

After `/prd` completes, three files are generated:

```
.claude/PRD-[feature-name]/
├── PRD.md              # Full requirements document
├── task_plan.md        # Execution plan for /planning-parallel
└── findings.md         # Architecture context
```

### Handoff to /planning-parallel

```bash
# PRD generates these files
/prd

# Outputs:
# PRD complete! All artifacts in .claude/PRD-notifications/
# To start: /planning-parallel .claude/PRD-notifications/task_plan.md

# Execute the plan
/planning-parallel .claude/PRD-notifications/task_plan.md
```

---

## Complete Workflow Diagram

```
User: /prd
        │
        ▼
┌───────────────────┐
│ Phase 1: Explore  │
│ → CODEBASE_ARCH   │
│ → Spawn explorer  │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Phase 2: Discover │
│ → Smart questions │
│ → User confirms   │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Phase 3: Document │
│ → Generate PRD.md │
│ → Stories + Tasks │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐     ┌───────────────────┐
│ Phase 4: Review   │     │   PM Reviewer     │
│ → Spawn reviewers │────►│ + Engineer Review │
│   (parallel)      │     │   (background)    │
└─────────┬─────────┘     └─────────┬─────────┘
          │◄────────────────────────┘
          ▼
┌───────────────────┐
│ Phase 5: Refine   │
│ → Prioritize      │
│ → Update PRD      │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Phase 6: Handoff  │
│ → task_plan.md    │
│ → findings.md     │
└─────────┬─────────┘
          │
          ▼
    Ready for:
/planning-parallel
```

---

## Related Documentation

- [Planning Parallel](./PLANNING_PARALLEL.md) - How task plans are executed
- [README](../README.md) - Quick start and plugin overview
