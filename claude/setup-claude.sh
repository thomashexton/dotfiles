#!/usr/bin/env bash
# Merge personal Claude CLI preferences on top of existing settings.
# This preserves machine-specific config (API keys, Bedrock auth, model IDs)
# while applying personal overrides like attribution settings.

set -euo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
  SETTINGS="$HOME/Library/Application Support/Otter/claude-code-user/settings.json"
else
  SETTINGS="${XDG_CONFIG_HOME:-$HOME/.config}/otter/claude-code-user/settings.json"
fi
OVERRIDES="$(cd "$(dirname "$0")" && pwd)/.claude/settings.overrides.json"

if [[ ! -f "$OVERRIDES" ]]; then
  return 0 2>/dev/null || exit 0
fi

mkdir -p "$HOME/.claude"
mkdir -p "$(dirname "$SETTINGS")"

if [[ -f "$SETTINGS" ]]; then
  # Merge: overrides win over existing settings
  tmp=$(mktemp)
  jq -s '.[0] * .[1]' "$SETTINGS" "$OVERRIDES" > "$tmp" && mv "$tmp" "$SETTINGS"
else
  cp "$OVERRIDES" "$SETTINGS"
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "Claude CLI not found; skipping MCP registration."
  exit 0
fi

# Register obsidian MCP at user scope (works with claude mcp list / Claude Code CLI)
claude mcp remove obsidian --scope user 2>/dev/null || true
claude mcp add --scope user obsidian -- npx @mauricio.wolff/mcp-obsidian@latest "$HOME/second-brain"
