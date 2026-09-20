#!/bin/bash
# PostToolUse hook: run shellcheck on modified shell scripts (warn only, never blocks)
#
# Shared by Claude Code and Codex. Union of both tool vocabularies:
#   Write / Edit  — Claude Code, path in .tool_input.file_path
#   apply_patch   — Codex, no path field, so fall back to the git working-tree diff
set -uo pipefail

# Drain stdin before any early exit so the caller never sees a broken pipe.
INPUT=$(cat)
command -v shellcheck >/dev/null 2>&1 || exit 0

TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')

case "$TOOL_NAME" in
  Write|Edit)
    FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
    printf '%s' "$FILE_PATH" | grep -qE '\.(sh|bash)$' || exit 0
    [ -f "$FILE_PATH" ] || exit 0
    if ! shellcheck -S warning "$FILE_PATH" 2>&1; then
      echo "[lint-check] shellcheck found issues in $FILE_PATH" >&2
    fi
    ;;

  apply_patch)
    CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // ""')
    [ -n "$CWD" ] || exit 0
    GIT_ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null || true)
    [ -n "$GIT_ROOT" ] || exit 0

    git -C "$GIT_ROOT" diff --name-only -- '*.sh' '*.bash' | while IFS= read -r file; do
      [ -n "$file" ] || continue
      [ -f "$GIT_ROOT/$file" ] || continue
      if ! shellcheck -S warning "$GIT_ROOT/$file" 2>&1; then
        echo "[lint-check] shellcheck found issues in $file" >&2
      fi
    done
    ;;
esac

exit 0
