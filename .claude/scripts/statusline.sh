#!/bin/bash

# Claude Code statusline script with TokyoNight theme
# Receives JSON input via stdin with context information

input=$(cat)

# Prevent opportunistic locking by background git operations (avoids stale .git/index.lock)
export GIT_OPTIONAL_LOCKS=0

# Extract values using jq
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
# Reasoning effort level (low/medium/high/xhigh/max); absent when model lacks effort support
EFFORT=$(echo "$input" | jq -r '.effort.level // empty')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
DIR_NAME=${CURRENT_DIR##*/}

# Worktree name: git_worktree covers any linked worktree, worktree.name only --worktree sessions
WORKTREE=$(echo "$input" | jq -r '.workspace.git_worktree // .worktree.name // empty')

# Open PR for the current branch; absent until one is found
PR_NUMBER=$(echo "$input" | jq -r '.pr.number // empty')
PR_REVIEW=$(echo "$input" | jq -r '.pr.review_state // empty')

# Context window usage
CTX_USED=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
CTX_USED_INT=$(printf "%.0f" "$CTX_USED" 2>/dev/null || echo "0")

# Session cost and code statistics
TOTAL_COST_USD=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Rate limits (Claude.ai subscribers only, populated after the first API response).
# resets_at is Unix epoch seconds.
FIVE_PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
FIVE_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
SEVEN_PCT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
SEVEN_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

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

# Effort segment: color by level, shown to the right of the model name
if [ -n "$EFFORT" ]; then
  case "$EFFORT" in
    max|xhigh) EFFORT_COLOR="$RED" ;;
    high)      EFFORT_COLOR="$YELLOW" ;;
    *)         EFFORT_COLOR="$GREEN" ;;
  esac
  EFFORT_SEG=" ${EFFORT_COLOR}🧠 ${EFFORT}${RESET}"
else
  EFFORT_SEG=""
fi

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

format_reset_time() {
  local epoch="$1" style="$2"
  [ -z "$epoch" ] && return
  case "$style" in
    time)     TZ=Asia/Tokyo date -j -r "$epoch" +"%H:%M JST" 2>/dev/null ;;
    datetime) local dt; dt=$(TZ=Asia/Tokyo date -j -r "$epoch" +"%b %-d, %H:%M" 2>/dev/null | tr '[:upper:]' '[:lower:]'); printf "%s JST" "$dt" ;;
  esac
}

# Pace delta: usage % vs elapsed % of the window. ⇡ = burning faster than the
# window refills, ⇣ = headroom. Result is assigned (not printed) so the doubled
# %% survives until the caller's printf renders it as a single %.
pace_seg() {
  local pct=$1 resets_at=$2 window=$3
  PACE_SEG=""
  [ -z "$resets_at" ] && return
  local elapsed=$(( (window - (resets_at - $(date +%s))) * 100 / window ))
  [ "$elapsed" -lt 0 ] && elapsed=0
  [ "$elapsed" -gt 100 ] && elapsed=100
  local delta=$(( pct - elapsed ))
  if [ "$delta" -gt 0 ]; then
    PACE_SEG=" ${RED}⇡${delta}%%${RESET}"
  else
    PACE_SEG=" ${GREEN}⇣$(( -delta ))%%${RESET}"
  fi
}

# ── Worktree and PR segments ─────────────────────────────────────────────────
WORKTREE_SEG=""
[ -n "$WORKTREE" ] && WORKTREE_SEG=" ${GRAY}|${RESET} ${BLUE}🌿 $WORKTREE${RESET}"

PR_SEG=""
if [ -n "$PR_NUMBER" ]; then
  case "$PR_REVIEW" in
    approved)          PR_COLOR="$GREEN"; PR_MARK="✓" ;;
    changes_requested) PR_COLOR="$RED";   PR_MARK="✗" ;;
    draft)             PR_COLOR="$GRAY";  PR_MARK="○" ;;
    *)                 PR_COLOR="$YELLOW"; PR_MARK="•" ;;
  esac
  PR_SEG=" ${GRAY}|${RESET} ${PR_COLOR}⑂ #${PR_NUMBER} ${PR_MARK}${RESET}"
fi

# ── Git status ───────────────────────────────────────────────────────────────
# rev-parse (not `-d .git`) so linked worktrees, where .git is a file, are detected
if git -C "$CURRENT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH=$(git -C "$CURRENT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
  BRANCH_SEG="${PURPLE}$BRANCH${RESET}"

  GIT_STATUS=$(git -C "$CURRENT_DIR" diff --stat 2>/dev/null)
  STAGED_STATUS=$(git -C "$CURRENT_DIR" diff --cached --stat 2>/dev/null)
  UNTRACKED=$(git -C "$CURRENT_DIR" status --porcelain 2>/dev/null | grep -c '^??' 2>/dev/null || true)
  UNTRACKED=${UNTRACKED:-0}

  if [ -n "$GIT_STATUS" ] || [ -n "$STAGED_STATUS" ] || [ "$UNTRACKED" -gt 0 ]; then
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

    DIFF_SEG="${YELLOW}${FILES_CHANGED:-0} changed${RESET}, ${GREEN}+${INSERTIONS:-0}${RESET} ${RED}-${DELETIONS:-0}${RESET}, ${YELLOW}${STAGED_FILES:-0} staged${RESET}, ${YELLOW}$UNTRACKED untracked${RESET} ${GRAY}|${RESET} "
  else
    DIFF_SEG="${GREEN}✓ Clean${RESET} ${GRAY}|${RESET} "
  fi
else
  BRANCH_SEG="${GRAY}Not a Repo${RESET}"
  DIFF_SEG=""
fi

printf "🤖 ${GREEN}$MODEL${RESET}${EFFORT_SEG} ${GRAY}|${RESET} ${CYAN}👻 $DIR_NAME${RESET} ${GRAY}|${RESET} 🚀 ${BRANCH_SEG}${WORKTREE_SEG}${PR_SEG}\n${DIFF_SEG}${CTX_COLOR}⚡ ${CTX_USED_INT}%%${RESET} ${GRAY}|${RESET} ${YELLOW}💰 ¥${TOTAL_COST_JPY}${RESET} ${GRAY}|${RESET} 🍣 ${GREEN}+${LINES_ADDED}${RESET} ${RED}-${LINES_REMOVED}${RESET}"

# ── Usage rate limit bars ────────────────────────────────────────────────────
# Assigns WINDOW_SEG. Each window may be absent independently (and the whole
# rate_limits object is absent for API-key users and before the first API response).
window_seg() {
  local label=$1 pct=$2 resets_at=$3 window=$4 style=$5
  if [ -z "$pct" ]; then
    WINDOW_SEG="${GRAY}${label}${RESET} ${GRAY}○○○○○○○○○○${RESET} ${GRAY}---%%${RESET}"
    return
  fi
  pct=$(printf "%.0f" "$pct")
  pace_seg "$pct" "$resets_at" "$window"
  WINDOW_SEG="${GRAY}${label}${RESET} $(build_bar "$pct" 10) $(color_for_pct "$pct")$(printf '%3d' "$pct")%%${RESET}${PACE_SEG} \033[2m⟳\033[0m ${GRAY}$(format_reset_time "$resets_at" "$style")${RESET}"
}

window_seg "current" "$FIVE_PCT" "$FIVE_RESET" 18000 "time"        # 5 hours
five_seg="$WINDOW_SEG"
window_seg "weekly" "$SEVEN_PCT" "$SEVEN_RESET" 604800 "datetime"  # 7 days

printf "\n${five_seg} ${GRAY}|${RESET} ${WINDOW_SEG}"
