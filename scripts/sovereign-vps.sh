#!/usr/bin/env bash
# ============================================================================
# Sovereign Stack — ALL VPS PHASES (4 + 5)
# One command to deploy your own infrastructure.
#
# Usage:
#   bash sovereign-vps.sh --all --domain yourdomain.com
#   bash sovereign-vps.sh --all
#   bash sovereign-vps.sh --nextcloud --vaultwarden --searxng --domain yourdomain.com
# ============================================================================
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

# ============================================================================
# Pre-flight checks
# ============================================================================
preflight_check() {
    local has_critical_failure=false
    local has_warning=false

    echo ""
    echo -e "${CYAN}━━━ Pre-flight Checks ━━━${NC}"
    echo ""

    # 1. Root check
    if [[ $EUID -eq 0 ]]; then
        echo -e "${GREEN}[OK]${NC} Running as root"
    else
        echo -e "${RED}[FAIL]${NC} Not running as root"
        has_critical_failure=true
    fi

    # 2. RAM check
    local ram_kb ram_gb
    ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    ram_gb=$(( ram_kb / 1024 / 1024 ))
    if [[ $ram_gb -ge 8 ]]; then
        echo -e "${GREEN}[OK]${NC} RAM: ${ram_gb}GB (minimum: 4GB)"
    elif [[ $ram_gb -ge 4 ]]; then
        echo -e "${YELLOW}[WARN]${NC} RAM: ${ram_gb}GB (minimum: 4GB) — Ollama requires 8GB+"
        has_warning=true
    else
        echo -e "${YELLOW}[WARN]${NC} RAM: ${ram_gb}GB (minimum: 4GB, recommended: 8GB for Ollama)"
        has_warning=true
    fi

    # 3. Disk space check
    local disk_avail_kb disk_avail_gb
    disk_avail_kb=$(df / --output=avail | tail -1 | tr -d ' ')
    disk_avail_gb=$(( disk_avail_kb / 1024 / 1024 ))
    if [[ $disk_avail_gb -ge 20 ]]; then
        echo -e "${GREEN}[OK]${NC} Disk: ${disk_avail_gb}GB free (minimum: 20GB)"
    else
        echo -e "${YELLOW}[WARN]${NC} Disk: ${disk_avail_gb}GB free (minimum: 20GB)"
        has_warning=true
    fi

    # 4. OS check
    local os_id os_version os_pretty
    os_id=$(. /etc/os-release 2>/dev/null && echo "$ID" || echo "unknown")
    os_version=$(. /etc/os-release 2>/dev/null && echo "$VERSION_ID" || echo "unknown")
    os_pretty=$(. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME" || echo "Unknown OS")
    if [[ "$os_id" == "ubuntu" && ( "$os_version" == "22.04" || "$os_version" == "24.04" ) ]]; then
        echo -e "${GREEN}[OK]${NC} OS: $os_pretty"
    else
        echo -e "${YELLOW}[WARN]${NC} OS: $os_pretty (tested on Ubuntu 22.04/24.04)"
        has_warning=true
    fi

    # 5. Docker check
    if command -v docker &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} Docker: installed"
    else
        echo -e "${GREEN}[OK]${NC} Docker: not installed (will be installed)"
    fi

    # 6. Port checks
    local ports_to_check=(8080 8081 8082 8083 8084 8085 8086 8087 3000 53 51820)
    local ports_in_use=()
    for port in "${ports_to_check[@]}"; do
        if ss -tlnp 2>/dev/null | grep -q ":${port} " || ss -ulnp 2>/dev/null | grep -q ":${port} "; then
            ports_in_use+=("$port")
        fi
    done
    if [[ ${#ports_in_use[@]} -eq 0 ]]; then
        echo -e "${GREEN}[OK]${NC} Ports: all required ports are free"
    else
        echo -e "${YELLOW}[WARN]${NC} Ports already in use: ${ports_in_use[*]}"
        has_warning=true
    fi

    # 7. Internet connectivity
    if curl -sf --max-time 5 https://hub.docker.com >/dev/null 2>&1; then
        echo -e "${GREEN}[OK]${NC} Internet: connected"
    elif curl -sf --max-time 5 https://1.1.1.1 >/dev/null 2>&1; then
        echo -e "${GREEN}[OK]${NC} Internet: connected"
    else
        echo -e "${RED}[FAIL]${NC} Internet: no connectivity detected"
        has_critical_failure=true
    fi

    echo ""

    # Return results
    if [[ "$has_critical_failure" == true ]]; then
        err "Critical pre-flight check(s) failed. Cannot continue."
        exit 1
    fi
    if [[ "$has_warning" == true ]]; then
        warn "Some checks raised warnings. Review above before proceeding."
    else
        log "All pre-flight checks passed."
    fi
    echo ""
}

CHECK_ONLY=false
for arg in "$@"; do
    if [[ "$arg" == "--check" || "$arg" == "--dry-run" ]]; then
        CHECK_ONLY=true
    fi
done

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════════════╗"
echo "  ║   Sovereign Stack — Complete VPS Deploy           ║"
echo "  ║   Phase 4 (Knight) + Phase 5 (Sovereign)         ║"
echo "  ╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"

preflight_check

if [[ "$CHECK_ONLY" == true ]]; then
    log "Check-only mode: exiting without installing."
    exit 0
fi

SCRIPT_DIR=$(mktemp -d)
BASE_URL="https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts"

echo -e "${CYAN}Downloading scripts...${NC}"
curl -fsSL "$BASE_URL/phase4-knight.sh" -o "$SCRIPT_DIR/phase4.sh"
curl -fsSL "$BASE_URL/phase5-sovereign.sh" -o "$SCRIPT_DIR/phase5.sh"
chmod +x "$SCRIPT_DIR"/*.sh

# Extract --domain from args
DOMAIN=""
for arg in "$@"; do
    if [[ "$prev_arg" == "--domain" ]]; then
        DOMAIN="$arg"
    fi
    prev_arg="$arg"
done

echo ""
echo -e "${GREEN}━━━ PHASE 4: KNIGHT (Deploy Services) ━━━${NC}"
echo ""
bash "$SCRIPT_DIR/phase4.sh" "$@"

echo ""
echo -e "${GREEN}━━━ PHASE 5: SOVEREIGN (Integration & Hardening) ━━━${NC}"
echo ""
if [[ -n "$DOMAIN" ]]; then
    bash "$SCRIPT_DIR/phase5.sh" --domain "$DOMAIN"
else
    bash "$SCRIPT_DIR/phase5.sh" --domain ""
fi

rm -rf "$SCRIPT_DIR"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}║   VPS DEPLOY COMPLETE — Phases 4, 5 done!            ║${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}║   Your castle is built and fortified.                 ║${NC}"
echo -e "${GREEN}║   You are Sovereign.                                  ║${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}║   Credentials: /root/sovereign-stack-credentials.txt  ║${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
