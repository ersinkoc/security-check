#!/bin/bash
# security-check installer
# Usage: curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash
#
# This script installs security-check skills into your project.
# It auto-detects your AI coding assistant and copies the appropriate files.

set -euo pipefail

REPO_URL="https://github.com/ersinkoc/security-check"
BRANCH="main"
TEMP_DIR=$(mktemp -d)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

print_banner() {
    echo ""
    echo -e "${RED}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}              ${CYAN}security-check installer${NC}                    ${RED}║${NC}"
    echo -e "${RED}║${NC}  Your AI Becomes a Security Team. Zero Tools Required.   ${RED}║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

detect_platform() {
    local platforms=()

    if [ -d ".claude" ] || command -v claude &>/dev/null; then
        platforms+=("claude")
    fi

    if [ -d ".agents" ] || [ -f "AGENTS.md" ]; then
        platforms+=("agents")
    fi

    if [ -f ".cursor" ] || [ -d ".cursor" ]; then
        platforms+=("cursor")
    fi

    if [ ${#platforms[@]} -eq 0 ]; then
        platforms+=("claude" "agents")
    fi

    echo "${platforms[@]}"
}

install_claude() {
    echo -e "${CYAN}[+] Installing Claude Code skills...${NC}"
    mkdir -p .claude/skills
    cp "$TEMP_DIR/security-check/scan-target/CLAUDE.md" ./CLAUDE.md 2>/dev/null || {
        if [ -f "CLAUDE.md" ]; then
            echo "" >> CLAUDE.md
            cat "$TEMP_DIR/security-check/scan-target/CLAUDE.md" >> CLAUDE.md
            echo -e "${YELLOW}    Appended security-check config to existing CLAUDE.md${NC}"
        else
            cp "$TEMP_DIR/security-check/scan-target/CLAUDE.md" ./CLAUDE.md
        fi
    }
    cp "$TEMP_DIR/security-check/scan-target/.claude/skills/"*.md .claude/skills/
    echo -e "${GREEN}    ✓ Claude Code skills installed${NC}"
}

install_agents() {
    echo -e "${CYAN}[+] Installing agent skills (.agents format)...${NC}"
    mkdir -p .agents/skills
    if [ -f "AGENTS.md" ]; then
        echo "" >> AGENTS.md
        cat "$TEMP_DIR/security-check/scan-target/AGENTS.md" >> AGENTS.md
        echo -e "${YELLOW}    Appended security-check config to existing AGENTS.md${NC}"
    else
        cp "$TEMP_DIR/security-check/scan-target/AGENTS.md" ./AGENTS.md
    fi
    cp "$TEMP_DIR/security-check/scan-target/.agents/skills/"*.md .agents/skills/
    echo -e "${GREEN}    ✓ Agent skills installed${NC}"
}

install_checklists() {
    echo -e "${CYAN}[+] Installing security checklists...${NC}"
    mkdir -p checklists
    cp "$TEMP_DIR/security-check/checklists/"*.md checklists/
    echo -e "${GREEN}    ✓ Security checklists installed${NC}"
}

main() {
    print_banner

    if ! command -v git &>/dev/null; then
        echo -e "${RED}Error: git is required but not installed.${NC}"
        exit 1
    fi

    if [ ! -d ".git" ]; then
        echo -e "${YELLOW}Warning: Not in a git repository root. Proceeding anyway...${NC}"
    fi

    echo -e "${CYAN}[+] Downloading security-check...${NC}"
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR/security-check" 2>/dev/null || {
        echo -e "${RED}Error: Failed to clone repository.${NC}"
        echo -e "${YELLOW}Trying alternative download method...${NC}"
        curl -fsSL "https://github.com/ersinkoc/security-check/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$TEMP_DIR"
        mv "$TEMP_DIR/security-check-$BRANCH" "$TEMP_DIR/security-check"
    }
    echo -e "${GREEN}    ✓ Downloaded${NC}"

    local platforms
    platforms=$(detect_platform)

    for platform in $platforms; do
        case "$platform" in
            claude) install_claude ;;
            agents|cursor) install_agents ;;
        esac
    done

    install_checklists

    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Installation complete!                       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  Open your AI assistant and say: ${CYAN}\"run security check\"${NC}"
    echo ""
    echo -e "  Installed components:"
    echo -e "    • 40+ vulnerability detection skills"
    echo -e "    • 7 language-specific security scanners"
    echo -e "    • 10 security checklists (3000+ total items)"
    echo ""
    echo -e "  Documentation: ${CYAN}https://github.com/ersinkoc/security-check${NC}"
    echo ""
}

main "$@"
