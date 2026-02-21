#!/bin/bash
set -euo pipefail

# Usage: merge.sh <agent-1> <agent-2> ...
# Merges each agent's swarm branch into the current branch

if [ $# -eq 0 ]; then
  echo "Usage: $0 <agent-1> [agent-2] ..." >&2
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
AGENTS=("$@")

echo "Merging swarm branches..."

for agent in "${AGENTS[@]}"; do
  branch_name="swarm/$agent"
  echo "  Merging $branch_name..."

  if ! git -C "$REPO_ROOT" merge --no-ff "$branch_name" -m "chore: merge $branch_name results"; then
    echo "Error: Conflict detected while merging $branch_name" >&2
    echo "Resolve conflicts manually, then re-run this script for remaining agents." >&2
    exit 1
  fi

  echo "  Merged $branch_name successfully."
done

echo "All branches merged."
