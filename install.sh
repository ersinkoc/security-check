#!/bin/bash
# security-check installer (redirects to skills.sh)
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash -s -- --lang go
#   ./install.sh --category injection

set -euo pipefail

SCRIPT_URL="https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh"

echo ""
echo "  Redirecting to skills.sh installer..."
echo "  For future installs, use: npx skills add ersinkoc/security-check"
echo ""

# Download to temp file and execute (avoids nested curl|bash stdin conflict)
TEMP_SCRIPT=$(mktemp)
trap "rm -f $TEMP_SCRIPT" EXIT
curl -fsSL "$SCRIPT_URL" -o "$TEMP_SCRIPT"
bash "$TEMP_SCRIPT" "$@"
