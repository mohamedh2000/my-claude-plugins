---
name: learn
description: Extract reusable patterns from Claude Code sessions and save them as learned skills for future use.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
---

# /learn - Extract Reusable Patterns

Extract patterns from the current session or a previous session and save them as learned skills.

## Usage

```
/learn                    # Extract from current session
/learn [session-id]       # Extract from specific session
/learn skip               # Skip pending review, remove from queue
```

## How It Works

### Step 1: Determine Source

Check for pending reviews first:

```bash
# Check for pending review file
BASE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
PENDING_FILE="$BASE_DIR/pending-review.jsonl"
```

If pending reviews exist, read the extraction prompt:
```
Read file: $BASE_DIR/extraction-prompt.md
```

If no pending reviews, extract from current conversation context.

### Step 2: Identify Patterns

Look for these pattern types in the session:

| Pattern Type | Indicators |
|--------------|------------|
| **Error Resolution** | User reported error → Claude fixed it → User confirmed "that worked" |
| **User Correction** | User said "no, actually..." or "that's wrong" or corrected an approach |
| **Workaround** | Non-obvious solution to a framework/library limitation |
| **Debugging Technique** | Effective debugging approach that found the root cause |
| **Project Convention** | Repeated patterns specific to this codebase |

### Step 3: Extract & Format

For each pattern found, create a learned skill file:

```markdown
---
name: [pattern-name]
type: learned
source: [session-id]
project: [project-path]
extracted: [date]
---

# [Descriptive Title]

## Context
[When this pattern applies]

## Problem
[What went wrong or what was needed]

## Solution
[What worked]

## Key Insight
[The reusable lesson]

## Example
```
[Code or command example]
```
```

### Step 4: Save Pattern

Determine save location (profile-aware):

```bash
BASE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
LEARNED_PATH="$BASE_DIR/skills/learned"
```

Save to: `$LEARNED_PATH/[date]-[pattern-name].md`

### Step 5: Update Index

Append to `$LEARNED_PATH/index.json`:

```json
{
  "patterns": [
    {
      "name": "[pattern-name]",
      "file": "[filename]",
      "type": "[pattern-type]",
      "project": "[project]",
      "keywords": ["keyword1", "keyword2"],
      "extracted": "[date]"
    }
  ]
}
```

### Step 6: Clear Pending Review

If extracting from pending review, remove it from queue:

```bash
# Remove first line from pending-review.jsonl
tail -n +2 "$PENDING_FILE" > "$PENDING_FILE.tmp"
mv "$PENDING_FILE.tmp" "$PENDING_FILE"

# Remove extraction prompt
rm -f "$BASE_DIR/extraction-prompt.md"
```

## Skip Command

If user says `/learn skip` or "skip learning":

1. Remove the oldest pending review from queue
2. Don't extract any patterns
3. Report: "Skipped session review. N remaining."

## Output

After extraction, report:

```
## Patterns Extracted

| Pattern | Type | Saved To |
|---------|------|----------|
| [name] | [type] | [path] |

Remaining pending reviews: N
```

## Example Patterns

### Error Resolution Example
```markdown
---
name: prisma-client-not-generated
type: learned
source: abc123
project: /Users/me/myapp
extracted: 2026-01-24
---

# Prisma Client Not Generated Error

## Context
After modifying `schema.prisma`

## Problem
Error: `@prisma/client did not initialize yet`

## Solution
Run `npx prisma generate` after any schema changes

## Key Insight
Prisma requires explicit client regeneration - it doesn't happen automatically on file save.
```

### User Correction Example
```markdown
---
name: nextjs-server-components-no-hooks
type: learned
source: def456
project: /Users/me/nextapp
extracted: 2026-01-24
---

# No React Hooks in Server Components

## Context
Building Next.js 14 app with App Router

## Problem
Used `useState` in a Server Component, got hydration error

## Solution
Add `'use client'` directive or move state to a Client Component

## Key Insight
Server Components can't use hooks. Always check if component needs interactivity before adding state.
```
