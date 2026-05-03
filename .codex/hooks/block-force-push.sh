#!/bin/bash
set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')

[ "$TOOL_NAME" = "Bash" ] || exit 0

COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
if printf '%s' "$COMMAND" | grep -qE '(^|[;&|[:space:]])git[[:space:]]+push([^;&|]*[[:space:]])(--force|-f)([[:space:]]|$)'; then
  echo "BLOCKED: Force push is not allowed. Use standard push without --force." >&2
  exit 2
fi

exit 0
