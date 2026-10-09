#!/bin/bash
# PostToolUse hook: format and lint the files an edit just touched, and feed
# failures back to the agent. Formatters fix in place; linters only report.
#
# Shared by Claude Code and Codex. Union of both tool vocabularies:
#   Write / Edit  — Claude Code, path in .tool_input.file_path
#   apply_patch   — Codex, paths parsed from the patch text in .tool_input.command
#
# Stderr from an exit-0 hook never reaches the agent, so failures go out on
# stdout as {"decision":"block","reason":...}, which both agents show next to
# the tool result. A missing tool or a project without a linter config is
# skipped silently, so this works in any repository.
set -uo pipefail

# Drain stdin before any early exit so the caller never sees a broken pipe.
INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // ""')

edited_files() {
  case "$TOOL_NAME" in
    Write|Edit)
      printf '%s\n' "$INPUT" | jq -r '.tool_input.file_path // ""'
      ;;
    apply_patch)
      printf '%s' "$INPUT" | jq -r '.tool_input.command // ""' \
        | sed -nE 's/^\*\*\* (Add|Update) File: (.*)$/\2/p'
      ;;
  esac
}

has() { command -v "$1" >/dev/null 2>&1; }

# Print the nearest directory from $1 upward that contains one of the given names.
find_up() {
  local dir="$1" name
  shift
  while [ -n "$dir" ] && [ "$dir" != "/" ]; do
    for name in "$@"; do
      if [ -e "$dir/$name" ]; then
        printf '%s' "$dir"
        return 0
      fi
    done
    dir=$(dirname "$dir")
  done
  return 1
}

# Exit non-zero with the findings on stdout/stderr when the file needs attention.
check_file() {
  local f="$1" root
  case "$f" in
    *.sh|*.bash)
      has shellcheck || return 0
      shellcheck -S warning -f gcc "$f"
      ;;
    *.tf|*.tfvars)
      has terraform || return 0
      terraform fmt -no-color -list=false "$f"
      ;;
    *.go)
      has gofmt || return 0
      gofmt -w "$f"
      ;;
    *.py)
      has ruff || return 0
      ruff check --quiet "$f"
      ;;
    *.ts|*.tsx|*.mts|*.cts)
      # ponytail: looks for the linter next to its config only; monorepos that
      # hoist node_modules above the config need a wider search.
      if root=$(find_up "$(dirname "$f")" biome.json biome.jsonc) \
        && [ -x "$root/node_modules/.bin/biome" ]; then
        "$root/node_modules/.bin/biome" lint "$f"
      elif root=$(find_up "$(dirname "$f")" eslint.config.js eslint.config.mjs eslint.config.cjs eslint.config.ts eslint.config.mts eslint.config.cts) \
        && [ -x "$root/node_modules/.bin/eslint" ]; then
        (cd "$root" && node_modules/.bin/eslint "$f")
      fi
      ;;
  esac
}

REPORT=""
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in
    /*) ;;
    *) [ -n "$CWD" ] && f="$CWD/$f" ;;
  esac
  [ -f "$f" ] || continue
  if ! out=$(check_file "$f" 2>&1); then
    REPORT+="== $f"$'\n'"$out"$'\n'
  fi
done < <(edited_files)

[ -n "$REPORT" ] || exit 0

# Cap the output so a noisy linter does not flood the agent's context.
REASON="[quality-check] fix these before continuing:"$'\n'"$(printf '%s' "$REPORT" | head -n 40)"
jq -n --arg r "$REASON" '{decision: "block", reason: $r}'
exit 0
