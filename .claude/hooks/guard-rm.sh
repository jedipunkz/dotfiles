#!/bin/bash
# PreToolUse hook: guard rm commands
#
# Policy:
#   BLOCK  — any rm with recursive (-r/-R/--recursive) or force (-f/-F/--force) flags
#   PASS   — plain rm without dangerous flags (normal permission flow will ask user)
#
# Why a hook instead of deny rules only:
#   deny rules do prefix matching. "Bash(rm -rf:*)" misses "rm -fr", "rm -Rf",
#   "rm -rn", "rm --recursive", etc. A hook catches all flag-order variations.

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
[ "$TOOL_NAME" != "Bash" ] && exit 0

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Strip quoted strings first to avoid false positives from commit messages like:
#   git commit -m "remove the rm -rf call"
# After stripping, split on ; & | and check each segment individually.
# Only a segment whose FIRST token is "rm" is evaluated.
STRIPPED=$(echo "$COMMAND" | sed "s/'[^']*'//g" | sed 's/"[^"]*"//g')

while IFS= read -r segment; do
  segment="${segment#"${segment%%[![:space:]]*}"}"  # trim leading whitespace
  [ -z "$segment" ] && continue

  # Only proceed if this segment starts with "rm" as a command
  echo "$segment" | grep -qE '^rm[[:space:]]' || continue

  # Block if rm has any dangerous flag:
  #   -r / -R  recursive  |  -f / -F  force  |  combined e.g. -fr -Rf -rn
  #   --recursive / --force  long-form equivalents
  if echo "$segment" | grep -qE '^rm[[:space:]].*-[a-zA-Z]*[rRfF]' || \
     echo "$segment" | grep -qE '^rm[[:space:]].*(--recursive|--force)'; then
    echo "BLOCKED: rm with recursive or force flags is not allowed." >&2
    echo "  Use plain 'rm <file>' instead — Claude will ask for your approval first." >&2
    exit 2
  fi
done < <(echo "$STRIPPED" | tr ';&|' '\n')

# Plain rm (no dangerous flags) — exit 0 so normal permission flow prompts user
exit 0
