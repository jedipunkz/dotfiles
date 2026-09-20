#!/bin/bash
# PreToolUse hook: block access to sensitive files
#
# Background: permissions.deny in settings.json has known bypass bugs
# (anthropics/claude-code#24846, #6699). This hook is the reliable layer.
#
# Shared by Claude Code and Codex. The two send different tool vocabularies,
# so the case below is the union of both:
#   Read / Edit / Write — Claude Code, path in .tool_input.file_path
#   Grep                — Claude Code, path in .tool_input.path
#   apply_patch         — Codex, patch text in .tool_input.command
#   Bash                — both, command text in .tool_input.command
set -uo pipefail

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')

# Expand ~ to $HOME and check if a path is sensitive
is_sensitive_path() {
  local p="${1/#\~/$HOME}"
  local base
  base=$(basename "$p")

  # .env files
  [[ "$base" == ".env" ]] && return 0
  [[ "$base" == .env.* ]] && return 0
  printf '%s' "$p" | grep -qE '(^|/)\.env(\.[^/]+)?$' && return 0

  # Key/cert files
  [[ "$base" =~ \.(pem|key|p12|pfx|cert|crt|cer)$ ]] && return 0

  # SSH private keys
  [[ "$base" =~ ^id_(rsa|ed25519|ecdsa|dsa|xmss|ecdsa_sk|ed25519_sk)$ ]] && return 0

  # Known sensitive filenames
  case "$base" in
    credentials|credentials.json|secrets.json|secret.json) return 0 ;;
    service-account*.json) return 0 ;;
    .netrc|.npmrc|.pypirc|.pip|pip.conf) return 0 ;;
    hosts.yml) printf '%s' "$p" | grep -q "config/gh" && return 0 ;;
  esac

  # Sensitive directories
  printf '%s' "$p" | grep -qE '(^|/)(\.aws|\.ssh|\.gnupg)(/|$)' && return 0
  printf '%s' "$p" | grep -qE '(^|/)\.config/gh(/|$)' && return 0

  return 1
}

block() {
  echo "BLOCKED: Access to sensitive path '$1' is denied." >&2
  echo "  Use environment variables or a secrets manager instead of reading secrets directly." >&2
  exit 2
}

case "$TOOL_NAME" in
  Read|Edit|Write)
    FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
    [ -n "$FILE_PATH" ] || exit 0
    is_sensitive_path "$FILE_PATH" && block "$FILE_PATH"
    ;;

  Grep)
    GREP_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.path // ""')
    [ -n "$GREP_PATH" ] || exit 0
    is_sensitive_path "$GREP_PATH" && block "$GREP_PATH"
    ;;

  apply_patch)
    PATCH=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
    while IFS= read -r path; do
      [ -n "$path" ] || continue
      is_sensitive_path "$path" && block "$path"
    done < <(printf '%s\n' "$PATCH" | sed -nE 's/^\*\*\* (Add|Update|Delete) File: (.*)$/\2/p')
    ;;

  Bash)
    COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
    if printf '%s' "$COMMAND" | grep -qE '(^|[[:space:];|&])(cat|head|tail|less|more|bat|view|nvim|vim|nano|emacs|open|xdg-open)[[:space:]]+[^|;&]*(\.env\b|\.env\.|\.aws/|\.ssh/id_|\.gnupg/|\.netrc|\.npmrc|\.pypirc|config/gh/|\.pem|\.key\b|credentials\.json|secrets\.json)'; then
      block "command input"
    fi
    ;;
esac

exit 0
