# Claude Profile & Plugin Setup

One-command setup for Claude profiles, plugins, and continuous learning on a new machine.

## Quick Start

```fish
# Clone the repo
git clone https://github.com/YOUR_USERNAME/my-claude-plugins.git ~/my-claude-plugins

# Run setup
fish ~/my-claude-plugins/setup/install.fish
```

## What It Sets Up

### 1. Profile System
Creates two Claude profiles with separate learned skills:

```
~/.claude-profiles/
├── work/
│   └── skills/learned/     # Work-specific learnings
└── personal/
    └── skills/learned/     # Personal learnings
```

### 2. Shared Resources (Symlinked)
Both profiles share these from `~/.claude/`:
- `CLAUDE.md` - Global instructions
- `settings.json` - Configuration
- `commands/` - Custom commands
- `hooks/` - Event hooks
- `agents/` - Agent definitions
- `plugins/` - Marketplace plugins
- All skills except `learned/`

### 3. Fish Profile Selector
On every new terminal, prompts:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Claude Profile Selection
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  [w] Work
  [p] Personal
  [s] Skip (use default ~/.claude)

  Select profile: _
```

### 4. Continuous Learning
- Sessions 10+ messages are queued for review
- Run `/learn` to extract patterns
- Patterns saved per-profile

### 5. Plugin Marketplace
Links this repo to `~/.claude/plugins/marketplaces/my-claude-plugins`

## After Setup

### Log into each profile:
```fish
# Work profile
claude-profile work
claude login

# Personal profile
claude-profile personal
claude login
```

### iTerm2 Users
Set **Profiles → Default → General → Command** to:
- `/opt/homebrew/bin/fish` (Apple Silicon)
- `/usr/local/bin/fish` (Intel)

## Files

| File | Purpose |
|------|---------|
| `install.fish` | Main setup script |
| `fish/claude-profile-selector.fish` | Terminal startup prompt |
| `fish/claude-profile.fish` | Manual profile switching function |
| `skills/continuous-learning/` | Learning system files |
| `skills/learn/` | /learn command |
| `settings-template.json` | Default settings with hooks |
| `settings-hooks-example.json` | Hooks to add to existing settings |

## Manual Profile Switch

```fish
# Switch to work
claude-profile work
claude

# Switch to personal
claude-profile personal
claude
```
