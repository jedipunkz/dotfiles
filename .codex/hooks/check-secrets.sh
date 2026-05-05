#!/bin/bash
set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')
[ "$TOOL_NAME" = "apply_patch" ] || exit 0

PATCH=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')

if printf '%s' "$PATCH" | sed -nE 's/^\*\*\* (Add|Update|Delete) File: (.*)$/\2/p' | grep -qE '(^|/)\.env(\.|$|/)'; then
  echo "BLOCKED: Writing to .env files is not allowed." >&2
  exit 2
fi

if printf '%s' "$PATCH" | grep -qE '^\+(.*)(AWS_SECRET_ACCESS_KEY|API_KEY|PRIVATE_KEY|SECRET_KEY|DB_PASSWORD)[[:space:]]*=[[:space:]]*['"'"'"]?[A-Za-z0-9+/]{16,}'; then
  echo "BLOCKED: Potential hardcoded secret detected in patch content. Use environment variables instead." >&2
  exit 2
fi

exit 0
