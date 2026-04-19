#!/bin/bash
# Hook: notify user when Claude needs confirmation or asks a question
#
# Performance notes:
#   - Allow-list pattern is cached in /tmp and rebuilt only when settings.json changes
#   - afplay (sound) and osascript (notification) run async so the hook exits immediately

INPUT=$(cat)

# Extract fields in one jq call
read -r HOOK_EVENT TOOL_NAME < <(
  echo "$INPUT" | jq -r '[.hook_event_name // "", .tool_name // ""] | @tsv'
)

TITLE="Claude Code - 確認が必要"
SOUND="Ping"

# ── Fire sound + notification immediately (async) ────────────────────────────
notify() {
  local msg="${1:0:120}"
  # Sound: afplay is fast and fires independently
  command -v afplay >/dev/null 2>&1 && { afplay "/System/Library/Sounds/${SOUND}.aiff" 2>/dev/null & disown; }
  # Visual notification (no sound name to avoid double-play)
  command -v osascript >/dev/null 2>&1 && {
    osascript -e "display notification \"$msg\" with title \"$TITLE\"" 2>/dev/null &
    disown
  }
}

# ── Allow-list cache: rebuild only when settings.json changes ────────────────
# Compiles all "Bash(prefix:*)" entries into one grep pattern: "^prefix( |$)|..."
_allow_pattern() {
  local settings="$HOME/.claude/settings.json"
  local cache="/tmp/claude_bash_allow.pat"
  [ -f "$settings" ] || { printf ""; return; }
  if [ ! -f "$cache" ] || [ "$settings" -nt "$cache" ]; then
    jq -r '
      [.permissions.allow[]?
       | select(startswith("Bash("))
       | ltrimstr("Bash(") | rtrimstr(":*")
       | "^" + . + "( |$)"]
      | join("|")
    ' "$settings" 2>/dev/null > "$cache"
  fi
  cat "$cache"
}

is_allowed_bash() {
  local pattern
  pattern=$(_allow_pattern)
  [ -z "$pattern" ] && return 1
  echo "$1" | grep -qE "$pattern"
}

# ─────────────────────────────────────────────────────────────────────────────

case "$HOOK_EVENT" in
  PreToolUse)
    case "$TOOL_NAME" in
      Bash)
        CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
        is_allowed_bash "$CMD" && exit 0
        notify "承認が必要: ${CMD:0:80}"
        ;;
      AskUserQuestion)
        MSG=$(echo "$INPUT" | jq -r '
          .tool_input.question // (.tool_input.questions[0] // "質問があります")
        ')
        notify "$MSG"
        ;;
      *) exit 0 ;;
    esac
    ;;

  Notification)
    NOTIF_TYPE=$(echo "$INPUT" | jq -r '.notification_type // ""')
    case "$NOTIF_TYPE" in
      idle_prompt|auth_success) exit 0 ;;
    esac
    MSG=$(echo "$INPUT" | jq -r '.message // "確認が必要です"')
    notify "$MSG"
    ;;

  *) exit 0 ;;
esac

exit 0
