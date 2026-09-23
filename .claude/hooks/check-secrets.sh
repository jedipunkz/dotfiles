#!/bin/bash
# PreToolUse hook: detect hardcoded secrets in written content and .env access
#
# Shared by Claude Code and Codex. Union of both tool vocabularies:
#   Write / Edit  — Claude Code, path in .tool_input.file_path, body in .content / .new_string
#   apply_patch   — Codex, patch text in .tool_input.command
#   Bash          — both, command text in .tool_input.command
set -uo pipefail

SECRET_KEYS='AWS_SECRET_ACCESS_KEY|API_KEY|PRIVATE_KEY|SECRET_KEY|DB_PASSWORD'

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')

case "$TOOL_NAME" in
  Write|Edit)
    FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
    if printf '%s' "$FILE_PATH" | grep -qE '(^|/)\.env(\.|$)'; then
      echo "BLOCKED: Writing to .env files is not allowed." >&2
      exit 2
    fi
    CONTENT=$(printf '%s' "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // ""')
    if printf '%s' "$CONTENT" | grep -qE "($SECRET_KEYS)[[:space:]]*=[[:space:]]*['\"]?[A-Za-z0-9+/]{16,}"; then
      echo "BLOCKED: Potential hardcoded secret detected in file content. Use environment variables instead." >&2
      exit 2
    fi
    ;;

  apply_patch)
    PATCH=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
    if printf '%s' "$PATCH" | sed -nE 's/^\*\*\* (Add|Update|Delete) File: (.*)$/\2/p' | grep -qE '(^|/)\.env(\.|$|/)'; then
      echo "BLOCKED: Writing to .env files is not allowed." >&2
      exit 2
    fi
    if printf '%s' "$PATCH" | grep -qE "^\+.*($SECRET_KEYS)[[:space:]]*=[[:space:]]*['\"]?[A-Za-z0-9+/]{16,}"; then
      echo "BLOCKED: Potential hardcoded secret detected in patch content. Use environment variables instead." >&2
      exit 2
    fi
    ;;

  Bash)
    COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
    if printf '%s' "$COMMAND" | grep -qE '(cat|head|tail|less|more)[[:space:]]+~?/?(\.env|\.aws/credentials|\.ssh/id_rsa)'; then
      echo "BLOCKED: Reading sensitive credential files is not allowed." >&2
      exit 2
    fi
    ;;
esac

exit 0
