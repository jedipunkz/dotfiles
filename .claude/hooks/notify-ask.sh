#!/bin/bash
# Hook: notify user when Claude needs confirmation or asks a question
#
# Triggered by two events:
#   1. Notification (matcher: permission_prompt) — tool permission dialogs (yes/no)
#   2. PreToolUse  (matcher: AskUserQuestion)   — Claude explicitly asks a question
#
# Sound: Ping (distinctive; different from Glass=complete, Basso=error)

INPUT=$(cat)
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // ""')
TOOL_NAME=$(echo "$INPUT"  | jq -r '.tool_name // ""')

TITLE="Claude Code - 確認が必要"
SOUND="Ping"

case "$HOOK_EVENT" in
  Notification)
    MSG=$(echo "$INPUT" | jq -r '.message // "確認が必要です"')
    ;;
  PreToolUse)
    [ "$TOOL_NAME" = "AskUserQuestion" ] || exit 0
    # tool_input may have .question (string) or .questions (array)
    MSG=$(echo "$INPUT" | jq -r '
      .tool_input.question //
      (.tool_input.questions[0] // "質問があります")
    ')
    ;;
  *)
    exit 0
    ;;
esac

# Truncate to keep notification readable
MSG="${MSG:0:120}"

if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$MSG\" with title \"$TITLE\" sound name \"$SOUND\"" 2>/dev/null || true
fi

exit 0
