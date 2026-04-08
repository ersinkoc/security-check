#!/bin/bash
# security-check installer (redirects to skills.sh)
# For full options: curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash -s -- --help

SCRIPT_URL="https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh"

echo ""
echo "  Redirecting to skills.sh installer..."
echo "  For future installs, use: npx skills add ersinkoc/security-check"
echo ""

curl -fsSL "$SCRIPT_URL" | bash -s -- "$@"
