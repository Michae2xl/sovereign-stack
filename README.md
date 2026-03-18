<div align="center">

# Sovereign Stack

### From Hero to Sovereign — Your Complete Digital Freedom Journey

**Stop giving your life to Big Tech. Take it back, one phase at a time.**

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)
[![Phases](https://img.shields.io/badge/phases-5-green)]()
[![Services](https://img.shields.io/badge/self--hosted_services-10+-purple)]()

[Start Now](#phase-1-hero) · [Why This Matters](#why) · [The Journey](#the-journey) · [FAQ](#faq)

---

> **You don't need to be a hacker.** Each phase takes 30-60 minutes. Follow the guide. Run the scripts. Own your digital life.

</div>

---

## The Journey

5 phases. Each one builds on the last. Start wherever you are.

```
  Phase 1        Phase 2        Phase 3        Phase 4        Phase 5
  +------+      +------+      +------+      +------+      +------+
  | HERO | ---> |GUARD.| ---> |WARR. | ---> |KNIGHT| ---> |SOVER.|
  |      |      |      |      |      |      |      |      |      |
  |  OS  |      |Browse|      | Apps |      | VPS  |      | Full |
  +------+      +------+      +------+      +------+      +------+
   ~30min        ~30min        ~45min        ~60min        ~30min
```

| Phase | Level | What You Do | What You Gain |
|-------|-------|-------------|---------------|
| **1** | **Hero** | Install Linux | OS free from Microsoft/Apple telemetry |
| **2** | **Guardian** | Harden your browser | Browsing without tracking |
| **3** | **Warrior** | Replace Google apps | Email, cloud, passwords, search — all yours |
| **4** | **Knight** | Deploy your own server | Self-hosted services on your VPS |
| **5** | **Sovereign** | Connect everything | Full digital sovereignty, nothing leaks |

### One-button install

```bash
# Local machine (phases 1-3):
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/sovereign-local.sh | bash

# VPS (phases 4-5):
ssh root@YOUR_VPS_IP
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/sovereign-vps.sh -o sovereign.sh
bash sovereign.sh --all --domain yourdomain.com
```

---

## Phase 1: Hero

**Leave Windows/macOS. Enter Linux.**

> *"The first step to freedom is owning the ground you stand on."*

### What you replace
| Before | After |
|--------|-------|
| Windows 11 (telemetry to Microsoft) | Linux Mint / Fedora / Pop!_OS |
| macOS (locked to Apple ecosystem) | Full control of your hardware |

### Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/phase1-hero.sh -o phase1.sh
bash phase1.sh
```

### Manual guide

1. **Choose your distro:**
   - **First time?** → [Linux Mint](https://linuxmint.com/) (looks like Windows, just works)
   - **Developer?** → [Fedora](https://fedoraproject.org/) (cutting edge, secure by default)
   - **Gaming?** → [Pop!_OS](https://pop.system76.com/) (Nvidia support out of the box)

2. **Create a bootable USB:**
   - Download [Ventoy](https://ventoy.net/) → copy ISO to USB → boot from it

3. **Install:** Follow the guided installer (15 minutes)

4. **Post-install essentials:**
   ```bash
   sudo apt update && sudo apt upgrade -y   # Debian/Ubuntu/Mint
   sudo dnf upgrade -y                       # Fedora
   sudo apt install -y curl wget git htop neofetch
   ```

**Phase 1 complete.** You now own your operating system.

[Full Phase 1 Guide →](docs/phase1-hero.md)

---

## Phase 2: Guardian

**Your browser is the biggest leak. Fix it.**

> *"Every tab you open tells a story. Make sure only you can read it."*

### What you replace
| Before | After |
|--------|-------|
| Chrome (Google sees everything) | Firefox hardened + uBlock Origin |
| Google Search | SearXNG / DuckDuckGo / Brave Search |
| Chrome password manager | Bitwarden (or KeePassXC offline) |
| No anonymous browsing | Tor Browser (maximum anonymity) |

### Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/phase2-guardian.sh -o phase2.sh
bash phase2.sh
```

### Manual guide

1. **Install Firefox** (comes pre-installed on most Linux distros)

2. **Essential extensions:**
   - [uBlock Origin](https://addons.mozilla.org/firefox/addon/ublock-origin/) — blocks ads + trackers
   - [Privacy Badger](https://privacybadger.org/) — learns to block invisible trackers
   - [HTTPS Everywhere](https://www.eff.org/https-everywhere) — forces encrypted connections
   - [Cookie AutoDelete](https://addons.mozilla.org/firefox/addon/cookie-autodelete/) — clears cookies on tab close
   - [Multi-Account Containers](https://addons.mozilla.org/firefox/addon/multi-account-containers/) — isolate sites from each other

3. **Harden Firefox settings:**
   - Go to `about:config` and set:
   ```
   privacy.trackingprotection.enabled = true
   privacy.resistFingerprinting = true
   network.cookie.cookieBehavior = 5
   dom.security.https_only_mode = true
   geo.enabled = false
   media.peerconnection.enabled = false    # disables WebRTC leak
   ```

4. **Change default search engine:**
   - Settings → Search → Default Search Engine → DuckDuckGo
   - Or self-host SearXNG later in Phase 4

**Phase 2 complete.** Your browsing is now private.

[Full Phase 2 Guide →](docs/phase2-guardian.md)

---

## Phase 3: Warrior

**Replace every Google app with something you control.**

> *"Every app you degoogle is a chain you break."*

### The Great Replacement

| Google Service | Replacement | Why It's Better |
|----------------|-------------|-----------------|
| **Gmail** | **ProtonMail** / Tuta | E2E encrypted, no ads, Swiss/German law |
| **Google Drive** | **Nextcloud** (Phase 4) or Proton Drive | Your server, your files |
| **Google Photos** | **Immich** (self-hosted) | Identical UX, zero cloud dependency |
| **Google Calendar** | **Proton Calendar** / Nextcloud | Encrypted, syncs with phone |
| **Google Maps** | **OsmAnd** / Organic Maps | Offline maps, no tracking |
| **Google Docs** | **LibreOffice** / Nextcloud Office | Full office suite, no cloud lock-in |
| **Google Keep** | **Joplin** / Standard Notes | E2E encrypted notes |
| **YouTube** | **FreeTube** / NewPipe (Android) | No ads, no tracking, no recommendations |
| **Google Authenticator** | **Aegis** (Android) / Ente Auth | Open source, encrypted backup |
| **Google Messages** | **Signal** / Element (Matrix) | E2E encrypted by default |
| **Chrome passwords** | **Bitwarden** / KeePassXC | Open source, cross-platform |
| **Google DNS** | **NextDNS** / AdGuard Home (Phase 4) | No DNS logging |
| **Android stock** | **GrapheneOS** / LineageOS | Degoogled Android |

### Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/phase3-warrior.sh -o phase3.sh
bash phase3.sh
```

### Priority order (do these first)

1. **Email** — Switch to ProtonMail. Forward Gmail. After 30 days, delete Gmail.
2. **Passwords** — Export Chrome passwords → import to Bitwarden
3. **Search** — Set DuckDuckGo/Brave Search as default everywhere
4. **Messages** — Install Signal, convince your close contacts
5. **Photos** — Set up Immich (Phase 4) or use Proton Drive
6. **2FA** — Export Google Authenticator → Aegis/Ente Auth
7. **Phone** — GrapheneOS if you have a Pixel (best option)

### Data export from Google

```bash
# Go to https://takeout.google.com
# Select: Gmail, Drive, Photos, Calendar, Contacts, Chrome bookmarks
# Export → Download → Import into new services
```

**Phase 3 complete.** Google no longer has your daily data.

[Full Phase 3 Guide →](docs/phase3-warrior.md)

---

## Phase 4: Knight

**Deploy your own server. Own the infrastructure.**

> *"A knight doesn't rent his castle. He builds it."*

This is where you get your own VPS and self-host everything.

### What you deploy

| Service | Replaces | What It Does |
|---------|----------|--------------|
| **Nextcloud** | Google Drive/Docs/Calendar | Files, office, calendar — all yours |
| **Vaultwarden** | LastPass, 1Password | Password manager for the whole family |
| **Matrix/Element** | WhatsApp, Discord | E2E encrypted chat, your server |
| **SearXNG** | Google Search | Private metasearch, no tracking |
| **Immich** | Google Photos | Photo backup with AI features |
| **Jitsi Meet** | Zoom, Google Meet | Video calls, no account needed |
| **AdGuard Home** | Google DNS | Network-wide ad blocking |
| **WireGuard** | NordVPN, ExpressVPN | Your own VPN |
| **Stalwart Mail** | Gmail (server-side) | Full mail server |
| **Forgejo** | GitHub | Your own Git hosting |

### Quick start

```bash
# SSH into your VPS
ssh root@YOUR_VPS_IP

# Download and run
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/phase4-knight.sh -o phase4.sh

# Install all human services
bash phase4.sh --all --domain yourdomain.com

# Or pick what you need
bash phase4.sh --nextcloud --vaultwarden --searxng --domain yourdomain.com
```

### VPS Providers (privacy-friendly)

| Provider | Privacy | Price (8GB) | Notes |
|----------|---------|-------------|-------|
| **Hetzner** | GDPR | ~EUR 9/mo | Best price/performance |
| **Njalla** | Zero KYC | ~EUR 15/mo | Crypto only, Pirate Bay founder |
| **1984.is** | Iceland | ~EUR 15/mo | Strongest free speech laws |
| **Contabo** | OK | ~EUR 6/mo | Cheapest option |

### Requirements

| | Minimum | Recommended |
|---|---------|-------------|
| RAM | 4GB | 8GB+ |
| CPU | 2 vCPUs | 4+ vCPUs |
| Disk | 40GB | 80GB+ |
| OS | Ubuntu 22.04 | Ubuntu 24.04 |

**Phase 4 complete.** You have your own infrastructure.

[Full Phase 4 Guide →](docs/phase4-knight.md)

---

## Phase 5: Sovereign

**Connect everything. Close every leak. Full sovereignty.**

> *"The sovereign answers to no one. Every byte is yours."*

### What happens here

1. **Phone to VPS:** Nextcloud sync, Vaultwarden auto-fill, Matrix on Element
2. **Desktop to VPS:** Nextcloud client, WireGuard always-on, SearXNG as default search
3. **DNS to AdGuard:** All devices use your private DNS (blocks ads + trackers network-wide)
4. **Email to your server:** Stalwart Mail receives, ProtonMail forwards
5. **Backups encrypted:** Rclone encrypts + uploads to Mega.nz / Backblaze B2
6. **Monitoring via Grafana:** You see everything, nobody else does
7. **Tor .onion services:** Access your stack from anywhere without exposing your IP

### Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/phase5-sovereign.sh -o phase5.sh
bash phase5.sh --domain yourdomain.com
```

### The final checklist

- [ ] All devices use WireGuard VPN
- [ ] All devices use AdGuard DNS
- [ ] All passwords in Vaultwarden
- [ ] All files in Nextcloud
- [ ] All photos in Immich
- [ ] All messages on Signal/Matrix
- [ ] All searches on SearXNG
- [ ] All email on your server
- [ ] Google account data exported and deleted
- [ ] Google account closed or empty
- [ ] No more Chrome, no more Google DNS, no more Google anything

**Phase 5 complete.** You are sovereign.

[Full Phase 5 Guide →](docs/phase5-sovereign.md)

---

## Why

### The numbers

- Google has **15+ years** of your data
- Gmail scans **1.8 billion** accounts
- Chrome has **65%** browser market share
- Google DNS (8.8.8.8) resolves **1 trillion+** queries/day
- Android sends location to Google **340 times/day** (even with GPS off)

### The risk

- Data breaches (Google was breached in 2018, exposed 500K accounts)
- Government requests (Google complied with **83%** of data requests in 2023)
- Ad profiling (Google knows your health, politics, finances, relationships)
- Vendor lock-in (try leaving Google — it's designed to be hard)
- Terms of Service change (they can, and do, change what they do with your data)

### The solution

**Sovereign Stack.** Step by step. No hacking required. Just follow the guide.

---

## FAQ

**Q: I'm not technical. Can I do this?**
A: Yes. Phase 1-3 require zero server knowledge. Phase 4-5 have scripts that do the heavy lifting.

**Q: How long does the full journey take?**
A: You can complete all 5 phases in a weekend. But there's no rush — each phase is independent.

**Q: Does it cost money?**
A: Phases 1-3 are free. Phase 4-5 need a VPS (~EUR 6-18/month). That's less than a Netflix subscription for owning your entire digital life.

**Q: Can I do this on Mac?**
A: Phases 2-5 work on macOS. Phase 1 (Linux) is optional if you're on Mac — skip it and start at Phase 2.

**Q: What about my phone?**
A: Phase 3 covers app replacements for Android/iOS. For maximum privacy: GrapheneOS on a Google Pixel.

**Q: Is this related to Freedom Stack?**
A: Yes. [Freedom Stack](https://github.com/Michae2xl/freedom-stack) is the **Agent Privacy Cloud** — infrastructure for AI agents. Sovereign Stack is the **human journey** — your personal digital freedom. They complement each other: Phase 4 can optionally include the Agent Privacy Cloud.

---

## Project Structure

```
sovereign-stack/
├── README.md                    <- You are here
├── LICENSE                      <- AGPL v3
├── CONTRIBUTING.md
├── skills/
│   └── sovereign/SKILL.md        <- Claude Code skill
├── scripts/
│   ├── sovereign-local.sh       <- One-button local (phases 1-3)
│   ├── sovereign-vps.sh         <- One-button VPS (phases 4-5)
│   ├── phase1-hero.sh           <- Linux post-install essentials
│   ├── phase2-guardian.sh       <- Firefox hardening + extensions
│   ├── phase3-warrior.sh        <- App replacements helper
│   ├── phase4-knight.sh         <- VPS self-hosted deploy
│   └── phase5-sovereign.sh      <- Full integration + hardening
└── docs/
    ├── phase1-hero.md           <- Detailed Phase 1 guide
    ├── phase2-guardian.md       <- Detailed Phase 2 guide
    ├── phase3-warrior.md        <- Detailed Phase 3 guide
    ├── phase4-knight.md         <- Detailed Phase 4 guide
    └── phase5-sovereign.md      <- Detailed Phase 5 guide
```

---

## License

[GNU Affero General Public License v3.0](LICENSE) — Free as in freedom.

---

## Related Projects

- **[Freedom Stack](https://github.com/Michae2xl/freedom-stack)** — Agent Privacy Cloud: privacy infrastructure for AI agents (Ollama, n8n, Qdrant, Tor, sandbox)

---

<div align="center">

**Your sovereignty starts with Phase 1.**

```bash
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/sovereign-local.sh | bash
```

[Star this repo](../../stargazers) if you believe privacy is a right, not a product.

</div>

---

## Donations

Privacy costs money. If Sovereign Stack helped you break free, consider supporting the project.

**Zcash (Shielded — fully private):** Send from any shielded wallet ([Zcash FOSS](https://f-droid.org/en/packages/co.electriccoin.zcash.foss/), Zashi, Ywallet)
```
u12rrgyaz7hwyzf0px29ka43tvk7nu92w7mzc99yv9ld3pg96fp4ef0mxe5kd0j5544yc33jqe66fd5s0fjv7uvsxh0uz24c7fuw44wfwcg2g74jgg2ukmpvc0l4a7r56sgjrra35fy4f0k3spjn5uh6kqxx5elmuv3ajd7zjs8s973e0n
```

**Bitcoin:**
```
bc1qus6gvfyepx38apvdxvqh4qj8n3d0jssthzmlnx
```
