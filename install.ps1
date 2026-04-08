# security-check installer (redirects to skills.ps1)
# For full options: .\skills.ps1 --help
#
# Usage:
#   irm https://raw.githubusercontent.com/ersinkoc/security-check/main/install.ps1 | iex
#   .\install.ps1
#   .\install.ps1 --lang go typescript

param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$PassArgs
)

$ScriptUrl = 'https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.ps1'

Write-Host ''
Write-Host '  Redirecting to skills.ps1 installer...'
Write-Host '  For future installs, use: npx skills add ersinkoc/security-check'
Write-Host ''

$scriptContent = Invoke-RestMethod $ScriptUrl
$tempFile = Join-Path ([System.IO.Path]::GetTempPath()) "skills-$(Get-Random).ps1"
Set-Content -Path $tempFile -Value $scriptContent
try {
    if ($PassArgs -and $PassArgs.Count -gt 0) {
        & $tempFile @PassArgs
    } else {
        & $tempFile
    }
} finally {
    Remove-Item -Path $tempFile -ErrorAction SilentlyContinue
}
