#!/bin/bash
# PreToolUse hook: block git force push
# Reads JSON from stdin: {"tool_name": "Bash", "tool_input": {"command": "..."}, ...}
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

if [ "$TOOL_NAME" = "Bash" ]; then
  COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
  if echo "$COMMAND" | grep -qE "git\s+push.*(--force|-f)(\s|$)"; then
    echo "BLOCKED: Force push is not allowed. Use standard push without --force." >&2
    exit 2
  fi
fi
exit 0