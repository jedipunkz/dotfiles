#!/bin/bash

# Claude Code subagent row renderer (subagentStatusLine) with TokyoNight theme
# Receives {"columns":N,"tasks":[...]} via stdin and prints one {"id","content"} JSON line per row

# TokyoNight color palette, same as statusline.sh
PURPLE=$'\033[38;2;187;154;247m'
GREEN=$'\033[38;2;115;218;202m'
YELLOW=$'\033[38;2;224;175;104m'
RED=$'\033[38;2;247;118;142m'
GRAY=$'\033[38;2;86;95;137m'
RESET=$'\033[0m'

jq -c --arg purple "$PURPLE" --arg green "$GREEN" --arg yellow "$YELLOW" \
  --arg red "$RED" --arg gray "$GRAY" --arg reset "$RESET" '
  def short: if . >= 1000 then "\((. / 100 | floor) / 10)k" else tostring end;
  .tasks[]
  | .tokenCount //= 0
  # Context color: green < 50%, yellow 50-80%, red > 80%; contextWindowSize is absent until the model resolves
  | (if .contextWindowSize > 0 then (.tokenCount * 100 / .contextWindowSize | floor) else null end) as $pct
  | (if $pct == null or $pct < 50 then $green elif $pct < 80 then $yellow else $red end) as $ctx
  | (if .status == "running" then "\($yellow)●"
     elif .status == "completed" then "\($green)✓"
     else "\($red)✗" end) as $mark
  | {id, content: "\($mark)\($reset) \($purple)\(.agentType // .type)\($reset) \($gray)·\($reset) \(.label) \($gray)·\($reset) \($ctx)⚡ \(.tokenCount | short)\(if $pct then " (\($pct)%)" else "" end)\($reset)"}
'
