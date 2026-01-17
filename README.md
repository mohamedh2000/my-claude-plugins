# Claude Code Plugin Marketplace

A collection of Claude Code plugins for professional software development workflows. Features parallel agent execution, comprehensive PRD generation, and specialized development agents.

> **Note:** The `/planning-parallel` plugin is built on top of the excellent [planning-with-files](https://github.com/OthmanAdi/planning-with-files) approach by [@OthmanAdi](https://github.com/OthmanAdi), extending it with parallel sub-agent execution, fault-tolerant error handling, and seamless token exhaustion recovery.

## Installation

1. **Add the marketplace to Claude Code:**
   ```bash
   claude plugins add-marketplace https://github.com/your-username/my-claude-plugins
   ```

2. **Or for local development, symlink to your plugins directory:**
   ```bash
   ln -s ~/my-claude-plugins ~/.claude/plugins/marketplaces/my-claude-plugins
   ```

3. **Enable plugins in Claude Code settings** (`~/.claude/settings.json`):
   ```json
   {
     "enabledPlugins": [
       "my-claude-plugins/spawn-worktree",
       "my-claude-plugins/prd",
       "my-claude-plugins/planning-parallel",
       "my-claude-plugins/agent-browser",
       "my-claude-plugins/senior-backend-engineer",
       "my-claude-plugins/ui-react-specialist",
       "my-claude-plugins/test-creator-agent"
     ]
   }
   ```

## Deep Dive Documentation

For detailed explanations of how these plugins work under the hood:

| Document | Description |
|----------|-------------|
| **[Planning Parallel Architecture](docs/PLANNING_PARALLEL.md)** | Flow diagrams, error handling, sub-agent handoffs, token exhaustion recovery |
| **[PRD Workflow](docs/PRD_WORKFLOW.md)** | The 6-phase workflow, task_plan.md optimization, mandatory integration |

### Key Features

- **Fault-Tolerant Execution** - 3-strike error protocol with automatic approach mutation
- **Sub-Agent Handoffs** - Seamless checkpoint & continue when agents hit context limits
- **Token Exhaustion Recovery** - Pick up exactly where you left off across sessions
- **File-Based Memory** - Nothing important stays only in context; everything persists to disk
- **Parallel Quality Passes** - 5x code simplifiers + 5x code reviewers run in parallel
- **Codebase-Aware PRDs** - Discovery phase explores your codebase before asking questions
- **Mandatory Integration** - Never ship disconnected frontend/backend again

---

## Plugins Overview

| Plugin | Type | Description |
|--------|------|-------------|
| `/spawn` | Command | Create isolated git worktrees for feature development |
| `/prd` | Command | Generate comprehensive Product Requirements Documents |
| `/planning-parallel` | Command | Execute task plans with parallel sub-agents |
| `/agent-browser` | Command | Browser automation for testing and data extraction |
| `senior-backend-engineer` | Agent | Backend API, database, and server-side development |
| `ui-react-specialist` | Agent | React components, design systems, and accessibility |
| `test-creator-agent` | Agent | Automated test generation from real application data |

---

## Commands & Skills

### `/spawn <task-name>`

Creates an isolated git worktree for feature development with a fresh Claude session.

**Arguments:**
| Argument | Required | Description |
|----------|----------|-------------|
| `task-name` | Yes | Name for the feature (creates branch `feat/<task-name>`) |

**Example:**
```
/spawn user-authentication
```

**What it does:**
- Creates worktree at `../<repo>-<task-name>`
- Creates branch `feat/<task-name>`
- Copies Claude permissions from parent repo
- Opens new terminal with `/prd` ready to run

---

### `/prd [file_path | description]`

Creates comprehensive Product Requirements Documents through a 6-phase collaborative workflow.

**Arguments:**
| Argument | Required | Description |
|----------|----------|-------------|
| `file_path` | No | Path to existing PRD to continue (e.g., `.claude/Task Documents/PRD-auth.md`) |
| `description` | No | Initial feature context to start with |

**Examples:**
```
/prd
/prd Add user authentication with OAuth support
/prd .claude/Task Documents/PRD-auth.md
```

**Workflow Phases:**
1. **Exploration** - Analyze codebase architecture
2. **Discovery** - Collaborative requirements gathering
3. **Documentation** - Create structured PRD with user stories
4. **Review** - Parallel PM + Engineer review
5. **Refinement** - Incorporate feedback
6. **Handoff** - Generate `task_plan.md` and `findings.md`

**Output Files:**
- `.claude/Task Documents/PRD-[feature].md` - Full requirements
- `task_plan.md` - Execution plan with task groups
- `findings.md` - Architecture context

---

### `/planning-parallel [file_path | description]`

File-based planning system with memory-safe parallel sub-agent execution.

**Arguments:**
| Argument | Required | Description |
|----------|----------|-------------|
| `file_path` | No | Path to task plan (defaults to `task_plan.md` in project root) |
| `description` | No | Task context if no plan file exists |

**Examples:**
```
/planning-parallel
/planning-parallel .claude/plans/auth-plan.md
```

**Three-File Architecture:**
- `task_plan.md` - Task tracking and progress
- `findings.md` - Research and discoveries
- `progress.md` - Session log and test results

**Execution Flow:**
1. Reads task groups from `task_plan.md`
2. Spawns appropriate agents in parallel per group
3. Monitors via file-based polling
4. Merges results after each group completes
5. Runs code simplification and review passes

---

### `/agent-browser`

Headless browser automation for web testing, form filling, screenshots, and data extraction.

**Core Commands:**

| Command | Description |
|---------|-------------|
| `agent-browser open <url>` | Navigate to URL |
| `agent-browser snapshot -i` | Get interactive elements (returns @refs) |
| `agent-browser click @e1` | Click element by ref |
| `agent-browser fill @e2 "text"` | Clear and type into input |
| `agent-browser screenshot [path]` | Capture screenshot |

**Navigation:**
```bash
agent-browser open https://example.com
agent-browser back
agent-browser forward
agent-browser reload
```

**Snapshot Options:**
| Option | Description |
|--------|-------------|
| `-i, --interactive` | Interactive elements only (recommended) |
| `-c, --compact` | Remove empty structural elements |
| `-d <N>` | Limit tree depth |

**Interactions (use @refs from snapshot):**
```bash
agent-browser click @e1
agent-browser dblclick @e1
agent-browser fill @e2 "hello world"
agent-browser type @e2 "append text"
agent-browser press Enter
agent-browser hover @e1
agent-browser select @e1 "option-value"
agent-browser scroll down 500
```

**Screenshots:**
```bash
agent-browser screenshot              # to stdout
agent-browser screenshot page.png     # to file
agent-browser screenshot --full       # full page
```

**Wait Commands:**
```bash
agent-browser wait @e1                # wait for element
agent-browser wait 2000               # wait milliseconds
agent-browser wait --text "Success"   # wait for text
```

**Sessions (parallel browsers):**
```bash
agent-browser --session test1 open https://site-a.com
agent-browser --session test2 open https://site-b.com
```

---

## Agents

Agents are spawned via the Task tool, not invoked directly as commands.

### `senior-backend-engineer`

Backend development specialist for APIs, databases, and server-side logic.

**Specializations:**
- REST/GraphQL API endpoints
- Database schema design and optimization
- Authentication (JWT, OAuth, RBAC)
- Third-party API integrations
- Background jobs and webhooks
- Middleware and validation

**Tech Stack:** Node.js, Express, TypeScript, PostgreSQL, MongoDB, Redis, Prisma

---

### `ui-react-specialist`

React UI specialist for components, design systems, and accessibility.

**Specializations:**
- React component architecture
- Design systems and component libraries
- Accessibility (WCAG AA compliance)
- Responsive design (mobile-first)
- TypeScript type safety
- Browser validation with screenshots

**Principles:** Atomic design, composition over inheritance, components under 200 lines

---

### `test-creator-agent`

Automated test generation by analyzing patterns and capturing real data.

**5-Phase Workflow:**
1. **Analyze** - Understand repo test structure
2. **Discover** - Find all function invocations
3. **Instrument** - Add temporary capture logs
4. **Capture** - Run app and collect real data
5. **Generate** - Create tests with fixtures

---

## Recommended Workflow

These plugins are designed to work together for end-to-end feature development:

```
┌─────────────────────────────────────────────────────────────┐
│  /spawn feature-name                                        │
│  Creates isolated worktree, starts new Claude session       │
└─────────────────────┬───────────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  /prd                                                       │
│  Collaborative requirements gathering and documentation     │
│  Outputs: PRD document, task_plan.md, findings.md          │
└─────────────────────┬───────────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  /planning-parallel                                         │
│  Executes task_plan.md with parallel agents:               │
│                                                             │
│  Group 1: ┌──────────────────┐  ┌────────────────────┐     │
│           │ backend-engineer │  │ ui-react-specialist│     │
│           └──────────────────┘  └────────────────────┘     │
│                      ▼                    ▼                 │
│  Group 2: Integration tasks (FE-INT)                       │
│                      ▼                                      │
│  Group 3: Code simplification (5 parallel agents)          │
│                      ▼                                      │
│  Group 4: Code review (5 parallel agents)                  │
└─────────────────────┬───────────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  /agent-browser                                             │
│  Browser validation and testing throughout                  │
└─────────────────────────────────────────────────────────────┘
```

### Quick Start Example

```bash
# 1. Start a new feature
/spawn user-dashboard

# 2. In the new terminal, PRD starts automatically
# Answer questions to define requirements

# 3. After PRD generates task_plan.md, execute it
/planning-parallel

# 4. Agents work in parallel, validate with browser
agent-browser open http://localhost:3000/dashboard
agent-browser screenshot dashboard.png
```

### Standalone Usage

Each plugin can also be used independently:

```bash
# Just create a PRD without spawning
/prd Add dark mode support

# Run browser automation for testing
/agent-browser
agent-browser open https://myapp.com
agent-browser snapshot -i

# Execute an existing plan
/planning-parallel ./my-custom-plan.md
```

---

## Plugin Structure

Each plugin follows this structure:

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
    └── hooks.json           # Event hooks (optional)
```

## License

MIT
