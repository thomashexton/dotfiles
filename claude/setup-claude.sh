#!/usr/bin/env bash
# Merge personal Claude CLI preferences on top of existing settings.
# This preserves machine-specific config (API keys, Bedrock auth, model IDs)
# while applying personal overrides like attribution settings.

set -euo pipefail

SETTINGS="$HOME/.claude/settings.json"
OVERRIDES="$(dirname "$0")/.claude/settings.overrides.json"

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

# Register obsidian MCP at user scope (works with claude mcp list / Claude Code CLI)
claude mcp remove obsidian --scope user 2>/dev/null || true
claude mcp add --scope user obsidian -- npx @mauricio.wolff/mcp-obsidian@latest "$HOME/second-brain"
