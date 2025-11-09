#!/bin/bash

# Claude Code statusline script with TokyoNight theme
# Receives JSON input via stdin with context information

input=$(cat)

# Extract values using jq
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
DIR_NAME=${CURRENT_DIR##*/}

# Session cost and code statistics
TOTAL_COST_USD=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Get USD/JPY exchange rate (cached for 24 hours)
CACHE_FILE="$HOME/.claude/usd_jpy_rate.cache"
CACHE_AGE_HOURS=24

if [ -f "$CACHE_FILE" ]; then
  CACHE_AGE=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null)))
  CACHE_AGE_HOURS_ACTUAL=$((CACHE_AGE / 3600))
else
  CACHE_AGE_HOURS_ACTUAL=999
fi

if [ $CACHE_AGE_HOURS_ACTUAL -ge $CACHE_AGE_HOURS ]; then
  # Fetch new rate
  USD_JPY=$(curl -s --max-time 2 "https://open.er-api.com/v6/latest/USD" 2>/dev/null | jq -r '.rates.JPY // empty')
  if [ -n "$USD_JPY" ] && [ "$USD_JPY" != "null" ]; then
    echo "$USD_JPY" > "$CACHE_FILE"
  else
    USD_JPY=150  # Fallback rate
  fi
else
  # Use cached rate
  USD_JPY=$(cat "$CACHE_FILE" 2>/dev/null || echo 150)
fi

# Calculate cost in JPY
TOTAL_COST_JPY=$(echo "$TOTAL_COST_USD * $USD_JPY" | bc 2>/dev/null || echo "0")
TOTAL_COST_JPY=$(printf "%.0f" "$TOTAL_COST_JPY" 2>/dev/null || echo "0")

# TokyoNight color palette (RGB ANSI codes)
PURPLE='\033[38;2;187;154;247m'   # #bb9af7 - Purple for model
CYAN='\033[38;2;125;207;255m'     # #7dcfff - Cyan for directory
BLUE='\033[38;2;122;162;247m'     # #7aa2f7 - Blue for branch
GREEN='\033[38;2;115;218;202m'    # #73daca - Green for success/additions
YELLOW='\033[38;2;224;175;104m'   # #e0af68 - Yellow for changes
RED='\033[38;2;247;118;142m'      # #f7768e - Red for deletions
GRAY='\033[38;2;86;95;137m'       # #565f89 - Gray for separators
RESET='\033[0m'

# Check if we're in a git repository
if [ -d "$CURRENT_DIR/.git" ]; then
  cd "$CURRENT_DIR" || exit

  # Get current branch
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  # Get git stats
  GIT_STATUS=$(git diff --stat 2>/dev/null)
  STAGED_STATUS=$(git diff --cached --stat 2>/dev/null)
  UNTRACKED=$(git status --porcelain 2>/dev/null | grep -c '^??' 2>/dev/null || true)
  UNTRACKED=${UNTRACKED:-0}

  # Check if there are any changes
  if [ -n "$GIT_STATUS" ] || [ -n "$STAGED_STATUS" ] || [ "$UNTRACKED" -gt 0 ]; then
    # Parse changes
    INSERTIONS=0
    DELETIONS=0
    FILES_CHANGED=0

    if [ -n "$GIT_STATUS" ]; then
      INSERTIONS=$(echo "$GIT_STATUS" | tail -1 | grep -o '[0-9]\+ insertion' | cut -d' ' -f1 || echo 0)
      DELETIONS=$(echo "$GIT_STATUS" | tail -1 | grep -o '[0-9]\+ deletion' | cut -d' ' -f1 || echo 0)
      FILES_CHANGED=$(echo "$GIT_STATUS" | tail -1 | grep -o '[0-9]\+ file' | cut -d' ' -f1 || echo 0)
    fi

    STAGED_FILES=0
    if [ -n "$STAGED_STATUS" ]; then
      STAGED_FILES=$(echo "$STAGED_STATUS" | tail -1 | grep -o '[0-9]\+ file' | cut -d' ' -f1 || echo 0)
    fi

    # Output with changes
    printf "${PURPLE}[$MODEL]${RESET} ${CYAN}📁 $DIR_NAME${RESET} ${GRAY}|${RESET} Git ${BLUE}[$BRANCH]${RESET}: ${YELLOW}${FILES_CHANGED:-0} changed${RESET}, ${GREEN}+${INSERTIONS:-0}${RESET} ${RED}-${DELETIONS:-0}${RESET}, ${YELLOW}${STAGED_FILES:-0} staged${RESET}, ${YELLOW}$UNTRACKED untracked${RESET} ${GRAY}|${RESET} ${YELLOW}💰 ¥${TOTAL_COST_JPY}${RESET} ${GRAY}|${RESET} 📝 ${GREEN}+${LINES_ADDED}${RESET} ${RED}-${LINES_REMOVED}${RESET}\n"
  else
    # Clean working tree
    printf "${PURPLE}[$MODEL]${RESET} ${CYAN}📁 $DIR_NAME${RESET} ${GRAY}|${RESET} Git ${BLUE}[$BRANCH]${RESET}: ${GREEN}✓ Clean${RESET} ${GRAY}|${RESET} ${YELLOW}💰 ¥${TOTAL_COST_JPY}${RESET} ${GRAY}|${RESET} 📝 ${GREEN}+${LINES_ADDED}${RESET} ${RED}-${LINES_REMOVED}${RESET}\n"
  fi
else
  # Not a git repository
  printf "${PURPLE}[$MODEL]${RESET} ${CYAN}📁 $DIR_NAME${RESET} ${GRAY}|${RESET} Git: ${GRAY}Not a repository${RESET} ${GRAY}|${RESET} ${YELLOW}💰 ¥${TOTAL_COST_JPY}${RESET} ${GRAY}|${RESET} 📝 ${GREEN}+${LINES_ADDED}${RESET} ${RED}-${LINES_REMOVED}${RESET}\n"
fi
