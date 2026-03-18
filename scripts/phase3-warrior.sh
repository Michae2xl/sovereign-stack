#!/usr/bin/env bash
# ============================================================================
# Sovereign Stack — Phase 3: Warrior
# Install FOSS replacements for Google apps
# ============================================================================

export DEBIAN_FRONTEND=noninteractive

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }
step() { echo -e "\n${CYAN}━━━ $1 ━━━${NC}\n"; }

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║   Sovereign Stack — Phase 3: Warrior      ║"
echo "  ║   Replace Google Apps with FOSS            ║"
echo "  ╚═══════════════════════════════════════════╝"
echo -e "${NC}"

# Check for Flatpak
if ! command -v flatpak &>/dev/null; then
    warn "Flatpak not installed. Run Phase 1 first or install manually."
    warn "sudo apt install -y flatpak && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
    exit 1
fi

# Ensure flathub remote is available
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

INSTALL_FAILURES=0

step "Installing FOSS desktop apps via Flatpak"

install_app() {
    local id=$1
    local name=$2
    local replaces=$3
    if flatpak list --app 2>/dev/null | grep -q "$id"; then
        log "$name already installed"
    else
        echo -n "  Installing $name (replaces $replaces)... "
        if flatpak install -y --noninteractive flathub "$id" &>/dev/null; then
            echo -e "${GREEN}done${NC}"
        else
            echo -e "${YELLOW}failed — install manually: flatpak install flathub $id${NC}"
            INSTALL_FAILURES=$((INSTALL_FAILURES + 1))
        fi
    fi
}

# Office & Productivity
step "Office & Productivity"
install_app "org.libreoffice.LibreOffice"         "LibreOffice"       "Google Docs/Sheets/Slides"
install_app "org.signal.Signal"                    "Signal"            "Google Messages/WhatsApp"
install_app "net.cozic.joplin_desktop"             "Joplin"            "Google Keep"
install_app "org.standardnotes.app"                "Standard Notes"    "Google Keep (alt)"
install_app "org.thunderbird.Thunderbird"          "Thunderbird"       "Gmail client"

# Media
step "Media"
install_app "io.freetubeapp.FreeTube"              "FreeTube"          "YouTube"
install_app "org.videolan.VLC"                     "VLC"               "Google Play Movies"
install_app "org.gimp.GIMP"                        "GIMP"              "Google Photos editor"

# Security & Privacy
step "Security & Privacy"
install_app "com.bitwarden.desktop"                "Bitwarden"         "Chrome passwords"
install_app "org.keepassxc.KeePassXC"              "KeePassXC"         "Google Authenticator (desktop)"

# Communication
step "Communication"
install_app "im.element.Element"                   "Element"           "Discord/Slack/Teams"

# Development
step "Development (optional)"
install_app "com.vscodium.codium"                  "VSCodium"          "VS Code (without telemetry)"

step "Summary of installed apps"
echo ""
echo "  Installed FOSS apps:"
flatpak list --app --columns=name 2>/dev/null | head -20
echo ""

if [[ $INSTALL_FAILURES -gt 0 ]]; then
    warn "$INSTALL_FAILURES app(s) failed to install. You can install them manually with flatpak."
fi

step "Manual steps remaining"
echo ""
echo "  1. EMAIL: Sign up at https://proton.me (free plan available)"
echo "     → Forward your Gmail to ProtonMail"
echo "     → After 30 days, stop using Gmail"
echo ""
echo "  2. SEARCH: Set DuckDuckGo or Brave Search as default"
echo "     → In Firefox: Settings → Search → Default Search Engine"
echo ""
echo "  3. MAPS: Install OsmAnd or Organic Maps on your phone"
echo "     → F-Droid (Android): https://f-droid.org"
echo "     → Or from app stores"
echo ""
echo "  4. PHONE (advanced): GrapheneOS on a Pixel phone"
echo "     → https://grapheneos.org/install"
echo ""
echo "  5. EXPORT GOOGLE DATA:"
echo "     → Go to https://takeout.google.com"
echo "     → Select all services → Export → Download"
echo "     → Import into your new apps"
echo ""

echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Phase 3: Warrior — COMPLETE             ║${NC}"
echo -e "${GREEN}║                                           ║${NC}"
echo -e "${GREEN}║   Google is losing its grip on you.        ║${NC}"
echo -e "${GREEN}║   Next: Phase 4 — Knight (your own server) ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
