#!/bin/bash
# PostToolUse hook: run shellcheck on modified shell scripts
# Reads JSON from stdin: {"tool_name": "Write"|"Edit", "tool_input": {"file_path": "..."}, ...}
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

case "$TOOL_NAME" in
  Write|Edit)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
    # Run shellcheck on shell scripts if available
    if echo "$FILE_PATH" | grep -qE "\.(sh|bash)$"; then
      if command -v shellcheck >/dev/null 2>&1; then
        if ! shellcheck -S warning "$FILE_PATH" 2>&1; then
          echo "[lint-check] shellcheck found issues in $FILE_PATH" >&2
          # Exit 0 to allow (just warn), not block
        fi
      fi
    fi
    ;;
esac
exit 0