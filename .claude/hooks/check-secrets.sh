#!/bin/bash
# PreToolUse hook: detect hardcoded secrets in Write/Edit tool content, and .env access in Bash
# Reads JSON from stdin
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

case "$TOOL_NAME" in
  Write|Edit)
    # Check file path first: block writing to .env files
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
    if echo "$FILE_PATH" | grep -qE "(^|/)\.env(\.|$)"; then
      echo "BLOCKED: Writing to .env files is not allowed." >&2
      exit 2
    fi
    # Check content for hardcoded credential patterns: KEY=value (not just variable references)
    CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // ""')
    if echo "$CONTENT" | grep -qE "(AWS_SECRET_ACCESS_KEY|API_KEY|PRIVATE_KEY|SECRET_KEY|DB_PASSWORD)\s*=\s*['\"]?[A-Za-z0-9+/]{16,}"; then
      echo "BLOCKED: Potential hardcoded secret detected in file content. Use environment variables instead." >&2
      exit 2
    fi
    ;;
  Bash)
    COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
    # Block reading sensitive credential files
    if echo "$COMMAND" | grep -qE "(cat|head|tail|less|more)\s+~?/?(\.env|\.aws/credentials|\.ssh/id_rsa)"; then
      echo "BLOCKED: Reading sensitive credential files is not allowed." >&2
      exit 2
    fi
    ;;
esac
exit 0