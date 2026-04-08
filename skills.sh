#!/bin/bash
# security-check skills installer
# https://github.com/ersinkoc/security-check
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash -s -- --all
#   curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash -s -- --lang go typescript python
#   curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash -s -- --category injection
#   curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash -s -- --list

set -euo pipefail

REPO_URL="https://github.com/ersinkoc/security-check"
BRANCH="main"
TEMP_DIR=$(mktemp -d)
VERSION="1.0.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Skill categories
CORE_SKILLS="sc-orchestrator sc-recon sc-dependency-audit sc-verifier sc-report sc-diff-report"
INJECTION_SKILLS="sc-sqli sc-nosqli sc-graphql sc-xss sc-ssti sc-xxe sc-ldap sc-cmdi sc-header-injection"
CODE_EXEC_SKILLS="sc-rce sc-deserialization"
ACCESS_SKILLS="sc-auth sc-authz sc-privilege-escalation sc-session"
DATA_SKILLS="sc-secrets sc-data-exposure sc-crypto"
SERVER_SKILLS="sc-ssrf sc-path-traversal sc-file-upload sc-open-redirect"
CLIENT_SKILLS="sc-csrf sc-cors sc-clickjacking sc-websocket"
LOGIC_SKILLS="sc-business-logic sc-race-condition sc-mass-assignment"
API_SKILLS="sc-api-security sc-rate-limiting sc-jwt"
INFRA_SKILLS="sc-iac sc-docker sc-ci-cd"
LANG_SKILLS="sc-lang-go sc-lang-typescript sc-lang-python sc-lang-php sc-lang-rust sc-lang-java sc-lang-csharp"

ALL_SKILLS="$CORE_SKILLS $INJECTION_SKILLS $CODE_EXEC_SKILLS $ACCESS_SKILLS $DATA_SKILLS $SERVER_SKILLS $CLIENT_SKILLS $LOGIC_SKILLS $API_SKILLS $INFRA_SKILLS $LANG_SKILLS"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

print_banner() {
    echo ""
    echo -e "${RED}  ┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}  │${NC}  ${BOLD}security-check${NC}  ${DIM}v${VERSION}${NC}                                  ${RED}│${NC}"
    echo -e "${RED}  │${NC}  ${CYAN}Your AI Becomes a Security Team. Zero Tools Required.${NC}  ${RED}│${NC}"
    echo -e "${RED}  │${NC}  ${DIM}Compatible with agentskills.io standard${NC}                 ${RED}│${NC}"
    echo -e "${RED}  └─────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

detect_platform() {
    local platforms=()

    if [ -d ".claude" ] || [ -f "CLAUDE.md" ] || command -v claude &>/dev/null; then
        platforms+=("claude")
    fi

    if [ -d ".agents" ] || [ -f "AGENTS.md" ]; then
        platforms+=("agents")
    fi

    if [ -f ".cursor" ] || [ -d ".cursor" ]; then
        platforms+=("cursor")
    fi

    if [ -f ".gemini" ] || [ -d ".gemini" ]; then
        platforms+=("gemini")
    fi

    if [ ${#platforms[@]} -eq 0 ]; then
        echo -e "${YELLOW}  No AI platform detected. Installing for Claude Code + Agents.${NC}"
        platforms+=("claude" "agents")
    else
        echo -e "${GREEN}  Detected platforms: ${platforms[*]}${NC}"
    fi

    echo "${platforms[@]}"
}

show_categories() {
    echo -e "${BOLD}  Available skill categories:${NC}"
    echo ""
    echo -e "  ${CYAN}core${NC}       Pipeline orchestration, recon, verification, reporting (6 skills)"
    echo -e "  ${CYAN}injection${NC}  SQL, NoSQL, GraphQL, XSS, SSTI, XXE, LDAP, CMDi, Headers (9 skills)"
    echo -e "  ${CYAN}exec${NC}       Remote code execution, insecure deserialization (2 skills)"
    echo -e "  ${CYAN}access${NC}     Auth, AuthZ, privilege escalation, sessions (4 skills)"
    echo -e "  ${CYAN}data${NC}       Secrets, data exposure, weak crypto (3 skills)"
    echo -e "  ${CYAN}server${NC}     SSRF, path traversal, file upload, open redirect (4 skills)"
    echo -e "  ${CYAN}client${NC}     CSRF, CORS, clickjacking, WebSocket (4 skills)"
    echo -e "  ${CYAN}logic${NC}      Business logic, race conditions, mass assignment (3 skills)"
    echo -e "  ${CYAN}api${NC}        API security, rate limiting, JWT (3 skills)"
    echo -e "  ${CYAN}infra${NC}      IaC, Docker, CI/CD (3 skills)"
    echo -e "  ${CYAN}lang${NC}       Language-specific: Go, TS, Python, PHP, Rust, Java, C# (7 skills)"
    echo ""
    echo -e "  ${BOLD}Total: 48 skills${NC}"
    echo ""
    echo -e "  ${DIM}Usage examples:${NC}"
    echo -e "    ${DIM}Install all:${NC}        skills.sh --all"
    echo -e "    ${DIM}By category:${NC}        skills.sh --category injection server"
    echo -e "    ${DIM}By language:${NC}        skills.sh --lang go typescript"
    echo -e "    ${DIM}Specific skills:${NC}    skills.sh --skills sc-sqli sc-xss sc-auth"
    echo ""
}

resolve_skills() {
    local selected=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --all)
                selected="$ALL_SKILLS"
                shift
                ;;
            --category)
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
                    case "$1" in
                        core)      selected="$selected $CORE_SKILLS" ;;
                        injection) selected="$selected $INJECTION_SKILLS" ;;
                        exec)      selected="$selected $CODE_EXEC_SKILLS" ;;
                        access)    selected="$selected $ACCESS_SKILLS" ;;
                        data)      selected="$selected $DATA_SKILLS" ;;
                        server)    selected="$selected $SERVER_SKILLS" ;;
                        client)    selected="$selected $CLIENT_SKILLS" ;;
                        logic)     selected="$selected $LOGIC_SKILLS" ;;
                        api)       selected="$selected $API_SKILLS" ;;
                        infra)     selected="$selected $INFRA_SKILLS" ;;
                        lang)      selected="$selected $LANG_SKILLS" ;;
                        *) echo -e "${RED}  Unknown category: $1${NC}"; exit 1 ;;
                    esac
                    shift
                done
                ;;
            --lang)
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
                    case "$1" in
                        go)         selected="$selected sc-lang-go" ;;
                        ts|typescript|js|javascript) selected="$selected sc-lang-typescript" ;;
                        py|python)  selected="$selected sc-lang-python" ;;
                        php)        selected="$selected sc-lang-php" ;;
                        rs|rust)    selected="$selected sc-lang-rust" ;;
                        java|kotlin) selected="$selected sc-lang-java" ;;
                        cs|csharp|dotnet) selected="$selected sc-lang-csharp" ;;
                        *) echo -e "${RED}  Unknown language: $1${NC}"; exit 1 ;;
                    esac
                    shift
                done
                ;;
            --skills)
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
                    selected="$selected $1"
                    shift
                done
                ;;
            --list)
                show_categories
                exit 0
                ;;
            --help|-h)
                print_banner
                show_categories
                exit 0
                ;;
            *)
                echo -e "${RED}  Unknown option: $1${NC}"
                echo -e "  Run with ${CYAN}--help${NC} for usage."
                exit 1
                ;;
        esac
    done

    # Default: install all if nothing specified
    if [ -z "$selected" ]; then
        selected="$ALL_SKILLS"
    fi

    # Always include core skills
    for core in $CORE_SKILLS; do
        if [[ ! " $selected " =~ " $core " ]]; then
            selected="$core $selected"
        fi
    done

    # Deduplicate
    echo "$selected" | tr ' ' '\n' | sort -u | tr '\n' ' '
}

download_repo() {
    echo -e "  ${CYAN}[1/3] Downloading security-check skills...${NC}"
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR/security-check" 2>/dev/null || {
        echo -e "  ${YELLOW}      git clone failed, trying tarball...${NC}"
        curl -fsSL "https://github.com/ersinkoc/security-check/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$TEMP_DIR"
        mv "$TEMP_DIR/security-check-$BRANCH" "$TEMP_DIR/security-check"
    }
    echo -e "  ${GREEN}      Downloaded${NC}"
}

install_skills() {
    local skills="$1"
    local source_dir="$TEMP_DIR/security-check"
    local skill_count=0

    # Detect platform
    local platforms
    platforms=$(detect_platform)
    echo ""

    echo -e "  ${CYAN}[2/3] Installing skills (agentskills.io format)...${NC}"

    for skill in $skills; do
        local skill_dir="$source_dir/skills/$skill"
        if [ ! -d "$skill_dir" ]; then
            echo -e "  ${YELLOW}      Skipping $skill (not found)${NC}"
            continue
        fi

        for platform in $platforms; do
            local target_dir=""
            case "$platform" in
                claude)  target_dir=".claude/skills/$skill" ;;
                agents|cursor|gemini) target_dir=".agents/skills/$skill" ;;
            esac

            if [ -n "$target_dir" ]; then
                mkdir -p "$target_dir"
                cp -r "$skill_dir"/* "$target_dir/"
            fi
        done

        skill_count=$((skill_count + 1))
    done

    echo -e "  ${GREEN}      Installed $skill_count skills${NC}"

    # Install orchestration files
    for platform in $platforms; do
        case "$platform" in
            claude)
                if [ -f "CLAUDE.md" ]; then
                    if ! grep -q "Security Check" "CLAUDE.md" 2>/dev/null; then
                        echo "" >> CLAUDE.md
                        cat "$source_dir/scan-target/CLAUDE.md" >> CLAUDE.md
                        echo -e "  ${YELLOW}      Appended security-check config to existing CLAUDE.md${NC}"
                    fi
                else
                    cp "$source_dir/scan-target/CLAUDE.md" ./CLAUDE.md
                    echo -e "  ${GREEN}      Created CLAUDE.md${NC}"
                fi
                ;;
            agents|cursor|gemini)
                if [ -f "AGENTS.md" ]; then
                    if ! grep -q "Security Check" "AGENTS.md" 2>/dev/null; then
                        echo "" >> AGENTS.md
                        cat "$source_dir/scan-target/AGENTS.md" >> AGENTS.md
                        echo -e "  ${YELLOW}      Appended security-check config to existing AGENTS.md${NC}"
                    fi
                else
                    cp "$source_dir/scan-target/AGENTS.md" ./AGENTS.md
                    echo -e "  ${GREEN}      Created AGENTS.md${NC}"
                fi
                ;;
        esac
    done
}

install_checklists() {
    local skills="$1"
    local source_dir="$TEMP_DIR/security-check"
    local checklist_count=0

    echo -e "  ${CYAN}[3/3] Installing security checklists...${NC}"

    # Copy checklists that are bundled inside skill references/
    for skill in $skills; do
        local ref_dir="$source_dir/skills/$skill/references"
        if [ -d "$ref_dir" ]; then
            mkdir -p checklists
            cp "$ref_dir"/*.md checklists/ 2>/dev/null || true
            checklist_count=$((checklist_count + 1))
        fi
    done

    if [ $checklist_count -gt 0 ]; then
        echo -e "  ${GREEN}      Installed $checklist_count checklists${NC}"
    else
        echo -e "  ${DIM}      No checklists for selected skills${NC}"
    fi
}

print_summary() {
    local skills="$1"
    local count
    count=$(echo "$skills" | wc -w | tr -d ' ')

    echo ""
    echo -e "  ${GREEN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${GREEN}│  Installation complete!                                  │${NC}"
    echo -e "  ${GREEN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${BOLD}Installed:${NC} $count skills (agentskills.io format)"
    echo ""
    echo -e "  ${BOLD}Next steps:${NC}"
    echo -e "    1. Open your AI coding assistant"
    echo -e "    2. Say: ${CYAN}\"run security check\"${NC}"
    echo ""
    echo -e "  ${BOLD}Other commands:${NC}"
    echo -e "    ${CYAN}\"scan diff\"${NC}              Scan only changed files (PR mode)"
    echo -e "    ${CYAN}\"scan for vulnerabilities\"${NC}  Full security audit"
    echo ""
    echo -e "  ${DIM}Docs: https://github.com/ersinkoc/security-check${NC}"
    echo -e "  ${DIM}Spec: https://agentskills.io${NC}"
    echo ""
}

main() {
    print_banner

    if ! command -v git &>/dev/null; then
        echo -e "${RED}  Error: git is required. Install it from https://git-scm.com${NC}"
        exit 1
    fi

    if [ ! -d ".git" ]; then
        echo -e "${YELLOW}  Warning: Not in a git repository root. Proceeding anyway...${NC}"
    fi

    local skills
    skills=$(resolve_skills "$@")

    download_repo
    install_skills "$skills"
    install_checklists "$skills"
    print_summary "$skills"
}

main "$@"
