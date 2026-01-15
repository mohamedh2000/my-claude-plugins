---
description: Automate browser interactions for web testing, form filling, screenshots, and data extraction
argument-hint: Optional URL to open
---

# Browser Automation Command

Automate browser interactions using the `agent-browser` CLI tool (headless Playwright-based automation).

**IMPORTANT**: This skill uses the `agent-browser` CLI tool, NOT browser extensions or MCP tools. Always use Bash to run `agent-browser` commands.

## Workflow

1. **Start with snapshot**: After opening a URL, use `agent-browser snapshot -ic` to get an accessibility tree with clickable refs
2. **Interact via refs**: Use `@ref` notation from snapshots (e.g., `agent-browser click @e5`)
3. **Extract data**: Use `agent-browser get text <selector>` or parse snapshot output
4. **Screenshot for verification**: Use `agent-browser screenshot` to capture state

## Common Commands

```bash
# Navigate
agent-browser open <url>

# Get accessibility tree with interactive elements (use this to find refs)
agent-browser snapshot -ic

# Click element by ref from snapshot
agent-browser click @e3

# Fill form field
agent-browser fill @e5 "text to enter"

# Take screenshot
agent-browser screenshot ./screenshot.png
agent-browser screenshot --full ./full-page.png

# Get text content
agent-browser get text @e2

# Wait for element or time
agent-browser wait "selector"
agent-browser wait 2000

# Check console/errors
agent-browser console
agent-browser errors
```

## Key Options

- `--headed` - Show browser window (for debugging)
- `--session <name>` - Isolated session
- `-i, --interactive` - Only interactive elements in snapshot
- `-c, --compact` - Remove empty structural elements
- `--full, -f` - Full page screenshot

$ARGUMENTS
