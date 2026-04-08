#Requires -Version 5.1
<#
.SYNOPSIS
    security-check installer for Windows
.DESCRIPTION
    Installs security-check skills into your project.
    Auto-detects your AI coding assistant and copies the appropriate files.
.EXAMPLE
    irm https://raw.githubusercontent.com/ersinkoc/security-check/main/install.ps1 | iex
.EXAMPLE
    .\install.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$RepoUrl = 'https://github.com/ersinkoc/security-check'
$Branch = 'main'
$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) "security-check-$(Get-Random)"

function Write-Banner {
    Write-Host ''
    Write-Host '  +-----------------------------------------------------------+' -ForegroundColor Red
    Write-Host '  |              security-check installer                      |' -ForegroundColor Red
    Write-Host '  |  Your AI Becomes a Security Team. Zero Tools Required.    |' -ForegroundColor Red
    Write-Host '  +-----------------------------------------------------------+' -ForegroundColor Red
    Write-Host ''
}

function Remove-TempDir {
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
    }
}

function Get-DetectedPlatforms {
    $platforms = @()

    if ((Test-Path '.claude') -or (Get-Command 'claude' -ErrorAction SilentlyContinue)) {
        $platforms += 'claude'
    }

    if ((Test-Path '.agents') -or (Test-Path 'AGENTS.md')) {
        $platforms += 'agents'
    }

    if (Test-Path '.cursor') {
        $platforms += 'cursor'
    }

    if ($platforms.Count -eq 0) {
        $platforms = @('claude', 'agents')
    }

    return $platforms
}

function Install-ClaudeSkills {
    param([string]$SourceDir)

    Write-Host '  [+] Installing Claude Code skills...' -ForegroundColor Cyan

    if (-not (Test-Path '.claude\skills')) {
        New-Item -ItemType Directory -Path '.claude\skills' -Force | Out-Null
    }

    $claudeMdSource = Join-Path $SourceDir 'scan-target\CLAUDE.md'
    if (Test-Path 'CLAUDE.md') {
        Add-Content -Path 'CLAUDE.md' -Value "`n"
        Get-Content $claudeMdSource | Add-Content -Path 'CLAUDE.md'
        Write-Host '      Appended security-check config to existing CLAUDE.md' -ForegroundColor Yellow
    }
    else {
        Copy-Item $claudeMdSource -Destination 'CLAUDE.md'
    }

    Copy-Item (Join-Path $SourceDir 'scan-target\.claude\skills\*.md') -Destination '.claude\skills\' -Force
    Write-Host '      Claude Code skills installed' -ForegroundColor Green
}

function Install-AgentSkills {
    param([string]$SourceDir)

    Write-Host '  [+] Installing agent skills (.agents format)...' -ForegroundColor Cyan

    if (-not (Test-Path '.agents\skills')) {
        New-Item -ItemType Directory -Path '.agents\skills' -Force | Out-Null
    }

    $agentsMdSource = Join-Path $SourceDir 'scan-target\AGENTS.md'
    if (Test-Path 'AGENTS.md') {
        Add-Content -Path 'AGENTS.md' -Value "`n"
        Get-Content $agentsMdSource | Add-Content -Path 'AGENTS.md'
        Write-Host '      Appended security-check config to existing AGENTS.md' -ForegroundColor Yellow
    }
    else {
        Copy-Item $agentsMdSource -Destination 'AGENTS.md'
    }

    Copy-Item (Join-Path $SourceDir 'scan-target\.agents\skills\*.md') -Destination '.agents\skills\' -Force
    Write-Host '      Agent skills installed' -ForegroundColor Green
}

function Install-Checklists {
    param([string]$SourceDir)

    Write-Host '  [+] Installing security checklists...' -ForegroundColor Cyan

    if (-not (Test-Path 'checklists')) {
        New-Item -ItemType Directory -Path 'checklists' -Force | Out-Null
    }

    Copy-Item (Join-Path $SourceDir 'checklists\*.md') -Destination 'checklists\' -Force
    Write-Host '      Security checklists installed' -ForegroundColor Green
}

function Main {
    Write-Banner

    # Check git
    if (-not (Get-Command 'git' -ErrorAction SilentlyContinue)) {
        Write-Host '  Error: git is required but not installed.' -ForegroundColor Red
        Write-Host '  Install git from https://git-scm.com/download/win' -ForegroundColor Yellow
        exit 1
    }

    if (-not (Test-Path '.git')) {
        Write-Host '  Warning: Not in a git repository root. Proceeding anyway...' -ForegroundColor Yellow
    }

    # Download
    Write-Host '  [+] Downloading security-check...' -ForegroundColor Cyan
    try {
        $sourceDir = Join-Path $TempDir 'security-check'
        git clone --depth 1 --branch $Branch $RepoUrl $sourceDir 2>$null
        if ($LASTEXITCODE -ne 0) { throw 'git clone failed' }
    }
    catch {
        Write-Host '      Trying alternative download method...' -ForegroundColor Yellow
        try {
            $zipUrl = "$RepoUrl/archive/refs/heads/$Branch.zip"
            $zipPath = Join-Path $TempDir 'security-check.zip'
            New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
            Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
            Expand-Archive -Path $zipPath -DestinationPath $TempDir -Force
            $sourceDir = Join-Path $TempDir "security-check-$Branch"
        }
        catch {
            Write-Host '  Error: Failed to download repository.' -ForegroundColor Red
            Remove-TempDir
            exit 1
        }
    }
    Write-Host '      Downloaded' -ForegroundColor Green

    # Detect & install
    $platforms = Get-DetectedPlatforms

    foreach ($platform in $platforms) {
        switch ($platform) {
            'claude'  { Install-ClaudeSkills -SourceDir $sourceDir }
            'agents'  { Install-AgentSkills -SourceDir $sourceDir }
            'cursor'  { Install-AgentSkills -SourceDir $sourceDir }
        }
    }

    Install-Checklists -SourceDir $sourceDir

    # Cleanup
    Remove-TempDir

    # Summary
    Write-Host ''
    Write-Host '  +-----------------------------------------------------------+' -ForegroundColor Green
    Write-Host '  |              Installation complete!                         |' -ForegroundColor Green
    Write-Host '  +-----------------------------------------------------------+' -ForegroundColor Green
    Write-Host ''
    Write-Host '  Open your AI assistant and say: ' -NoNewline
    Write-Host '"run security check"' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '  Installed components:'
    Write-Host '    - 40+ vulnerability detection skills'
    Write-Host '    - 7 language-specific security scanners'
    Write-Host '    - 10 security checklists (3000+ total items)'
    Write-Host ''
    Write-Host "  Documentation: $RepoUrl" -ForegroundColor Cyan
    Write-Host ''
}

Main
