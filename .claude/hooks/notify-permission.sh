#!/bin/bash
# PermissionRequest hook: macOS desktop notification when the agent needs approval
#
# Shared by Claude Code and Codex. Pass the agent label as $1 ("Claude Code" / "Codex").
# PermissionRequest only fires when approval is actually required, so no allow-list
# filtering is needed here.
set -uo pipefail

AGENT="${1:-Agent}"

INPUT=$(cat)
HOOK_EVENT=$(printf '%s' "$INPUT" | jq -r '.hook_event_name // ""')
[ "$HOOK_EVENT" = "PermissionRequest" ] || exit 0

TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')
TITLE="$AGENT - 確認が必要"

case "$TOOL_NAME" in
  Bash)
    MSG=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // "承認が必要です"' | tr '\n' ' ' | cut -c 1-120)
    ;;
  AskUserQuestion)
    # Claude Code sends questions[] as objects; take the text, not the raw JSON.
    MSG=$(printf '%s' "$INPUT" | jq -r '.tool_input.question // .tool_input.questions[0].question? // "質問があります"' | tr '\n' ' ' | cut -c 1-120)
    ;;
  *)
    MSG="$TOOL_NAME の承認が必要です"
    ;;
esac

# Tool input is untrusted here: strip the quoting characters that would
# otherwise break out of the osascript string literal.
MSG=$(printf '%s' "$MSG" | tr -d '"\\')

/usr/bin/osascript -e "display notification \"$MSG\" with title \"$TITLE\"" 2>/dev/null &
disown 2>/dev/null || true

exit 0
