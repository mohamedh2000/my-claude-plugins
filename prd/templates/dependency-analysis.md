# Dependency Impact Analysis Template

> **Usage**: Fill this section when the feature MODIFIES existing entities, APIs, or components.
> Copy into PRD Section 5.

---

## 5.1 Modified Entities & Their Dependents

For each data model, API, component, or type that this feature MODIFIES (not creates new):

### [Entity/API/Component Name] - MODIFIED

**What's changing:**
- [ ] Field added: [field name, type]
- [ ] Field removed: [field name]
- [ ] Field renamed: [old name] → [new name]
- [ ] Field type changed: [field] from [old type] to [new type]
- [ ] Response shape changed: [description]
- [ ] Props changed: [description]

**Dependent Code (will need updates):**

| File | Usage | Required Update | Task ID |
|------|-------|-----------------|---------|
| `src/components/Example.tsx` | Displays `entity.field` | Update to use `entity.newField` | FIX-001 |
| `src/pages/page.tsx` | Fetches `/api/entity` | Update response type | FIX-002 |
| `src/hooks/useEntity.ts` | Caches entity data | Update cache key shape | FIX-003 |
| `src/types/entity.ts` | Type definition | Update interface | FIX-004 |

**Breaking Changes:**
- [ ] API response shape change (frontend must update)
- [ ] Database schema change (migration required)
- [ ] Component props change (all usages must update)
- [ ] Type definition change (all imports must update)

---

## 5.2 Dependency Graph

```
[Modified Entity]
├── [Component1.tsx] ──→ needs: update field access
│   └── [ParentComponent.tsx] ──→ needs: update props
├── [useHook.ts] ──→ needs: update return type
├── [types.ts] ──→ needs: update interface
└── [api.ts] ──→ needs: update response handling
```

---

## 5.3 Affected Features Summary

| Feature | Impact Level | What Breaks | Fix Required |
|---------|--------------|-------------|--------------|
| [Feature 1] | HIGH | [specific breakage] | [specific fix] |
| [Feature 2] | MEDIUM | [what degrades] | [optional improvement] |
| [Feature 3] | LOW | Nothing breaks | None |

**Impact Levels:**
- **HIGH**: Will break if not updated (compile error, runtime error, wrong data)
- **MEDIUM**: Will work but with degraded experience (missing new data, deprecated usage)
- **LOW**: No breaking changes but could benefit from update

---

## 5.4 Fix-Up Tasks (Auto-Generated)

> These tasks are REQUIRED to maintain consistency after implementing this feature.

### [FIX-001] [Descriptive title]

- **Priority:** HIGH (blocking) | MEDIUM | LOW
- **Blocked By:** [Task that makes the change, e.g., BE-001]
- **Files:**
  - `src/path/to/file1.tsx`
  - `src/path/to/file2.ts`
- **Changes:**
  - [ ] Update `entity.oldField` → `entity.newField`
  - [ ] Add null check for new optional field
  - [ ] Update type import
- **Verification:**
  - [ ] TypeScript compiles without errors
  - [ ] Component renders correctly
  - [ ] No console errors

### [FIX-002] [Descriptive title]

- **Priority:** HIGH (blocking)
- **Blocked By:** [BE-002]
- **Files:**
  - `src/path/to/file.tsx`
- **Changes:**
  - [ ] Update API response type definition
  - [ ] Update destructuring pattern
- **Verification:**
  - [ ] Types match API response
  - [ ] Data displays correctly

---

## Verification Checklist

Before marking dependency analysis complete:

- [ ] Ran grep for each modified entity, counted usages
- [ ] All usages are listed as dependents
- [ ] Each dependent has a FIX-XXX task
- [ ] FIX tasks have correct blocking dependencies
- [ ] FIX tasks specify exact file paths
- [ ] FIX tasks describe specific code changes
- [ ] FIX tasks have verification criteria
