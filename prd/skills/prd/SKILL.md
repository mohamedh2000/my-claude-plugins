---
name: prd
version: "2.0.0"
description: This skill should be used when the user asks to "create a PRD", "write requirements", "build a spec document", "define product requirements", "plan a feature", or wants to collaboratively define specifications for a new feature or project. Creates comprehensive Product Requirements Documents with stories and tasks.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Task
  - AskUserQuestion
  - TodoWrite
---

# PRD Skill - Conductor Pattern

> **Architecture**: Lightweight orchestrator (~300 lines) + templates (loaded on-demand)
> **Templates**: Located in `prd/templates/` directory

## Workflow Overview

| Phase | Name | Template | Output |
|-------|------|----------|--------|
| 0 | Init | `phase-0-init.md` | TODO list, architecture verified |
| 1 | Exploration | `phase-1-explore.md` | Codebase context, dependency map |
| 2A | High-Level Discovery | `phase-2-discovery.md` | User stories, scope |
| 2B | Implementation Deep-Dive | `phase-2-discovery.md` | Data models, APIs, states |
| 3 | Documentation | `prd-template.md` | PRD.md created |
| 4 | Review | `phase-4-review-prompts.md` | PM + Engineer feedback |
| 5 | Refinement | `phase-5-readiness.md` | All issues addressed, gate passed |
| 6 | Handoff | `task-plan-template.md` | 4 output files verified |

## File Structure

All PRD artifacts are stored in: `.claude/PRD-[feature-name]/`

```
.claude/PRD-[feature-name]/
├── prd_state.md                              # State tracking (from templates/prd_state.md)
├── PRD.md                                    # The PRD document
├── task_plan.md                              # Execution plan for /planning-parallel
├── findings.md                               # Architecture context
└── CODE_ARCHITECTURE_PR-[feature-name].md    # Architecture with proposed changes
```

---

## Entry Point: State Detection

**FIRST**, check if resuming an existing PRD:

```
Read file: [argument if provided, or check for recent PRD folder]
```

### If argument provided:
- **Folder path** (e.g., `.claude/PRD-notifications`): Check for `prd_state.md`
- **File path** (ends with `.md`): Read and analyze status
- **Description**: Start fresh from Phase 0

### If resuming (prd_state.md exists):
1. Read `prd_state.md`
2. Apply **5-Question Reboot Protocol**
3. Resume from Next Action

### If starting fresh:
1. Proceed to Phase 0
2. Create state file after first phase

---

## State File Protocol

Create `.claude/PRD-[feature-name]/prd_state.md` using template:
```
Read file: prd/templates/prd_state.md
```

### State File Structure
```markdown
**PHASE**: [0-6]
**STATUS**: [NOT_STARTED | IN_PROGRESS | BLOCKED | COMPLETE]

## Completed Phases
- [x] Phase 0: Init
- [ ] Phase 1: Exploration
...

## Next Action
**ACTION**: [Specific next step]

ORCHESTRATOR STATUS: IN_PROGRESS
```

---

## Checkpoint Protocol (After Every Phase)

**MANDATORY** after completing each phase:

1. **UPDATE** state file:
   - Mark phase complete
   - Increment PHASE number
   - Set Next Action
2. **RE-READ** state file (verify update succeeded)
3. **VERIFY** expected artifacts exist
4. **PROCEED** only after verification passes

---

## Phase Execution

### Phase 0: Init
```
Read file: prd/templates/phase-0-init.md
```

**Actions:**
1. Create TODO list (TodoWrite)
2. Check/create CODE_ARCHITECTURE_FEATURES.md
3. Handle argument (existing PRD or description)

**Checkpoint:**
- [ ] TODO list created
- [ ] Architecture file exists
- Update state: PHASE → 1

---

### Phase 1: Exploration
```
Read file: prd/templates/phase-1-explore.md
```

**Actions:**
1. Read existing architecture docs
2. Get feature description from user
3. Spawn Explore agent with dependency mapping
4. Verify architecture file exists

**Checkpoint:**
- [ ] Feature description captured
- [ ] Exploration complete
- [ ] Dependency map created
- Update state: PHASE → 2A

---

### Phase 2: Discovery
```
Read file: prd/templates/phase-2-discovery.md
Read file: prd/templates/common-gaps.md
```

**Phase 2A - High-Level:**
- Vision, users, core features, scope
- 2-3 questions at a time

**Phase 2B - Deep-Dive:**
- Data sources, models, API contracts
- State management, UI states
- Dependency impact (for modifications)

**Checkpoint (after 2B):**
- [ ] All completion checklist items verified
- [ ] User confirmed "implementation-ready"
- Update state: PHASE → 3

---

### Phase 3: Documentation
```
Read file: prd/templates/prd-template.md
Read file: prd/templates/dependency-analysis.md (if modifying existing code)
```

**Actions:**
1. Create PRD folder: `mkdir -p .claude/PRD-[feature-name]`
2. Write PRD.md using template
3. Fill Section 5 (Dependency Impact) if applicable

**Checkpoint:**
- [ ] PRD.md exists and is complete
- [ ] Section 5 filled (if modifications)
- Update state: PHASE → 4

---

### Phase 4: Review
```
Read file: prd/templates/phase-4-review-prompts.md
```

**Actions:**
1. Spawn PM reviewer (background)
2. Spawn Engineer reviewer (background)
3. Monitor progress, report as each completes
4. Compile feedback

**Checkpoint:**
- [ ] PM review complete
- [ ] Engineer review complete
- Update state: PHASE → 5

---

### Phase 5: Refinement
```
Read file: prd/templates/phase-5-readiness.md
```

**Actions:**
1. Summarize review findings
2. Address BLOCKER and HIGH issues
3. Update PRD with resolutions
4. **Run Implementation Readiness Gate**
5. Get user confirmation

**Checkpoint:**
- [ ] All BLOCKER/HIGH issues addressed
- [ ] Readiness gate passed
- [ ] User confirmed approved
- Update state: PHASE → 6

---

### Phase 6: Handoff
```
Read file: prd/templates/task-plan-template.md
Read file: prd/templates/findings-template.md
Read file: prd/templates/architecture-pr-template.md
```

**Actions:**
1. Generate task_plan.md
2. Generate findings.md
3. Generate CODE_ARCHITECTURE_PR-[feature-name].md
4. **VERIFY all 4 files exist** (Glob each file)

**File Verification (MANDATORY):**
```
Glob: .claude/PRD-[feature-name]/PRD.md
Glob: .claude/PRD-[feature-name]/task_plan.md
Glob: .claude/PRD-[feature-name]/findings.md
Glob: .claude/PRD-[feature-name]/CODE_ARCHITECTURE_PR-*.md
```

**If ANY file missing:** Create immediately, re-verify.

**Checkpoint:**
- [ ] All 4 files verified
- [ ] FIX tasks have correct dependencies
- Update state: PHASE → COMPLETE

---

## 5-Question Reboot Protocol

If context is lost or resuming from interruption:

1. **Read state file:** `.claude/PRD-[feature-name]/prd_state.md`
2. **Answer these 5 questions:**
   - What phase am I in? → `PHASE` field
   - What's completed? → `Completed Phases` checklist
   - Current progress? → `Current Phase Progress` section
   - Next action? → `Next Action` section
   - Any blockers? → `Blockers` section
3. **Resume from Next Action**

---

## Agent Prompts (Quick Reference)

### Explore Agent (Phase 1)
```
Subagent type: Explore
Prompt: Exploring codebase for PRD: [feature]. Focus on:
1. Feature-relevant code
2. Architecture gaps
3. CRITICAL: Dependency mapping - grep for usages of entities being modified
Return: What's relevant, what you added to architecture doc, dependency map.
```

### PM Reviewer (Phase 4)
```
Subagent type: general-purpose
run_in_background: true
Prompt: [See phase-4-review-prompts.md - PM section]
```

### Engineer Reviewer (Phase 4)
```
Subagent type: general-purpose
run_in_background: true
Prompt: [See phase-4-review-prompts.md - Engineer section]
```

---

## Verification Gates

### Gate 1: Architecture (Phase 1)
```
Glob: .claude/CODE_ARCHITECTURE_FEATURES.md
```
**If missing:** Create synchronously before Phase 2.

### Gate 2: Readiness (Phase 5)
Run full checklist from `phase-5-readiness.md`:
- Data models complete?
- API contracts complete?
- UI states defined?
- Dependencies identified?
- User confirmed?

### Gate 3: Files (Phase 6)
All 4 files must exist:
- PRD.md
- task_plan.md
- findings.md
- CODE_ARCHITECTURE_PR-[feature-name].md

---

## Output Message

After Phase 6 completion:

> "PRD complete! All artifacts are in `.claude/PRD-[feature-name]/`:
> - `PRD.md` - The requirements document
> - `task_plan.md` - Execution plan
> - `findings.md` - Architecture context
> - `CODE_ARCHITECTURE_PR-[feature-name].md` - Architecture with proposed changes
>
> To start implementation, run: `/planning-parallel .claude/PRD-[feature-name]/task_plan.md`"

---

## Quick Reference: Templates

| Template | Purpose | When to Load |
|----------|---------|--------------|
| `prd_state.md` | State tracking | Session start |
| `phase-0-init.md` | Phase 0 instructions | Phase 0 |
| `phase-1-explore.md` | Exploration agent prompt | Phase 1 |
| `phase-2-discovery.md` | Discovery questions | Phase 2 |
| `common-gaps.md` | Checklist for missed details | Phase 2 |
| `prd-template.md` | PRD document structure | Phase 3 |
| `dependency-analysis.md` | Section 5 template | Phase 3 (if mods) |
| `phase-4-review-prompts.md` | Review agent prompts | Phase 4 |
| `phase-5-readiness.md` | Readiness gate checklist | Phase 5 |
| `task-plan-template.md` | task_plan.md structure | Phase 6 |
| `findings-template.md` | findings.md structure | Phase 6 |
| `architecture-pr-template.md` | Architecture PR template | Phase 6 |
