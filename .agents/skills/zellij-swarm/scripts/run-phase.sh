#!/bin/bash
set -euo pipefail

# Usage: run-phase.sh <agent-1> [agent-2] ...
# Blocks until all agents in the phase complete, then merges and cleans up.
# Prerequisite: worktrees must be set up and panes must be launched.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -eq 0 ]; then
  echo "Usage: $0 <agent-1> [agent-2] ..." >&2
  exit 1
fi

AGENTS=("$@")

echo "=== Phase [${AGENTS[*]}] starting ==="
echo ""

"$SCRIPT_DIR/monitor.sh" "${AGENTS[@]}"

echo ""
echo "Merging phase branches..."
"$SCRIPT_DIR/merge.sh" "${AGENTS[@]}"

echo ""
echo "Cleaning up phase worktrees..."
"$SCRIPT_DIR/cleanup.sh" "${AGENTS[@]}"

echo ""
echo "=== Phase [${AGENTS[*]}] complete ==="
