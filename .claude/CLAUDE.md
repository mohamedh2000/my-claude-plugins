# Plugin Development Reference

## Directory Structure

| Location | Purpose |
|----------|---------|
| `~/my-claude-plugins/` | **Dev source** - Your git repo for plugin development |
| `~/.claude/plugins/marketplaces/my-claude-plugins/` | **Installed copy** - Claude Code installs plugins here from your marketplace |
| `~/.claude/plugins/marketplaces/claude-plugins-official/` | **Official plugins** - Anthropic's official plugin marketplace |
| `~/.claude/plugins/local/` | **Local plugins** - For plugins without a marketplace (currently unused) |
| `~/.claude/plugins/cache/` | **Cache** - Cached plugin versions |
| `~/.local/share/claude/versions/` | **Binaries** - Claude Code executable versions (not plugins) |

## Your Plugins (in this repo)

- `agent-browser/` - Browser automation skill
- `planning-parallel/` - Parallel sub-agent execution
- `prd/` - Product Requirements Documents
- `senior-backend-engineer/` - Backend agent
- `spawn-worktree/` - Git worktree spawner
- `ui-react-specialist/` - React UI agent

## Plugin Structure

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── agents/
│   └── agent-name.md        # Agent definitions
├── skills/
│   └── skill-name/
│       └── SKILL.md         # Skill definitions
├── commands/
│   └── command.md           # Slash commands
└── hooks/
    └── hooks.json           # Event hooks
```

## Enabled Plugins

Check `~/.claude/settings.json` → `enabledPlugins` for active plugins.

## MCP Servers

- `claude mcp list` - Show configured MCP servers
- `claude mcp add <name>` - Add a server
- Note: `claude-in-chrome` comes from the Chrome extension, not plugin config

## Workflow

1. Edit plugins in `~/my-claude-plugins/`
2. Changes sync to `~/.claude/plugins/marketplaces/my-claude-plugins/` automatically (symlink/marketplace)
3. Test with `/skill-name` or agent invocations
