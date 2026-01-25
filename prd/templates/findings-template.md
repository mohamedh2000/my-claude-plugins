# Findings Template

> **Usage**: Copy this template when creating `.claude/PRD-[feature-name]/findings.md`

---

```markdown
# Findings: [Feature Name]

## PRD Reference
`.claude/PRD-[feature-name]/PRD.md`

---

## Architecture Context

### Tech Stack
<!-- Copy from PRD Section 2 -->
- **Framework**: [e.g., Next.js 14]
- **Language**: [e.g., TypeScript]
- **Key Libraries**: [e.g., TanStack Query, Zustand]

### Relevant Existing Features
<!-- Copy from PRD Section 2 -->
[Features similar to what we're building]

### Reusable Components
<!-- Copy from PRD Section 2 -->
| Component | Location | Can Reuse For |
|-----------|----------|---------------|
| [Component] | [path] | [purpose in new feature] |

### Integration Points
<!-- Copy from PRD Section 2 -->
| System | Integration Method | Notes |
|--------|-------------------|-------|
| [API/Service] | [method] | [notes] |

---

## Patterns to Follow

### Code Patterns
<!-- From exploration and PRD Section 2 -->
- **Data Fetching**: [React Query / SWR / etc.]
- **State Management**: [Zustand / Redux / Context]
- **Component Pattern**: [pattern description]
- **Error Handling**: [pattern description]

### Naming Conventions
- **Components**: PascalCase
- **Files**: [convention]
- **Functions**: camelCase
- **Types**: PascalCase with suffix (e.g., `UserType`, `ApiResponse`)

### Directory Structure
```
[Relevant directory structure for new feature]
```

---

## Implementation Notes

<!-- Add notes during implementation -->

### [Task ID] Notes
- [Discovery or decision made during implementation]
- [Unexpected finding]
- [Workaround applied]

---

## Research & Discoveries

<!-- Document findings during implementation -->

### [Date] - [Topic]
**Question**: [What needed to be researched]
**Finding**: [What was discovered]
**Impact**: [How this affects implementation]

---

## Dependencies Discovered

<!-- Track dependencies found during implementation -->

| Entity Modified | New Dependent Found | Update Required |
|-----------------|---------------------|-----------------|
| [entity] | [file] | [what update] |

---

## Open Questions (Resolved)

| Question | Answer | Resolved By |
|----------|--------|-------------|
| [Question from implementation] | [Answer] | [Person/Source] |

---

## Lessons Learned

<!-- Add after feature is complete -->

### What Went Well
- [item]

### What Could Be Improved
- [item]

### For Future PRDs
- [recommendation]
```
