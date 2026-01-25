---
name: continuous-learning
description: Automatically extract reusable patterns from Claude Code sessions and save them as learned skills for future use.
---

# Continuous Learning System

Automatically evaluates Claude Code sessions to extract reusable patterns that can be saved as learned skills.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      SESSION ENDS                            │
│  Stop hook: evaluate-session.sh                              │
│  → Queues session in pending-review.jsonl                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    NEXT SESSION STARTS                       │
│  SessionStart hook: session-start-review.sh                  │
│  → Creates extraction-prompt.md if pending reviews exist     │
│  → Notifies Claude to run /learn                             │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    /learn COMMAND                            │
│  → Reads session transcript                                  │
│  → Extracts patterns                                         │
│  → Saves to $CLAUDE_CONFIG_DIR/skills/learned/               │
│  → Clears pending review                                     │
└─────────────────────────────────────────────────────────────┘
```

## Profile-Aware Storage

Learned skills are saved per-profile:

```
~/.claude-profiles/work/skills/learned/     # Work learnings
~/.claude-profiles/personal/skills/learned/ # Personal learnings
~/.claude/skills/learned/                   # Default (no profile)
```

The active profile is determined by `$CLAUDE_CONFIG_DIR`.

## Files

| File | Purpose |
|------|---------|
| `evaluate-session.sh` | Stop hook - queues sessions for review |
| `session-start-review.sh` | SessionStart hook - prompts for extraction |
| `skills/learn/SKILL.md` | /learn command - extracts patterns |
| `config.json` | Configuration (min session length, etc.) |

## Configuration

Edit `config.json` to customize:

```json
{
  "min_session_length": 10,
  "extraction_threshold": "medium",
  "auto_approve": false,
  "patterns_to_detect": [
    "error_resolution",
    "user_corrections",
    "workarounds",
    "debugging_techniques",
    "project_specific"
  ]
}
```

## Pattern Types

| Pattern | Description | Trigger |
|---------|-------------|---------|
| `error_resolution` | How specific errors were fixed | "that fixed it", error → solution |
| `user_corrections` | When Claude was corrected | "no, actually...", "that's wrong" |
| `workarounds` | Non-obvious solutions | Framework/library quirks |
| `debugging_techniques` | Effective debugging | Successful root cause analysis |
| `project_specific` | Project conventions | Repeated codebase patterns |

## Usage

### Automatic (recommended)
1. Work normally - sessions are auto-queued
2. On next session start, you'll see pending reviews
3. Run `/learn` to extract or "skip learning" to dismiss

### Manual
Run `/learn` anytime to extract patterns from current session.

## Learned Skills Format

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
Prisma requires explicit client regeneration.
```

## Recall Mechanism

Learned patterns are loaded at session start via the extraction prompt, or can be searched:

```bash
# Search learned patterns
grep -r "keyword" $CLAUDE_CONFIG_DIR/skills/learned/

# List all patterns
cat $CLAUDE_CONFIG_DIR/skills/learned/index.json
```

## Hook Configuration

Already configured in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/skills/continuous-learning/session-start-review.sh"
        }]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/skills/continuous-learning/evaluate-session.sh"
        }]
      }
    ]
  }
}
```
