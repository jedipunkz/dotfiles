#!/bin/bash
set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')
[ "$TOOL_NAME" = "Bash" ] || exit 0

COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')

# Strip quoted strings to avoid false positives in messages.
STRIPPED=$(printf '%s' "$COMMAND" | sed "s/'[^']*'//g" | sed 's/"[^"]*"//g')

while IFS= read -r segment; do
  segment="${segment#"${segment%%[![:space:]]*}"}"
  [ -z "$segment" ] && continue
  printf '%s' "$segment" | grep -qE '^rm[[:space:]]' || continue

  if printf '%s' "$segment" | grep -qE '^rm[[:space:]].*-[a-zA-Z]*[rRfF]' || \
     printf '%s' "$segment" | grep -qE '^rm[[:space:]].*(--recursive|--force)'; then
    echo "BLOCKED: rm with recursive or force flags is not allowed." >&2
    echo "Use plain 'rm <file>' only when the user explicitly asks for removal." >&2
    exit 2
  fi
done < <(printf '%s\n' "$STRIPPED" | tr ';&|' '\n')

exit 0
