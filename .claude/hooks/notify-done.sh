#!/bin/bash
# Stop hook: macOS desktop notification with sound when the agent finishes a task
#
# Shared by Claude Code and Codex. Pass the agent label as $1 ("Claude Code" / "Codex").
#
# Claude Code splits the two outcomes into separate events: Stop fires on normal
# completion and StopFailure on an API error. There is no is_error field on Stop,
# so the outcome is read from hook_event_name. Codex only emits Stop.
# The body is fixed text on purpose — the turn's own message is not echoed here.
set -uo pipefail

AGENT="${1:-Agent}"

INPUT=$(cat)
HOOK_EVENT=$(printf '%s' "$INPUT" | jq -r '.hook_event_name // ""')

if [ "$HOOK_EVENT" = "StopFailure" ]; then
  TITLE="$AGENT - エラー"
  # error_type is a documented enum, but it is still payload input: keep it to
  # characters that cannot break out of the osascript string literal below.
  ERROR_TYPE=$(printf '%s' "$INPUT" | jq -r '.error_type // ""' | tr -cd 'a-zA-Z0-9_-')
  MSG="タスクがエラーで終了しました${ERROR_TYPE:+ ($ERROR_TYPE)}"
  SOUND_FILE="/System/Library/Sounds/Basso.aiff"
else
  TITLE="$AGENT - 完了"
  MSG="タスクが完了しました"
  SOUND_FILE="/System/Library/Sounds/Glass.aiff"
fi

afplay "$SOUND_FILE" >/dev/null 2>&1 &
/usr/bin/osascript -e "display notification \"$MSG\" with title \"$TITLE\"" 2>/dev/null || true

exit 0
