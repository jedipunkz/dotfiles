#!/bin/bash
# Stop hook: macOS desktop notification with sound when Claude finishes a task
# Reads JSON from stdin: {"stop_reason": "...", "is_error": false, ...}
INPUT=$(cat)
IS_ERROR=$(echo "$INPUT" | jq -r '.is_error // false')

if [ "$IS_ERROR" = "true" ]; then
  TITLE="Claude Code - エラー"
  MSG="タスクがエラーで終了しました"
  SOUND_FILE="/System/Library/Sounds/Basso.aiff"
else
  TITLE="Claude Code - 完了"
  MSG="タスクが完了しました"
  SOUND_FILE="/System/Library/Sounds/Glass.aiff"
fi

# afplay for reliable sound, osascript for visual notification
afplay "$SOUND_FILE" &
osascript -e "display notification \"$MSG\" with title \"$TITLE\"" 2>/dev/null || true

exit 0
