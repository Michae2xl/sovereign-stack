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

CYAN='\033[0;36m'; GREEN='\033[0;32m'; NC='\033[0m'

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════════════╗"
echo "  ║   Sovereign Stack — Complete VPS Deploy           ║"
echo "  ║   Phase 4 (Knight) + Phase 5 (Sovereign)         ║"
echo "  ╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"

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
