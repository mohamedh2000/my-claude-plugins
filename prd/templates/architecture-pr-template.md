# Architecture PR Template

> **Usage**: Copy this template when creating `.claude/PRD-[feature-name]/CODE_ARCHITECTURE_PR-[feature-name].md`
> This shows how the project architecture would look after implementing the proposed feature.

---

```markdown
# Project Architecture & Features (Post-[Feature Name])

> **Note**: This document shows the projected architecture after implementing the [Feature Name] feature.
> Base document: `.claude/CODE_ARCHITECTURE_FEATURES.md`
> Related PRD: `.claude/PRD-[feature-name]/PRD.md`

---

## Proposed Changes Summary

| Section | Change Type | Description |
|---------|-------------|-------------|
| Features Map | Addition | [New feature being added] |
| UI Components | Addition/Modification | [New/modified components] |
| Data Models | Addition/Modification | [New/modified models] |
| API Structure | Addition | [New endpoints] |

---

<!--
INSTRUCTIONS:
Copy all sections from CODE_ARCHITECTURE_FEATURES.md, then UPDATE sections below
to reflect the proposed changes. Mark all new/modified items with 🚧.
-->

## 1. Project Overview
<!-- Copy from CODE_ARCHITECTURE_FEATURES.md -->

## 2. Tech Stack
<!-- Copy from CODE_ARCHITECTURE_FEATURES.md -->

## 3. Architecture Diagram
<!-- Copy from CODE_ARCHITECTURE_FEATURES.md, update if new components added -->

## 4. Directory Structure
<!-- Copy and update to show new files/folders -->

---

## 5. Features Map

### Implemented Features
<!-- Keep existing features -->

| Feature | Description | Key Files | Status |
|---------|-------------|-----------|--------|
| [Existing features...] | | | ✅ Complete |
| **[New Feature Name]** | [From PRD overview] | [Proposed files from task plan] | 🚧 Proposed |

### Feature Flow Diagrams

#### [New Feature Name] (Proposed) 🚧
```
[Create flow diagram based on PRD user stories and technical requirements]
User Action → [Component] → [Hook/Store] → [API] → [Backend] → Response → UI Update
```

---

## 6. UI Components Inventory

### Pages
<!-- Keep existing, ADD new pages -->

| Page | Route | Description | Key Components | Status |
|------|-------|-------------|----------------|--------|
| [Existing...] | | | | ✅ |
| **[NewPage]** | /[route] | [From PRD] | [Proposed components] | 🚧 |

### Shared Components
<!-- Keep existing, ADD new components -->

| Component | Location | Props | Used By | Status |
|-----------|----------|-------|---------|--------|
| [Existing...] | | | | ✅ |
| **[NewComponent]** | [proposed path] | [from PRD] | [proposed usage] | 🚧 |

### Component Hierarchy (Updated)
```
[Update hierarchy to show where new components fit]
App
├── Layout
│   └── ...
├── [ExistingPage]
│   └── ...
└── **[NewPage]** 🚧
    ├── **[NewComponent1]** 🚧
    └── **[NewComponent2]** 🚧
```

---

## 7. Data Flow & State Management

### Key Data Models
<!-- Keep existing, ADD new models -->

| Model | Fields | Relationships | Status |
|-------|--------|---------------|--------|
| [Existing...] | | | ✅ |
| **[NewModel]** | [from PRD Section 4.1] | [from PRD] | 🚧 |

### State Architecture Updates
<!-- Document new state if added -->

```
[New Feature State] 🚧
├── Server State
│   └── [queryKey]: [shape]
└── Local State
    └── [stateName]: [type]
```

---

## 8. API Structure

### Internal APIs
<!-- Keep existing, ADD new endpoints -->

| Endpoint | Method | Purpose | Auth Required | Status |
|----------|--------|---------|---------------|--------|
| [Existing...] | | | | ✅ |
| **[/api/new]** | [method] | [from PRD] | [from PRD] | 🚧 |

---

## 9. Patterns & Conventions
<!-- Copy from CODE_ARCHITECTURE_FEATURES.md, note if new patterns introduced -->

---

## 10. Dependencies Graph
<!-- Update if new dependencies between modules -->

---

## Legend

- ✅ Complete - Existing, implemented
- 🚧 Proposed - Part of this PRD, not yet implemented

---

## Implementation Impact Analysis

### Files to Create
<!-- List from task_plan.md -->
| File | Purpose | Task |
|------|---------|------|
| `src/path/file.tsx` | [purpose] | [task ID] |

### Files to Modify
<!-- List existing files that need changes -->
| File | Modification | Task |
|------|--------------|------|
| `src/existing/file.tsx` | [what changes] | [task ID] |

### Integration Points
<!-- Where new feature connects to existing system -->
| Existing System | Integration Point | Notes |
|-----------------|-------------------|-------|
| [system] | [how it connects] | [notes] |

### Potential Conflicts
<!-- Any areas where new feature might conflict with existing code -->
| Area | Potential Conflict | Mitigation |
|------|-------------------|------------|
| [area] | [conflict] | [how to handle] |

---

## Review Checklist

Before approving this architecture change:
- [ ] All new components fit within existing patterns
- [ ] No duplicate functionality with existing features
- [ ] Integration points are clearly defined
- [ ] Breaking changes are documented with migration plan
- [ ] New endpoints follow existing API conventions
- [ ] State management follows existing patterns
```
