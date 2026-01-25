# Phase 5: Refinement & Implementation Readiness Gate

> **Purpose**: Address review feedback and verify PRD is implementation-ready.
> **Outcome**: All blockers resolved, PRD approved, ready for Phase 6.

---

## Step 1: Summarize Review Findings

Present combined feedback to user:
- Key issues from PM review
- Key issues from Engineering review
- Overlapping concerns

---

## Step 2: Prioritize Issues

| Priority | Description | Action |
|----------|-------------|--------|
| **BLOCKER** | Cannot implement without this | Must fix now |
| **HIGH** | Will cause rework if not addressed | Should fix now |
| **MEDIUM** | May cause confusion | Fix if time permits |
| **LOW** | Nice-to-have improvements | Document for later |

---

## Step 3: Address Each Issue

For each BLOCKER and HIGH issue:
1. Propose a specific resolution
2. Get user input on ambiguous items
3. Update the PRD with the resolution
4. Verify the fix addresses the gap

---

## Step 4: Update the PRD

- Incorporate agreed-upon changes
- Fill in any missing technical details
- Update revision history

---

## Step 5: Implementation Readiness Gate (MANDATORY)

**The PRD CANNOT be approved until ALL items pass.**

### A. Data Model Verification

For EACH entity in the PRD:
- [ ] ALL fields listed with specific types (not "user data" but `id: UUID, email: string, createdAt: DateTime`)
- [ ] Required vs optional marked for each field
- [ ] Validation rules specified (max length, regex, allowed values)
- [ ] Relationships and foreign keys defined
- [ ] **Test**: Could you write the database migration from this spec alone?

### B. API Contract Verification

For EACH endpoint in the PRD:
- [ ] Full request body schema with all fields and types
- [ ] Full response body schema with all fields and types
- [ ] All error responses defined (400, 401, 403, 404, 500) with shapes
- [ ] Auth requirements specified
- [ ] **Test**: Could you write the API route handler from this spec alone?

### C. Frontend State Verification

For EACH component/screen in the PRD:
- [ ] Data source identified (which API endpoint)
- [ ] Loading state defined
- [ ] Empty state defined
- [ ] Error state defined with specific error messages
- [ ] **Test**: Could you build this component from this spec alone?

### D. Integration Verification

- [ ] Data transformation from API response → UI state documented (or confirmed as direct mapping)
- [ ] Field names match between API response and frontend expectations
- [ ] Date formats, enum values, and special types specified
- [ ] **Test**: Could you wire the frontend to the backend from this spec alone?

### E. Edge Case Verification

- [ ] What happens on API error is defined
- [ ] What happens on network failure is defined
- [ ] What happens with partial/missing data is defined
- [ ] Validation error handling is specified

### F. Dependency Impact Verification (CRITICAL)

For EACH entity/API/component this feature MODIFIES:
- [ ] All dependents identified (verified with grep search)
- [ ] Each dependent has a specific FIX-XXX task
- [ ] Fix-up tasks have correct dependencies (blocked by the change)
- [ ] Fix-up tasks specify exact file paths and changes
- [ ] **Test**: Run `grep -r "[ModifiedEntity]" --include="*.ts"` - does the count match PRD?

**Verification Command (run for each modified entity):**
```bash
# Count actual usages
grep -r "EntityName" --include="*.ts" --include="*.tsx" src/ | grep -v "node_modules" | wc -l

# Compare to dependents listed in PRD Section 5
# If counts don't match, dependency analysis is incomplete
```

### G. Final Litmus Test

**Ask yourself (and the user):**

> "If a developer who has never seen this codebase reads this PRD, can they implement the feature WITHOUT asking a single clarifying question about data shapes, API contracts, UI behavior, or what else might break?"

**Specific questions to verify:**
1. Can they write the database migration from Section 4.1?
2. Can they implement the API routes from Section 4.2?
3. Can they build the UI components from Section 4.4?
4. Can they wire frontend to backend from Section 4.3?
5. Do they know ALL other code that needs updating from Section 5?
6. Are there FIX tasks for every dependent file?

**If ANY answer is NO**, identify what's missing and add it to the PRD.

---

## Step 6: Final Confirmation

Only after the Implementation Readiness Gate passes:

1. Walk through major changes with user
2. Ask: "Is this PRD detailed enough that implementation can proceed without clarifying questions?"
3. If yes, mark status as "Approved"
4. If no, identify remaining gaps and address them

---

## Update State File

After Phase 5 completes:

```markdown
**PHASE**: 6
**STATUS**: IN_PROGRESS

## Completed Phases
- [x] **Phase 5**: Refinement (address feedback, readiness gate)

## Session Notes
- BLOCKER issues addressed: [count]
- HIGH issues addressed: [count]
- Readiness gate: PASSED
- User confirmation: "implementation-ready"

## Next Action
**ACTION**: Start Phase 6 - Generate planning files
```
