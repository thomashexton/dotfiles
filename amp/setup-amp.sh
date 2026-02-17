#!/usr/bin/env bash
# Merge personal Amp preferences on top of the devbox template config.
# The template provides ~/.config/amp/settings.json with MCP server config;
# this script adds personal overrides without clobbering it.

set -euo pipefail

SETTINGS="$HOME/.config/amp/settings.json"
OVERRIDES="$(dirname "$0")/.config/amp/settings.overrides.json"

if [[ ! -f "$OVERRIDES" ]]; then
  return 0 2>/dev/null || exit 0
fi

if [[ -f "$SETTINGS" ]]; then
  # Merge: overrides win over existing settings
  tmp=$(mktemp)
  jq -s '.[0] * .[1]' "$SETTINGS" "$OVERRIDES" > "$tmp" && mv "$tmp" "$SETTINGS"
else
  cp "$OVERRIDES" "$SETTINGS"
fi
