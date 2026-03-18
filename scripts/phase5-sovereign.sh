#!/usr/bin/env bash
# ============================================================================
# Sovereign Stack — Phase 5: Sovereign
# Full integration, hardening, and connection of all services
# ============================================================================
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }
step() { echo -e "\n${CYAN}━━━ $1 ━━━${NC}\n"; }

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

DOMAIN="${1:---help}"

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║   Sovereign Stack — Phase 5: Sovereign    ║"
echo "  ║   Full Integration & Hardening            ║"
echo "  ╚═══════════════════════════════════════════╝"
echo -e "${NC}"

if [[ "$DOMAIN" == "--help" || "$DOMAIN" == "-h" ]]; then
    echo "Usage: bash phase5-sovereign.sh --domain yourdomain.com"
    echo ""
    echo "This script:"
    echo "  1. Installs Caddy reverse proxy with auto-HTTPS"
    echo "  2. Hardens the server (UFW, fail2ban, SSH)"
    echo "  3. Sets up encrypted backups"
    echo "  4. Configures WireGuard VPN"
    echo "  5. Prints the final integration checklist"
    echo ""
    echo "Options:"
    echo "  --check         Run pre-flight checks only (no install)"
    echo "  --dry-run       Same as --check"
    exit 0
fi

# Parse flags
CHECK_ONLY=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --domain) DOMAIN="$2"; shift ;;
        --check|--dry-run) CHECK_ONLY=true ;;
        *) ;;
    esac
    shift
done

preflight_check

if [[ "$CHECK_ONLY" == true ]]; then
    log "Check-only mode: exiting without installing."
    exit 0
fi

# ============================================================================
step "1. Caddy Reverse Proxy (auto-HTTPS)"
if [[ -n "$DOMAIN" && "$DOMAIN" != "--help" ]]; then
    mkdir -p /opt/sovereign-stack/caddy

    cat > /opt/sovereign-stack/caddy/Caddyfile << CADDY
# Sovereign Stack — Caddy Reverse Proxy
{
    email admin@${DOMAIN}
}

cloud.${DOMAIN} {
    reverse_proxy localhost:8080
}

vault.${DOMAIN} {
    reverse_proxy localhost:8081
}

search.${DOMAIN} {
    reverse_proxy localhost:8082
}

photos.${DOMAIN} {
    reverse_proxy localhost:8083
}

chat.${DOMAIN} {
    reverse_proxy localhost:8084
}

element.${DOMAIN} {
    reverse_proxy localhost:8085
}

meet.${DOMAIN} {
    reverse_proxy localhost:8086
}

git.${DOMAIN} {
    reverse_proxy localhost:8087
}
CADDY

    # Add Caddy to docker-compose
    if ! docker ps | grep -q sovereign-caddy; then
        docker run -d \
            --name sovereign-caddy \
            --restart unless-stopped \
            --network host \
            -v /opt/sovereign-stack/caddy/Caddyfile:/etc/caddy/Caddyfile \
            -v caddy_data:/data \
            -v caddy_config:/config \
            caddy:latest
    fi
    log "Caddy running with auto-HTTPS for *.${DOMAIN}"
else
    warn "No domain provided — skipping HTTPS. Access services by IP:port"
fi

# ============================================================================
step "2. Server Hardening"

# UFW Firewall
if command -v ufw &>/dev/null; then
    ufw --force reset
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow 22/tcp    # SSH
    ufw allow 80/tcp    # HTTP
    ufw allow 443/tcp   # HTTPS
    ufw allow 53/tcp    # DNS (AdGuard)
    ufw allow 53/udp    # DNS (AdGuard)
    ufw allow 51820/udp # WireGuard
    ufw --force enable
    log "UFW firewall configured"
else
    apt install -y ufw
    warn "UFW installed — re-run this script to configure"
fi

# fail2ban
if ! command -v fail2ban-client &>/dev/null; then
    apt install -y fail2ban
fi
cat > /etc/fail2ban/jail.local << 'F2B'
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = ssh
F2B
systemctl enable --now fail2ban
log "fail2ban enabled (SSH protection)"

# SSH hardening
if ! grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config 2>/dev/null; then
    warn "Consider disabling SSH password auth:"
    warn "  1. Add your SSH key: ssh-copy-id root@server"
    warn "  2. Set PasswordAuthentication no in /etc/ssh/sshd_config"
    warn "  3. Restart: systemctl restart sshd"
fi

# ============================================================================
step "3. Encrypted Backups"

if ! command -v rclone &>/dev/null; then
    curl -fsSL https://rclone.org/install.sh | bash
    log "rclone installed"
fi

cat > /opt/sovereign-stack/backup.sh << 'BACKUP'
#!/usr/bin/env bash
# Sovereign Stack — Daily Encrypted Backup
set -euo pipefail
BACKUP_DIR="/opt/sovereign-stack/backups/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting backup..."

# Dump databases
docker exec sovereign-mariadb mysqldump -u root --all-databases 2>/dev/null > "$BACKUP_DIR/mariadb.sql" || true
docker exec sovereign-matrix-db pg_dumpall -U synapse 2>/dev/null > "$BACKUP_DIR/matrix-pg.sql" || true
docker exec sovereign-immich-db pg_dumpall -U postgres 2>/dev/null > "$BACKUP_DIR/immich-pg.sql" || true

# Backup volumes
tar czf "$BACKUP_DIR/nextcloud.tar.gz" -C /var/lib/docker/volumes/ sovereign-stack_nextcloud_data 2>/dev/null || true
tar czf "$BACKUP_DIR/vaultwarden.tar.gz" -C /var/lib/docker/volumes/ sovereign-stack_vaultwarden_data 2>/dev/null || true

# Encrypt
if command -v gpg &>/dev/null; then
    tar czf - "$BACKUP_DIR" | gpg --symmetric --cipher-algo AES256 --batch --passphrase-file /root/.backup-passphrase -o "$BACKUP_DIR.tar.gz.gpg"
    rm -rf "$BACKUP_DIR"
    echo "[$(date)] Encrypted backup: $BACKUP_DIR.tar.gz.gpg"
fi

# Upload (configure rclone first: rclone config)
# rclone copy "$BACKUP_DIR.tar.gz.gpg" remote:sovereign-backups/

echo "[$(date)] Backup complete"
BACKUP
chmod +x /opt/sovereign-stack/backup.sh

# Create cron
(crontab -l 2>/dev/null; echo "0 3 * * * /opt/sovereign-stack/backup.sh >> /var/log/sovereign-backup.log 2>&1") | sort -u | crontab -
log "Daily backup configured (3 AM)"
warn "Configure rclone for remote backup: rclone config"

# ============================================================================
step "4. WireGuard VPN"

if ! command -v wg &>/dev/null; then
    apt install -y wireguard
fi

if [[ ! -f /etc/wireguard/wg0.conf ]]; then
    WG_PRIVKEY=$(wg genkey)
    WG_PUBKEY=$(echo "$WG_PRIVKEY" | wg pubkey)
    SERVER_IP=$(curl -s ifconfig.me)

    cat > /etc/wireguard/wg0.conf << WG
[Interface]
PrivateKey = $WG_PRIVKEY
Address = 10.66.66.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Add clients below:
# [Peer]
# PublicKey = CLIENT_PUBLIC_KEY
# AllowedIPs = 10.66.66.2/32
WG

    systemctl enable --now wg-quick@wg0
    log "WireGuard running on port 51820"
    echo ""
    echo "  Server public key: $WG_PUBKEY"
    echo "  Server IP: $SERVER_IP"
    echo ""
    echo "  To add a client:"
    echo "    1. On client: wg genkey | tee privatekey | wg pubkey > publickey"
    echo "    2. Add [Peer] block to /etc/wireguard/wg0.conf on server"
    echo "    3. Restart: wg-quick down wg0 && wg-quick up wg0"
else
    log "WireGuard already configured"
fi

# ============================================================================
step "5. Final Sovereignty Checklist"

echo ""
echo -e "  ${CYAN}YOUR SERVICES:${NC}"
[[ -n "$DOMAIN" && "$DOMAIN" != "--help" ]] && {
    echo "  Cloud:     https://cloud.${DOMAIN}"
    echo "  Passwords: https://vault.${DOMAIN}"
    echo "  Search:    https://search.${DOMAIN}"
    echo "  Photos:    https://photos.${DOMAIN}"
    echo "  Chat:      https://element.${DOMAIN}"
    echo "  Video:     https://meet.${DOMAIN}"
    echo "  Git:       https://git.${DOMAIN}"
} || {
    echo "  Cloud:     http://YOUR_IP:8080"
    echo "  Passwords: http://YOUR_IP:8081"
    echo "  Search:    http://YOUR_IP:8082"
    echo "  Photos:    http://YOUR_IP:8083"
    echo "  Chat:      http://YOUR_IP:8085"
    echo "  Video:     http://YOUR_IP:8086"
    echo "  Git:       http://YOUR_IP:8087"
    echo "  DNS:       http://YOUR_IP:3000"
}
echo ""
echo -e "  ${CYAN}CONNECT YOUR DEVICES:${NC}"
echo "  [ ] Phone: Install Nextcloud app, Bitwarden app, Element app"
echo "  [ ] Phone: Set DNS to your AdGuard (VPS_IP or via WireGuard)"
echo "  [ ] Desktop: Install Nextcloud sync client"
echo "  [ ] Desktop: Install Bitwarden extension in Firefox"
echo "  [ ] Desktop: Set SearXNG as default search engine"
echo "  [ ] Desktop: Connect WireGuard VPN"
echo "  [ ] All devices: Enable WireGuard"
echo ""
echo -e "  ${CYAN}FINAL STEPS:${NC}"
echo "  [ ] Export Google data from https://takeout.google.com"
echo "  [ ] Import data to Nextcloud, Immich, Vaultwarden"
echo "  [ ] Forward Gmail to your new email"
echo "  [ ] After 30 days: close Gmail"
echo "  [ ] After 60 days: delete Google account"
echo ""

echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}║   PHASE 5: SOVEREIGN — COMPLETE                   ║${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}║   You answer to no one.                           ║${NC}"
echo -e "${GREEN}║   Every byte is yours.                            ║${NC}"
echo -e "${GREEN}║   You are sovereign.                              ║${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
