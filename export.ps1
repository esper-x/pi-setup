$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = if ($env:PI_CODING_AGENT_DIR) {
  $env:PI_CODING_AGENT_DIR
} else {
  Join-Path $HOME '.pi\agent'
}

foreach ($file in @('AGENTS.md', 'mcp.json', 'settings.json')) {
  $sourceFile = Join-Path $source $file
  if (-not (Test-Path $sourceFile)) {
    throw "Missing source file: $sourceFile"
  }
}

Copy-Item (Join-Path $source 'AGENTS.md') (Join-Path $repoRoot 'config\AGENTS.md') -Force
Copy-Item (Join-Path $source 'mcp.json') (Join-Path $repoRoot 'config\mcp.json') -Force

$settings = Get-Content (Join-Path $source 'settings.json') -Raw | ConvertFrom-Json
$settings.PSObject.Properties.Remove('lastChangelogVersion')
$settings | ConvertTo-Json -Depth 100 | Set-Content (Join-Path $repoRoot 'config\settings.json') -Encoding utf8

foreach ($directory in @('agents', 'extensions', 'prompts')) {
  $sourceDirectory = Join-Path $source $directory
  $destination = Join-Path $repoRoot "config\$directory"
  if (-not (Test-Path $sourceDirectory)) {
    throw "Missing source directory: $sourceDirectory"
  }
  Remove-Item $destination -Recurse -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force -Path $destination | Out-Null
  Copy-Item (Join-Path $sourceDirectory '*') $destination -Recurse -Force
}

Write-Host "Exported pi config from $source to $repoRoot\config"
