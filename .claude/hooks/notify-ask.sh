#!/bin/bash
# Hook: notify user when Claude needs confirmation or asks a question
#
# Approach (layered):
#   1. PreToolUse(Bash)         — detect commands NOT in allow list → will show
#                                 permission dialog → Ping before dialog appears
#   2. PreToolUse(AskUserQuestion) — Claude explicitly asks a yes/no question
#   3. Notification(catch-all)  — fallback for any remaining notification events
#                                 (Notification(permission_prompt) is unreliable per
#                                  issues #11964 and #17170)
#
# Sound: Ping (distinct from Glass=complete, Basso=error)

INPUT=$(cat)
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // ""')
TOOL_NAME=$(echo "$INPUT"  | jq -r '.tool_name // ""')

TITLE="Claude Code - 確認が必要"
SOUND="Ping"

# ── Helper: check if a Bash command is pre-approved (in allow list) ──────────
is_allowed_bash() {
  local cmd="$1"
  local settings="$HOME/.claude/settings.json"
  [ -f "$settings" ] || return 1  # unknown → treat as needing approval

  # Read Bash allow patterns: "Bash(prefix:*)" → check if cmd starts with prefix
  while IFS= read -r entry; do
    case "$entry" in
      Bash\(*)
        prefix=$(echo "$entry" | sed 's/^Bash(\(.*\):\*.*)/\1/')
        echo "$cmd" | grep -qE "^${prefix}(\s|$)" && return 0
        ;;
    esac
  done < <(jq -r '.permissions.allow[] // empty' "$settings" 2>/dev/null)

  return 1  # not found in allow list → will need approval
}

# ─────────────────────────────────────────────────────────────────────────────

case "$HOOK_EVENT" in
  PreToolUse)
    case "$TOOL_NAME" in
      Bash)
        CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
        is_allowed_bash "$CMD" && exit 0   # auto-approved, no dialog → skip
        MSG="承認が必要: ${CMD:0:80}"
        ;;
      AskUserQuestion)
        MSG=$(echo "$INPUT" | jq -r '
          .tool_input.question //
          (.tool_input.questions[0] // "質問があります")
        ')
        ;;
      *)
        exit 0
        ;;
    esac
    ;;

  Notification)
    # Catch-all fallback. Skip noisy types if notification_type is present.
    NOTIF_TYPE=$(echo "$INPUT" | jq -r '.notification_type // ""')
    case "$NOTIF_TYPE" in
      idle_prompt|auth_success) exit 0 ;;
    esac
    MSG=$(echo "$INPUT" | jq -r '.message // "確認が必要です"')
    ;;

  *)
    exit 0
    ;;
esac

MSG="${MSG:0:120}"

if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$MSG\" with title \"$TITLE\" sound name \"$SOUND\"" 2>/dev/null || true
fi

exit 0
