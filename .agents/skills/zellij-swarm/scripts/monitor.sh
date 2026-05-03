#!/bin/bash
set -euo pipefail

# Usage: monitor.sh <agent-1> <agent-2> ...
# Polls .swarm-status files every 30s, exits when all agents are done

if [ $# -eq 0 ]; then
  echo "Usage: $0 <agent-1> [agent-2] ..." >&2
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
AGENTS=("$@")

while true; do
  clear
  echo "=== Swarm Status $(date '+%H:%M:%S') ==="
  all_done=true

  for agent in "${AGENTS[@]}"; do
    status_file="$REPO_ROOT/.gitworktree/$agent/.swarm-status"
    if [ -f "$status_file" ]; then
      echo "✓ $agent: $(cat "$status_file")"
    else
      echo "… $agent: in progress"
      git -C "$REPO_ROOT/.gitworktree/$agent" log --oneline -3 2>/dev/null || true
      all_done=false
    fi
  done

  if $all_done; then
    echo ""
    echo "All agents done!"
    break
  fi

  echo ""
  echo "Next check in 30s... (Ctrl+C to stop)"
  sleep 30
done
