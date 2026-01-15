---
name: spawn
version: "1.0.0"
description: Spawns a new git worktree with a fresh Claude session running /prd. Use when starting isolated feature work.
user-invocable: true
allowed-tools:
  - Bash
  - Read
arguments:
  task-name:
    description: Name for the task/feature (will create branch feat/<task-name>)
    required: true
---

# Spawn Worktree

Creates an isolated git worktree for feature development with its own Claude session.

## What This Does

When you run `/spawn <task-name>`:

1. Creates a new git worktree at `../<repo>-<task-name>`
2. Creates branch `feat/<task-name>`
3. Copies Claude permissions from parent repo
4. Opens a new terminal in Antigravity
5. Starts Claude with `/prd` in the new terminal

## Instructions for Claude

**IMPORTANT: This skill spawns a new terminal. After running the spawn script, DO NOT continue processing in this terminal.**

Execute these steps:

1. Extract the task name from the arguments
2. Run the spawn script: `${CLAUDE_PLUGIN_ROOT}/scripts/spawn.sh "<task-name>"`
3. Report the result to the user
4. **STOP HERE** - Tell the user to switch to the new terminal window

## Usage

```
/spawn my-feature
/spawn bug-fix-123
/spawn calendar-integration
```

## Output

After successful spawn, inform the user:
- Worktree location
- Branch name
- That a new terminal has opened with Claude ready
- That THIS terminal session is complete (switch to new terminal)
