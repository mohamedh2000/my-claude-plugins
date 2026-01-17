---
name: prd
version: "1.0.0"
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

# PRD (Product Requirements Document) Skill

Create comprehensive product requirements documents through collaborative discovery, followed by expert review and refinement.

## Workflow Overview

This skill follows a 6-phase approach:

1. **Exploration Phase** - Understand existing codebase architecture and patterns
2. **Discovery Phase** - Collaborative requirements gathering (informed by exploration)
3. **Documentation Phase** - Create structured PRD with stories/tasks
4. **Review Phase** - Multi-agent critique and analysis
5. **Refinement Phase** - Collaborative improvement
6. **Handoff Phase** - Generate `task_plan.md` for `/planning-parallel`

---

## Phase 0: Check for Existing PRD (Entry Point)

Before starting the workflow, check if an existing PRD file was provided as an argument.

### Argument Detection

Check the provided arguments:
- **If argument is a file path** (ends with `.md` or contains `/`):
  - Read the file
  - Parse the PRD content
  - Jump to appropriate phase based on PRD status
- **If argument is a description** (or empty):
  - Proceed to Phase 1 (Exploration) as normal
  - Use description as initial feature context if provided

### Loading Existing PRD

If a file path is provided:

```
1. Read the PRD file at the provided path
2. Check the PRD Status field (Draft | In Review | Approved)
3. Analyze what sections are complete vs incomplete
```

**Based on PRD Status:**

| Status | Action |
|--------|--------|
| **Draft** | Continue from Discovery/Documentation phase. Ask clarifying questions for incomplete sections. |
| **In Review** | Jump to Review Phase (spawn PM + Engineer reviewers) |
| **Approved** | Jump to Handoff Phase (generate task_plan.md if not exists) |
| **Incomplete/Missing sections** | Identify gaps, ask clarifying questions, fill in missing parts |

### Resuming PRD Workflow

When loading an existing PRD:

1. **Summarize what exists**:
   > "I've loaded the PRD for [Feature Name]. Here's what's defined:
   > - ✓ Overview and goals
   > - ✓ User stories (5 stories)
   > - ⚠️ Technical requirements (incomplete - missing API contracts)
   > - ✗ Tasks breakdown (not started)
   >
   > I have some questions to fill in the gaps..."

2. **Ask clarifying questions** for incomplete sections

3. **Continue workflow** from the appropriate phase

### Example Usage

```
/prd .claude/Task Documents/PRD-notifications.md
```

Claude reads the file, analyzes completeness, and continues:
> "I've loaded your PRD for the Notification System. The user stories look complete, but I noticed the API contracts section is empty. Let me ask a few questions:
> 1. What format should notifications be returned in - paginated list or infinite scroll?
> 2. Should read/unread status be tracked per-notification or per-user?"

---

## Phase 1: Exploration - Codebase Understanding

Before asking requirements questions, gain context about the existing project. This enables more informed questions and ensures the PRD aligns with current architecture.

### Step 1: Read Existing Architecture Knowledge

First, read the living architecture document:

```
Read file: .claude/CODEBASE_ARCHITECTURE.md (in project root)
```

This document contains accumulated knowledge from previous explorations. Use it as a starting point to avoid re-discovering known information.

### Step 2: Get Feature Context from User

Ask the user one simple question:

> "What feature or capability would you like to build? (Just a brief description - I'll explore the codebase to understand the relevant context.)"

### Step 3: Spawn Exploration Agent

Use the Task tool with the Explore agent. The agent should:
1. Start with existing knowledge from CODEBASE_ARCHITECTURE.md
2. Explore areas relevant to the requested feature
3. **Update the architecture doc** with any new findings

```
Subagent type: Explore
Prompt: You are exploring a codebase to inform a PRD for: [USER'S FEATURE DESCRIPTION]

**First**: Read .claude/CODEBASE_ARCHITECTURE.md (in project root) to understand what's already documented.

**Then**: Focus your exploration on areas relevant to this feature that aren't fully documented yet:

1. **Feature-Relevant Code**:
   - Find existing features similar to what user wants to build
   - Identify components, services, or utilities that could be reused
   - Map integration points the new feature will need

2. **Gaps in Architecture Doc**:
   - If tech stack section is incomplete, fill it in
   - If relevant code flows aren't documented, trace and document them
   - If patterns aren't documented, identify and record them

3. **Specific Code Paths**:
   - Trace the data flow for similar features
   - Identify where new code would integrate
   - Note any constraints or dependencies

**Finally**: Update .claude/CODEBASE_ARCHITECTURE.md with your findings:
- Add any missing tech stack details
- Add the explored feature to "Section 7: Explored Features"
- Update "Exploration History" table with date and findings
- Fill in any other incomplete sections you discovered info for

Return a summary of:
1. What you learned that's relevant to the requested feature
2. What you added/updated in the architecture doc
```

### Exploration Output

After exploration, you should have:
- **Updated Architecture Doc**: New findings persisted for future explorations
- **Feature-Specific Context**: Relevant patterns, reusable code, integration points
- **Informed Starting Point**: Ready to ask smart, context-aware questions

### Use Exploration to Inform Questions

With codebase context, tailor discovery questions:
- Reference existing patterns: "I see you use [X pattern] for data fetching. Should the new feature follow this?"
- Suggest reuse: "There's an existing [component] that handles [similar thing]. Could we extend it?"
- Identify constraints: "The current auth system uses [approach]. The new feature will need to integrate with this."

---

## Phase 2: Discovery - Requirements Gathering

Now begin collaborative requirements gathering, informed by codebase exploration.

### Context-Aware Questions

Use exploration findings to ask smarter questions:
- "I noticed you have [existing feature]. How should the new feature relate to it?"
- "Your codebase uses [pattern]. Should we follow the same approach here?"
- "I see [component] already handles [similar thing]. Can we extend it or do we need something new?"

### Initial Questions
Start with broad context, then drill down:

1. **Vision**: "What problem are you trying to solve? What's the high-level goal?"
2. **Users**: "Who are the primary users? Are there different user types/roles?"
3. **Core Features**: "What are the must-have features for the first version?"
4. **Scope Boundaries**: "What is explicitly out of scope?"

### Deep-Dive Questions
Based on initial answers, probe deeper:

- **User Flows**: "Walk me through how a user would accomplish [X]?"
- **Edge Cases**: "What happens when [unusual scenario]?"
- **Data**: "What data needs to be stored? What are the relationships?"
- **Integrations**: "Does this need to connect to any external services or APIs?"
- **Constraints**: "Are there performance, security, or compliance requirements?"
- **Success Metrics**: "How will you measure if this is successful?"

### Conversation Guidelines

- Ask 2-3 questions at a time, not overwhelming lists
- Summarize understanding after each exchange
- Identify ambiguities and ask for clarification
- Propose solutions when requirements are vague
- Continue until BOTH parties agree requirements are complete

### Completion Criteria

Before moving to Phase 2, confirm:
- [ ] Core user stories are defined
- [ ] Acceptance criteria are clear
- [ ] Technical constraints are understood
- [ ] Scope boundaries are explicit
- [ ] User has confirmed: "Yes, this captures what I want to build"

---

## Phase 3: Documentation - Create the PRD

Generate a structured PRD document at: `.claude/Task Documents/PRD-[feature-name].md`

### PRD Structure

```markdown
# PRD: [Feature Name]

**Created**: [Date]
**Status**: Draft | In Review | Approved
**Author**: [User] + Claude

---

## 1. Overview

### Problem Statement
[What problem does this solve?]

### Goals
[What are the measurable objectives?]

### Non-Goals (Out of Scope)
[What this project will NOT do]

---

## 2. Existing Architecture Context

### Tech Stack
- **Framework**: [e.g., Next.js 14, React 18]
- **Language**: [e.g., TypeScript]
- **Key Libraries**: [e.g., TanStack Query, Zustand, Tailwind]

### Relevant Existing Features
[Features similar to what we're building that informed this design]

### Reusable Components/Services
[Existing code that will be leveraged or extended]

### Integration Points
[APIs, services, or systems this feature will connect to]

### Patterns to Follow
[Naming conventions, architectural patterns, testing approach from existing codebase]

---

## 3. User Stories

### Epic: [Epic Name]

#### Story Group A (Parallel Track 1) - [Theme/Foundation]
> These stories can be worked on in parallel with Group B

**Story A1: [User Story Title]**
- **As a** [user type] **I want** [capability] **So that** [benefit]
- **Acceptance Criteria:**
  - [ ] Criterion 1
  - [ ] Criterion 2
- **Dependencies**: None (foundation story)

**Story A2: [User Story Title]**
- **As a** [user type] **I want** [capability] **So that** [benefit]
- **Acceptance Criteria:**
  - [ ] Criterion 1
- **Dependencies**: A1 (must complete first)

#### Story Group B (Parallel Track 2) - [Theme]
> These stories can be worked on in parallel with Group A

**Story B1: [User Story Title]**
- **As a** [user type] **I want** [capability] **So that** [benefit]
- **Acceptance Criteria:**
  - [ ] Criterion 1
- **Dependencies**: None (independent track)

#### Story Group C (Sequential - Requires A & B)
> These stories require completion of Groups A and B

**Story C1: [User Story Title]**
- **As a** [user type] **I want** [capability] **So that** [benefit]
- **Acceptance Criteria:**
  - [ ] Criterion 1
- **Dependencies**: A2, B1 (integration story)

### Story Dependency Graph

```
[A1] ──→ [A2] ──┐
                ├──→ [C1] ──→ [C2]
[B1] ──────────┘

Legend:
──→ = "must complete before"
Stories at same vertical level can run in parallel
```

---

## 4. Technical Requirements

### Data Model
[Entities, relationships, schema considerations]

### API Contracts
[Endpoints, request/response shapes]

### Security Requirements
[Auth, permissions, data protection]

### Performance Requirements
[Load expectations, response times]

---

## 5. Tasks Breakdown

### Parallel Execution Plan

```
Sprint/Phase 1: Foundation (Parallel Tracks)
├── Track A (Backend):     [BE-001] → [BE-002]
├── Track B (Frontend):    [FE-001] → [FE-002]
└── Track C (Infra):       [INFRA-001]

Sprint/Phase 2: Additional Features (After Phase 1)
├── Track A (Backend):     [BE-003]
└── Track B (Frontend):    [FE-003]

Sprint/Phase 3: Integration (MANDATORY - After Phase 2)
└── Track INT:             [FE-INT-001] → [FE-INT-002]
    ├── Connect FE to BE endpoints
    ├── Verify API contracts match
    └── End-to-end verification

Sprint/Phase 4: Polish (After Phase 3)
└── All tracks converge:   [FE-004], [BE-004]
```

> ⚠️ **Phase 3 (Integration) is MANDATORY** when the feature has both backend and frontend tasks. Never skip this phase.

---

### Backend Tasks

#### Track BE-A: [Theme - e.g., Data Layer]

**[BE-001] Task Title** ⚡ Can start immediately
- **Description**: What needs to be done
- **Story**: A1
- **Dependencies**: None
- **Complexity**: Small | Medium | Large
- **Subtasks**:
  - [ ] Subtask 1
  - [ ] Subtask 2

**[BE-002] Task Title** → Requires BE-001
- **Description**: What needs to be done
- **Story**: A2
- **Dependencies**: BE-001
- **Complexity**: Small | Medium | Large

#### Track BE-B: [Theme - e.g., API Layer]

**[BE-003] Task Title** ⚡ Can start immediately (parallel with BE-A)
- **Description**: What needs to be done
- **Story**: B1
- **Dependencies**: None
- **Complexity**: Small | Medium | Large

---

### Frontend Tasks

#### Track FE-A: [Theme - e.g., UI Components]

**[FE-001] Task Title** ⚡ Can start immediately (parallel with Backend)
- **Description**: What needs to be done
- **Story**: A1
- **Dependencies**: None (can build with mocked data)
- **Complexity**: Small | Medium | Large
- **Subtasks**:
  - [ ] Subtask 1
  - [ ] Subtask 2

**[FE-002] Task Title** → Requires FE-001
- **Description**: What needs to be done
- **Story**: A2
- **Dependencies**: FE-001
- **Complexity**: Small | Medium | Large

#### Track FE-INT: Frontend-Backend Integration (REQUIRED)
> ⚠️ **MANDATORY**: Always include this track when PRD has both BE and FE tasks

**[FE-INT-001] Connect Frontend to Backend Endpoints** → Requires all BE-*, all FE-UI-*
- **Description**: Wire frontend components to actual backend API endpoints, replacing any mock data with real API calls
- **Story**: Integration
- **Dependencies**: All BE tasks, All FE UI tasks
- **Complexity**: Medium
- **Subtasks**:
  - [ ] Replace mock data with actual API calls
  - [ ] Verify API response shape matches frontend expectations
  - [ ] Ensure property names align (no mapping errors)
  - [ ] Handle loading, error, and empty states
  - [ ] Test data renders correctly in UI

**[FE-INT-002] Integration Verification** → Requires FE-INT-001
- **Description**: End-to-end verification that frontend and backend work together correctly
- **Story**: Integration
- **Dependencies**: FE-INT-001
- **Complexity**: Small
- **Acceptance Criteria**:
  - [ ] curl backend endpoints → verify correct response shape
  - [ ] Browser test → verify data renders correctly
  - [ ] Test all CRUD operations end-to-end
  - [ ] Verify error handling works (trigger errors, confirm UI shows them)
  - [ ] No console errors related to data/API issues

---

### Infrastructure/Shared Tasks

**[INFRA-001] Task Title** ⚡ Can start immediately
- **Description**: What needs to be done
- **Dependencies**: None
- **Complexity**: Small | Medium | Large

---

## 6. Dependencies & Sequencing

### Task Dependency Graph

```
BACKEND                          FRONTEND                    INFRA
───────                          ────────                    ─────
[BE-001] ─────┐                  [FE-001] ────┐              [INFRA-001]
    │         │                      │        │                  │
    ▼         │                      ▼        │                  │
[BE-002] ─────┼──────────────────[FE-002]     │                  │
    │         │                      │        │                  │
    ▼         │                      ▼        │                  │
[BE-003] ─────┴─────────────────►[FE-003]◄────┘                  │
                                     │                           │
                                     ▼                           │
                                 [FE-004]◄────────────────────────┘

Legend:
─► Sequential dependency (must complete before)
⚡ Tasks with no dependencies can start immediately
Tasks on same row can run in parallel
```

### Parallel Execution Summary

| Phase | Backend Team | Frontend Team | Integration | Infra |
|-------|--------------|---------------|-------------|-------|
| 1 | BE-001, BE-003 | FE-001 | - | INFRA-001 |
| 2 | BE-002 | FE-002, FE-003 | - | - |
| 3 (INT) | - | - | FE-INT-001, FE-INT-002 | - |
| 4 | BE-004 | FE-004 (polish) | - | - |

> ⚠️ **Phase 3 (Integration) is MANDATORY** - FE-INT tasks verify that frontend and backend work together correctly.

### Critical Path
[Identify the longest chain of dependent tasks - this determines minimum timeline]

```
Critical Path: BE-001 → BE-002 → FE-INT-001 → FE-INT-002 → FE-004
```

---

## 7. Open Questions

- [ ] Question 1
- [ ] Question 2

---

## 8. Revision History

| Date | Version | Changes | Reviewed By |
|------|---------|---------|-------------|
| [Date] | 1.0 | Initial draft | - |
```

### Task Breakdown Guidelines

**Story Grouping Rules:**
- Group stories that share a theme or can be worked on together
- Mark independent story groups that can run in parallel
- Identify stories that must wait for other groups to complete
- Create a dependency graph showing the flow

**Backend Tasks (BE-XXX):**
- Database schema/migrations
- API endpoints (CRUD operations)
- Business logic services
- External integrations
- Background jobs/workers

**Frontend Tasks (FE-XXX):**
- UI components (can often start with mocked data - parallel with BE)
- State management
- API integration (depends on BE endpoints)
- Forms and validation
- Routing

**Parallelization Strategy:**
- ⚡ Mark tasks that can start immediately (no dependencies)
- Frontend UI can often be built in parallel with Backend using mocked data
- Integration tasks come after both BE and FE foundations are ready
- Infrastructure tasks are usually independent and can run in parallel

**Dependency Notation:**
- `None` = Can start immediately, no blockers
- `BE-001` = Blocked until BE-001 completes
- `BE-001, FE-002` = Blocked until both complete (integration point)

**Track Organization:**
- Group related tasks into "tracks" by theme
- Each track can have its own dependency chain
- Tracks can run in parallel until they need to integrate

**⚠️ MANDATORY Integration Tasks (when PRD has both BE and FE):**

When a feature includes BOTH backend and frontend tasks, you MUST include integration tasks. This is NOT optional - skipping integration leads to disconnected FE/BE that don't work together.

Required integration tasks:
1. **[FE-INT-001] Connect Frontend to Backend**
   - Wire FE to actual BE endpoints (replace mocks)
   - Verify API response shapes match FE expectations
   - Ensure property names align

2. **[FE-INT-002] Integration Verification**
   - curl + browser verification
   - End-to-end CRUD testing
   - Error handling verification

Integration tasks must:
- Depend on ALL BE tasks and ALL FE UI tasks
- Be in a later Execution Group (after BE and FE groups complete)
- Have explicit acceptance criteria for API contract verification
- Include curl and browser-based validation

Example Execution Groups with Integration:
```
| Group | Tasks | Execution | Blocked By |
|-------|-------|-----------|------------|
| **Group 1** | BE-001, BE-002, FE-001, FE-002 | ⚡ PARALLEL | None |
| **Group 2** | BE-003, FE-003 | ⚡ PARALLEL | Group 1 |
| **Group 3** | FE-INT-001, FE-INT-002 | Sequential | Group 2 |
```

---

## Phase 4: Review - Multi-Agent Critique

After the PRD is written, spawn two specialized review agents to analyze the document.

### Spawn Review Agents

Use the Task tool to spawn both agents **in the background** (set `run_in_background: true`). This allows you to continue monitoring progress and provide updates to the user as reviews complete.

**IMPORTANT**: When spawning review agents:
1. Set `run_in_background: true` on BOTH Task tool calls
2. Spawn both agents in a SINGLE message (parallel execution)
3. Store the returned `output_file` paths for each agent
4. Periodically check progress using `Read` tool on the output files
5. Report to the user as each review completes

**Agent 1: Project Manager Reviewer**
```
Subagent type: general-purpose
run_in_background: true
Prompt: You are a Senior Project Manager reviewing a PRD. Read the document at .claude/Task Documents/PRD-[feature-name].md and provide a critical analysis:

1. **Completeness Check**:
   - Are all user stories complete with acceptance criteria?
   - Are there missing edge cases or scenarios?
   - Is the scope clearly defined?

2. **Task Analysis**:
   - Are tasks properly sized? (Should any be split further?)
   - Are dependencies correctly identified?
   - Is the implementation order logical?
   - Are there missing tasks?

3. **Risk Assessment**:
   - What are potential blockers?
   - Are there ambiguous requirements that could cause delays?
   - What questions remain unanswered?

4. **Recommendations**:
   - Specific improvements needed
   - Priority order for addressing issues

Provide your analysis in a structured format.
```

**Agent 2: Senior Software Engineer Reviewer**
```
Subagent type: general-purpose
run_in_background: true
Prompt: You are a Senior Software Engineer reviewing a PRD for technical feasibility. Read the document at .claude/Task Documents/PRD-[feature-name].md and provide technical critique:

1. **Technical Feasibility**:
   - Are the technical requirements realistic?
   - Are there architectural concerns?
   - Are technology choices appropriate?

2. **Implementation Gaps**:
   - What technical details are missing?
   - Are there implicit requirements not documented?
   - What could cause implementation surprises?

3. **API & Data Model Review**:
   - Is the data model complete and normalized appropriately?
   - Are API contracts well-defined?
   - Are there missing endpoints or fields?

4. **Non-Functional Requirements**:
   - Are performance requirements realistic?
   - Are security considerations adequate?
   - What about error handling, logging, monitoring?

5. **Task Estimates**:
   - Are complexity estimates reasonable?
   - Are there hidden complexities in any tasks?
   - Should any tasks be broken down further?

Provide your analysis in a structured format.
```

### Monitor Background Agents and Collect Reviews

After spawning both review agents in the background:

1. **Monitor Progress**: Use `Read` tool on the `output_file` paths returned by each Task call
2. **Provide Updates**: As each agent completes, inform the user:
   - "✓ PM Review complete - analyzing feedback..."
   - "✓ Engineering Review complete - analyzing feedback..."
3. **Use TaskOutput**: You can also use `TaskOutput` tool with `block: false` to check status without waiting
4. **Compile Feedback**: Once both agents finish, compile their feedback for the refinement phase

---

## Phase 5: Refinement - Collaborative Improvement

Present the combined feedback to the user:

1. **Summarize Review Findings**:
   - Key issues from PM review
   - Key issues from Engineering review
   - Overlapping concerns

2. **Prioritize Issues**:
   - Critical (must address before implementation)
   - Important (should address)
   - Nice-to-have (consider for later)

3. **Propose Solutions**:
   - For each critical/important issue, propose a resolution
   - Get user input on ambiguous items

4. **Update the PRD**:
   - Incorporate agreed-upon changes
   - Update revision history
   - Mark status as "Approved" when complete

5. **Final Confirmation**:
   - Walk through major changes with user
   - Confirm the PRD is ready for implementation

6. **Generate task_plan.md for /planning-parallel**:
   - After PRD is approved, generate a `task_plan.md` in the project root
   - This enables seamless handoff to `/planning-parallel` for implementation

---

## Phase 6: Handoff - Generate Planning Files

After the PRD is approved, generate implementation planning files compatible with `/planning-parallel`:

### Generate task_plan.md

Create `task_plan.md` in the **project root** (not in .claude/) with this structure:

```markdown
# Task Plan: [Feature Name]

## Goal
[One sentence from PRD overview]

## Current Group
Group 1

## PRD Reference
`.claude/Task Documents/PRD-[feature-name].md`

---

## Execution Groups

<!--
INSTRUCTIONS FOR /prd:
- Create groups based on task dependencies from the PRD
- Tasks with no dependencies or shared dependencies go in parallel groups
- Tasks blocked by others go in sequential groups
- Number of tasks per group is FLEXIBLE (2, 3, 5, etc.)
-->

| Group | Tasks | Execution | Blocked By |
|-------|-------|-----------|------------|
| **Group 1** | [List all parallel task IDs] | ⚡ PARALLEL | None |
| **Group 2** | [List all parallel task IDs] | ⚡ PARALLEL | Group 1 |
| **Group 3** | [List task IDs] | Sequential | Group 2 |

---

## Tasks

<!--
INSTRUCTIONS FOR /prd:
- Generate one task section per independent unit of work from the PRD
- Use task IDs from PRD (BE-001, FE-001, INFRA-001, etc.)
- Assign appropriate agent type based on task domain
- Group parallel tasks together, mark with same group number

⚠️ MANDATORY: If PRD has BOTH backend and frontend tasks, you MUST include:
- FE-INT-001: Connect Frontend to Backend Endpoints
- FE-INT-002: Integration Verification
These tasks go in a LATER group that depends on all BE and FE tasks completing.
-->

### [TASK-ID]: [Task Title]
- **Group:** [N] ⚡ (or "Sequential")
- **Agent:** [agent-type: senior-backend-engineer | ui-react-specialist | general-purpose]
- **Status:** pending
- **Blocked By:** [None | Task IDs]
- **Subtasks:**
  - [ ] Subtask 1
  - [ ] Subtask 2
- **Stories:** [Story IDs from PRD]
- **Isolated Files:** findings_[TASK-ID].md, progress_[TASK-ID].md

<!-- Repeat for each task -->

<!-- ⚠️ MANDATORY INTEGRATION TASKS (include when PRD has both BE and FE tasks) -->

### FE-INT-001: Connect Frontend to Backend Endpoints
- **Group:** [LAST-1] Sequential
- **Agent:** ui-react-specialist
- **Status:** pending
- **Blocked By:** [All BE-* tasks], [All FE-* tasks]
- **Subtasks:**
  - [ ] Replace mock data/placeholder API calls with actual backend endpoints
  - [ ] Verify API response shape matches frontend type definitions
  - [ ] Ensure property names align (no mapping errors)
  - [ ] Implement proper loading states during API calls
  - [ ] Implement error handling for API failures
  - [ ] Handle empty state when no data returned
- **Stories:** Integration
- **Isolated Files:** findings_FE-INT-001.md, progress_FE-INT-001.md

### FE-INT-002: Integration Verification
- **Group:** [LAST] Sequential
- **Agent:** ui-react-specialist
- **Status:** pending
- **Blocked By:** FE-INT-001
- **Subtasks:**
  - [ ] curl each backend endpoint → verify correct response shape
  - [ ] Browser test → verify data renders correctly for each component
  - [ ] Test all CRUD operations end-to-end (create, read, update, delete)
  - [ ] Trigger error conditions → verify UI displays errors correctly
  - [ ] Check browser console for any data/API related errors
  - [ ] Verify no TypeScript errors related to API response types
- **Stories:** Integration
- **Isolated Files:** findings_FE-INT-002.md, progress_FE-INT-002.md

<!-- END MANDATORY INTEGRATION TASKS -->

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

### Generate findings.md

Create `findings.md` in the **project root**:

```markdown
# Findings: [Feature Name]

## PRD Reference
`.claude/Task Documents/PRD-[feature-name].md`

## Architecture Context
<!-- Copy relevant sections from PRD Section 2 -->

### Tech Stack
[From PRD]

### Relevant Existing Features
[From PRD]

### Reusable Components
[From PRD]

### Integration Points
[From PRD]

## Implementation Notes
<!-- Add notes during implementation -->

## Research & Discoveries
<!-- Document findings during implementation -->
```

### Notify User

After generating files, inform the user:

> "PRD complete! I've also generated `task_plan.md` and `findings.md` in your project root for use with `/planning-parallel`.
>
> To start implementation, run: `/planning-parallel`"

---

## Quick Reference: File Location

All PRDs are stored in: `.claude/Task Documents/`

Naming convention: `PRD-[feature-name].md`
- Use kebab-case for feature names
- Examples:
  - `PRD-user-authentication.md`
  - `PRD-dashboard-analytics.md`
  - `PRD-payment-integration.md`

---

## Example Invocation

User: `/prd`
Claude: "What feature or capability would you like to build? (Just a brief description - I'll explore the codebase first to understand the context.)"

User: "I want to add a notification system to our app"
Claude: "Let me explore your codebase to understand the architecture and existing patterns..."
[Spawns Explore agent to analyze codebase]

Claude: "I've analyzed your codebase. Here's what I found:
- You're using Next.js with TypeScript and TanStack Query for data fetching
- I see you have an existing toast component in `components/ui/Toast.tsx`
- Your API layer follows the pattern in `services/api/`
- Related: there's a user preferences system that could tie into notification settings

Now let me ask some informed questions..."
[Begins discovery phase with context-aware questions]

[... collaborative refinement continues ...]

Claude: [Creates PRD with architecture context, spawns PM + Engineer reviewers, refines based on feedback]

Claude: "PRD complete! I've also generated `task_plan.md` and `findings.md` in your project root.

To start implementation, run: `/planning-parallel`"
