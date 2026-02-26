#!/usr/bin/env bash
# Merge personal Codex CLI preferences on top of existing config.
# This preserves any machine-specific settings while applying managed defaults.

set -euo pipefail

SETTINGS="$HOME/.codex/config.toml"
OVERRIDES="$(dirname "$0")/.codex/config.overrides.toml"
BEGIN_MARK="# BEGIN DOTFILES CODEX OVERRIDES"
END_MARK="# END DOTFILES CODEX OVERRIDES"

if [[ ! -f "$OVERRIDES" ]]; then
  return 0 2>/dev/null || exit 0
fi

mkdir -p "$HOME/.codex"

if [[ ! -f "$SETTINGS" ]]; then
  cp "$OVERRIDES" "$SETTINGS"
  exit 0
fi

tmp=$(mktemp)
awk -v begin="$BEGIN_MARK" -v end="$END_MARK" '
  $0 == begin { in_block = 1; next }
  $0 == end { in_block = 0; next }
  !in_block { print }
' "$SETTINGS" > "$tmp"

{
  cat "$tmp"
  printf "\n%s\n" "$BEGIN_MARK"
  cat "$OVERRIDES"
  printf "%s\n" "$END_MARK"
} > "$SETTINGS"

rm -f "$tmp"
