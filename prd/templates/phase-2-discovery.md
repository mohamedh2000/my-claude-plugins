# Phase 2: Discovery - Requirements Gathering

> **Purpose**: Collaborative requirements gathering informed by codebase exploration.
> **Outcome**: Complete understanding of WHAT to build and HOW it will work.

---

## Phase 2A: High-Level Discovery

Start with broad context. Ask 2-3 questions at a time:

### Vision & Goals
1. "What problem are you trying to solve? What's the high-level goal?"
2. "Who are the primary users? Are there different user types/roles?"
3. "What are the must-have features for the first version?"
4. "What is explicitly out of scope?"

### Deeper Probing (based on answers)
- "Walk me through how a user would accomplish [X]?"
- "What happens when [unusual scenario]?"
- "How will you measure if this is successful?"

### Context-Aware Questions (use exploration findings)
- "I noticed you have [existing feature]. How should the new feature relate to it?"
- "Your codebase uses [pattern]. Should we follow the same approach here?"
- "I see [component] already handles [similar thing]. Can we extend it or do we need something new?"

---

## Phase 2B: Implementation Deep-Dive (CRITICAL - DO NOT SKIP)

**This phase prevents the #1 cause of PRD failures: vague technical requirements.**

For EACH feature/user story, answer these questions explicitly:

### Data Source Questions
- "Where does this data come from? (existing API, new endpoint, external service, user input)"
- "If new endpoint: what's the exact request/response contract?"
- "If existing API: which endpoint? Does it return everything needed or needs modification?"
- "If external service: what's the integration method? (SDK, REST API, webhook)"
- "What authentication/authorization is required to access this data?"

### Data Model Questions
- "What are ALL the fields needed? (not just 'a user object' - list every field)"
- "What are the data types for each field?"
- "Which fields are required vs optional?"
- "What are the validation rules for each field?"
- "What are the relationships between entities?"

### API Contract Questions (for EACH endpoint)
```
Endpoint: [METHOD] /api/[path]
Request Body: { field1: type, field2: type, ... }
Response Success (200): { field1: type, field2: type, ... }
Response Error (4xx/5xx): { error: string, code: string, ... }
Auth: [required | optional | none]
Rate Limits: [if applicable]
```

### State Management Questions
- "Where will this data live in the frontend? (component state, global store, URL params, localStorage)"
- "How will the data be fetched? (on mount, on action, polling, real-time)"
- "What caching strategy? (cache duration, invalidation triggers)"
- "What optimistic updates are needed?"

### UI State Questions (for EACH component/screen)
- "What does the loading state look like?"
- "What does the empty state look like? (no data)"
- "What does the error state look like? (API failure, validation error)"
- "What does the partial data state look like? (some fields missing)"
- "What are all the possible states this UI can be in?"

### Integration Questions
- "How does the frontend call this backend endpoint? (fetch wrapper, React Query, tRPC)"
- "What's the exact data transformation needed between API response and UI state?"
- "Are there any field name mismatches to handle?"

### Edge Cases & Error Handling
- "What happens if the API returns an error?"
- "What happens if the user loses network connection?"
- "What happens if the user navigates away mid-operation?"
- "What happens if there's a race condition?"
- "What happens if the data is stale?"

### Dependency Impact Questions (CRITICAL for modifications)

If this feature MODIFIES existing entities/APIs/components (not just creates new ones):

- "What existing code uses this data model? (List all files)"
- "What existing components depend on this API response shape?"
- "If we change this field/prop, what will break?"
- "Are there other features that fetch this same data?"
- "What types/interfaces will need updating?"
- "Are there cached queries that will need invalidation?"
- "Are there tests that will need updating?"

**For each dependent identified:**
- "What specific update does it need?"
- "Can it be updated in parallel or does it need to wait for the change?"
- "Is this a breaking change or additive change?"

---

## Conversation Guidelines

- Ask 2-3 questions at a time, not overwhelming lists
- Summarize understanding after each exchange
- **DO NOT accept vague answers** - push for specifics
- If user says "just a user object", ask "what fields specifically?"
- If user says "call the API", ask "which endpoint? what's the contract?"
- Propose concrete solutions when requirements are vague
- Continue until BOTH parties agree requirements are **implementation-ready**

---

## Phase 2 Completion Checklist

**DO NOT proceed to Phase 3 until ALL items are checked:**

### Core Requirements
- [ ] Core user stories defined with acceptance criteria
- [ ] Technical constraints understood
- [ ] Scope boundaries explicit

### Data & API (for EACH endpoint)
- [ ] Exact endpoint/service identified
- [ ] Full request/response contract documented
- [ ] Error response shapes defined

### Data Models (for EACH entity)
- [ ] All fields listed
- [ ] Types specified
- [ ] Validations documented

### UI States (for EACH component/screen)
- [ ] Loading state defined
- [ ] Empty state defined
- [ ] Error state defined

### Integration
- [ ] Data transformation documented (or confirmed as direct mapping)

### Dependencies (for EACH MODIFIED entity/API/component)
- [ ] All dependents identified
- [ ] Required update documented for each
- [ ] Fix-up task created for each breaking change

### Final Confirmation
- [ ] User confirmed: "Yes, this is detailed enough to implement without questions"

---

## Update State File

After completing Phase 2:

```markdown
**PHASE**: 3
**STATUS**: IN_PROGRESS

## Completed Phases
- [x] **Phase 0**: Init
- [x] **Phase 1**: Exploration
- [x] **Phase 2A**: High-level discovery
- [x] **Phase 2B**: Implementation deep-dive

## Session Notes
- User stories: [count]
- API endpoints: [list]
- Data models: [list]
- Dependencies identified: [list of modified entities and their dependents]

## Next Action
**ACTION**: Start Phase 3 - Create PRD.md
```
