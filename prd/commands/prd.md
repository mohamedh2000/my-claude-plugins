---
description: Create comprehensive Product Requirements Documents with stories and tasks
argument-hint: "[file_path] or feature description"
---

# PRD Command

Create a comprehensive Product Requirements Document through collaborative discovery.

## Usage

```
/prd                           # Start fresh PRD workflow
/prd Add user authentication   # Start with feature description
/prd .claude/PRD-notifications # Load existing PRD folder
```

## Output Location

All PRD artifacts are created in a dedicated folder:

```
.claude/PRD-[feature-name]/
├── PRD.md              # The PRD document
├── task_plan.md        # Execution plan for /planning-parallel
└── findings.md         # Architecture context from exploration
```

## Argument Handling

$ARGUMENTS

**If argument is a folder path** (e.g., `.claude/PRD-notifications`):
1. Read `PRD.md` from that folder
2. Use it as existing PRD context
3. Continue PRD workflow from where it left off

**If argument is a file path** (ends with `.md`):
1. Read the file directly
2. Use it as existing PRD context
3. Continue PRD workflow from where it left off

**If argument is a description** (or empty):
1. Start fresh PRD workflow
2. Use the description as initial feature context (if provided)
3. Infer feature name from description (kebab-case)

Run the prd skill to begin the PRD workflow.
