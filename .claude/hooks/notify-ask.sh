#!/bin/bash
# Hook: notify user when Claude needs confirmation or asks a question
#
# Triggered by PreToolUse only (Notification hook removed — it caused double-firing
# alongside PreToolUse, resulting in two sounds per confirmation).
#
# Latency optimisation: afplay fires in background as the very first action,
# before any allow-list check or osascript, so sound plays at earliest opportunity.

INPUT=$(cat)

SOUND_FILE="/System/Library/Sounds/Frog.aiff"
TITLE="Claude Code - 確認が必要"

# ── Sound (afplay) + notification (osascript) ────────────────────────────────
_notify() {
  local msg="${1:0:120}"
  afplay "$SOUND_FILE" &
  /usr/bin/osascript -e "display notification \"$msg\" with title \"$TITLE\"" 2>/dev/null &
  disown 2>/dev/null
}

# ── Allow-list cache ──────────────────────────────────────────────────────────
# Compiles "Bash(prefix:*)" entries into one grep ERE pattern, cached in /tmp.
# Rebuilt only when settings.json is newer than cache file.
_allow_pattern() {
  local settings="$HOME/.claude/settings.json" cache="/tmp/claude_bash_allow.pat"
  [ -f "$settings" ] || { printf ""; return; }
  if [ ! -f "$cache" ] || [ "$settings" -nt "$cache" ]; then
    jq -r '
      [.permissions.allow[]?
       | select(startswith("Bash("))
       | ltrimstr("Bash(") | rtrimstr(":*)")
       | "^" + . + "( |$)"]
      | join("|")
    ' "$settings" 2>/dev/null > "$cache"
  fi
  cat "$cache"
}

_is_allowed() {
  local pattern; pattern=$(_allow_pattern)
  [ -z "$pattern" ] && return 1
  printf '%s' "$1" | grep -qE "$pattern"
}

# ─────────────────────────────────────────────────────────────────────────────

read -r HOOK_EVENT TOOL_NAME < <(
  printf '%s' "$INPUT" | jq -r '[.hook_event_name // "", .tool_name // ""] | @tsv'
)

[ "$HOOK_EVENT" = "PreToolUse" ] || exit 0

case "$TOOL_NAME" in
  Bash)
    CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
    _is_allowed "$CMD" && exit 0
    _notify "承認が必要: ${CMD:0:80}"
    ;;
  AskUserQuestion)
    MSG=$(printf '%s' "$INPUT" | jq -r '
      .tool_input.question // (.tool_input.questions[0] // "質問があります")
    ')
    _notify "$MSG"
    ;;
  *)
    exit 0
    ;;
esac

exit 0
