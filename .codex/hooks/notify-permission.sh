#!/bin/bash
set -euo pipefail

INPUT=$(cat)
HOOK_EVENT=$(printf '%s' "$INPUT" | jq -r '.hook_event_name // ""')
[ "$HOOK_EVENT" = "PermissionRequest" ] || exit 0

TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')
TITLE="Codex - 確認が必要"

case "$TOOL_NAME" in
  Bash)
    MSG=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // "承認が必要です"' | cut -c 1-120)
    ;;
  *)
    MSG="$TOOL_NAME の承認が必要です"
    ;;
esac

/usr/bin/osascript -e "display notification \"$MSG\" with title \"$TITLE\"" 2>/dev/null &
disown 2>/dev/null || true

exit 0
