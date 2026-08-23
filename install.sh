#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target=${PI_CODING_AGENT_DIR:-"$HOME/.pi/agent"}
install_packages=false

if [ "${1:-}" = "--install-packages" ]; then
  install_packages=true
elif [ "$#" -gt 0 ]; then
  printf 'Usage: %s [--install-packages]\n' "$0" >&2
  exit 2
fi

mkdir -p "$target" "$target/agents" "$target/extensions" "$target/prompts"
cp "$repo_root/config/AGENTS.md" "$target/AGENTS.md"
cp "$repo_root/config/mcp.json" "$target/mcp.json"
cp "$repo_root/config/settings.json" "$target/settings.json"
cp "$repo_root/config/agents"/*.md "$target/agents/"
cp "$repo_root/config/extensions"/*.ts "$target/extensions/"
cp "$repo_root/config/prompts"/*.md "$target/prompts/"

if [ "$install_packages" = true ]; then
  PI_CODING_AGENT_DIR="$target" pi install npm:pi-mcp-adapter
  PI_CODING_AGENT_DIR="$target" pi install npm:pi-subagents
  PI_CODING_AGENT_DIR="$target" pi install npm:pi-interactive-shell
fi

printf 'Installed pi config to %s\n' "$target"
