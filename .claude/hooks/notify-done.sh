#!/bin/bash
# Stop hook: macOS desktop notification with sound when Claude finishes a task
# Reads JSON from stdin: {"stop_reason": "...", "is_error": false, ...}
INPUT=$(cat)
IS_ERROR=$(echo "$INPUT" | jq -r '.is_error // false')

if [ "$IS_ERROR" = "true" ]; then
  TITLE="Claude Code - エラー"
  MSG="タスクがエラーで終了しました"
  SOUND="Basso"
else
  TITLE="Claude Code - 完了"
  MSG="タスクが完了しました"
  SOUND="Glass"
fi

# macOS notification with sound (sound name plays via Notification Center)
if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$MSG\" with title \"$TITLE\" sound name \"$SOUND\"" 2>/dev/null || true
fi

exit 0
