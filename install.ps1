param(
  [switch]$InstallPackages
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = if ($env:PI_CODING_AGENT_DIR) {
  $env:PI_CODING_AGENT_DIR
} else {
  Join-Path $HOME '.pi\agent'
}

New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item (Join-Path $repoRoot 'config\AGENTS.md') (Join-Path $target 'AGENTS.md') -Force
Copy-Item (Join-Path $repoRoot 'config\mcp.json') (Join-Path $target 'mcp.json') -Force
Copy-Item (Join-Path $repoRoot 'config\settings.json') (Join-Path $target 'settings.json') -Force

foreach ($directory in @('agents', 'extensions', 'prompts')) {
  $source = Join-Path $repoRoot "config\$directory"
  $destination = Join-Path $target $directory
  New-Item -ItemType Directory -Force -Path $destination | Out-Null
  Copy-Item (Join-Path $source '*') $destination -Recurse -Force
}

if ($InstallPackages) {
  $packages = @(
    'npm:pi-mcp-adapter',
    'npm:pi-subagents',
    'npm:pi-interactive-shell'
  )
  $previousConfigDir = $env:PI_CODING_AGENT_DIR
  $env:PI_CODING_AGENT_DIR = $target
  try {
    foreach ($package in $packages) {
      & pi install $package
      if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $package"
      }
    }
  } finally {
    $env:PI_CODING_AGENT_DIR = $previousConfigDir
  }
}

Write-Host "Installed pi config to $target"
