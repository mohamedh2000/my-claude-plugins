# PRD Template

> **Usage**: Copy this template when creating `.claude/PRD-[feature-name]/PRD.md`
> Replace all `[placeholders]` with actual content.

---

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

### 4.1 Data Models

#### [Entity Name 1]
| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| id | string (UUID) | Yes | Auto-generated | Primary key |
| [field2] | [type] | [Yes/No] | [rules] | [description] |
| createdAt | DateTime | Yes | Auto-generated | Creation timestamp |
| updatedAt | DateTime | Yes | Auto-updated | Last update timestamp |

**Relationships:**
- [Entity1] → [Entity2]: [one-to-many/many-to-many/etc.]

**Indexes:**
- [field] - [reason for index]

---

### 4.2 API Contracts

#### [API-001] [Endpoint Name]
```
[METHOD] /api/[path]

Purpose: [What this endpoint does]
Auth: [Required | Optional | None] - [JWT | API Key | Session]
Rate Limit: [X requests per minute | None]

Request Headers:
  Authorization: Bearer <token>
  Content-Type: application/json

Request Body:
{
  "field1": "string (required) - description",
  "field2": "number (optional) - description, default: 0",
  "nested": {
    "subfield": "string (required)"
  }
}

Response 200 (Success):
{
  "data": {
    "id": "string - the created/returned resource ID",
    "field1": "string",
    "field2": "number",
    "createdAt": "ISO 8601 datetime"
  },
  "meta": {
    "requestId": "string"
  }
}

Response 400 (Validation Error):
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human readable message",
    "details": [
      { "field": "field1", "message": "Field is required" }
    ]
  }
}

Response 401 (Unauthorized):
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication required"
  }
}

Response 404 (Not Found):
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Resource not found"
  }
}

Response 500 (Server Error):
{
  "error": {
    "code": "INTERNAL_ERROR",
    "message": "An unexpected error occurred"
  }
}
```

---

### 4.3 Data Flow & State Management

#### Data Sources
| Data | Source | Fetch Strategy | Cache Duration |
|------|--------|----------------|----------------|
| [Data type] | [API-001] | [On mount / On demand / Polling / Real-time] | [Duration or "No cache"] |

#### Frontend State Architecture
```
[Component/Page Name]
├── Server State (React Query / SWR / etc.)
│   ├── [queryKey]: [data shape] - fetched from [API-XXX]
│   └── [queryKey]: [data shape] - fetched from [API-XXX]
├── Local State (useState / useReducer)
│   ├── [stateName]: [type] - [purpose]
│   └── [stateName]: [type] - [purpose]
└── URL State (query params / path params)
    └── [paramName]: [type] - [purpose]
```

#### Data Transformations
| Source (API Response) | Target (UI State) | Transformation |
|-----------------------|-------------------|----------------|
| `response.data.items` | `items: Item[]` | Direct mapping |
| `response.data.user.firstName + lastName` | `displayName: string` | Concatenation |

---

### 4.4 UI States (Per Component/Screen)

#### [Component/Screen Name]
| State | Condition | UI Behavior |
|-------|-----------|-------------|
| **Loading** | Data fetching in progress | Show skeleton/spinner, disable interactions |
| **Empty** | Data fetched, array is empty | Show empty state illustration + CTA |
| **Error** | API returned error | Show error message + retry button |
| **Partial** | Some fields missing/null | Show available data, placeholder for missing |
| **Success** | Data loaded successfully | Render full component |
| **Stale** | Cache expired, refetching | Show current data + subtle loading indicator |

**Error Message Mapping:**
| Error Code | User-Facing Message | Action |
|------------|---------------------|--------|
| UNAUTHORIZED | "Please log in to continue" | Redirect to login |
| NOT_FOUND | "[Resource] not found" | Show empty state |
| VALIDATION_ERROR | Show field-specific errors | Highlight fields |
| RATE_LIMITED | "Too many requests. Please wait." | Disable button, show countdown |
| INTERNAL_ERROR | "Something went wrong. Please try again." | Show retry button |

---

### 4.5 Security Requirements

#### Authentication
- **Method**: [JWT | Session | API Key | OAuth]
- **Token Storage**: [HttpOnly Cookie | localStorage | Memory]
- **Token Refresh**: [Strategy for refresh]

#### Authorization
| Resource/Action | Required Role/Permission |
|-----------------|-------------------------|
| [action] | [role or permission] |

#### Data Protection
- **Sensitive Fields**: [List fields requiring encryption/masking]
- **PII Handling**: [How personal data is handled]
- **Audit Logging**: [What actions are logged]

---

### 4.6 Performance Requirements

| Metric | Target | Measurement |
|--------|--------|-------------|
| API Response Time (p95) | < [X]ms | [How measured] |
| Time to Interactive | < [X]s | Lighthouse |
| Largest Contentful Paint | < [X]s | Lighthouse |
| Max Payload Size | < [X]KB | [API response size] |

#### Optimization Strategies
- [ ] Pagination: [page size, cursor vs offset]
- [ ] Caching: [strategy]
- [ ] Lazy Loading: [what to lazy load]
- [ ] Debouncing: [for search/input, delay in ms]

---

## 5. Dependency Impact Analysis

> This section identifies existing features that may break or need updates.

### 5.1 Modified Entities & Their Dependents

#### [Entity/API/Component Name] - MODIFIED
**What's changing:**
- [Field added/removed/renamed]
- [Response shape changed]
- [Props changed]

**Dependent Code (will need updates):**
| File | Usage | Required Update | Task ID |
|------|-------|-----------------|---------|
| `src/components/UserCard.tsx` | Displays `user.name` | Update to use `user.displayName` | FIX-001 |
| `src/pages/profile.tsx` | Fetches `/api/user` | Update response type | FIX-002 |

**Breaking Changes:**
- [ ] API response shape change (frontend must update)
- [ ] Database schema change (migration required)
- [ ] Component props change (all usages must update)
- [ ] Type definition change (all imports must update)

### 5.2 Dependency Graph

```
[Modified Entity]
├── [Dependent 1] ──→ needs [specific update]
│   └── [Nested Dependent] ──→ needs [specific update]
├── [Dependent 2] ──→ needs [specific update]
└── [Dependent 3] ──→ needs [specific update]
```

### 5.3 Affected Features Summary

| Feature | Impact Level | What Breaks | Fix Required |
|---------|--------------|-------------|--------------|
| User Profile | HIGH | API response shape changed | Update types, refetch logic |
| Dashboard | MEDIUM | New field available | Optional: display new field |
| Admin Panel | LOW | No breaking changes | None |

**Impact Levels:**
- **HIGH**: Will break if not updated (compile error, runtime error, wrong data)
- **MEDIUM**: Will work but with degraded experience
- **LOW**: No breaking changes but could benefit from update

### 5.4 Fix-Up Tasks (Auto-Generated)

**[FIX-001] Update UserCard for new user schema**
- **Priority:** HIGH (blocking)
- **Blocked By:** [BE-001]
- **Files:** `src/components/UserCard.tsx`
- **Changes:**
  - Update `user.name` → `user.displayName`
  - Add null check for new optional field
- **Verification:** Component renders without errors

---

## 6. Tasks Breakdown

### Parallel Execution Plan

```
Sprint/Phase 1: Foundation (Parallel Tracks)
├── Track A (Backend):     [BE-001] → [BE-002]
├── Track B (Frontend):    [FE-001] → [FE-002]
└── Track C (Infra):       [INFRA-001]

Sprint/Phase 2: Integration (MANDATORY)
└── Track INT:             [FE-INT-001] → [FE-INT-002]

Sprint/Phase 3: Polish (After Integration)
└── All tracks converge:   [FE-003], [BE-003]
```

### Backend Tasks

**[BE-001] Task Title**
- **Description**: What needs to be done
- **Story**: A1
- **Dependencies**: None
- **Complexity**: Small | Medium | Large
- **Subtasks**:
  - [ ] Subtask 1
  - [ ] Subtask 2

### Frontend Tasks

**[FE-001] Task Title**
- **Description**: What needs to be done
- **Story**: A1
- **Dependencies**: None (can build with mocked data)
- **Complexity**: Small | Medium | Large

### Integration Tasks (MANDATORY when both FE + BE)

**[FE-INT-001] Connect Frontend to Backend Endpoints**
- **Dependencies**: All BE-*, All FE-*
- **Subtasks**:
  - [ ] Replace mock data with actual API calls
  - [ ] Verify API response shape matches frontend expectations
  - [ ] Handle loading, error, and empty states

**[FE-INT-002] Integration Verification**
- **Dependencies**: FE-INT-001
- **Acceptance Criteria**:
  - [ ] curl backend endpoints → verify correct response
  - [ ] Browser test → verify data renders correctly
  - [ ] No console errors

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
