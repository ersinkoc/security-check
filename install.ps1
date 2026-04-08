# security-check installer (redirects to skills.ps1)
# For full options: .\skills.ps1 --help

$ScriptUrl = 'https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.ps1'

Write-Host ''
Write-Host '  Redirecting to skills.ps1 installer...'
Write-Host '  For future installs, use: npx skills add ersinkoc/security-check'
Write-Host ''

Invoke-Expression (Invoke-RestMethod $ScriptUrl)
