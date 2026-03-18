---
name: sovereign
description: "Sovereign Stack — complete digital privacy for humans in one command. From Hero to Sovereign in 5 phases: Linux, hardened browser, FOSS apps, self-hosted VPS (Nextcloud, Vaultwarden, SearXNG, Immich, Matrix, Jitsi, AdGuard, WireGuard, Forgejo, Stalwart Mail), full integration with HTTPS, encrypted backups, and Tor .onion. Triggers: 'sovereign', 'sovereign stack', 'human privacy', 'degoogle', 'digital freedom', 'self-hosted human', 'replace google', 'hero to sovereign'."
---

# Skill Sovereign — Sovereign Stack

> **From Hero to Sovereign in one command.** Complete digital privacy for humans.

**Repo:** https://github.com/Michae2xl/sovereign-stack

---

## What This Skill Does

Installs the full Sovereign Stack at once:

1. **Phase 1 — Hero:** Linux post-install (update, tools, Flatpak, firewall)
2. **Phase 2 — Guardian:** Firefox hardened (user.js, extensions, Tor Browser)
3. **Phase 3 — Warrior:** FOSS apps via Flatpak (Signal, Bitwarden, FreeTube, LibreOffice, Element, etc)
4. **Phase 4 — Knight:** VPS with 10+ self-hosted services (Nextcloud, Vaultwarden, SearXNG, Immich, Matrix, Jitsi, AdGuard, Forgejo)
5. **Phase 5 — Sovereign:** Caddy auto-HTTPS, WireGuard VPN, encrypted backups, server hardening, Tor .onion

---

## Full Install (1 Command)

### Local machine (Phases 1-3):
```bash
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/sovereign-local.sh | bash
```

### VPS (Phases 4-5):
```bash
ssh root@YOUR_VPS_IP
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/sovereign-vps.sh -o sovereign.sh
bash sovereign.sh --all --domain yourdomain.com
```

### No domain (works via IP + Tor .onion):
```bash
bash sovereign.sh --all
```

---

## How To Use This Skill

### When the user arrives, ask:

1. **Where to install?** (local machine? VPS? both?)
2. **Running Linux?** (if not, start at Phase 1)
3. **Have a VPS?** (if not, recommend Hetzner/Njalla/1984.is)
4. **Have a domain?** (optional — works without one)
5. **What to prioritize?** (everything? specific services only?)

### Based on answers:

| Situation | Command |
|-----------|---------|
| Everything at once (local + VPS) | `sovereign-local.sh` + `sovereign-vps.sh --all` |
| Local machine only (no VPS) | `sovereign-local.sh` (Phases 1-3) |
| VPS only (Linux already set up) | `sovereign-vps.sh --all --domain X` |
| Specific services | `sovereign-vps.sh --nextcloud --vaultwarden --searxng` |

---

## Installed Services (VPS)

| Service | Replaces | Port | Subdomain |
|---------|----------|------|-----------|
| **Nextcloud + MariaDB** | Google Drive/Docs/Calendar | 8080 | cloud. |
| **Vaultwarden** | LastPass/1Password | 8081 | vault. |
| **SearXNG** | Google Search | 8082 | search. |
| **Immich + PostgreSQL** | Google Photos | 8083 | photos. |
| **Matrix/Synapse** | WhatsApp/Discord | 8084 | chat. |
| **Element** | Discord/Teams | 8085 | element. |
| **Jitsi Meet** | Zoom/Google Meet | 8086 | meet. |
| **Forgejo** | GitHub/GitLab | 8087 | git. |
| **AdGuard Home** | Google DNS | 3000/53 | dns. |
| **WireGuard** | NordVPN/ExpressVPN | 51820 | — |
| **Stalwart Mail** | Gmail (server) | 25/143 | mail. |
| **Caddy** | — (reverse proxy) | 80/443 | — |

### Infrastructure
| Service | Function |
|---------|----------|
| UFW + fail2ban | Firewall + SSH protection |
| Rclone + GPG | Daily encrypted backup |
| Tor | .onion hidden services |

---

## Installed Apps (Local — Flatpak)

| App | Replaces |
|-----|----------|
| Signal | WhatsApp/Google Messages |
| Element | Discord/Slack |
| Bitwarden | Chrome passwords |
| KeePassXC | Google Authenticator (desktop) |
| LibreOffice | Google Docs |
| Joplin | Google Keep |
| FreeTube | YouTube |
| Thunderbird | Gmail client |
| VLC | Google Play Movies |
| GIMP | Google Photos editor |
| VSCodium | VS Code (without telemetry) |

---

## Journey Overview

```
  Phase 1        Phase 2        Phase 3        Phase 4        Phase 5
  +------+      +------+      +------+      +------+      +------+
  | HERO | ---> |GUARD.| ---> |WARR. | ---> |KNIGHT| ---> |SOVER.|
  |      |      |      |      |      |      |      |      |      |
  |  OS  |      |Browse|      | Apps |      | VPS  |      | Full |
  +------+      +------+      +------+      +------+      +------+
   ~30min        ~30min        ~45min        ~60min        ~30min

  LOCAL <-----------------------|  VPS  |----------------------->
  (Phases 1-3)                  (Phases 4-5)
```

---

## Final Sovereignty Checklist

- [ ] Linux installed with disk encryption
- [ ] Firefox hardened + uBlock Origin + Privacy Badger
- [ ] Tor Browser installed
- [ ] FOSS apps installed (Signal, Bitwarden, FreeTube, etc)
- [ ] VPS with all services running
- [ ] Caddy with auto-HTTPS
- [ ] WireGuard VPN on all devices
- [ ] AdGuard DNS blocking ads/trackers
- [ ] Nextcloud syncing on all devices
- [ ] Vaultwarden with all passwords
- [ ] Immich backing up photos
- [ ] SearXNG as default search
- [ ] Daily encrypted backups
- [ ] Google data exported and account emptied

---

## Requirements

### Local Machine
- Any computer with Linux (or willingness to install)
- 4GB+ RAM, 20GB+ disk

### VPS (Phases 4-5)
| | Minimum | Recommended |
|---|---------|-------------|
| RAM | 4GB | 8GB+ |
| CPU | 2 vCPUs | 4+ vCPUs |
| Disk | 40GB | 80GB+ |
| OS | Ubuntu 22.04 | Ubuntu 24.04 |
| Cost | ~EUR 6/mo | ~EUR 12/mo |

### Privacy-Friendly VPS Providers
| Provider | Privacy | Price (8GB) |
|----------|---------|-------------|
| Hetzner | GDPR | ~EUR 9/mo |
| Njalla | Zero KYC, crypto | ~EUR 15/mo |
| 1984.is | Iceland | ~EUR 15/mo |
| Contabo | Standard | ~EUR 6/mo |

---

## Troubleshooting

```bash
# Check container status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep sovereign

# Service logs
docker logs sovereign-nextcloud --tail 50

# Restart all
cd /opt/sovereign-stack && docker compose restart

# Check credentials
cat /root/sovereign-stack-credentials.txt

# Check firewall
ufw status

# Check WireGuard
wg show
```

---

## Relation to Freedom Stack

| Project | Audience | Focus |
|---------|----------|-------|
| **Sovereign Stack** (this skill) | Humans | Personal privacy, degoogle, self-hosted |
| **Freedom Stack** (agent-shielded skill) | Devs/AI Agents | Agent Privacy Cloud (Ollama, n8n, Qdrant, Tor) |

They can run **together on the same VPS** — fully complementary.

```bash
# Install sovereign (human) + freedom (agents) on the same VPS:
bash sovereign.sh --all --domain yourdomain.com
bash install.sh --agents --searxng --tor --security
```
