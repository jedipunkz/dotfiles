#!/bin/bash
set -euo pipefail

INPUT=$(cat)
LAST_MESSAGE=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // ""' | cut -c 1-120)

TITLE="Codex - 完了"
MSG="タスクが完了しました"
[ -n "$LAST_MESSAGE" ] && MSG="$LAST_MESSAGE"

afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &
/usr/bin/osascript -e "display notification \"$MSG\" with title \"$TITLE\"" 2>/dev/null || true

exit 0
