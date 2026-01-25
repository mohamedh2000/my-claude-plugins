# Phase 0: Initialization

> **Purpose**: Set up tracking and verify prerequisites before starting PRD workflow.
> **Outcome**: TODO list created, architecture file verified/created.

---

## Step 0.1: Create Output Tracking TODO List (MANDATORY)

Create a TODO list to track all required PRD outputs:

```
TodoWrite:
- [ ] Phase 0: Verify/create CODE_ARCHITECTURE_FEATURES.md
- [ ] Phase 1: Complete codebase exploration (including dependency mapping)
- [ ] Phase 2A: Complete high-level requirements discovery
- [ ] Phase 2B: Complete implementation deep-dive (data sources, API contracts, state mgmt)
- [ ] Phase 2B: Complete dependency impact analysis (identify all affected code)
- [ ] Phase 3: Create PRD.md with full technical specifications
- [ ] Phase 3: Complete Section 5 (Dependency Impact Analysis) if modifying existing code
- [ ] Phase 3: Create FIX-XXX tasks for each dependent
- [ ] Phase 4: Complete PM review
- [ ] Phase 4: Complete Engineer review
- [ ] Phase 5: Address all BLOCKER and HIGH issues from reviews
- [ ] Phase 5: Address all DEPENDENCY GAPS from reviews
- [ ] Phase 5: Pass Implementation Readiness Gate (data models, APIs, UI states, dependencies verified)
- [ ] Phase 5: User confirms "implementation-ready without questions"
- [ ] Phase 6: Create task_plan.md (including FIX-XXX tasks)
- [ ] Phase 6: Create findings.md
- [ ] Phase 6: Create CODE_ARCHITECTURE_PR-[feature-name].md
- [ ] Phase 6: VERIFY all 4 files exist
- [ ] Phase 6: VERIFY all FIX tasks have correct dependencies
```

---

## Step 0.2: Check for CODE_ARCHITECTURE_FEATURES.md

```
Read file: .claude/CODE_ARCHITECTURE_FEATURES.md
```

### If file does NOT exist → Create it

Spawn an agent to create it (**BLOCKING - wait for completion**):

```
Subagent type: Explore
run_in_background: false
Prompt: Create comprehensive architecture documentation for this project.

Create `.claude/CODE_ARCHITECTURE_FEATURES.md` with these sections:

1. Project Overview (name, type, description)
2. Tech Stack (core technologies, key dependencies)
3. Architecture Diagram (ASCII)
4. Directory Structure
5. Features Map (implemented features, flow diagrams)
6. UI Components Inventory (pages, shared components, hierarchy)
7. Data Flow & State Management
8. API Structure (internal APIs, external integrations)
9. Patterns & Conventions
10. Dependencies Graph

Be comprehensive - this document will be used for future feature planning.
Return a summary of what you documented.
```

**Verify creation:**
```
Glob: .claude/CODE_ARCHITECTURE_FEATURES.md
```

### If file DOES exist → Use as context

Read it and note:
- Existing features to avoid duplication
- Established patterns to follow
- Potential integration points for new features

---

## Step 0.3: Argument Detection

Check provided arguments:

| Argument Type | Action |
|---------------|--------|
| **Folder path** (e.g., `.claude/PRD-notifications`) | Read `PRD.md` from folder, jump to appropriate phase |
| **File path** (ends with `.md`) | Read file directly, analyze completeness |
| **Description** (or empty) | Proceed to Phase 1 |

### Loading Existing PRD

If path provided:
1. Read the PRD file
2. Check PRD Status field (Draft | In Review | Approved)
3. Analyze complete vs incomplete sections

| Status | Action |
|--------|--------|
| **Draft** | Continue from Discovery/Documentation phase |
| **In Review** | Jump to Phase 4 (spawn reviewers) |
| **Approved** | Jump to Phase 6 (generate task_plan.md) |
| **Incomplete** | Identify gaps, ask clarifying questions |

### Resuming PRD Workflow

When loading existing PRD, summarize what exists:

> "I've loaded the PRD for [Feature Name]. Here's what's defined:
> - ✓ Overview and goals
> - ✓ User stories (5 stories)
> - ⚠️ Technical requirements (incomplete - missing API contracts)
> - ✗ Tasks breakdown (not started)
>
> I have some questions to fill in the gaps..."

---

## Phase 0 Completion Checklist

- [ ] TODO list created
- [ ] CODE_ARCHITECTURE_FEATURES.md exists
- [ ] Existing PRD loaded (if path provided)
- [ ] Ready to proceed to Phase 1

---

## Update State File

After completing Phase 0:

```markdown
**PHASE**: 1
**STATUS**: IN_PROGRESS

## Completed Phases
- [x] **Phase 0**: Init (TODO list, architecture check)

## Next Action
**ACTION**: Start Phase 1 - Get feature description from user
```
