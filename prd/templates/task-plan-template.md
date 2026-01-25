# Task Plan Template

> **Usage**: Copy this template when creating `.claude/PRD-[feature-name]/task_plan.md`
> This file is consumed by `/planning-parallel` for execution.

---

```markdown
# Task Plan: [Feature Name]

## Goal
[One sentence from PRD overview]

## Current Group
Group 1

## PRD Reference
`.claude/PRD-[feature-name]/PRD.md`

---

## Execution Groups

<!--
INSTRUCTIONS:
- Create groups based on task dependencies from the PRD
- Tasks with no dependencies or shared dependencies go in parallel groups
- Tasks blocked by others go in sequential groups
- Number of tasks per group is FLEXIBLE (2, 3, 5, etc.)
-->

| Group | Tasks | Execution | Blocked By |
|-------|-------|-----------|------------|
| **Group 1** | BE-001, FE-001 | ⚡ PARALLEL | None |
| **Group 2** | BE-002, FE-002 | ⚡ PARALLEL | Group 1 |
| **Group 3** | FE-INT-001 | Sequential | Group 2 |
| **Group 4** | FE-INT-002 | Sequential | Group 3 |

---

## Tasks

<!--
INSTRUCTIONS:
- Generate one task section per independent unit of work from the PRD
- Use task IDs from PRD (BE-001, FE-001, INFRA-001, etc.)
- Assign appropriate agent type based on task domain
- Group parallel tasks together, mark with same group number

⚠️ MANDATORY: If PRD has BOTH backend and frontend tasks, you MUST include:
- FE-INT-001: Connect Frontend to Backend Endpoints
- FE-INT-002: Integration Verification
These tasks go in a LATER group that depends on all BE and FE tasks completing.
-->

### BE-001: [Task Title]
- **Group:** 1 ⚡
- **Agent:** senior-backend-engineer
- **Status:** pending
- **Blocked By:** None
- **PRD Reference:** Section 4.1 - Data Models, Section 4.2 - API Contracts
- **Implementation Details:**
  - **Data Model:** [Entity name from PRD Section 4.1]
  - **API Contract:** [API-XXX from PRD - include endpoint path]
- **Subtasks:**
  - [ ] Create database schema/migration
  - [ ] Implement API endpoint
  - [ ] Add validation
  - [ ] Add tests
- **Verification:**
  - [ ] Migration runs successfully
  - [ ] API returns expected response shape
  - [ ] curl test passes
- **Stories:** A1
- **Isolated Files:** findings_BE-001.md, progress_BE-001.md

---

### BE-002: [Task Title]
- **Group:** 2 ⚡
- **Agent:** senior-backend-engineer
- **Status:** pending
- **Blocked By:** BE-001
- **PRD Reference:** Section 4.2 - API Contracts
- **Subtasks:**
  - [ ] Subtask 1
  - [ ] Subtask 2
- **Verification:**
  - [ ] Specific verification
- **Stories:** A2
- **Isolated Files:** findings_BE-002.md, progress_BE-002.md

---

### FE-001: [Task Title]
- **Group:** 1 ⚡
- **Agent:** ui-react-specialist
- **Status:** pending
- **Blocked By:** None (can build with mocked data)
- **PRD Reference:** Section 4.4 - UI States
- **Implementation Details:**
  - **Data Source:** [Will connect to API-XXX in integration phase]
  - **UI States:** Loading, Empty, Error, Success (see PRD 4.4)
- **Subtasks:**
  - [ ] Create component structure
  - [ ] Implement UI states
  - [ ] Add styling
  - [ ] Add tests
- **Verification:**
  - [ ] Component renders all states
  - [ ] Storybook stories pass (if applicable)
- **Stories:** A1
- **Isolated Files:** findings_FE-001.md, progress_FE-001.md

---

### FE-002: [Task Title]
- **Group:** 2 ⚡
- **Agent:** ui-react-specialist
- **Status:** pending
- **Blocked By:** FE-001
- **PRD Reference:** Section 4.3 - Data Flow, Section 4.4 - UI States
- **Subtasks:**
  - [ ] Subtask 1
  - [ ] Subtask 2
- **Verification:**
  - [ ] Specific verification
- **Stories:** A2
- **Isolated Files:** findings_FE-002.md, progress_FE-002.md

---

<!-- ⚠️ MANDATORY INTEGRATION TASKS -->

### FE-INT-001: Connect Frontend to Backend Endpoints
- **Group:** 3 Sequential
- **Agent:** ui-react-specialist
- **Status:** pending
- **Blocked By:** All BE-* tasks, All FE-* tasks
- **PRD Reference:** Section 4.3 - Data Flow & State Management
- **Subtasks:**
  - [ ] Replace mock data/placeholder API calls with actual backend endpoints
  - [ ] Verify API response shape matches frontend type definitions
  - [ ] Ensure property names align (no mapping errors)
  - [ ] Implement proper loading states during API calls
  - [ ] Implement error handling for API failures
  - [ ] Handle empty state when no data returned
- **Verification:**
  - [ ] No hardcoded/mock data remains
  - [ ] TypeScript compiles without type errors
  - [ ] Data flows from API to UI correctly
- **Stories:** Integration
- **Isolated Files:** findings_FE-INT-001.md, progress_FE-INT-001.md

---

### FE-INT-002: Integration Verification
- **Group:** 4 Sequential
- **Agent:** ui-react-specialist
- **Status:** pending
- **Blocked By:** FE-INT-001
- **PRD Reference:** Section 4.2 - API Contracts, Section 4.4 - UI States
- **Subtasks:**
  - [ ] curl each backend endpoint → verify correct response shape
  - [ ] Browser test → verify data renders correctly for each component
  - [ ] Test all CRUD operations end-to-end (create, read, update, delete)
  - [ ] Trigger error conditions → verify UI displays errors correctly
  - [ ] Check browser console for any data/API related errors
  - [ ] Verify no TypeScript errors related to API response types
- **Verification:**
  - [ ] All CRUD operations work end-to-end
  - [ ] Error states display correctly
  - [ ] No console errors
- **Stories:** Integration
- **Isolated Files:** findings_FE-INT-002.md, progress_FE-INT-002.md

---

<!-- ⚠️ FIX-UP TASKS (include when PRD modifies existing entities) -->

### FIX-001: [Update dependent for changed entity]
- **Group:** [After the change task] Sequential
- **Agent:** [ui-react-specialist | senior-backend-engineer]
- **Status:** pending
- **Blocked By:** [Task that makes the breaking change, e.g., BE-001]
- **PRD Reference:** Section 5.4 - Fix-Up Tasks
- **Files to Update:**
  - `src/components/AffectedComponent.tsx`
  - `src/types/affected.ts`
- **Specific Changes:**
  - [ ] Change `entity.oldField` → `entity.newField`
  - [ ] Update type definition to match new schema
  - [ ] Update any destructuring patterns
- **Verification:**
  - [ ] TypeScript compiles without errors
  - [ ] Component renders correctly
  - [ ] No console errors
- **Stories:** Fix-up (dependency maintenance)
- **Isolated Files:** findings_FIX-001.md, progress_FIX-001.md

---

## Dependency Tracking

### Breaking Changes & Fix-Up Status
| Change | Made In | Affects | Fix Task | Status |
|--------|---------|---------|----------|--------|
| [Change description] | BE-001 | [files] | FIX-001 | pending |

### Execution Order (with fix-ups)
```
Phase 1: Core Changes
├── BE-001 (change) ──→ FIX-001 (fix dependent)
├── FE-001 (new component) ──→ no fix needed
└── ...

Phase 2: Integration
└── FE-INT-001 ──→ blocked by all FIX tasks
```

---

## Key Decisions
| Decision | Rationale |
|----------|-----------|
| [From PRD] | [From PRD] |

## Errors Encountered
| Error | Task | Attempt | Resolution |
|-------|------|---------|------------|
|       |      | 1       |            |

## Session Log
| Time | Group/Task | Action | Result |
|------|------------|--------|--------|
|      | Setup | Created task_plan.md | - |
```
