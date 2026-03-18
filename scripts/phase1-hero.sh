#!/usr/bin/env bash
# ============================================================================
# Sovereign Stack — Phase 1: Hero
# Linux post-install essentials
# ============================================================================

export DEBIAN_FRONTEND=noninteractive

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }
step() { echo -e "\n${CYAN}━━━ $1 ━━━${NC}\n"; }

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║   Sovereign Stack — Phase 1: Hero     ║"
echo "  ║   Linux Post-Install Essentials       ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${NC}"

# Detect package manager
if command -v apt &>/dev/null; then
    PKG="apt"
elif command -v dnf &>/dev/null; then
    PKG="dnf"
elif command -v pacman &>/dev/null; then
    PKG="pacman"
else
    err "Unsupported package manager. Install manually."
    exit 1
fi

step "Updating system"
case $PKG in
    apt)    sudo apt-get update -y && sudo apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" ;;
    dnf)    sudo dnf upgrade -y ;;
    pacman) sudo pacman -Syu --noconfirm ;;
esac
log "System updated"

step "Installing essentials"
PACKAGES="curl wget git htop neofetch vim unzip"
case $PKG in
    apt)    sudo apt-get install -y $PACKAGES ;;
    dnf)    sudo dnf install -y $PACKAGES ;;
    pacman) sudo pacman -S --noconfirm $PACKAGES ;;
esac
log "Essential packages installed"

step "Installing Flatpak (universal app store)"
case $PKG in
    apt)    sudo apt-get install -y flatpak ;;
    dnf)    sudo dnf install -y flatpak ;;
    pacman) sudo pacman -S --noconfirm flatpak ;;
esac
# --if-not-exists ensures idempotency
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
log "Flatpak installed — you can now install apps from Flathub"

step "Basic security"
# Enable firewall
if command -v ufw &>/dev/null; then
    sudo ufw --force enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    log "Firewall (UFW) enabled"
elif command -v firewall-cmd &>/dev/null; then
    sudo systemctl enable --now firewalld
    log "Firewall (firewalld) enabled"
else
    warn "No firewall found. Consider installing ufw."
fi

# Enable automatic updates
if [[ "$PKG" == "apt" ]]; then
    sudo apt-get install -y unattended-upgrades
    sudo dpkg-reconfigure -plow unattended-upgrades 2>/dev/null || true
    log "Automatic security updates enabled"
fi

step "System info"
neofetch 2>/dev/null || true

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Phase 1: Hero — COMPLETE                ║${NC}"
echo -e "${GREEN}║                                           ║${NC}"
echo -e "${GREEN}║   You now own your operating system.      ║${NC}"
echo -e "${GREEN}║   Next: Phase 2 — Guardian (browser)      ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
