$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$CommandArgs = @($args)
$script:OrcaExitCode = 0

function Show-Usage {
  @"
Orca Mission Control 1.0

Usage:
  orca mission COMMAND [OPTIONS]
  orca dashboard [--project PATH] [--port PORT] [--no-open]
  orca version
  orca list
  orca show COMMAND
  orca path COMMAND
  orca run COMMAND [--print] [--target PATH] [--sandbox MODE] [--output FILE] [--] [CONTEXT]
  orca help

Examples:
  orca mission create "Ship a trustworthy release" --criterion "The install smoke passes"
  orca mission check AC-1 -- ruby -e "exit 0"
  orca dashboard
  orca run orca-review --print -- "Review the current change"
"@
}

function Require-Ruby {
  if ($null -eq (Get-Command ruby -ErrorAction SilentlyContinue)) {
    throw "Orca Mission Control requires Ruby, but ruby was not found on PATH."
  }
  if ([string]::IsNullOrWhiteSpace($env:RUBYOPT)) {
    $env:RUBYOPT = "--disable-gems"
  } elseif ($env:RUBYOPT -notmatch "--disable-gems") {
    $env:RUBYOPT = "$($env:RUBYOPT) --disable-gems"
  }
}

function Invoke-Mission([string[]]$MissionArgs) {
  Require-Ruby
  if ([string]::IsNullOrWhiteSpace($env:ORCA_ROOT)) {
    $env:ORCA_ROOT = Join-Path (Get-Location) ".orca"
  }
  & ruby (Join-Path $Root "scripts/orca-mission.rb") @MissionArgs
  $script:OrcaExitCode = $LASTEXITCODE
}

function Invoke-Dashboard([string[]]$DashboardArgs) {
  Require-Ruby
  & ruby (Join-Path $Root "scripts/orca-dashboard.rb") @DashboardArgs
  $script:OrcaExitCode = $LASTEXITCODE
}

function Resolve-OrcaCommand([string]$Name) {
  if ([string]::IsNullOrWhiteSpace($Name)) {
    throw "A command name is required."
  }
  $Normalized = $Name
  if ($Normalized.EndsWith(".md")) {
    $Normalized = $Normalized.Substring(0, $Normalized.Length - 3)
  }
  if (!$Normalized.StartsWith("orca-")) {
    $Normalized = "orca-$Normalized"
  }
  $Path = Join-Path (Join-Path $Root "commands") "$Normalized.md"
  if (!(Test-Path -LiteralPath $Path -PathType Leaf)) {
    throw "Unknown Orca command: $Normalized"
  }
  return @{ Name = $Normalized; Path = $Path }
}

function New-OrcaPrompt([string]$Name, [string]$Path, [string]$Context) {
  $Definition = Get-Content -Raw -LiteralPath $Path
  $Prompt = @"
Follow the optional Orca workflow definition ``$Name``.

Execution rules:
- Prefer the project's configured tracker and documentation system when available.
- If an external system is unavailable, continue with local project artifacts and state the boundary.
- Keep changes within the requested outcome and verify them with the strongest available check.
- End with a concise completion summary covering outcome, evidence, blockers, and next action.

Command definition:

$Definition
"@
  if (![string]::IsNullOrWhiteSpace($Context)) {
    $Prompt += "`n`nAdditional context:`n`n$Context`n"
  }
  return $Prompt
}

function Invoke-OrcaRun([string[]]$RunArgs) {
  if ($RunArgs.Count -eq 0) {
    throw "run requires a command name."
  }
  $Resolved = Resolve-OrcaCommand $RunArgs[0]
  $PrintOnly = $false
  $Target = (Get-Location).Path
  $Sandbox = "workspace-write"
  $Output = ""
  $ContextParts = New-Object System.Collections.Generic.List[string]
  $Index = 1
  $ReadingContext = $false
  while ($Index -lt $RunArgs.Count) {
    $Value = $RunArgs[$Index]
    if ($ReadingContext) {
      $ContextParts.Add($Value)
      $Index += 1
      continue
    }
    switch ($Value) {
      "--print" { $PrintOnly = $true; $Index += 1 }
      "--target" {
        if ($Index + 1 -ge $RunArgs.Count) { throw "--target requires a path." }
        $Target = (Resolve-Path -LiteralPath $RunArgs[$Index + 1]).Path
        $Index += 2
      }
      "--sandbox" {
        if ($Index + 1 -ge $RunArgs.Count) { throw "--sandbox requires a mode." }
        $Sandbox = $RunArgs[$Index + 1]
        $Index += 2
      }
      "--output" {
        if ($Index + 1 -ge $RunArgs.Count) { throw "--output requires a file." }
        $Output = $RunArgs[$Index + 1]
        $Index += 2
      }
      "--" { $ReadingContext = $true; $Index += 1 }
      default { throw "Unknown run option: $Value" }
    }
  }

  $Prompt = New-OrcaPrompt $Resolved.Name $Resolved.Path ($ContextParts -join " ")
  if ($PrintOnly) {
    Write-Output $Prompt
    $script:OrcaExitCode = 0
    return
  }
  if ($null -eq (Get-Command codex -ErrorAction SilentlyContinue)) {
    throw "Codex CLI is not installed. Use --print to inspect the Orca prompt."
  }
  $CodexArgs = @("exec", "--ignore-user-config", "--skip-git-repo-check", "--sandbox", $Sandbox, "-C", $Target)
  if (![string]::IsNullOrWhiteSpace($Output)) {
    $CodexArgs += @("-o", $Output)
  }
  $CodexArgs += "-"
  $Prompt | & codex @CodexArgs
  $script:OrcaExitCode = $LASTEXITCODE
}

try {
  $Command = if ($CommandArgs.Count -gt 0) { $CommandArgs[0] } else { "help" }
  $Rest = if ($CommandArgs.Count -gt 1) { @($CommandArgs[1..($CommandArgs.Count - 1)]) } else { @() }
  switch ($Command) {
    { $_ -in @("help", "-h", "--help") } { Show-Usage; exit 0 }
    "version" { (Get-Content -Raw -LiteralPath (Join-Path $Root "VERSION")).Trim(); exit 0 }
    "mission" { Invoke-Mission $Rest; exit $script:OrcaExitCode }
    "dashboard" { Invoke-Dashboard $Rest; exit $script:OrcaExitCode }
    "list" {
      Get-ChildItem -LiteralPath (Join-Path $Root "commands") -Filter "orca-*.md" |
        Sort-Object Name |
        ForEach-Object { $_.BaseName }
      exit 0
    }
    "show" {
      if ($Rest.Count -ne 1) { throw "show requires one command name." }
      $Resolved = Resolve-OrcaCommand $Rest[0]
      Get-Content -Raw -LiteralPath $Resolved.Path
      exit 0
    }
    "path" {
      if ($Rest.Count -ne 1) { throw "path requires one command name." }
      $Resolved = Resolve-OrcaCommand $Rest[0]
      $Resolved.Path
      exit 0
    }
    "run" { Invoke-OrcaRun $Rest; exit $script:OrcaExitCode }
    default {
      $Resolved = Resolve-OrcaCommand $Command
      Invoke-OrcaRun (@($Resolved.Name) + $Rest)
      exit $script:OrcaExitCode
    }
  }
} catch {
  [Console]::Error.WriteLine("orca: $($_.Exception.Message)")
  exit 2
}
