#!/bin/bash
# Hook: append lifecycle events (WorktreeCreate/Remove, CwdChanged, SubagentStart)
# to a rolling log file for later inspection.

INPUT=$(cat)
LOG_DIR="$HOME/.claude/logs"
LOG_FILE="$LOG_DIR/events.log"

mkdir -p "$LOG_DIR"

EVENT=$(printf '%s' "$INPUT" | jq -r '.hook_event_name // "unknown"' 2>/dev/null)
SUMMARY=$(printf '%s' "$INPUT" | jq -c '{cwd: .cwd, subagent: .subagent_type, worktree: .worktree_path}' 2>/dev/null)
TS=$(date '+%Y-%m-%dT%H:%M:%S%z')

printf '%s\t%s\t%s\n' "$TS" "$EVENT" "$SUMMARY" >> "$LOG_FILE"

exit 0
