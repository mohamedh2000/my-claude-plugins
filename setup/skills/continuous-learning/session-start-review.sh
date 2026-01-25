#!/bin/bash
# Continuous Learning - Session Start Review
# Checks for pending session reviews and prepares extraction prompt
#
# This hook runs at session start and checks if there are sessions
# waiting to be reviewed for pattern extraction.

set -e

# Determine base directory based on profile
if [ -n "$CLAUDE_CONFIG_DIR" ]; then
  BASE_DIR="$CLAUDE_CONFIG_DIR"
else
  BASE_DIR="$HOME/.claude"
fi

PENDING_REVIEW_FILE="$BASE_DIR/pending-review.jsonl"
LEARNED_SKILLS_PATH="$BASE_DIR/skills/learned"
EXTRACTION_PROMPT_FILE="$BASE_DIR/extraction-prompt.md"

# Exit if no pending reviews
if [ ! -f "$PENDING_REVIEW_FILE" ] || [ ! -s "$PENDING_REVIEW_FILE" ]; then
  exit 0
fi

# Count pending reviews
pending_count=$(wc -l < "$PENDING_REVIEW_FILE" | tr -d ' ')

if [ "$pending_count" -eq 0 ]; then
  exit 0
fi

# Get the oldest pending review
oldest_review=$(head -1 "$PENDING_REVIEW_FILE")
session_id=$(echo "$oldest_review" | jq -r '.session_id')
transcript=$(echo "$oldest_review" | jq -r '.transcript')
project=$(echo "$oldest_review" | jq -r '.project')
messages=$(echo "$oldest_review" | jq -r '.messages')

# Verify transcript still exists
if [ ! -f "$transcript" ]; then
  # Remove invalid entry and exit
  tail -n +2 "$PENDING_REVIEW_FILE" > "$PENDING_REVIEW_FILE.tmp"
  mv "$PENDING_REVIEW_FILE.tmp" "$PENDING_REVIEW_FILE"
  exit 0
fi

# Create extraction prompt
cat > "$EXTRACTION_PROMPT_FILE" << EOF
# Pending Learning Extraction

You have **$pending_count session(s)** pending review for pattern extraction.

## Oldest Session to Review
- **Session ID**: $session_id
- **Project**: $project
- **Messages**: $messages
- **Transcript**: $transcript

## Instructions

Run \`/learn\` to extract patterns from this session, or say "skip learning" to dismiss.

Patterns to look for:
- Error resolutions (how bugs were fixed)
- User corrections (where I made mistakes)
- Workarounds (non-obvious solutions)
- Debugging techniques (effective approaches)
- Project conventions (patterns specific to this codebase)

Extracted patterns will be saved to: \`$LEARNED_SKILLS_PATH/\`
EOF

echo "[ContinuousLearning] $pending_count session(s) pending review. Run /learn or say 'skip learning'" >&2
