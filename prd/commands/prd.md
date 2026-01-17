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
/prd .claude/Task Documents/PRD-existing.md   # Load existing PRD as context
```

## Argument Handling

$ARGUMENTS

**If argument is a file path** (ends with `.md` or contains `/`):
1. Read the file
2. Use it as existing PRD context
3. Continue PRD workflow from where it left off (ask clarifying questions, refine, etc.)

**If argument is a description** (or empty):
1. Start fresh PRD workflow
2. Use the description as initial feature context (if provided)

Run the prd skill to begin the PRD workflow.
