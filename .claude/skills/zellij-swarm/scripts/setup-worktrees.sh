#!/bin/bash
set -euo pipefail

# Usage: setup-worktrees.sh <agent-1> <agent-2> ...
# Creates git worktrees for each agent under .gitworktree/

if [ $# -eq 0 ]; then
  echo "Usage: $0 <agent-1> [agent-2] ..." >&2
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
BRANCH_BASE=$(git rev-parse --abbrev-ref HEAD)
AGENTS=("$@")

echo "Setting up worktrees (base branch: $BRANCH_BASE)"

for agent in "${AGENTS[@]}"; do
  worktree_path="$REPO_ROOT/.gitworktree/$agent"
  branch_name="swarm/$agent"

  if [ -d "$worktree_path" ]; then
    echo "  Skipping $agent: worktree already exists at $worktree_path"
    continue
  fi

  git -C "$REPO_ROOT" worktree add "$worktree_path" -b "$branch_name"
  echo "  Created worktree: $agent ($branch_name)"
done

echo "Done. Worktrees ready under $REPO_ROOT/.gitworktree/"
