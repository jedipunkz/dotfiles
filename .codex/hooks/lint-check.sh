#!/bin/bash
set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')
[ "$TOOL_NAME" = "apply_patch" ] || exit 0

command -v shellcheck >/dev/null 2>&1 || exit 0

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

exit 0
