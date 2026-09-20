#!/bin/bash
# Stop hook: macOS desktop notification with sound when the agent finishes a task
#
# Shared by Claude Code and Codex. Pass the agent label as $1 ("Claude Code" / "Codex").
#
# Claude Code splits the two outcomes into separate events: Stop fires on normal
# completion and StopFailure on an API error. There is no is_error field on Stop,
# so the outcome is read from hook_event_name. Codex only emits Stop.
# .last_assistant_message is sent by both and replaces the generic text when present.
set -uo pipefail

AGENT="${1:-Agent}"

INPUT=$(cat)
HOOK_EVENT=$(printf '%s' "$INPUT" | jq -r '.hook_event_name // ""')
LAST_MESSAGE=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // ""' | tr '\n' ' ' | cut -c 1-120)

if [ "$HOOK_EVENT" = "StopFailure" ]; then
  TITLE="$AGENT - エラー"
  ERROR_TYPE=$(printf '%s' "$INPUT" | jq -r '.error_type // ""')
  MSG="タスクがエラーで終了しました${ERROR_TYPE:+ ($ERROR_TYPE)}"
  SOUND_FILE="/System/Library/Sounds/Basso.aiff"
else
  TITLE="$AGENT - 完了"
  MSG="タスクが完了しました"
  SOUND_FILE="/System/Library/Sounds/Glass.aiff"
fi

[ "$HOOK_EVENT" != "StopFailure" ] && [ -n "$LAST_MESSAGE" ] && MSG="$LAST_MESSAGE"

# Model output is untrusted here: strip the quoting characters that would
# otherwise break out of the osascript string literal.
MSG=$(printf '%s' "$MSG" | tr -d '"\\')

afplay "$SOUND_FILE" >/dev/null 2>&1 &
/usr/bin/osascript -e "display notification \"$MSG\" with title \"$TITLE\"" 2>/dev/null || true

exit 0
