param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$DistributionRoot = Join-Path $RepoRoot 'erwin-copilot'
$SkillsSource = Join-Path $DistributionRoot 'skills'
$AgentsSource = Join-Path $DistributionRoot 'agents'

$CopilotRoot = Join-Path $HOME '.copilot'
$SkillsTarget = Join-Path $CopilotRoot 'skills'
$AgentsTarget = Join-Path $CopilotRoot 'agents'

if (-not (Test-Path $SkillsSource)) {
    throw "Missing distribution skills folder: $SkillsSource"
}

if (-not (Test-Path $AgentsSource)) {
    throw "Missing distribution agents folder: $AgentsSource"
}

New-Item -ItemType Directory -Force -Path $SkillsTarget | Out-Null
New-Item -ItemType Directory -Force -Path $AgentsTarget | Out-Null

function Copy-ErwinDirectory {
    param(
        [Parameter(Mandatory)] [string]$Source,
        [Parameter(Mandatory)] [string]$Destination
    )

    if ((Test-Path $Destination) -and -not $Force) {
        throw "Target already exists: $Destination. Re-run with -Force to replace Erwin-managed files."
    }

    if (Test-Path $Destination) {
        Remove-Item -Recurse -Force $Destination
    }

    Copy-Item -Recurse -Force $Source $Destination
}

Get-ChildItem -Path $SkillsSource -Directory | ForEach-Object {
    Copy-ErwinDirectory -Source $_.FullName -Destination (Join-Path $SkillsTarget $_.Name)
}

Get-ChildItem -Path $AgentsSource -Filter '*.agent.md' -File | ForEach-Object {
    $destination = Join-Path $AgentsTarget $_.Name
    if ((Test-Path $destination) -and -not $Force) {
        throw "Target already exists: $destination. Re-run with -Force to replace Erwin-managed files."
    }
    Copy-Item -Force $_.FullName $destination
}

Write-Host 'Erwin AI Dev installed for GitHub Copilot.'
Write-Host "Skills: $SkillsTarget"
Write-Host "Agents: $AgentsTarget"
Write-Host 'Open a new Copilot chat or reload VS Code, then use /skills or /agents to verify discovery.'
