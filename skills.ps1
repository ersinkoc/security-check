#Requires -Version 5.1
<#
.SYNOPSIS
    security-check skills installer for Windows
.DESCRIPTION
    Installs security-check agent skills (agentskills.io format) into your project.
    Auto-detects your AI coding assistant and copies the appropriate skill folders.
.EXAMPLE
    irm https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.ps1 | iex
.EXAMPLE
    .\skills.ps1 --all
    .\skills.ps1 --lang go typescript python
    .\skills.ps1 --category injection server
    .\skills.ps1 --list
#>

[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Args
)

$ErrorActionPreference = 'Stop'

$RepoUrl = 'https://github.com/ersinkoc/security-check'
$Branch = 'main'
$Version = '1.0.0'
$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) "security-check-$(Get-Random)"

# Skill categories
$SkillCategories = @{
    core      = @('sc-orchestrator','sc-recon','sc-dependency-audit','sc-verifier','sc-report','sc-diff-report')
    injection = @('sc-sqli','sc-nosqli','sc-graphql','sc-xss','sc-ssti','sc-xxe','sc-ldap','sc-cmdi','sc-header-injection')
    exec      = @('sc-rce','sc-deserialization')
    access    = @('sc-auth','sc-authz','sc-privilege-escalation','sc-session')
    data      = @('sc-secrets','sc-data-exposure','sc-crypto')
    server    = @('sc-ssrf','sc-path-traversal','sc-file-upload','sc-open-redirect')
    client    = @('sc-csrf','sc-cors','sc-clickjacking','sc-websocket')
    logic     = @('sc-business-logic','sc-race-condition','sc-mass-assignment')
    api       = @('sc-api-security','sc-rate-limiting','sc-jwt')
    infra     = @('sc-iac','sc-docker','sc-ci-cd')
    lang      = @('sc-lang-go','sc-lang-typescript','sc-lang-python','sc-lang-php','sc-lang-rust','sc-lang-java','sc-lang-csharp')
}

$LangAliases = @{
    go='sc-lang-go'; ts='sc-lang-typescript'; typescript='sc-lang-typescript'; js='sc-lang-typescript'; javascript='sc-lang-typescript'
    py='sc-lang-python'; python='sc-lang-python'; php='sc-lang-php'; rs='sc-lang-rust'; rust='sc-lang-rust'
    java='sc-lang-java'; kotlin='sc-lang-java'; cs='sc-lang-csharp'; csharp='sc-lang-csharp'; dotnet='sc-lang-csharp'
}

function Write-Banner {
    Write-Host ''
    Write-Host '  +-----------------------------------------------------------+' -ForegroundColor Red
    Write-Host "  |  security-check  v$Version                                  |" -ForegroundColor Red
    Write-Host '  |  Your AI Becomes a Security Team. Zero Tools Required.    |' -ForegroundColor Red
    Write-Host '  |  Compatible with agentskills.io standard                  |' -ForegroundColor Red
    Write-Host '  +-----------------------------------------------------------+' -ForegroundColor Red
    Write-Host ''
}

function Remove-TempDir {
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
    }
}

function Show-Categories {
    Write-Host '  Available skill categories:' -ForegroundColor White
    Write-Host ''
    Write-Host '  core       Pipeline orchestration, recon, verification, reporting (6 skills)' -ForegroundColor Cyan
    Write-Host '  injection  SQL, NoSQL, GraphQL, XSS, SSTI, XXE, LDAP, CMDi, Headers (9 skills)' -ForegroundColor Cyan
    Write-Host '  exec       Remote code execution, insecure deserialization (2 skills)' -ForegroundColor Cyan
    Write-Host '  access     Auth, AuthZ, privilege escalation, sessions (4 skills)' -ForegroundColor Cyan
    Write-Host '  data       Secrets, data exposure, weak crypto (3 skills)' -ForegroundColor Cyan
    Write-Host '  server     SSRF, path traversal, file upload, open redirect (4 skills)' -ForegroundColor Cyan
    Write-Host '  client     CSRF, CORS, clickjacking, WebSocket (4 skills)' -ForegroundColor Cyan
    Write-Host '  logic      Business logic, race conditions, mass assignment (3 skills)' -ForegroundColor Cyan
    Write-Host '  api        API security, rate limiting, JWT (3 skills)' -ForegroundColor Cyan
    Write-Host '  infra      IaC, Docker, CI/CD (3 skills)' -ForegroundColor Cyan
    Write-Host '  lang       Language-specific: Go, TS, Python, PHP, Rust, Java, C# (7 skills)' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '  Total: 48 skills' -ForegroundColor White
    Write-Host ''
    Write-Host '  Usage:' -ForegroundColor DarkGray
    Write-Host '    .\skills.ps1 --all                          Install all skills' -ForegroundColor DarkGray
    Write-Host '    .\skills.ps1 --category injection server    Install by category' -ForegroundColor DarkGray
    Write-Host '    .\skills.ps1 --lang go typescript           Install by language' -ForegroundColor DarkGray
    Write-Host '    .\skills.ps1 --skills sc-sqli sc-xss        Install specific skills' -ForegroundColor DarkGray
    Write-Host ''
}

function Get-DetectedPlatforms {
    $platforms = @()
    if ((Test-Path '.claude') -or (Test-Path 'CLAUDE.md') -or (Get-Command 'claude' -ErrorAction SilentlyContinue)) { $platforms += 'claude' }
    if ((Test-Path '.agents') -or (Test-Path 'AGENTS.md')) { $platforms += 'agents' }
    if (Test-Path '.cursor') { $platforms += 'cursor' }
    if ($platforms.Count -eq 0) {
        Write-Host '  No AI platform detected. Installing for Claude Code + Agents.' -ForegroundColor Yellow
        $platforms = @('claude', 'agents')
    } else {
        Write-Host "  Detected platforms: $($platforms -join ', ')" -ForegroundColor Green
    }
    return $platforms
}

function Get-AllSkills {
    $all = @()
    foreach ($cat in $SkillCategories.Keys) { $all += $SkillCategories[$cat] }
    return $all | Sort-Object -Unique
}

function Resolve-SkillList {
    param([string[]]$Arguments)

    $selected = @()
    $i = 0

    if ($null -eq $Arguments -or $Arguments.Count -eq 0) {
        return Get-AllSkills
    }

    while ($i -lt $Arguments.Count) {
        switch ($Arguments[$i]) {
            '--all' { return Get-AllSkills }
            '--list' { Show-Categories; exit 0 }
            '--help' { Write-Banner; Show-Categories; exit 0 }
            '-h' { Write-Banner; Show-Categories; exit 0 }
            '--category' {
                $i++
                while ($i -lt $Arguments.Count -and -not $Arguments[$i].StartsWith('--')) {
                    $cat = $Arguments[$i]
                    if ($SkillCategories.ContainsKey($cat)) {
                        $selected += $SkillCategories[$cat]
                    } else {
                        Write-Host "  Unknown category: $cat" -ForegroundColor Red; exit 1
                    }
                    $i++
                }
                continue
            }
            '--lang' {
                $i++
                while ($i -lt $Arguments.Count -and -not $Arguments[$i].StartsWith('--')) {
                    $lang = $Arguments[$i]
                    if ($LangAliases.ContainsKey($lang)) {
                        $selected += $LangAliases[$lang]
                    } else {
                        Write-Host "  Unknown language: $lang" -ForegroundColor Red; exit 1
                    }
                    $i++
                }
                continue
            }
            '--skills' {
                $i++
                while ($i -lt $Arguments.Count -and -not $Arguments[$i].StartsWith('--')) {
                    $selected += $Arguments[$i]
                    $i++
                }
                continue
            }
            default {
                Write-Host "  Unknown option: $($Arguments[$i])" -ForegroundColor Red
                Write-Host '  Run with --help for usage.' -ForegroundColor Yellow
                exit 1
            }
        }
        $i++
    }

    # Always include core
    $selected += $SkillCategories['core']
    return $selected | Sort-Object -Unique
}

function Main {
    Write-Banner

    if (-not (Get-Command 'git' -ErrorAction SilentlyContinue)) {
        Write-Host '  Error: git is required. Install from https://git-scm.com/download/win' -ForegroundColor Red
        exit 1
    }

    if (-not (Test-Path '.git')) {
        Write-Host '  Warning: Not in a git repository root. Proceeding anyway...' -ForegroundColor Yellow
    }

    $skills = Resolve-SkillList -Arguments $Args

    # Download
    Write-Host '  [1/3] Downloading security-check skills...' -ForegroundColor Cyan
    try {
        $sourceDir = Join-Path $TempDir 'security-check'
        git clone --depth 1 --branch $Branch $RepoUrl $sourceDir 2>$null
        if ($LASTEXITCODE -ne 0) { throw 'clone failed' }
    } catch {
        Write-Host '      Trying zip download...' -ForegroundColor Yellow
        try {
            New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
            $zipPath = Join-Path $TempDir 'sc.zip'
            Invoke-WebRequest -Uri "$RepoUrl/archive/refs/heads/$Branch.zip" -OutFile $zipPath -UseBasicParsing
            Expand-Archive -Path $zipPath -DestinationPath $TempDir -Force
            $sourceDir = Join-Path $TempDir "security-check-$Branch"
        } catch {
            Write-Host '  Error: Failed to download.' -ForegroundColor Red
            Remove-TempDir; exit 1
        }
    }
    Write-Host '      Downloaded' -ForegroundColor Green

    # Detect platform
    $platforms = Get-DetectedPlatforms
    Write-Host ''

    # Install skills
    Write-Host '  [2/3] Installing skills (agentskills.io format)...' -ForegroundColor Cyan
    $count = 0
    foreach ($skill in $skills) {
        $skillSource = Join-Path $sourceDir "skills\$skill"
        if (-not (Test-Path $skillSource)) { continue }

        foreach ($platform in $platforms) {
            $targetDir = switch ($platform) {
                'claude' { ".claude\skills\$skill" }
                default  { ".agents\skills\$skill" }
            }
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }
            Copy-Item -Path "$skillSource\*" -Destination $targetDir -Recurse -Force
        }
        $count++
    }
    Write-Host "      Installed $count skills" -ForegroundColor Green

    # Orchestration files
    foreach ($platform in $platforms) {
        switch ($platform) {
            'claude' {
                $src = Join-Path $sourceDir 'scan-target\CLAUDE.md'
                if (Test-Path 'CLAUDE.md') {
                    if (-not (Select-String -Path 'CLAUDE.md' -Pattern 'Security Check' -Quiet)) {
                        Add-Content -Path 'CLAUDE.md' -Value "`n"; Get-Content $src | Add-Content -Path 'CLAUDE.md'
                        Write-Host '      Appended to existing CLAUDE.md' -ForegroundColor Yellow
                    }
                } else {
                    Copy-Item $src -Destination 'CLAUDE.md'
                    Write-Host '      Created CLAUDE.md' -ForegroundColor Green
                }
            }
            default {
                $src = Join-Path $sourceDir 'scan-target\AGENTS.md'
                if (Test-Path 'AGENTS.md') {
                    if (-not (Select-String -Path 'AGENTS.md' -Pattern 'Security Check' -Quiet)) {
                        Add-Content -Path 'AGENTS.md' -Value "`n"; Get-Content $src | Add-Content -Path 'AGENTS.md'
                        Write-Host '      Appended to existing AGENTS.md' -ForegroundColor Yellow
                    }
                } else {
                    Copy-Item $src -Destination 'AGENTS.md'
                    Write-Host '      Created AGENTS.md' -ForegroundColor Green
                }
            }
        }
    }

    # Checklists
    Write-Host '  [3/3] Installing security checklists...' -ForegroundColor Cyan
    $clCount = 0
    foreach ($skill in $skills) {
        $refDir = Join-Path $sourceDir "skills\$skill\references"
        if (Test-Path $refDir) {
            if (-not (Test-Path 'checklists')) { New-Item -ItemType Directory -Path 'checklists' -Force | Out-Null }
            Copy-Item -Path "$refDir\*.md" -Destination 'checklists\' -Force -ErrorAction SilentlyContinue
            $clCount++
        }
    }
    if ($clCount -gt 0) {
        Write-Host "      Installed $clCount checklists" -ForegroundColor Green
    } else {
        Write-Host '      No checklists for selected skills' -ForegroundColor DarkGray
    }

    Remove-TempDir

    Write-Host ''
    Write-Host '  +-----------------------------------------------------------+' -ForegroundColor Green
    Write-Host '  |  Installation complete!                                    |' -ForegroundColor Green
    Write-Host '  +-----------------------------------------------------------+' -ForegroundColor Green
    Write-Host ''
    Write-Host "  Installed: $count skills (agentskills.io format)"
    Write-Host ''
    Write-Host '  Next: open your AI assistant and say ' -NoNewline
    Write-Host '"run security check"' -ForegroundColor Cyan
    Write-Host ''
    Write-Host "  Docs: $RepoUrl" -ForegroundColor DarkGray
    Write-Host '  Spec: https://agentskills.io' -ForegroundColor DarkGray
    Write-Host ''
}

Main
