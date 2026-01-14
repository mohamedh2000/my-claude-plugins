# Task Plan: [Feature Name]

## Goal
[One sentence describing the end state]

## Current Group
Group 1

## PRD Reference
`.claude/Task Documents/PRD-[feature-name].md`

---

## Execution Groups

<!--
Tasks in the same group can be executed in PARALLEL.
Tasks are blocked by previous groups completing.
-->

| Group | Tasks | Execution | Blocked By |
|-------|-------|-----------|------------|
| **Group 1** | [TASK-IDs] | ⚡ PARALLEL | None |
| **Group 2** | [TASK-IDs] | ⚡ PARALLEL | Group 1 |
| **Group 3** | [TASK-IDs] | Sequential | Group 2 |

---

## Tasks

<!--
Each task has:
- Unique ID (BE-001, FE-001, etc.)
- Group assignment (parallel or sequential)
- Agent type for sub-agent spawning
- Blocked by (dependencies)
- Subtasks to complete
- Isolated files for parallel execution
-->

### [TASK-ID]: [Task Title]
- **Group:** [N] ⚡ (or "Sequential")
- **Agent:** [senior-backend-engineer | ui-react-specialist | general-purpose]
- **Status:** pending
- **Blocked By:** [None | TASK-IDs]
- **Subtasks:**
  - [ ] Subtask 1
  - [ ] Subtask 2
- **Stories:** [Story IDs from PRD]
- **Isolated Files:** findings_[TASK-ID].md, progress_[TASK-ID].md

<!-- Add more tasks as needed -->

---

## Key Decisions
| Decision | Rationale |
|----------|-----------|
|          |           |

## Errors Encountered
| Error | Task | Attempt | Resolution |
|-------|------|---------|------------|
|       |      | 1       |            |

## Session Log
| Time | Group/Task | Action | Result |
|------|------------|--------|--------|
|      | Setup | Created task_plan.md | - |

---

## Notes
- Update task status as you progress: pending → in_progress → complete
- For parallel groups, spawn all tasks in a SINGLE message
- Sub-agents write to isolated files, orchestrator merges after
- Re-read this plan before major decisions
