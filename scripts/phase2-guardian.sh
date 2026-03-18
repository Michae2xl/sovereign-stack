#!/usr/bin/env bash
# ============================================================================
# Sovereign Stack — Phase 2: Guardian
# Firefox hardening + privacy extensions
# ============================================================================

export DEBIAN_FRONTEND=noninteractive

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }
step() { echo -e "\n${CYAN}━━━ $1 ━━━${NC}\n"; }

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║   Sovereign Stack — Phase 2: Guardian     ║"
echo "  ║   Browser Hardening                       ║"
echo "  ╚═══════════════════════════════════════════╝"
echo -e "${NC}"

# Detect package manager
if command -v apt &>/dev/null; then
    PKG="apt"
elif command -v dnf &>/dev/null; then
    PKG="dnf"
elif command -v pacman &>/dev/null; then
    PKG="pacman"
else
    PKG="unknown"
fi

step "Ensuring Firefox is installed"

# Detect if Firefox is a snap (Ubuntu 22.04+)
FIREFOX_IS_SNAP=false
if command -v snap &>/dev/null && snap list firefox &>/dev/null 2>&1; then
    FIREFOX_IS_SNAP=true
    log "Firefox detected as snap package"
fi

if command -v firefox &>/dev/null; then
    log "Firefox already installed: $(firefox --version 2>/dev/null || echo 'detected')"
else
    case $PKG in
        apt)    sudo apt-get install -y firefox ;;
        dnf)    sudo dnf install -y firefox ;;
        pacman) sudo pacman -S --noconfirm firefox ;;
        *)      warn "Install Firefox manually from https://www.mozilla.org/firefox/" ;;
    esac
    if command -v firefox &>/dev/null; then
        log "Firefox installed"
    else
        warn "Firefox installation may have failed. Continuing anyway."
    fi
fi

step "Finding Firefox profile"

# Determine the correct profile directory
if $FIREFOX_IS_SNAP; then
    FIREFOX_DIR="$HOME/snap/firefox/common/.mozilla/firefox"
else
    FIREFOX_DIR="$HOME/.mozilla/firefox"
fi

PROFILE=""
if [[ -d "$FIREFOX_DIR" ]]; then
    PROFILE=$(find "$FIREFOX_DIR" -maxdepth 1 -name "*.default-release" -type d 2>/dev/null | head -1)
    if [[ -z "$PROFILE" ]]; then
        PROFILE=$(find "$FIREFOX_DIR" -maxdepth 1 -name "*.default" -type d 2>/dev/null | head -1)
    fi
fi

if [[ -z "${PROFILE:-}" ]]; then
    warn "No Firefox profile found. Creating a temporary profile..."
    # Start Firefox headless and wait for profile creation
    firefox --headless &>/dev/null &
    FIREFOX_PID=$!
    # Wait up to 10 seconds for the profile to appear
    for i in $(seq 1 10); do
        sleep 1
        if [[ -d "$FIREFOX_DIR" ]]; then
            PROFILE=$(find "$FIREFOX_DIR" -maxdepth 1 -name "*.default-release" -type d 2>/dev/null | head -1)
            [[ -n "$PROFILE" ]] && break
            PROFILE=$(find "$FIREFOX_DIR" -maxdepth 1 -name "*.default" -type d 2>/dev/null | head -1)
            [[ -n "$PROFILE" ]] && break
        fi
    done
    # Properly terminate Firefox
    if kill -0 "$FIREFOX_PID" 2>/dev/null; then
        kill "$FIREFOX_PID" 2>/dev/null || true
        # Wait for process to actually exit (up to 5 seconds)
        for i in $(seq 1 5); do
            kill -0 "$FIREFOX_PID" 2>/dev/null || break
            sleep 1
        done
        # Force kill if still running
        kill -9 "$FIREFOX_PID" 2>/dev/null || true
    fi
    wait "$FIREFOX_PID" 2>/dev/null || true
fi

if [[ -n "${PROFILE:-}" ]]; then
    step "Hardening Firefox (user.js)"
    cat > "$PROFILE/user.js" << 'USERJS'
// Sovereign Stack — Firefox Hardening
// Privacy
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.firstparty.isolate", true);

// HTTPS-only
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

// Cookies
user_pref("network.cookie.cookieBehavior", 5);
user_pref("network.cookie.lifetimePolicy", 2);

// Disable telemetry
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("browser.ping-centre.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

// Disable WebRTC leak
user_pref("media.peerconnection.enabled", false);

// Disable geolocation
user_pref("geo.enabled", false);

// Disable Pocket
user_pref("extensions.pocket.enabled", false);

// Disable prefetching
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.predictor.enabled", false);

// Search
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.searches", false);

// DRM (optional — disable if you don't use Netflix/Spotify in browser)
// user_pref("media.eme.enabled", false);
USERJS
    log "Firefox hardened with user.js"
else
    warn "Could not find Firefox profile — apply settings manually via about:config"
fi

step "Recommended extensions (install manually)"
echo ""
echo "  Open Firefox and install these extensions:"
echo ""
echo "  1. uBlock Origin (ad + tracker blocker)"
echo "     https://addons.mozilla.org/firefox/addon/ublock-origin/"
echo ""
echo "  2. Privacy Badger (learns to block trackers)"
echo "     https://addons.mozilla.org/firefox/addon/privacy-badger17/"
echo ""
echo "  3. Cookie AutoDelete (clears cookies on tab close)"
echo "     https://addons.mozilla.org/firefox/addon/cookie-autodelete/"
echo ""
echo "  4. Multi-Account Containers (isolate sites)"
echo "     https://addons.mozilla.org/firefox/addon/multi-account-containers/"
echo ""
echo "  5. Decentraleyes (local CDN emulation)"
echo "     https://addons.mozilla.org/firefox/addon/decentraleyes/"
echo ""

step "Installing Tor Browser (optional, for maximum anonymity)"
if ! command -v torbrowser-launcher &>/dev/null; then
    case $PKG in
        apt)    sudo apt-get install -y torbrowser-launcher && log "Tor Browser launcher installed" || warn "Tor Browser launcher install failed" ;;
        dnf)    sudo dnf install -y torbrowser-launcher && log "Tor Browser launcher installed" || warn "Tor Browser launcher install failed" ;;
        pacman) warn "Install from AUR: yay -S tor-browser" ;;
        *)      warn "Install Tor Browser from https://www.torproject.org/" ;;
    esac
else
    log "Tor Browser launcher already installed"
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Phase 2: Guardian — COMPLETE            ║${NC}"
echo -e "${GREEN}║                                           ║${NC}"
echo -e "${GREEN}║   Your browser is now hardened.            ║${NC}"
echo -e "${GREEN}║   Next: Phase 3 — Warrior (degoogle apps) ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
