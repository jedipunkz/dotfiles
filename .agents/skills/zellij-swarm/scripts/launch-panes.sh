#!/bin/bash
set -euo pipefail

# Usage: launch-panes.sh <agent-1> <agent-2> ...
# Launches Zellij panes for each agent, running .swarm-start.sh in their worktree

if [ $# -eq 0 ]; then
  echo "Usage: $0 <agent-1> [agent-2] ..." >&2
  exit 1
fi

if [ -z "${ZELLIJ:-}" ]; then
  echo "Error: Not running inside a Zellij session" >&2
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
AGENTS=("$@")

for agent in "${AGENTS[@]}"; do
  worktree_path="$REPO_ROOT/.gitworktree/$agent"

  if [ ! -d "$worktree_path" ]; then
    echo "Error: Worktree not found at $worktree_path" >&2
    exit 1
  fi

  chmod +x "$worktree_path/.swarm-start.sh"
  zellij action new-pane \
    --name "swarm:$agent" \
    --cwd "$worktree_path" \
    -- bash .swarm-start.sh

  echo "  Launched pane: swarm:$agent"
done

echo "All panes launched."
