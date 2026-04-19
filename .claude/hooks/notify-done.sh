#!/bin/bash
# Stop hook: macOS desktop notification when Claude finishes a task
# Reads JSON from stdin: {"stop_reason": "...", "is_error": false, ...}
INPUT=$(cat)
IS_ERROR=$(echo "$INPUT" | jq -r '.is_error // false')

if [ "$IS_ERROR" = "true" ]; then
  TITLE="Claude Code - エラー"
  MSG="タスクがエラーで終了しました"
else
  TITLE="Claude Code - 完了"
  MSG="タスクが完了しました"
fi

# macOS notification
if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$MSG\" with title \"$TITLE\"" 2>/dev/null || true
fi

exit 0
