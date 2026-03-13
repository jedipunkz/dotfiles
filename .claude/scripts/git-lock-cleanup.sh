#!/bin/bash
# PreToolUse hook: Remove stale .git/index.lock before git commands
#
# Claude Code polls git status internally and sometimes leaves stale lock files
# that block user git commands. This hook cleans them up automatically.
# See: https://github.com/anthropics/claude-code/issues/11005

# Read tool input JSON from stdin (required to avoid blocking the pipe)
input=$(cat)

# Extract the command string
if command -v jq &>/dev/null; then
    cmd=$(echo "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
else
    cmd=$(echo "$input" | grep -o '"command" *: *"[^"]*"' | sed 's/.*: *"//;s/"//')
fi

# Only proceed for git commands
echo "$cmd" | grep -qE '^\s*git\s' || exit 0

# Walk up from PWD to find .git/index.lock
dir="$PWD"
lock_file=""
while [ "$dir" != "/" ]; do
    if [ -f "$dir/.git/index.lock" ]; then
        lock_file="$dir/.git/index.lock"
        break
    fi
    dir="$(dirname "$dir")"
done

[ -z "$lock_file" ] && exit 0

# Remove lock only if no git process is currently running
if ! pgrep -x "git" >/dev/null 2>&1; then
    rm -f "$lock_file"
fi

exit 0
