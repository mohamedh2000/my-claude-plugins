# Common Implementation Gaps Reference

> **Usage**: Use this checklist during Phase 2 discovery to catch commonly missed details.

---

## Data Gaps
*Cause: "what fields does this have?"*

- [ ] User object fields (id, email, name, avatar, role, createdAt, etc.)
- [ ] Timestamps (ISO 8601 or Unix? With timezone?)
- [ ] IDs (UUID, auto-increment, nanoid?)
- [ ] Enums (list all possible values, not just "status: string")
- [ ] Nullable fields (can this be null? what's the default?)

---

## API Gaps
*Cause: "what does the API return?"*

- [ ] Exact response shape (not "returns items" but `{ data: Item[], total: number, page: number }`)
- [ ] Error response shapes (what fields? code, message, details?)
- [ ] Pagination format (cursor, offset, or page-based? what fields?)
- [ ] Sort/filter parameters (how are they passed? query params?)

---

## UI Gaps
*Cause: "what should it look like when...?"*

- [ ] Loading state (skeleton? spinner? which parts?)
- [ ] Empty state (illustration? message? CTA?)
- [ ] Error state (inline? toast? full-page?)
- [ ] Partial data (what if some fields are missing?)
- [ ] Optimistic updates (update UI before API confirms?)

---

## Integration Gaps
*Cause: "how do I connect FE to BE?"*

- [ ] Data fetching method (React Query, SWR, fetch, axios?)
- [ ] Cache key structure
- [ ] Cache invalidation triggers
- [ ] Data transformation (API shape → UI shape)
- [ ] Field name mapping (if API uses snake_case, UI uses camelCase)

---

## Common Missing Features
*Cause: "wait, we need that too?"*

- [ ] Pagination
- [ ] Search/filtering
- [ ] Sorting
- [ ] Bulk actions
- [ ] Undo/redo
- [ ] Offline support
- [ ] Real-time updates
- [ ] Export/import

---

## Dependency Gaps
*Cause: "wait, that broke something else!"*

- [ ] Modified a data model but didn't check what components use it
- [ ] Changed API response shape but didn't update frontend types
- [ ] Renamed a field but didn't search for all usages
- [ ] Changed a component's props but didn't update all parents
- [ ] Added required field to existing model (what about existing data?)
- [ ] Changed validation rules (will existing data pass?)
- [ ] Modified a shared hook (what components depend on it?)
- [ ] Updated a type definition (what imports it?)

---

## Verification Commands

Before finalizing PRD, run these checks:

```bash
# For each modified entity, verify dependent count
grep -r "EntityName" --include="*.ts" --include="*.tsx" src/ | wc -l

# For each modified API, find all fetch calls
grep -r "/api/endpoint" --include="*.ts" --include="*.tsx" src/ | wc -l

# For each modified component, find all imports
grep -r "import.*ComponentName" --include="*.tsx" src/ | wc -l
```

Compare results to dependents listed in PRD Section 5.
