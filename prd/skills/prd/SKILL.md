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

## File Structure

All PRD artifacts are stored together in a dedicated folder:

```
.claude/PRD-[feature-name]/
├── PRD.md                                    # The PRD document
├── task_plan.md                              # Execution plan for /planning-parallel
├── findings.md                               # Architecture context from exploration
└── CODE_ARCHITECTURE_PR-[feature-name].md    # Updated architecture with proposed changes
```

The `CODE_ARCHITECTURE_PR-[feature-name].md` is a copy of the project's `CODE_ARCHITECTURE_FEATURES.md` updated to reflect how the architecture would look after implementing the proposed feature. This allows reviewers to see the architectural impact of the PRD.

**Feature name inference:**
- Derive from user's feature description (kebab-case)
- Examples: `notifications`, `user-authentication`, `dashboard-analytics`
- Ask user to confirm if ambiguous

---

## Phase 0: Check for Existing PRD (Entry Point)

Before starting the workflow, perform two checks:
1. **Architecture Features Check**: Ensure project architecture is documented
2. **Existing PRD Check**: Check if an existing PRD file or folder was provided

### Step 0.1: Check for CODE_ARCHITECTURE_FEATURES.md

**FIRST**, before doing anything else, check if `.claude/CODE_ARCHITECTURE_FEATURES.md` exists:

```
Read file: .claude/CODE_ARCHITECTURE_FEATURES.md
```

**If the file does NOT exist**, spawn a background agent to create it:

```
Subagent type: Explore
run_in_background: true
Prompt: You are creating a comprehensive architecture documentation for this project.

Create `.claude/CODE_ARCHITECTURE_FEATURES.md` with the following structure:

# Project Architecture & Features

## Last Updated
[Current date]

## 1. Project Overview
- **Name**: [Project name from package.json or directory]
- **Type**: [Web app, API, CLI, library, etc.]
- **Description**: [Brief description of what the project does]

## 2. Tech Stack

### Core Technologies
| Category | Technology | Version |
|----------|------------|---------|
| Language | [e.g., TypeScript] | [version] |
| Framework | [e.g., Next.js] | [version] |
| Runtime | [e.g., Node.js] | [version] |

### Key Dependencies
| Package | Purpose | Category |
|---------|---------|----------|
| [package] | [what it does] | [UI/State/Data/Auth/etc.] |

## 3. Architecture Diagram

```
[ASCII diagram showing the high-level architecture]
Example:
┌─────────────────────────────────────────────────────────────┐
│                        CLIENT                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Pages     │  │ Components  │  │   State/Stores      │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
│         └────────────────┼───────────────────┘              │
└─────────────────────────┬───────────────────────────────────┘
                          │ API Calls
┌─────────────────────────┴───────────────────────────────────┐
│                        SERVER                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Routes    │  │  Services   │  │   Data Layer        │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 4. Directory Structure

```
[Root directory structure with explanations]
project/
├── src/
│   ├── components/     # Reusable UI components
│   ├── pages/          # Route pages
│   ├── services/       # Business logic & API clients
│   ├── hooks/          # Custom React hooks
│   ├── utils/          # Helper functions
│   └── types/          # TypeScript type definitions
├── public/             # Static assets
└── ...
```

## 5. Features Map

### Implemented Features

| Feature | Description | Key Files | Status |
|---------|-------------|-----------|--------|
| [Feature name] | [What it does] | [Main files] | ✅ Complete |

### Feature Flow Diagrams

#### [Feature 1 Name]
```
User Action → Component → Hook/Store → API → Backend → Response → UI Update
```

[Detailed flow for each major feature]

## 6. UI Components Inventory

### Pages
| Page | Route | Description | Key Components |
|------|-------|-------------|----------------|
| [PageName] | /path | [Purpose] | [Components used] |

### Shared Components
| Component | Location | Props | Used By |
|-----------|----------|-------|---------|
| [Component] | [path] | [key props] | [pages/features] |

### Component Hierarchy
```
App
├── Layout
│   ├── Header
│   │   ├── Logo
│   │   └── Navigation
│   ├── Main Content
│   │   └── [Page-specific content]
│   └── Footer
└── Providers
    ├── AuthProvider
    ├── ThemeProvider
    └── [Other providers]
```

## 7. Data Flow & State Management

### State Architecture
[Describe state management approach: Redux, Zustand, Context, etc.]

### Data Fetching Patterns
[Describe how data is fetched: React Query, SWR, custom hooks, etc.]

### Key Data Models
| Model | Fields | Relationships |
|-------|--------|---------------|
| [Entity] | [key fields] | [related entities] |

## 8. API Structure

### Internal APIs
| Endpoint | Method | Purpose | Auth Required |
|----------|--------|---------|---------------|
| /api/... | GET/POST | [Purpose] | Yes/No |

### External Integrations
| Service | Purpose | SDK/Method |
|---------|---------|------------|
| [Service] | [What for] | [How integrated] |

## 9. Patterns & Conventions

### Code Patterns
- **Component Pattern**: [Functional/Class, co-location, etc.]
- **State Pattern**: [How state is managed]
- **Error Handling**: [How errors are caught/displayed]
- **Styling Pattern**: [Tailwind, CSS Modules, Styled Components, etc.]

### Naming Conventions
- Components: PascalCase
- Files: [convention]
- Functions: camelCase
- Constants: UPPER_SNAKE_CASE

### Testing Approach
[Testing strategy, frameworks used, coverage expectations]

## 10. Dependencies Graph

```
[Show how major modules depend on each other]
```

---

**Instructions**:
1. Explore the entire codebase thoroughly
2. Map all existing features, pages, and components
3. Trace data flows and state management
4. Document all API endpoints
5. Create accurate diagrams
6. Be comprehensive - this document will be used for future feature planning

Return a summary of what you documented.
```

**Continue with the workflow** while the background agent runs. The architecture document will be available for future `/prd` runs.

**If the file DOES exist**, read it and use it as context for the current PRD:
- Note the existing features to avoid duplication
- Understand the established patterns to follow
- Identify potential integration points for new features

### Step 0.2: Argument Detection

Check the provided arguments:
- **If argument is a folder path** (e.g., `.claude/PRD-notifications`):
  - Read `PRD.md` from that folder
  - Parse the PRD content
  - Jump to appropriate phase based on PRD status
- **If argument is a file path** (ends with `.md`):
  - Read the file directly
  - Parse the PRD content
  - Jump to appropriate phase based on PRD status
- **If argument is a description** (or empty):
  - Proceed to Phase 1 (Exploration) as normal
  - Use description as initial feature context if provided

### Loading Existing PRD

If a path is provided:

```
1. Read the PRD file at the provided path (or PRD.md in the folder)
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
/prd .claude/PRD-notifications
```

Claude reads `.claude/PRD-notifications/PRD.md`, analyzes completeness, and continues:
> "I've loaded your PRD for the Notification System. The user stories look complete, but I noticed the API contracts section is empty. Let me ask a few questions:
> 1. What format should notifications be returned in - paginated list or infinite scroll?
> 2. Should read/unread status be tracked per-notification or per-user?"

---

## Phase 1: Exploration - Codebase Understanding

Before asking requirements questions, gain context about the existing project. This enables more informed questions and ensures the PRD aligns with current architecture.

### Step 1: Read Existing Architecture Knowledge

First, read both architecture documents if they exist:

```
Read file: .claude/CODE_ARCHITECTURE_FEATURES.md (comprehensive features/UI map)
Read file: .claude/CODEBASE_ARCHITECTURE.md (accumulated exploration findings)
```

**CODE_ARCHITECTURE_FEATURES.md** provides:
- Complete feature inventory with status
- UI components hierarchy and relationships
- Data models and API structure
- Established patterns and conventions

**CODEBASE_ARCHITECTURE.md** contains:
- Accumulated knowledge from previous explorations
- Feature-specific deep dives
- Integration point discoveries

Use both documents as context to:
- Avoid proposing features that already exist
- Follow established patterns and conventions
- Identify reusable components and integration points
- Understand the full scope of the current system

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

### Step 1: Create PRD Folder

First, create the PRD folder if it doesn't exist:
```
mkdir -p .claude/PRD-[feature-name]
```

### Step 2: Generate PRD Document

Create the PRD at: `.claude/PRD-[feature-name]/PRD.md`

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
Prompt: You are a Senior Project Manager reviewing a PRD. Read the document at .claude/PRD-[feature-name]/PRD.md and provide a critical analysis:

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
Prompt: You are a Senior Software Engineer reviewing a PRD for technical feasibility. Read the document at .claude/PRD-[feature-name]/PRD.md and provide technical critique:

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

After the PRD is approved, generate implementation planning files in the same PRD folder:

### Generate task_plan.md

Create `task_plan.md` in `.claude/PRD-[feature-name]/` with this structure:

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

Create `findings.md` in `.claude/PRD-[feature-name]/`:

```markdown
# Findings: [Feature Name]

## PRD Reference
`.claude/PRD-[feature-name]/PRD.md`

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

### Generate CODE_ARCHITECTURE_PR-[feature-name].md

Create an updated architecture document that shows how the project would look after implementing the proposed feature.

**If `.claude/CODE_ARCHITECTURE_FEATURES.md` exists**, use it as the base. Otherwise, create from scratch based on PRD content.

Create `CODE_ARCHITECTURE_PR-[feature-name].md` in `.claude/PRD-[feature-name]/`:

```markdown
# Project Architecture & Features (Post-[Feature Name])

> **Note**: This document shows the projected architecture after implementing the [Feature Name] feature.
> Base document: `.claude/CODE_ARCHITECTURE_FEATURES.md`
> Related PRD: `.claude/PRD-[feature-name]/PRD.md`

## Proposed Changes Summary

| Section | Change Type | Description |
|---------|-------------|-------------|
| Features Map | Addition | [New feature being added] |
| UI Components | Addition/Modification | [New/modified components] |
| Data Models | Addition/Modification | [New/modified models] |
| API Structure | Addition | [New endpoints] |

---

[Copy all sections from CODE_ARCHITECTURE_FEATURES.md, then UPDATE the following sections to reflect the proposed changes:]

## 5. Features Map

### Implemented Features
[Keep existing features, ADD:]

| Feature | Description | Key Files | Status |
|---------|-------------|-----------|--------|
| [Existing features...] | | | ✅ Complete |
| **[New Feature Name]** | [From PRD overview] | [Proposed files from task plan] | 🚧 Proposed |

### Feature Flow Diagrams

#### [New Feature Name] (Proposed)
```
[Create flow diagram based on PRD user stories and technical requirements]
User Action → [Component] → [Hook/Store] → [API] → [Backend] → Response → UI Update
```

## 6. UI Components Inventory

### Pages
[Keep existing, ADD new pages from PRD:]

| Page | Route | Description | Key Components |
|------|-------|-------------|----------------|
| [Existing...] | | | |
| **[NewPage]** | /[route] | [From PRD] | [Proposed components] | 🚧 |

### Shared Components
[Keep existing, ADD new components from PRD:]

| Component | Location | Props | Used By |
|-----------|----------|-------|---------|
| [Existing...] | | | |
| **[NewComponent]** | [proposed path] | [from PRD] | [proposed usage] | 🚧 |

### Component Hierarchy (Updated)
```
[Update hierarchy to show where new components fit]
```

## 7. Data Flow & State Management

### Key Data Models
[Keep existing, ADD new models from PRD:]

| Model | Fields | Relationships |
|-------|--------|---------------|
| [Existing...] | | |
| **[NewModel]** | [from PRD data model] | [from PRD] | 🚧 |

## 8. API Structure

### Internal APIs
[Keep existing, ADD new endpoints from PRD:]

| Endpoint | Method | Purpose | Auth Required |
|----------|--------|---------|---------------|
| [Existing...] | | | |
| **[/api/new]** | [method] | [from PRD] | [from PRD] | 🚧 |

---

## Legend
- ✅ Complete - Existing, implemented
- 🚧 Proposed - Part of this PRD, not yet implemented

## Implementation Impact Analysis

### Files to Create
[List from task_plan.md]

### Files to Modify
[List existing files that need changes]

### Integration Points
[Where new feature connects to existing system]

### Potential Conflicts
[Any areas where new feature might conflict with existing code]
```

**Important**:
- Mark all new/modified items with 🚧 to distinguish from existing features
- Preserve all existing content from CODE_ARCHITECTURE_FEATURES.md
- Only add/modify sections relevant to the new feature
- Include an "Implementation Impact Analysis" section to help reviewers understand scope

### Notify User

After generating files, inform the user:

> "PRD complete! All artifacts are in `.claude/PRD-[feature-name]/`:
> - `PRD.md` - The requirements document
> - `task_plan.md` - Execution plan
> - `findings.md` - Architecture context
> - `CODE_ARCHITECTURE_PR-[feature-name].md` - Architecture with proposed changes
>
> To start implementation, run: `/planning-parallel .claude/PRD-[feature-name]/task_plan.md`"

---

## Quick Reference: File Location

All PRD artifacts are stored in: `.claude/PRD-[feature-name]/`

```
.claude/PRD-[feature-name]/
├── PRD.md                                    # The PRD document
├── task_plan.md                              # Execution plan for /planning-parallel
├── findings.md                               # Architecture context from exploration
└── CODE_ARCHITECTURE_PR-[feature-name].md    # Architecture with proposed changes
```

**Project-level architecture** (created automatically if missing):
```
.claude/CODE_ARCHITECTURE_FEATURES.md         # Full project architecture & features map
```

Naming convention for folders:
- Use kebab-case for feature names
- Examples:
  - `.claude/PRD-user-authentication/`
  - `.claude/PRD-dashboard-analytics/`
  - `.claude/PRD-payment-integration/`

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

Claude: [Creates PRD folder, generates PRD.md, spawns PM + Engineer reviewers, refines based on feedback]

Claude: "PRD complete! All artifacts are in `.claude/PRD-notifications/`:
- `PRD.md` - The requirements document
- `task_plan.md` - Execution plan
- `findings.md` - Architecture context
- `CODE_ARCHITECTURE_PR-notifications.md` - Architecture with proposed changes

To start implementation, run: `/planning-parallel .claude/PRD-notifications/task_plan.md`"
