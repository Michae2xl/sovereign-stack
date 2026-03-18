---
name: soberana
description: "Sovereign Stack — instalação completa de privacidade digital para humanos. Do Hero ao Soberano em 1 comando. 5 fases: Linux, browser hardened, apps FOSS, VPS self-hosted (Nextcloud, Vaultwarden, SearXNG, Immich, Matrix, Jitsi, AdGuard, WireGuard, Forgejo, Stalwart Mail), integração total com HTTPS, backups criptografados e Tor .onion. Triggers: 'soberana', 'sovereign', 'sovereign stack', 'privacidade humana', 'degoogle', 'digital freedom', 'self-hosted humano', 'substituir google', 'hero to sovereign'."
---

# Skill Soberana — Sovereign Stack

> **Do Hero ao Soberano em 1 comando.** Privacidade digital completa para humanos.

**Repo:** https://github.com/Michae2xl/sovereign-stack

---

## O Que Esta Skill Faz

Instala TUDO do Sovereign Stack de uma vez:

1. **Phase 1 — Hero:** Post-install Linux (atualiza, ferramentas, Flatpak, firewall)
2. **Phase 2 — Guardian:** Firefox hardened (user.js, extensões, Tor Browser)
3. **Phase 3 — Warrior:** Apps FOSS via Flatpak (Signal, Bitwarden, FreeTube, LibreOffice, Element, etc)
4. **Phase 4 — Knight:** VPS com 10+ serviços self-hosted (Nextcloud, Vaultwarden, SearXNG, Immich, Matrix, Jitsi, AdGuard, Forgejo)
5. **Phase 5 — Sovereign:** Caddy auto-HTTPS, WireGuard VPN, backups criptografados, server hardening, Tor .onion

---

## Instalação Completa (1 Comando)

### Na máquina local (Fases 1-3):
```bash
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/sovereign-local.sh | bash
```

### No VPS (Fases 4-5):
```bash
ssh root@SEU_VPS_IP
curl -fsSL https://raw.githubusercontent.com/Michae2xl/sovereign-stack/main/scripts/sovereign-vps.sh -o sovereign.sh
bash sovereign.sh --all --domain seudominio.com
```

### Sem domínio (funciona via IP + Tor .onion):
```bash
bash sovereign.sh --all
```

---

## Como Usar Esta Skill

### Quando o usuário chegar, pergunte:

1. **Onde quer instalar?** (máquina local? VPS? ambos?)
2. **Tem Linux?** (se não, começa na Fase 1)
3. **Tem VPS?** (se não, recomende Hetzner/Njalla/1984.is)
4. **Tem domínio?** (opcional — funciona sem)
5. **O que quer priorizar?** (tudo? só alguns serviços?)

### Baseado nas respostas:

| Situação | Comando |
|----------|---------|
| Tudo de uma vez (local + VPS) | `sovereign-local.sh` + `sovereign-vps.sh --all` |
| Só máquina local (sem VPS) | `sovereign-local.sh` (Fases 1-3) |
| Só VPS (já tem Linux configurado) | `sovereign-vps.sh --all --domain X` |
| Serviços específicos | `sovereign-vps.sh --nextcloud --vaultwarden --searxng` |

---

## Serviços Instalados (VPS)

| Serviço | Substitui | Porta | Subdomínio |
|---------|-----------|-------|------------|
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

### Infraestrutura
| Serviço | Função |
|---------|--------|
| UFW + fail2ban | Firewall + proteção SSH |
| Rclone + GPG | Backup criptografado diário |
| Tor | .onion hidden services |

---

## Apps Instalados (Local — Flatpak)

| App | Substitui |
|-----|-----------|
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
| VSCodium | VS Code (sem telemetria) |

---

## Jornada Visual

```
  Phase 1        Phase 2        Phase 3        Phase 4        Phase 5
  ┌──────┐      ┌──────┐      ┌──────┐      ┌──────┐      ┌──────┐
  │ HERO │ ──▶  │GUARD.│ ──▶  │WARR. │ ──▶  │KNIGHT│ ──▶  │SOVER.│
  │      │      │      │      │      │      │      │      │      │
  │  OS  │      │Browse│      │ Apps │      │ VPS  │      │ Full │
  └──────┘      └──────┘      └──────┘      └──────┘      └──────┘
   ~30min        ~30min        ~45min        ~60min        ~30min

  LOCAL ◄──────────────────────┤  VPS  ├──────────────────►
  (Fases 1-3)                  (Fases 4-5)
```

---

## Checklist Final de Soberania

- [ ] Linux instalado com disk encryption
- [ ] Firefox hardened + uBlock Origin + Privacy Badger
- [ ] Tor Browser instalado
- [ ] Apps FOSS instalados (Signal, Bitwarden, FreeTube, etc)
- [ ] VPS com todos os serviços rodando
- [ ] Caddy com HTTPS automático
- [ ] WireGuard VPN em todos os dispositivos
- [ ] AdGuard DNS bloqueando ads/trackers
- [ ] Nextcloud sincronizando em todos os dispositivos
- [ ] Vaultwarden com todas as senhas
- [ ] Immich fazendo backup das fotos
- [ ] SearXNG como busca padrão
- [ ] Backups criptografados diários
- [ ] Google data exportada e conta esvaziada

---

## Requisitos

### Máquina Local
- Qualquer computador com Linux (ou disposição pra instalar)
- 4GB+ RAM, 20GB+ disco

### VPS (Fases 4-5)
| | Mínimo | Recomendado |
|---|--------|-------------|
| RAM | 4GB | 8GB+ |
| CPU | 2 vCPUs | 4+ vCPUs |
| Disco | 40GB | 80GB+ |
| OS | Ubuntu 22.04 | Ubuntu 24.04 |
| Custo | ~€6/mês | ~€12/mês |

### VPS Providers Privacy-Friendly
| Provider | Privacidade | Preço (8GB) |
|----------|-------------|-------------|
| Hetzner | GDPR | ~€9/mês |
| Njalla | Zero KYC, crypto | ~€15/mês |
| 1984.is | Islândia | ~€15/mês |
| Contabo | OK | ~€6/mês |

---

## Troubleshooting

```bash
# Ver status dos containers
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep sovereign

# Logs de um serviço
docker logs sovereign-nextcloud --tail 50

# Restart tudo
cd /opt/sovereign-stack && docker compose restart

# Verificar credenciais
cat /root/sovereign-stack-credentials.txt

# Verificar firewall
ufw status

# Verificar WireGuard
wg show
```

---

## Relação com Freedom Stack

| Projeto | Público | Foco |
|---------|---------|------|
| **Sovereign Stack** (esta skill) | Humanos | Privacidade pessoal, degoogle, self-hosted |
| **Freedom Stack** (skill agent-shielded) | Devs/Agents AI | Agent Privacy Cloud (Ollama, n8n, Qdrant, Tor) |

Podem rodar **juntos no mesmo VPS** — são complementares.

```bash
# Instalar sovereign (humano) + freedom (agents) no mesmo VPS:
bash sovereign.sh --all --domain seudominio.com
bash install.sh --agents --searxng --tor --security
```
