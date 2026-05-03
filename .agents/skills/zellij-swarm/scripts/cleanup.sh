#!/bin/bash
set -euo pipefail

# Usage: cleanup.sh [--force] <agent-1> <agent-2> ...
# Removes worktrees and swarm branches for each agent
# --force: use force removal (for interrupted/broken worktrees)

FORCE=false
if [ "${1:-}" = "--force" ]; then
  FORCE=true
  shift
fi

if [ $# -eq 0 ]; then
  echo "Usage: $0 [--force] <agent-1> [agent-2] ..." >&2
  echo "  --force: force removal of worktrees and branches" >&2
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
AGENTS=("$@")

echo "Cleaning up swarm worktrees and branches..."

for agent in "${AGENTS[@]}"; do
  worktree_path=".gitworktree/$agent"
  branch_name="swarm/$agent"

  if $FORCE; then
    git -C "$REPO_ROOT" worktree remove --force "$worktree_path" 2>/dev/null || true
    git -C "$REPO_ROOT" branch -D "$branch_name" 2>/dev/null || true
  else
    git -C "$REPO_ROOT" worktree remove "$worktree_path" 2>/dev/null || true
    git -C "$REPO_ROOT" branch -d "$branch_name" 2>/dev/null || true
  fi

  echo "  Removed: $agent"
done

rmdir "$REPO_ROOT/.gitworktree" 2>/dev/null || true

echo "Cleanup complete."
