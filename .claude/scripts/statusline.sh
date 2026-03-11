#!/bin/bash

# Claude Code statusline script with TokyoNight theme
# Receives JSON input via stdin with context information

input=$(cat)

# workarround .git/index.lock issue
GIT_OPTIONAL_LOCKS=0

# Extract values using jq
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
DIR_NAME=${CURRENT_DIR##*/}

# Context window usage
CTX_USED=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
CTX_USED_INT=$(printf "%.0f" "$CTX_USED" 2>/dev/null || echo "0")

# Session cost and code statistics
TOTAL_COST_USD=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Get USD/JPY exchange rate (cached for 24 hours)
CACHE_FILE="$HOME/.claude/usd_jpy_rate.cache"
CACHE_AGE_HOURS=24

if [ -f "$CACHE_FILE" ]; then
  CACHE_AGE=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
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

# Context color: green < 50%, yellow 50-80%, red > 80%
if [ "$CTX_USED_INT" -ge 80 ]; then
  CTX_COLOR="$RED"
elif [ "$CTX_USED_INT" -ge 50 ]; then
  CTX_COLOR="$YELLOW"
else
  CTX_COLOR="$GREEN"
fi

# ── Usage bar helpers (from kamranahmedse/claude-statusline, JST display) ──
color_for_pct() {
  local pct=$1
  if [ "$pct" -ge 90 ]; then printf "$RED"
  elif [ "$pct" -ge 70 ]; then printf "$YELLOW"
  elif [ "$pct" -ge 50 ]; then printf "$YELLOW"
  else printf "$GREEN"
  fi
}

build_bar() {
  local pct=$1
  local width=${2:-10}
  [ "$pct" -lt 0 ] 2>/dev/null && pct=0
  [ "$pct" -gt 100 ] 2>/dev/null && pct=100
  local filled=$(( pct * width / 100 ))
  local empty=$(( width - filled ))
  local bar_color filled_str="" empty_str="" i
  bar_color=$(color_for_pct "$pct")
  for ((i=0; i<filled; i++)); do filled_str+="●"; done
  for ((i=0; i<empty; i++)); do empty_str+="○"; done
  printf "${bar_color}${filled_str}\033[2m${empty_str}${RESET}"
}

iso_to_epoch() {
  # Strip fractional seconds and timezone → parse as UTC
  local stripped="${1%%.*}"
  stripped="${stripped%%Z}"; stripped="${stripped%%+*}"; stripped="${stripped%%-[0-9][0-9]:[0-9][0-9]}"
  date -j -u -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null
}

format_reset_time() {
  local iso_str="$1" style="$2"
  [ -z "$iso_str" ] || [ "$iso_str" = "null" ] && return
  local epoch
  epoch=$(iso_to_epoch "$iso_str")
  [ -z "$epoch" ] && return
  case "$style" in
    time)     TZ=Asia/Tokyo date -j -r "$epoch" +"%H:%M JST" 2>/dev/null ;;
    datetime) local dt; dt=$(TZ=Asia/Tokyo date -j -r "$epoch" +"%b %-d, %H:%M" 2>/dev/null | tr '[:upper:]' '[:lower:]'); printf "%s JST" "$dt" ;;
  esac
}

get_oauth_token() {
  [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ] && echo "$CLAUDE_CODE_OAUTH_TOKEN" && return
  if command -v security >/dev/null 2>&1; then
    local blob token
    blob=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
    token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
    [ -n "$token" ] && [ "$token" != "null" ] && echo "$token" && return
  fi
  local creds="$HOME/.claude/.credentials.json"
  if [ -f "$creds" ]; then
    local token
    token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds" 2>/dev/null)
    [ -n "$token" ] && [ "$token" != "null" ] && echo "$token" && return
  fi
}

# ── Fetch usage data (async background refresh) ─────────────────────────────
USAGE_CACHE="/tmp/claude_statusline_usage.json"
USAGE_LOCK="/tmp/claude_statusline_usage.lock"
USAGE_DATA=""
CACHE_TTL=300  # refresh every 5 minutes

# Always use cached data immediately for display (no blocking)
[ -f "$USAGE_CACHE" ] && USAGE_DATA=$(cat "$USAGE_CACHE" 2>/dev/null)

# Check if background refresh is needed
cache_stale=true
if [ -f "$USAGE_CACHE" ]; then
  cache_mtime=$(stat -f %m "$USAGE_CACHE" 2>/dev/null || stat -c %Y "$USAGE_CACHE" 2>/dev/null)
  cache_age=$(( $(date +%s) - ${cache_mtime:-0} ))
  [ "$cache_age" -lt $CACHE_TTL ] && cache_stale=false
fi

if [ "$cache_stale" = true ]; then
  # Skip if another refresh is in progress (lock expires after 30s)
  lock_ok=true
  if [ -f "$USAGE_LOCK" ]; then
    lock_mtime=$(stat -f %m "$USAGE_LOCK" 2>/dev/null || stat -c %Y "$USAGE_LOCK" 2>/dev/null)
    lock_age=$(( $(date +%s) - ${lock_mtime:-0} ))
    [ "$lock_age" -lt 30 ] && lock_ok=false
  fi
  if [ "$lock_ok" = true ]; then
    token=$(get_oauth_token)
    if [ -n "$token" ]; then
      touch "$USAGE_LOCK"
      (
        response=$(curl -s --max-time 10 \
          -H "Accept: application/json" \
          -H "Content-Type: application/json" \
          -H "Authorization: Bearer $token" \
          -H "anthropic-beta: oauth-2025-04-20" \
          -H "User-Agent: claude-code/2.1.34" \
          "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
        if echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
          mkdir -p "$(dirname "$USAGE_CACHE")"
          echo "$response" > "$USAGE_CACHE"
        fi
        rm -f "$USAGE_LOCK"
      ) &
      disown
    fi
  fi
fi

# ── Check if we're in a git repository
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
    printf "🤖 ${GREEN}$MODEL${RESET} ${GRAY}|${RESET} ${CYAN}👻 $DIR_NAME${RESET} ${GRAY}|${RESET} 🚀 ${PURPLE}$BRANCH${RESET}: ${YELLOW}${FILES_CHANGED:-0} changed${RESET}, ${GREEN}+${INSERTIONS:-0}${RESET} ${RED}-${DELETIONS:-0}${RESET}, ${YELLOW}${STAGED_FILES:-0} staged${RESET}, ${YELLOW}$UNTRACKED untracked${RESET} ${GRAY}|${RESET} ${CTX_COLOR}⚡ ${CTX_USED_INT}%%${RESET} ${GRAY}|${RESET} ${YELLOW}💰 ¥${TOTAL_COST_JPY}${RESET} ${GRAY}|${RESET} 🍣 ${GREEN}+${LINES_ADDED}${RESET} ${RED}-${LINES_REMOVED}${RESET}"
  else
    # Clean working tree
    printf "🤖 ${GREEN}$MODEL${RESET} ${GRAY}|${RESET} ${CYAN}👻 $DIR_NAME${RESET} ${GRAY}|${RESET} 🚀 ${PURPLE}$BRANCH${RESET}: ${GREEN}✓ Clean${RESET} ${GRAY}|${RESET} ${CTX_COLOR}⚡ ${CTX_USED_INT}%%${RESET} ${GRAY}|${RESET} ${YELLOW}💰 ¥${TOTAL_COST_JPY}${RESET} ${GRAY}|${RESET} 🍣 ${GREEN}+${LINES_ADDED}${RESET} ${RED}-${LINES_REMOVED}${RESET}"
  fi
else
  # Not a git repository
  printf "🤖 ${GREEN}$MODEL${RESET} ${GRAY}|${RESET} ${CYAN}👻 $DIR_NAME${RESET} ${GRAY}|${RESET} 🚀 ${GRAY}Not a Repo${RESET} ${GRAY}|${RESET} ${CTX_COLOR}⚡ ${CTX_USED_INT}%%${RESET} ${GRAY}|${RESET} ${YELLOW}💰 ¥${TOTAL_COST_JPY}${RESET} ${GRAY}|${RESET} 🍣 ${GREEN}+${LINES_ADDED}${RESET} ${RED}-${LINES_REMOVED}${RESET}"
fi

# ── Usage rate limit bars ────────────────────────────────────────────────────
if [ -n "$USAGE_DATA" ] && echo "$USAGE_DATA" | jq -e '.five_hour' >/dev/null 2>&1; then
  five_pct=$(echo "$USAGE_DATA" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
  five_reset=$(format_reset_time "$(echo "$USAGE_DATA" | jq -r '.five_hour.resets_at // empty')" "time")
  five_bar=$(build_bar "$five_pct" 10)
  five_color=$(color_for_pct "$five_pct")

  seven_pct=$(echo "$USAGE_DATA" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
  seven_reset=$(format_reset_time "$(echo "$USAGE_DATA" | jq -r '.seven_day.resets_at // empty')" "datetime")
  seven_bar=$(build_bar "$seven_pct" 10)
  seven_color=$(color_for_pct "$seven_pct")

  printf "\n${GRAY}current${RESET} ${five_bar} ${five_color}$(printf '%3d' "$five_pct")%%${RESET} \033[2m⟳\033[0m ${GRAY}${five_reset}${RESET}"
  printf "\n${GRAY}weekly${RESET}  ${seven_bar} ${seven_color}$(printf '%3d' "$seven_pct")%%${RESET} \033[2m⟳\033[0m ${GRAY}${seven_reset}${RESET}"

  extra_enabled=$(echo "$USAGE_DATA" | jq -r '.extra_usage.is_enabled // false')
  if [ "$extra_enabled" = "true" ]; then
    extra_pct=$(echo "$USAGE_DATA" | jq -r '.extra_usage.utilization // 0' | awk '{printf "%.0f", $1}')
    extra_used=$(echo "$USAGE_DATA" | jq -r '.extra_usage.used_credits // 0' | awk '{printf "%.2f", $1/100}')
    extra_limit=$(echo "$USAGE_DATA" | jq -r '.extra_usage.monthly_limit // 0' | awk '{printf "%.2f", $1/100}')
    extra_bar=$(build_bar "$extra_pct" 10)
    extra_color=$(color_for_pct "$extra_pct")
    printf "\n${GRAY}extra${RESET}   ${extra_bar} ${extra_color}\$${extra_used}\033[2m/\033[0m${GRAY}\$${extra_limit}${RESET}"
  fi
fi
