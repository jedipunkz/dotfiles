#!/bin/bash
# PreToolUse hook: remove a stale .git/index.lock before running git commands
# Shared by Claude Code and Codex — both send {"tool_name", "tool_input.command", "cwd"}
set -uo pipefail

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')
[ "$TOOL_NAME" = "Bash" ] || exit 0

COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
printf '%s' "$COMMAND" | grep -qE '(^|[[:space:];|&])git([[:space:]]|$)' || exit 0

CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // ""')
[ -n "$CWD" ] || exit 0

GIT_ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null || true)
[ -n "$GIT_ROOT" ] || exit 0

LOCK_FILE="$GIT_ROOT/.git/index.lock"
[ -f "$LOCK_FILE" ] || exit 0

# Only delete the lock when no process actually holds it.
LOCK_HELD=false
if command -v lsof >/dev/null 2>&1; then
  lsof "$LOCK_FILE" >/dev/null 2>&1 && LOCK_HELD=true
elif command -v fuser >/dev/null 2>&1; then
  fuser "$LOCK_FILE" >/dev/null 2>&1 && LOCK_HELD=true
else
  # Fallback: treat a lock older than 60s as stale
  MOD_TIME=$(stat -f %m "$LOCK_FILE" 2>/dev/null || stat -c %Y "$LOCK_FILE" 2>/dev/null || echo 0)
  LOCK_AGE=$(( $(date +%s) - MOD_TIME ))
  [ "$LOCK_AGE" -le 60 ] && LOCK_HELD=true
fi

if [ "$LOCK_HELD" = false ]; then
  unlink "$LOCK_FILE" 2>/dev/null || true
  echo "[clean-git-lock] removed stale $LOCK_FILE" >&2
fi

exit 0
