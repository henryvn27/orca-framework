param(
  [ValidateSet("local", "global")]
  [string]$Mode = "local",
  [string]$Target = ""
)

$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")

if ($Target -eq "") {
  if ($Mode -eq "global") {
    $Target = Join-Path $HOME ".orca-framework"
  } else {
    $Target = Join-Path (Get-Location) ".orca-framework"
  }
}

New-Item -ItemType Directory -Force -Path $Target | Out-Null

foreach ($Item in @("VERSION", "ORCA-Framework.md", "README.md", "commands", "skills", "templates", "docs", "dashboard", "mcp", "install", "scripts", "bin")) {
  $Source = Join-Path $Root $Item
  $Destination = Join-Path $Target $Item
  if (!(Test-Path $Source)) {
    throw "Missing source item: $Item"
  }
  if (Test-Path $Destination) {
    Remove-Item -Recurse -Force $Destination
  }
  Copy-Item -Recurse $Source $Destination
}

$BinDir = Join-Path $Target "bin"
foreach ($CommandFile in Get-ChildItem -Path (Join-Path $Target "commands") -Filter "orca-*.md") {
  $CommandName = [System.IO.Path]::GetFileNameWithoutExtension($CommandFile.Name)
  $ShimPath = Join-Path $BinDir $CommandName
  @"
#!/usr/bin/env sh
set -eu
script_dir=`$(CDPATH= cd -- "`$(dirname -- "`$0")" && pwd)
exec "`$script_dir/orca" "$CommandName" "`$@"
"@ | Set-Content -NoNewline -Encoding ASCII -Path $ShimPath
  @"
@echo off
"%~dp0orca.cmd" run "$CommandName" %*
exit /b %ERRORLEVEL%
"@ | Set-Content -NoNewline -Encoding ASCII -Path "$ShimPath.cmd"
}

Write-Host "Orca Mission Control installed to $Target"
Write-Host "Install overview: $(Join-Path $Target 'docs/install-overview.md')"
Write-Host "Beginner path: $(Join-Path $Target 'docs/install-for-beginners.md')"
Write-Host "Technical path: $(Join-Path $Target 'docs/install-for-technical-users.md')"
Write-Host "Optional tracker integration: $(Join-Path $Target 'docs/linear-guidance.md')"
Write-Host ""
Write-Host "Next steps:"
$PathCommand = '$env:PATH = "' + (Join-Path $Target 'bin') + ';$env:PATH"'
Write-Host "1. Add Orca to PATH for this session: $PathCommand"
Write-Host "2. Verify the install: & $(Join-Path $Target 'bin/orca.cmd') version"
Write-Host "3. Open Mission Control: & $(Join-Path $Target 'bin/orca.cmd') dashboard"
Write-Host '4. Create your first Mission: orca mission create "Outcome" --criterion "Observable proof"'
Write-Host "5. Follow the product walkthrough: $(Join-Path $Target 'docs/first-workflow.md')"
