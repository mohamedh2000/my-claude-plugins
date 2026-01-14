#!/bin/bash
# Spawn a new Claude instance in a fresh git worktree
# Usage: spawn.sh <task-name>

set -e

TASK_NAME="${1:-task-$(date +%s)}"

if [ -z "$TASK_NAME" ]; then
  echo "Error: Task name is required"
  echo "Usage: spawn.sh <task-name>"
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_ROOT" ]; then
  echo "Error: Not in a git repository"
  exit 1
fi

REPO_NAME=$(basename "$REPO_ROOT")
WORKTREE_PATH="${REPO_ROOT}/../${REPO_NAME}-${TASK_NAME}"

echo "Creating worktree for task: $TASK_NAME"
echo "Location: $WORKTREE_PATH"
echo ""

# Create worktree with new branch
if git worktree add -b "feat/${TASK_NAME}" "$WORKTREE_PATH" 2>/dev/null; then
  echo "✓ Created worktree: $WORKTREE_PATH"
  echo "✓ Branch: feat/${TASK_NAME}"
elif [ -d "$WORKTREE_PATH" ]; then
  echo "✓ Worktree already exists at: $WORKTREE_PATH"
else
  # Branch might exist, try without -b
  if git worktree add "$WORKTREE_PATH" "feat/${TASK_NAME}" 2>/dev/null; then
    echo "✓ Created worktree using existing branch: feat/${TASK_NAME}"
  else
    echo "Error: Could not create worktree"
    exit 1
  fi
fi

# Copy Claude permissions to new worktree
# Priority: project settings.local.json > global settings.json
mkdir -p "${WORKTREE_PATH}/.claude"
if [ -f "${REPO_ROOT}/.claude/settings.local.json" ]; then
  cp "${REPO_ROOT}/.claude/settings.local.json" "${WORKTREE_PATH}/.claude/"
  echo "✓ Copied project Claude permissions to worktree"
fi

# Also copy global settings to ensure all tool permissions are inherited
if [ -f "${HOME}/.claude/settings.json" ]; then
  # Merge global permissions into worktree (global as base, project overrides)
  if [ -f "${WORKTREE_PATH}/.claude/settings.local.json" ]; then
    # If jq is available, merge the permissions arrays
    if command -v jq &> /dev/null; then
      GLOBAL_PERMS=$(jq -r '.permissions.allow // []' "${HOME}/.claude/settings.json")
      LOCAL_PERMS=$(jq -r '.permissions.allow // []' "${WORKTREE_PATH}/.claude/settings.local.json")
      MERGED=$(jq -n --argjson g "$GLOBAL_PERMS" --argjson l "$LOCAL_PERMS" '{permissions: {allow: ($g + $l | unique)}}')
      echo "$MERGED" > "${WORKTREE_PATH}/.claude/settings.local.json"
      echo "✓ Merged global + project permissions"
    fi
  else
    # No local settings, just use global
    cp "${HOME}/.claude/settings.json" "${WORKTREE_PATH}/.claude/settings.local.json"
    echo "✓ Copied global Claude permissions to worktree"
  fi
fi

# Use AppleScript to open a new terminal in current Antigravity window,
# navigate to worktree, and start Claude with planning-with-files
ESCAPED_PATH=$(printf '%s' "$WORKTREE_PATH" | sed "s/'/'\\\\''/g")

osascript <<EOF
-- Activate Antigravity to ensure it's focused
tell application "Antigravity" to activate
delay 0.5

tell application "System Events"
  tell process "Antigravity"
    -- Open new terminal panel (Ctrl+\`)
    keystroke "\`" using {control down}
    delay 0.5

    -- Navigate to worktree and start Claude with planning-with-files
    keystroke "cd '${ESCAPED_PATH}' && claude '/prd'"
    delay 0.2

    -- Press Enter to execute
    key code 36
  end tell
end tell
EOF

echo ""
echo "✓ Opened new terminal in Antigravity"
echo "✓ Navigating to: $WORKTREE_PATH"
echo "✓ Starting Claude with /prd"
echo ""
echo ">>> Switch to the new terminal to continue working <<<"
