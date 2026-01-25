# Phase 1: Exploration - Codebase Understanding

> **Purpose**: Gain context about existing project before asking requirements questions.
> **Outcome**: Architecture understood, relevant patterns identified, dependency map created.

---

## Step 1: Read Existing Architecture Knowledge

Read both architecture documents if they exist:

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

Use both documents to:
- Avoid proposing features that already exist
- Follow established patterns and conventions
- Identify reusable components and integration points
- Understand the full scope of the current system

---

## Step 2: Get Feature Context from User

Ask the user one simple question:

> "What feature or capability would you like to build? (Just a brief description - I'll explore the codebase to understand the relevant context.)"

---

## Step 3: Spawn Exploration Agent

```
Subagent type: Explore
Prompt: You are exploring a codebase to inform a PRD for: [USER'S FEATURE DESCRIPTION]

**First**: Read .claude/CODEBASE_ARCHITECTURE.md to understand what's already documented.

**Then**: Focus on areas relevant to this feature:

### 1. Feature-Relevant Code
- Find existing features similar to what user wants to build
- Identify components, services, or utilities that could be reused
- Map integration points the new feature will need

### 2. Gaps in Architecture Doc
- If tech stack section is incomplete, fill it in
- If relevant code flows aren't documented, trace and document them
- If patterns aren't documented, identify and record them

### 3. Specific Code Paths
- Trace data flow for similar features
- Identify where new code would integrate
- Note any constraints or dependencies

### 4. CRITICAL - Dependency Mapping
For each entity/API/component that the new feature will CREATE or MODIFY, find what ALREADY USES it:

**Data Model Dependencies:**
- If modifying an existing model (e.g., User), find ALL places that:
  - Import/reference this model
  - Query this table
  - Display fields from this model
- Use: `grep -r "User" --include="*.ts" --include="*.tsx"`

**API Dependencies:**
- If modifying an existing endpoint, find ALL places that:
  - Call this endpoint (frontend fetch calls, other services)
  - Depend on its response shape
- Use: `grep -r "/api/users" --include="*.ts" --include="*.tsx"`

**Component Dependencies:**
- If modifying a shared component, find ALL places that:
  - Import this component
  - Pass props to it
- Use: `grep -r "import.*ComponentName" --include="*.tsx"`

**Type/Interface Dependencies:**
- If modifying a type definition, find ALL files that import it
- Use: `grep -r "import.*TypeName" --include="*.ts"`

Create a dependency map:
```
DEPENDENCY MAP:

[Entity/API/Component being modified] is used by:
├── [File1.tsx] - [how it's used]
├── [File2.ts] - [how it's used]
└── [File3.tsx] - [how it's used]

Potential Impact:
- If we change [field/prop/response], these files will need updates
```

**Finally**: Update .claude/CODEBASE_ARCHITECTURE.md with your findings:
- Add any missing tech stack details
- Add the explored feature to "Section 7: Explored Features"
- Update "Exploration History" table with date and findings
- Fill in any other incomplete sections

Return a summary of:
1. What you learned that's relevant to the requested feature
2. What you added/updated in the architecture doc
3. **DEPENDENCY MAP**: What existing code depends on entities this feature will modify
```

---

## Step 4: Verification Gate (MANDATORY)

**Before proceeding to Phase 2**, verify the architecture file exists:

```
Glob: .claude/CODE_ARCHITECTURE_FEATURES.md
```

**If file STILL does not exist:**
1. Inform user: "The architecture file wasn't created. Creating it now..."
2. Create it synchronously using Explore agent (NOT in background)
3. Verify creation with Glob before proceeding

**Do NOT proceed to Phase 2 until `.claude/CODE_ARCHITECTURE_FEATURES.md` exists.**

---

## Phase 1 Completion Checklist

- [ ] Existing architecture documents read
- [ ] Feature description obtained from user
- [ ] Exploration agent completed
- [ ] Dependency map created
- [ ] CODE_ARCHITECTURE_FEATURES.md verified to exist
- [ ] Ready to proceed to Phase 2

---

## Use Exploration to Inform Questions

With codebase context, tailor discovery questions:
- Reference existing patterns: "I see you use [X pattern] for data fetching. Should the new feature follow this?"
- Suggest reuse: "There's an existing [component] that handles [similar thing]. Could we extend it?"
- Identify constraints: "The current auth system uses [approach]. The new feature will need to integrate with this."

---

## Update State File

After completing Phase 1:

```markdown
**PHASE**: 2A
**STATUS**: IN_PROGRESS

## Completed Phases
- [x] **Phase 0**: Init (TODO list, architecture check)
- [x] **Phase 1**: Exploration (codebase understanding)

## Session Notes
- Feature: [user's description]
- Key findings: [summary from exploration]
- Dependency map: [entities that will be affected]

## Next Action
**ACTION**: Start Phase 2A - High-level discovery questions
```
