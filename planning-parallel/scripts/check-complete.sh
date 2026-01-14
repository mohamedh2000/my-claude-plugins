#!/bin/bash
# Check if all tasks in task_plan.md are complete
# Exit 0 if complete, exit 1 if incomplete
# Used by Stop hook to verify task completion

PLAN_FILE="${1:-task_plan.md}"

if [ ! -f "$PLAN_FILE" ]; then
    echo "ERROR: $PLAN_FILE not found"
    echo "Cannot verify completion without a task plan."
    exit 1
fi

echo "=== Task Completion Check ==="
echo ""

# Count tasks by status
TOTAL=$(grep -c "^### \[" "$PLAN_FILE" 2>/dev/null || echo "0")
COMPLETE=$(grep -cF "**Status:** complete" "$PLAN_FILE" 2>/dev/null || echo "0")
IN_PROGRESS=$(grep -cF "**Status:** in_progress" "$PLAN_FILE" 2>/dev/null || echo "0")
PENDING=$(grep -cF "**Status:** pending" "$PLAN_FILE" 2>/dev/null || echo "0")

# Check for any remaining sub-agent files (should be cleaned up)
SUBAGENT_FILES=$(ls findings_*.md progress_*.md 2>/dev/null | wc -l | tr -d ' ')

echo "Total tasks:    $TOTAL"
echo "Complete:       $COMPLETE"
echo "In progress:    $IN_PROGRESS"
echo "Pending:        $PENDING"
echo ""

if [ "$SUBAGENT_FILES" -gt 0 ]; then
    echo "WARNING: Found $SUBAGENT_FILES sub-agent files not yet merged"
    ls findings_*.md progress_*.md 2>/dev/null
    echo ""
fi

# Check completion
if [ "$COMPLETE" -eq "$TOTAL" ] && [ "$TOTAL" -gt 0 ] && [ "$SUBAGENT_FILES" -eq 0 ]; then
    echo "ALL TASKS COMPLETE"
    exit 0
else
    echo "TASK NOT COMPLETE"
    echo ""
    if [ "$SUBAGENT_FILES" -gt 0 ]; then
        echo "Merge sub-agent files before completing."
    fi
    echo "Do not stop until all tasks are complete."
    exit 1
fi
