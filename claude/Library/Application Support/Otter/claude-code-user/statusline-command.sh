#!/bin/bash
# Read JSON data that Claude Code sends to stdin
input=$(cat)

# Colors
RST='\033[0m'
BOLD='\033[1m'
CYAN='\033[36m'
BLUE='\033[34m'
MAGENTA='\033[35m'
GREEN='\033[32m'
YELLOW='\033[33m'
ORANGE='\033[38;5;208m'
RED='\033[31m'
DIM='\033[2m'

# Extract fields using jq
MODEL=$(echo "$input" | jq -r '.model.display_name' | sed 's/.*claude-//; s/-v[0-9].*//; s/-[0-9]\{8,\}//' | awk -F'-' '{name=toupper(substr($1,1,1)) substr($1,2); ver=""; for(i=2;i<=NF;i++) ver=(ver=="")?$i:ver"."$i; print name (ver==""?"":" "ver)}')
DIR=$(echo "$input" | jq -r '.workspace.project_dir // .cwd')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0' | xargs printf '%.2f')

# Get git branch
BRANCH=$(git -C "$DIR" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

# Context color based on usage
if [ "$PCT" -ge 80 ]; then
  CTX_COLOR=$RED
elif [ "$PCT" -ge 60 ]; then
  CTX_COLOR=$ORANGE
elif [ "$PCT" -ge 40 ]; then
  CTX_COLOR=$YELLOW
else
  CTX_COLOR=$GREEN
fi

# Build parts
MODEL_PART="${BOLD}${CYAN}[${MODEL}]${RST}"
DIR_SHORT="${DIR/#$HOME/\~}"
DIR_PART="${BLUE}${DIR_SHORT}${RST}"
BRANCH_PART=""
[ -n "$BRANCH" ] && BRANCH_PART=" ${DIM}|${RST} ${MAGENTA}${BRANCH}${RST}"
CTX_PART="${CTX_COLOR}${PCT}% ctx${RST}"
COST_PART="${DIM}\$${COST}${RST}"

printf "%b %b%b ${DIM}|${RST} %b ${DIM}|${RST} %b" "$MODEL_PART" "$DIR_PART" "$BRANCH_PART" "$CTX_PART" "$COST_PART"
