#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_dir=${PI_CODING_AGENT_DIR:-"$HOME/.pi/agent"}

for file in AGENTS.md mcp.json settings.json; do
  if [ ! -f "$source_dir/$file" ]; then
    printf 'Missing source file: %s\n' "$source_dir/$file" >&2
    exit 1
  fi
done

cp "$source_dir/AGENTS.md" "$repo_root/config/AGENTS.md"
cp "$source_dir/mcp.json" "$repo_root/config/mcp.json"

node - "$source_dir/settings.json" "$repo_root/config/settings.json" <<'NODE'
const fs = require('fs')
const [source, destination] = process.argv.slice(2)
const settings = JSON.parse(fs.readFileSync(source, 'utf8'))
delete settings.lastChangelogVersion
fs.writeFileSync(destination, `${JSON.stringify(settings, null, 2)}\n`)
NODE

for directory in agents extensions prompts; do
  if [ ! -d "$source_dir/$directory" ]; then
    printf 'Missing source directory: %s\n' "$source_dir/$directory" >&2
    exit 1
  fi
  rm -rf "$repo_root/config/$directory"
  mkdir -p "$repo_root/config/$directory"
  cp -R "$source_dir/$directory"/. "$repo_root/config/$directory/"
done

printf 'Exported pi config from %s to %s/config\n' "$source_dir" "$repo_root"
