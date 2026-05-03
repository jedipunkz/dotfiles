#!/bin/bash
set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')

is_sensitive_path() {
  local p="${1/#\~/$HOME}"
  local base
  base=$(basename "$p")

  [[ "$base" == ".env" ]] && return 0
  [[ "$base" == .env.* ]] && return 0
  printf '%s' "$p" | grep -qE '(^|/)\.env(\.[^/]+)?$' && return 0
  [[ "$base" =~ \.(pem|key|p12|pfx|cert|crt|cer)$ ]] && return 0
  [[ "$base" =~ ^id_(rsa|ed25519|ecdsa|dsa|xmss|ecdsa_sk|ed25519_sk)$ ]] && return 0

  case "$base" in
    credentials|credentials.json|secrets.json|secret.json) return 0 ;;
    service-account*.json) return 0 ;;
    .netrc|.npmrc|.pypirc|pip.conf) return 0 ;;
    hosts.yml) printf '%s' "$p" | grep -q "config/gh" && return 0 ;;
  esac

  printf '%s' "$p" | grep -qE '(^|/)(\.aws|\.ssh|\.gnupg)(/|$)' && return 0
  printf '%s' "$p" | grep -qE '(^|/)\.config/gh(/|$)' && return 0

  return 1
}

block() {
  echo "BLOCKED: Access to sensitive path '$1' is denied." >&2
  echo "Use environment variables or a secrets manager instead of reading secrets directly." >&2
  exit 2
}

case "$TOOL_NAME" in
  Bash)
    COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
    if printf '%s' "$COMMAND" | grep -qE '(^|[[:space:];|&])(cat|head|tail|less|more|bat|view|nvim|vim|nano|emacs|open|xdg-open)[[:space:]]+[^|;&]*(\.env\b|\.env\.|\.aws/|\.ssh/id_|\.gnupg/|\.netrc|\.npmrc|\.pypirc|config/gh/|\.pem|\.key\b|credentials\.json|secrets\.json)'; then
      block "command input"
    fi
    ;;
  apply_patch)
    PATCH=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
    while IFS= read -r path; do
      [ -z "$path" ] && continue
      is_sensitive_path "$path" && block "$path"
    done < <(printf '%s\n' "$PATCH" | sed -nE 's/^\*\*\* (Add|Update|Delete) File: (.*)$/\2/p')
    ;;
esac

exit 0
