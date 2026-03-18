#!/usr/bin/env bash
# ============================================================================
# Sovereign Stack — ALL LOCAL PHASES (1 + 2 + 3)
# One command to freedom on your local machine.
#
# Usage: curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/sovereign-local.sh | bash
# ============================================================================
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; NC='\033[0m'

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════════════╗"
echo "  ║   Sovereign Stack — Complete Local Install        ║"
echo "  ║   Phase 1 (Hero) + Phase 2 (Guardian) + Phase 3  ║"
echo "  ║   (Warrior)                                       ║"
echo "  ╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"

SCRIPT_DIR=$(mktemp -d)
BASE_URL="https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts"

echo -e "${CYAN}Downloading scripts...${NC}"
curl -fsSL "$BASE_URL/phase1-hero.sh" -o "$SCRIPT_DIR/phase1.sh"
curl -fsSL "$BASE_URL/phase2-guardian.sh" -o "$SCRIPT_DIR/phase2.sh"
curl -fsSL "$BASE_URL/phase3-warrior.sh" -o "$SCRIPT_DIR/phase3.sh"
chmod +x "$SCRIPT_DIR"/*.sh

echo ""
echo -e "${GREEN}━━━ PHASE 1: HERO (Linux Essentials) ━━━${NC}"
echo ""
bash "$SCRIPT_DIR/phase1.sh"

echo ""
echo -e "${GREEN}━━━ PHASE 2: GUARDIAN (Browser Hardening) ━━━${NC}"
echo ""
bash "$SCRIPT_DIR/phase2.sh"

echo ""
echo -e "${GREEN}━━━ PHASE 3: WARRIOR (FOSS Apps) ━━━${NC}"
echo ""
bash "$SCRIPT_DIR/phase3.sh"

rm -rf "$SCRIPT_DIR"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}║   LOCAL SETUP COMPLETE — Phases 1, 2, 3 done!    ║${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}║   Your machine is free from Big Tech.             ║${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}║   Next: Phase 4-5 on your VPS:                    ║${NC}"
echo -e "${GREEN}║   ssh root@VPS_IP                                 ║${NC}"
echo -e "${GREEN}║   curl -fsSL .../sovereign-vps.sh | bash          ║${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
