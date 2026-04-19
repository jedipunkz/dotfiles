#!/bin/bash
# PreToolUse hook: remove stale .git/index.lock before git commands
# Reads JSON from stdin: {"tool_name": "Bash", "tool_input": {"command": "..."}, "cwd": "..."}
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

[ "$TOOL_NAME" != "Bash" ] && exit 0

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
echo "$COMMAND" | grep -qE "(^|\s)git(\s|$)" || exit 0

# Find the git repo root from cwd
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
[ -z "$CWD" ] && exit 0

GIT_ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null)
[ -z "$GIT_ROOT" ] && exit 0

LOCK_FILE="$GIT_ROOT/.git/index.lock"
[ -f "$LOCK_FILE" ] || exit 0

# Check if any process actually holds the lock
LOCK_HELD=false
if command -v lsof >/dev/null 2>&1; then
  lsof "$LOCK_FILE" >/dev/null 2>&1 && LOCK_HELD=true
elif command -v fuser >/dev/null 2>&1; then
  fuser "$LOCK_FILE" >/dev/null 2>&1 && LOCK_HELD=true
else
  # Fallback: treat lock older than 60s as stale
  LOCK_AGE=$(( $(date +%s) - $(stat -f %m "$LOCK_FILE" 2>/dev/null || stat -c %Y "$LOCK_FILE" 2>/dev/null || echo 0) ))
  [ "$LOCK_AGE" -le 60 ] && LOCK_HELD=true
fi

if [ "$LOCK_HELD" = "false" ]; then
  rm -f "$LOCK_FILE"
  echo "[clean-git-lock] Removed stale $LOCK_FILE" >&2
fi

exit 0
