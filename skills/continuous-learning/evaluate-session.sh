#!/bin/bash
# Continuous Learning - Session Evaluator
# Runs on Stop hook to mark sessions for pattern extraction
#
# Flow:
# 1. Stop hook runs this script at session end
# 2. If session is long enough, save to pending-review
# 3. Next SessionStart hook will prompt Claude to extract patterns

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.json"

# Determine learned skills path based on profile
if [ -n "$CLAUDE_CONFIG_DIR" ]; then
  BASE_DIR="$CLAUDE_CONFIG_DIR"
else
  BASE_DIR="$HOME/.claude"
fi

LEARNED_SKILLS_PATH="$BASE_DIR/skills/learned"
PENDING_REVIEW_FILE="$BASE_DIR/pending-review.jsonl"
MIN_SESSION_LENGTH=10

# Load config if exists
if [ -f "$CONFIG_FILE" ]; then
  MIN_SESSION_LENGTH=$(jq -r '.min_session_length // 10' "$CONFIG_FILE" 2>/dev/null || echo "10")
fi

# Ensure learned skills directory exists
mkdir -p "$LEARNED_SKILLS_PATH"

# Get transcript path from environment (set by Claude Code)
transcript_path="${CLAUDE_TRANSCRIPT_PATH:-}"

if [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
  exit 0
fi

# Count user messages in session
message_count=$(grep -c '"type":"user"' "$transcript_path" 2>/dev/null || echo "0")

# Skip short sessions
if [ "$message_count" -lt "$MIN_SESSION_LENGTH" ]; then
  exit 0
fi

# Get session metadata
session_id=$(basename "$transcript_path" .jsonl)
project_dir=$(grep -m1 '"cwd"' "$transcript_path" 2>/dev/null | sed 's/.*"cwd":"\([^"]*\)".*/\1/' || echo "unknown")
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Append to pending review file
echo "{\"session_id\":\"$session_id\",\"transcript\":\"$transcript_path\",\"project\":\"$project_dir\",\"messages\":$message_count,\"timestamp\":\"$timestamp\"}" >> "$PENDING_REVIEW_FILE"

echo "[ContinuousLearning] Session queued for review ($message_count messages)" >&2
