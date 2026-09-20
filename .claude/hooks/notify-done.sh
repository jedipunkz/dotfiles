#!/bin/bash
# Stop hook: macOS desktop notification with sound when the agent finishes a task
#
# Shared by Claude Code and Codex. Pass the agent label as $1 ("Claude Code" / "Codex").
# stdin JSON fields differ per agent, so both are read with a default:
#   .is_error               — Claude Code
#   .last_assistant_message — Codex
set -uo pipefail

AGENT="${1:-Agent}"

INPUT=$(cat)
IS_ERROR=$(printf '%s' "$INPUT" | jq -r '.is_error // false')
LAST_MESSAGE=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // ""' | tr '\n' ' ' | cut -c 1-120)

if [ "$IS_ERROR" = "true" ]; then
  TITLE="$AGENT - エラー"
  MSG="タスクがエラーで終了しました"
  SOUND_FILE="/System/Library/Sounds/Basso.aiff"
else
  TITLE="$AGENT - 完了"
  MSG="タスクが完了しました"
  SOUND_FILE="/System/Library/Sounds/Glass.aiff"
fi

[ -n "$LAST_MESSAGE" ] && MSG="$LAST_MESSAGE"

# Model output is untrusted here: strip the quoting characters that would
# otherwise break out of the osascript string literal.
MSG=$(printf '%s' "$MSG" | tr -d '"\\')

afplay "$SOUND_FILE" >/dev/null 2>&1 &
/usr/bin/osascript -e "display notification \"$MSG\" with title \"$TITLE\"" 2>/dev/null || true

exit 0
