#!/bin/bash
# PreToolUse hook: block access to sensitive files
#
# Background: permissions.deny in settings.json has known bypass bugs
# (anthropics/claude-code#24846, #6699). This hook is the reliable layer.
#
# Covers:
#   Read  — direct file read
#   Edit  — file modification (also writes)
#   Bash  — commands like cat/head/tail reading sensitive files
#   Grep  — searching sensitive file contents
#
# Reads JSON from stdin

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

# Expand ~ to $HOME and check if a path is sensitive
is_sensitive_path() {
  local p="${1/#\~/$HOME}"
  local base
  base=$(basename "$p")

  # .env files
  [[ "$base" == ".env" ]] && return 0
  [[ "$base" == .env.* ]] && return 0
  echo "$p" | grep -qE '(^|/)\.env(\.[^/]+)?$' && return 0

  # Key/cert files
  [[ "$base" =~ \.(pem|key|p12|pfx|cert|crt|cer)$ ]] && return 0

  # SSH private keys
  [[ "$base" =~ ^id_(rsa|ed25519|ecdsa|dsa|xmss|ecdsa_sk|ed25519_sk)$ ]] && return 0

  # Known sensitive filenames
  case "$base" in
    credentials|credentials.json|secrets.json|secret.json) return 0 ;;
    service-account*.json) return 0 ;;
    .netrc|.npmrc|.pypirc|.pip|pip.conf) return 0 ;;
    hosts.yml) echo "$p" | grep -q "config/gh" && return 0 ;;
  esac

  # Sensitive directories
  echo "$p" | grep -qE "(^|/)(\.aws|\.ssh|\.gnupg)(\/|$)" && return 0
  echo "$p" | grep -qE "(^|/)\.config/gh(/|$)" && return 0

  return 1
}

block() {
  local file="$1"
  echo "BLOCKED: Access to sensitive file '${file}' is denied." >&2
  echo "  Use environment variables or a secrets manager instead of reading secrets directly." >&2
  exit 2
}

case "$TOOL_NAME" in
  Read|Edit|Write)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
    [ -z "$FILE_PATH" ] && exit 0
    is_sensitive_path "$FILE_PATH" && block "$FILE_PATH"
    ;;

  Bash)
    COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
    # Check if command references known sensitive file patterns
    if echo "$COMMAND" | grep -qE \
      '(^|[[:space:];|&])(cat|head|tail|less|more|bat|view|nvim|vim|nano|emacs|open|xdg-open)[[:space:]]+[^|;&]*'\
'(\.env\b|\.env\.|\.aws/|\.ssh/id_|\.gnupg/|\.netrc|\.npmrc|\.pypirc|config/gh/|\.pem|\.key\b|credentials\.json|secrets\.json)'; then
      echo "BLOCKED: Command attempts to read a sensitive file." >&2
      echo "  Avoid reading secrets directly; use environment variables instead." >&2
      exit 2
    fi
    ;;

  Grep)
    GREP_PATH=$(echo "$INPUT" | jq -r '.tool_input.path // ""')
    [ -z "$GREP_PATH" ] && exit 0
    is_sensitive_path "$GREP_PATH" && block "$GREP_PATH"
    ;;
esac

exit 0
