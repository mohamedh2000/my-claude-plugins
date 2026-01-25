# Phase 4: Review Prompts

> **Purpose**: Spawn PM and Engineer review agents to analyze the PRD.
> **Outcome**: Critical feedback identifying gaps before implementation.

---

## Spawning Instructions

Use the Task tool to spawn both agents **in the background**:

1. Set `run_in_background: true` on BOTH Task calls
2. Spawn both agents in a SINGLE message (parallel execution)
3. Store the returned `output_file` paths
4. Periodically check progress using `Read` tool on output files
5. Report to user as each review completes

---

## Agent 1: Project Manager Reviewer

```
Subagent type: general-purpose
run_in_background: true
Prompt: You are a Senior Project Manager reviewing a PRD. Read the document at .claude/PRD-[feature-name]/PRD.md and provide a critical analysis.

Your PRIMARY goal is to identify gaps that would cause implementation questions or rework.

## 1. Implementation Readiness Check

For EACH user story, verify:
- [ ] Acceptance criteria are testable (not vague like "works well")
- [ ] Edge cases are explicitly documented
- [ ] Error scenarios are defined
- [ ] The developer could implement this WITHOUT asking questions

Flag any story where you'd need to ask "but what happens when...?"

## 2. Data & API Completeness

- [ ] Every data model has ALL fields listed (not just "user object")
- [ ] Every API endpoint has full request/response contracts
- [ ] Error response shapes are defined
- [ ] Field validations are specified

Flag any place where a developer would need to guess field names or types.

## 3. UI State Coverage

For each component/screen:
- [ ] Loading state is defined
- [ ] Empty state is defined
- [ ] Error state is defined (with specific error messages)
- [ ] All possible states are enumerated

Flag any component missing state definitions.

## 4. Integration Clarity

- [ ] Data flow from API → State → UI is clear
- [ ] Data transformations are documented
- [ ] No gaps between "backend returns X" and "frontend displays Y"

Flag any place where FE/BE integration is hand-wavy.

## 5. Task Analysis

- Are tasks properly sized? (Should any be split?)
- Are dependencies correctly identified?
- Is the implementation order logical?
- Are there missing tasks?

## 6. Dependency Impact Analysis (Section 5 of PRD)

- [ ] All MODIFIED entities are identified (not just new ones)
- [ ] For each modified entity, ALL dependents are listed
- [ ] Each dependent has a specific update documented
- [ ] Fix-up tasks (FIX-XXX) are created for each affected file
- [ ] Fix-up tasks have correct dependencies (blocked by the change they depend on)
- [ ] No "orphan" changes (changes without corresponding fix-ups)

**Flag any place where:**
- A change is made but dependents aren't identified
- A dependent is listed but no fix-up task exists
- A fix-up task is missing specific update instructions

## 7. Critical Question

**Could a developer implement this feature from this PRD alone, without asking any clarifying questions?**

If NO, list every question they would need to ask.

## Output Format

### Implementation Blockers (MUST FIX)
[List issues that WILL cause implementation questions]

### Dependency Gaps (MUST FIX)
[Missing impact analysis, unidentified dependents, missing fix-up tasks]

### Gaps (SHOULD FIX)
[List missing details that may cause confusion]

### Suggestions (NICE TO HAVE)
[Optional improvements]

### Unanswered Questions
[Questions a developer would need to ask]
```

---

## Agent 2: Senior Software Engineer Reviewer

```
Subagent type: general-purpose
run_in_background: true
Prompt: You are a Senior Software Engineer reviewing a PRD for technical feasibility and implementation readiness. Read the document at .claude/PRD-[feature-name]/PRD.md and provide technical critique.

Your PRIMARY goal is to identify technical gaps that would require guesswork or research during implementation.

## 1. Data Model Completeness

For EACH entity in section 4.1:
- [ ] Are ALL fields listed? (Not just "user data" - every field)
- [ ] Are data types specific? (Not just "string" - what kind? UUID, email, enum?)
- [ ] Are field constraints documented? (max length, regex, allowed values)
- [ ] Are nullable fields marked?
- [ ] Are default values specified?
- [ ] Are relationships fully defined? (foreign keys, cascades)
- [ ] Are indexes specified for query patterns?

**Flag any entity where you'd need to guess fields or types.**

## 2. API Contract Completeness

For EACH endpoint in section 4.2:
- [ ] Request body has ALL fields with types and required/optional
- [ ] Response body has EXACT shape (not "returns user object")
- [ ] ALL error responses are defined (400, 401, 403, 404, 500)
- [ ] Error response shapes match frontend error handling
- [ ] Pagination format is specified (if applicable)
- [ ] Query parameters are documented

**Flag any endpoint where response shape is ambiguous.**

## 3. Frontend-Backend Contract Alignment

- [ ] API response field names match what frontend expects
- [ ] Data transformations are documented (if API shape ≠ UI shape)
- [ ] No implicit assumptions about data format
- [ ] Date/time formats are specified (ISO 8601? Unix timestamp?)
- [ ] Enum values are listed (not just "status: string")

**Flag any place where FE and BE might interpret data differently.**

## 4. State Management Verification

- [ ] It's clear where each piece of data lives (server vs local state)
- [ ] Cache invalidation triggers are defined
- [ ] Optimistic update strategy is clear (if applicable)
- [ ] Real-time update strategy is clear (if applicable)

## 5. Missing Technical Details

Check for these commonly missed items:
- [ ] Pagination: How? Cursor-based or offset? Page size?
- [ ] Sorting: What fields? Default sort?
- [ ] Filtering: What filters? How are they passed?
- [ ] Search: Full-text? Fuzzy? Which fields?
- [ ] File uploads: Max size? Allowed types? Storage location?
- [ ] Background jobs: Retry policy? Failure handling?
- [ ] Webhooks: Payload format? Retry logic? Signature verification?

## 6. Error Handling Gaps

- [ ] Every API call has corresponding error handling in UI
- [ ] Error messages are user-friendly (not raw API errors)
- [ ] Retry logic is specified where appropriate
- [ ] Timeout handling is defined

## 7. Security Review

- [ ] Auth requirements per endpoint are specified
- [ ] Authorization rules are explicit (who can do what)
- [ ] Input validation is defined
- [ ] Rate limiting is specified
- [ ] Sensitive data handling is documented

## 8. Dependency & Breaking Change Review (CRITICAL)

Check Section 5 (Dependency Impact Analysis):

**For each MODIFIED entity (data model, API, component, type):**
- [ ] Is the modification clearly described?
- [ ] Are ALL dependents identified? (Use grep to verify)
- [ ] For each dependent, is the required update specific?
- [ ] Is there a FIX-XXX task for each dependent?
- [ ] Do FIX tasks have correct blocking dependencies?

**Verify dependency completeness:**
```bash
# For modified models, search for all usages
grep -r "ModelName" --include="*.ts" --include="*.tsx" | wc -l
# Compare count to dependents listed in PRD
```

**Flag if:**
- A model/API is modified but Section 5 is empty or says "N/A"
- Dependents listed don't match actual usage count from grep
- Fix-up tasks are vague ("update component" instead of specific changes)
- Fix-up tasks don't specify which files

**Breaking Change Risk Assessment:**
| Change | Risk | Mitigation |
|--------|------|------------|
| [API response shape] | HIGH | FIX-001, FIX-002 cover all consumers |
| [DB field rename] | HIGH | Migration included in BE-001 |

## 9. Implementation Questions

**As an engineer about to implement this, list EVERY question you'd need to ask before starting:**

Example questions:
- "What exact fields does the User object have?"
- "What's the response shape for GET /api/items?"
- "What error code does the API return for X?"
- "How should the UI handle Y error?"
- "What other components use this model and will they break?"

## Output Format

### BLOCKER: Cannot Implement Without Answers
[Issues that WILL block implementation - missing data shapes, undefined contracts]

### BLOCKER: Dependency Gaps
[Missing impact analysis - changes without identified dependents, missing fix-up tasks]

### HIGH: Will Cause Rework
[Gaps that will likely cause incorrect implementations]

### MEDIUM: May Cause Confusion
[Unclear areas that could be interpreted multiple ways]

### Implementation Questions I'd Need To Ask
[Every question an engineer would need answered]

### Breaking Change Risks
[Changes that could break existing features if not handled correctly]

### Technical Debt Warnings
[Architectural concerns or scalability issues]
```

---

## Monitoring Progress

After spawning both agents:

1. **Monitor Progress**: Use `Read` tool on `output_file` paths
2. **Provide Updates**:
   - "PM Review complete - analyzing feedback..."
   - "Engineering Review complete - analyzing feedback..."
3. **Use TaskOutput**: Can also use with `block: false` to check status
4. **Compile Feedback**: Once both finish, compile for refinement phase

---

## Update State File

After reviews complete:

```markdown
**PHASE**: 5
**STATUS**: IN_PROGRESS

## Completed Phases
- [x] **Phase 4**: Review (PM + Engineer)

## Session Notes
- PM review: [summary of key findings]
- Engineer review: [summary of key findings]
- BLOCKER issues: [count]
- HIGH issues: [count]

## Next Action
**ACTION**: Start Phase 5 - Address review feedback
```
