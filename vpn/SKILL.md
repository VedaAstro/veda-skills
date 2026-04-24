---
name: VPN инфраструктура VEDA
description: Playbook для self-hosted VPN: VLESS Reality + CF-fronted WS + AmneziaWG. Декомпозиция, деплой новой ноды, troubleshooting, 10+ грабель. Связан с memory/veda-vpn-cloudflare-setup.md (snapshot) + memory/vpn-audit-roadmap-2026-04-24.md (план).
type: playbook
---

# VPN Skill — self-hosted anti-censorship для РФ 2026

> **⚠️ АКТУАЛЬНЫЙ ПЛАН РАБОТ:** `~/.claude/projects/-Users-alex-Projects/memory/vpn-audit-roadmap-2026-04-24.md` — SSOT аудита + roadmap P0-P3 + 3 эксперта + research. **Читай ПЕРЕД любым действием.**
>
> **Разграничение:**
> - **vpn-audit-roadmap-2026-04-24.md** — аудит, обоснование решений, что сделано/что предстоит, гарантии в %
> - **veda-vpn-cloudflare-setup.md** — фактический snapshot инфры (IP, ключи, UUIDs, порты, subscription URLs)
> - **Этот файл (SKILL.md)** — playbook (как развернуть ноду, как диагностировать, грабли)
> - **platform/scripts/ops/vpn-watchdog/** — watchdog скрипты + deploy через `./deploy.sh vpn-watchdog`

## Critical updates 2026-04-24 (не повторять старые ошибки)

### Факты зафиксированные в этой сессии
1. **Aeza под OFAC санкциями с 01.07.2025** — не reputation-safe для CTO-настройки. В roadmap: вывести. См. audit §2.2.
2. **Cloudflare 16 KB throttle с 09.06.2025** — WS+CF для real traffic мёртв в РФ на consumer ISP. Только delivery подписки. См. audit §2.3.
3. **Aparecium Reality detection** — Xray 26.2.6 patched v1, v2 ожидается H2 2026. См. audit §2.4.
4. **Наш AWG = v1.x, НЕ 2.0** — magic headers фиксированные + одинаковые на обеих нодах. AWG 2.0 release март 2026. См. audit §2.5.

### Решения приняты
- **Hetzner отклонён** (Alex 2026-04-24, "Hetzner минус") — KYC паспорт + строгая abuse-policy против VPN.
- **Новый стек:** FlokiNET FI + BuyVM LU + 1984 IS — pure no-KYC. См. audit §4.1.
- **Moscow VPS operations** — только через `platform/scripts/ops/deploy.sh vpn-watchdog` (deploy-guard блочит прямой SSH write).

### P0 выполнено 2026-04-24
- UFW :443/:80 → только CF IP ranges (обе ноды)
- Xray + Caddy access/error logs disabled на Aeza (`loglevel=none`), shredded 8475 строк forensic
- Caddy `respond "OK"` → HTML placeholder (stub, полный Hugo в P2)
- Subscription mirror Aeza→FRA (sub/.../alex.txt отдаётся с обеих edges)
- vpn-watchdog на Moscow: cron hourly SNI + 5-мин endpoint/HTTP/sub health, Telegram alerts

### Known incident (требует диагностики)
- **Reality :2053 недоступен с Timeweb Moscow для обеих нод** (watchdog зафиксировал 2026-04-24 17:51 UTC). Нужен тест с consumer ISP (Alex iPhone на МТС/Beeline). Если там тоже fail → ТСПУ уже режет :2053, миграция Reality на :443 через XHTTP.

---

> SSOT текущего состояния инфры (IP, ключи, UUIDs, подписки): **`~/.claude/projects/-Users-alex-Projects/memory/veda-vpn-cloudflare-setup.md`**. Этот файл — **knowledge**, memory — **данные**.

## Когда использовать

- Задача: VPN работает через раз / медленно / вообще лежит
- Задача: добавить нового клиента / нового сервера / новую страну
- Задача: сменить SNI / обновить Xray / перенести на другого провайдера
- Задача: Alex спрашивает «что делать если РКН заблочит X»
- Задача: понять что из свежих 2026-трендов имеет смысл внедрить

## Базовая архитектура (принцип)

**Три слоя устойчивости = минимум три независимых пути:**

1. **Transport diversification** — разные протоколы (Reality TCP + AWG UDP + WS+CF). Разные риски детекции.
2. **Geographic diversification** — минимум 2 страны (Finland + Germany). Один ASN-бан не кладёт обоих.
3. **Provider diversification** — минимум 2 провайдера (Aeza + Timeweb). Один corporate-инцидент не кладёт обоих.

**Anti-patterns:**
- ❌ Одна нода (SPOF)
- ❌ Один протокол (Reality-only)
- ❌ Две ноды одного провайдера (корпоративный риск)
- ❌ Порт 443 как Reality direct (на нем CF фронт, коллизия)
- ❌ SNI из РКН-блоклиста (discord.com, meta\*, twitter, linkedin, ...) — моментальный фейл
- ❌ Reality SNI на «малый» ASN/хостер с mismatch (figma.com на Aeza = триггер AI-DPI)

## Протоколы — решение что брать (апрель 2026)

| Протокол | Транспорт | Живучесть | Скорость | Когда брать |
|---|---|---|---|---|
| **VLESS Reality + XTLS Vision** | TCP :нестанд | 3–9 мес | ~средн. | Primary если ISP пропускает нестанд порты |
| **VLESS WS + TLS via CF** | TCP :443 | 9–24 мес | ⚠️ медленнее | Fallback (CDN маскирует, но проигрывает в latency) |
| **VLESS XHTTP** | TCP :443 | 12+ мес | быстрее WS | **Следующее поколение** — меньше детектится чем WS, можно через CF gRPC fallback |
| **AmneziaWG 2.0** | UDP :нестанд | 12–24 мес | быстр | Primary если UDP проходит (часто на мобильных не проходит) |
| **Hysteria2 / TUIC** | UDP :443 | ⚠️ падает | быстр | НЕ брать — РКН массово режет QUIC с 2025 |
| **OpenVPN / plain WG** | — | 🔴 | — | НЕ брать — детектится сигнатурно |
| **ShadowSocks 2022** | TCP :нестанд | 6–12 мес | быстр | Старый fallback, ловят по энтропии |

**Рекомендованный стек на одну ноду:** Reality + WS(CF) + AWG 2.0. На две ноды — дублировать.

## SNI для Reality — как выбирать (КРИТИЧНО)

**Критерии хорошего SNI:**
1. TLS 1.3 + HTTP/2 на целевом домене
2. **Не заблокирован РКН** (проверка обязательна из РФ!)
3. Популярный в РФ (не палит паттерн)
4. Не в «попсовом DPI-whitelist» (yahoo.com, google.com, apple.com — избегать)
5. Стабильный fingerprint (большая корп-компания)

**Проверка из РФ (через veda-backend 109.73.194.217):**
```bash
ssh root@109.73.194.217 'timeout 10 openssl s_client -connect SNI:443 -servername SNI -tls1_3 -alpn h2 </dev/null 2>&1 | grep -E "Verification|ALPN"'
# Нужно: Verification: OK + ALPN protocol: h2
```

**Проверенные SNI (апрель 2026):**
- ✅ `www.udemy.com` — используем на Aeza FI
- ✅ `www.asus.com` — используем на FRA DE
- ✅ `www.notion.com`
- ✅ `login.microsoftonline.com` (но корпоративный профиль)
- ✅ `www.cloudflare.com`
- ✅ `www.lovable.dev`
- ✅ `assets-global.website-files.com` (Webflow CDN)

**НЕ использовать (проверено — недоступны или заблокированы из РФ):**
- ❌ `www.figma.com` — не резолвится из РФ (вероятно заблокирован)
- ❌ `discord.com` — заблокирован РКН с 10/2024
- ❌ `www.tradingview.com` — TLS_FAIL из РФ
- ❌ `www.coursera.org` — TLS_FAIL
- ❌ `linkedin.com`, `meta.com`, `twitter.com`, `medium.com` — все заблокированы РКН
- ❌ `www.microsoft.com`, `www.apple.com` — только TLS 1.2, Reality нужен 1.3

**Правило разведения:** SNI на разных нодах должны быть **разными** — если РКН заблочит один домен глобально, вторая нода с другим SNI живёт.

## Декомпозиция стека (как устроено под капотом)

```
[Клиент: Happ iOS/Mac, AmneziaVPN Mac, sing-box CLI]
       │
       ├── Reality TCP :2053 ──► Xray inbound (server) ──► freedom outbound ──► Internet
       │
       ├── WS + TLS :443 ──► Caddy reverse_proxy ──► Xray WS inbound :8080 ──► freedom outbound ──► Internet
       │                       (через CF CDN edge)
       │
       └── AmneziaWG UDP :51444 ──► kernel awg0 iface ──► iptables MASQUERADE ──► Internet
```

**Зачем Caddy перед Xray для WS:**
- Правильный TLS (LE DNS-01 cert через CF API)
- Path-matching (один домен, много endpoints)
- Можно подмешивать легитимный контент (fallback)
- CF требует чтобы origin имел валидный cert для Full Strict

**Зачем x-ui:**
- Управление inbounds (клиенты, UUID, SNI)
- Автогенерация Xray config.json из SQLite DB
- Панель для добавления клиентов без SQL

**КРИТИЧНО: x-ui `allocate` поле** в inbound **ломает** Reality! При ручной вставке в DB ставить NULL. Смотри граблю #2.

## Playbook: деплой новой ноды (30-45 минут)

### Предусловия
- SSH root на VPS, Ubuntu 24.04
- CF API token с правами на зону (уже есть в `/etc/caddy/.env.vpn` на Aeza)
- Доменное имя (subdomain `edgeN.veda-astro.ru`)

### Шаги

```bash
# На новой ноде NEW_IP
ssh root@$NEW_IP

# 1. База + BBR
apt update && apt install -y curl wget unzip sqlite3 jq ufw
cat > /etc/sysctl.d/99-bbr.conf <<EOF
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_fastopen=3
EOF
sysctl -p /etc/sysctl.d/99-bbr.conf

# 2. Caddy (с CF DNS plugin — обязательно для DNS-01!)
apt install -y golang-go
wget -q https://github.com/caddyserver/xcaddy/releases/download/v0.4.2/xcaddy_0.4.2_linux_amd64.deb -O /tmp/xcaddy.deb
dpkg -i /tmp/xcaddy.deb
xcaddy build --with github.com/caddy-dns/cloudflare --output /usr/bin/caddy
# Install systemd unit (из стандартного пакета caddy)
apt install -y caddy
cp /usr/local/bin/caddy-cf /usr/bin/caddy 2>/dev/null  # наш билд с CF
mkdir -p /etc/systemd/system/caddy.service.d
cat > /etc/systemd/system/caddy.service.d/env.conf <<EOF
[Service]
EnvironmentFile=/etc/caddy/.env.vpn
EOF

# 3. x-ui 2.5.4
cd /tmp
wget -q https://github.com/MHSanaei/3x-ui/releases/download/v2.5.4/x-ui-linux-amd64.tar.gz
tar xzf x-ui-linux-amd64.tar.gz
cd x-ui; chmod +x x-ui bin/xray-linux-amd64
cp -r . /usr/local/x-ui/
cp x-ui.service /etc/systemd/system/
cp x-ui.sh /usr/bin/x-ui; chmod +x /usr/bin/x-ui
systemctl daemon-reload && systemctl enable x-ui

# 4. Обновить Xray до 26.2.6+ (из пакета 25.3.3 несовместим с клиентами!)
systemctl stop x-ui
wget -q https://github.com/XTLS/Xray-core/releases/download/v26.2.6/Xray-linux-64.zip -O /tmp/xray.zip
unzip -qo /tmp/xray.zip -d /tmp/xray-new/
cp /tmp/xray-new/xray /usr/local/x-ui/bin/xray-linux-amd64
chmod +x /usr/local/x-ui/bin/xray-linux-amd64
chattr +i /usr/local/x-ui/bin/xray-linux-amd64  # pin версию!
systemctl start x-ui

# 5. Сменить порт панели на рандомный (по умолчанию 2053 = конфликт с Reality!)
PANEL_PORT=$((RANDOM + 10000))
PANEL_PATH=$(openssl rand -hex 12)
/usr/local/x-ui/x-ui setting -port $PANEL_PORT -webBasePath "/$PANEL_PATH/"

# 6. Секреты
WS_PATH=$(openssl rand -hex 16)
ALEX_UUID=$(uuidgen)
SHORT_ID=$(openssl rand -hex 8)
KEYS=$(/usr/local/x-ui/bin/xray-linux-amd64 x25519)
REALITY_PRIV=$(echo "$KEYS" | awk '/Private/{print $NF}')
REALITY_PUB=$(echo "$KEYS" | awk '/Public/{print $NF}')

mkdir -p /etc/caddy
cat > /etc/caddy/.env.vpn <<EOF
WS_PATH=$WS_PATH
ALEX_UUID=$ALEX_UUID
SHORT_ID=$SHORT_ID
REALITY_PRIV=$REALITY_PRIV
REALITY_PUB=$REALITY_PUB
CF_API_TOKEN=<CF_API_TOKEN_from_memory_vpn_setup_md>
EOF
chmod 600 /etc/caddy/.env.vpn

# 7. DNS A record (через CF API)
SUBDOMAIN=edgeN  # заменить на свой
curl -sS -X POST "https://api.cloudflare.com/client/v4/zones/<CF_ZONE_ID_from_memory>/dns_records" \
  -H "Authorization: Bearer <CF_API_TOKEN_from_memory_vpn_setup_md>" \
  -H "Content-Type: application/json" \
  --data "{\"type\":\"A\",\"name\":\"$SUBDOMAIN\",\"content\":\"$NEW_IP\",\"proxied\":true,\"ttl\":120}"

# 8. Caddyfile
cat > /etc/caddy/Caddyfile <<CADDYEOF
$SUBDOMAIN.veda-astro.ru {
    tls { dns cloudflare {env.CF_API_TOKEN} }
    @ws {
        path /$WS_PATH/*
        header Connection *Upgrade*
        header Upgrade websocket
    }
    reverse_proxy @ws 127.0.0.1:8080
    respond "OK" 200
}
CADDYEOF
systemctl restart caddy

# 9. Firewall — open only necessary ports (x-ui панель публично ЗАКРЫТА!)
ufw --force reset
ufw default deny incoming && ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 2053/tcp    # Reality
ufw allow 51445/udp   # AWG
ufw --force enable

# 10. Reality inbound (SQL injection в x-ui DB — готовый сниппет)
# см. block ниже «Reality/WS inbound insert SQL»

# 11. AmneziaWG 2.0
add-apt-repository -y ppa:amnezia/ppa
apt install -y amneziawg amneziawg-tools amneziawg-dkms
modprobe amneziawg
# см. block ниже «AWG setup»

# 12. Subscription update
# Добавить клиента в /var/www/veda-sub/sub/<hash>/<user>.txt (на Aeza edge)
```

### Reality/WS inbound insert SQL (x-ui DB)

```python
# Python snippet — вставить в x-ui sqlite
import json, sqlite3
conn = sqlite3.connect('/etc/x-ui/x-ui.db')
cur = conn.cursor()

# Reality inbound
settings = json.dumps({
    "clients": [{"id": "ALEX_UUID_HERE", "email": "alex@node", "flow": "xtls-rprx-vision", "enable": True}],
    "decryption": "none", "fallbacks": []
})
stream = json.dumps({
    "network": "tcp", "security": "reality",
    "realitySettings": {
        "show": False, "dest": "www.asus.com:443",
        "serverNames": ["www.asus.com"],
        "privateKey": "PRIV_HERE",
        "shortIds": ["SHORT_ID_HERE"],
        "minClient": "", "maxClient": "", "maxTimediff": 0
    },
    "tcpSettings": {"acceptProxyProtocol": False, "header": {"type": "none"}}
})
sniffing = json.dumps({"enabled": True, "destOverride": ["http","tls","quic"]})

cur.execute("""INSERT INTO inbounds
  (user_id, up, down, total, remark, enable, expiry_time, listen, port, protocol,
   settings, stream_settings, tag, sniffing, allocate)
  VALUES (1, 0, 0, 0, 'reality', 1, 0, '0.0.0.0', 2053, 'vless', ?, ?, 'inbound-2053', ?, NULL)""",
  (settings, stream, sniffing))
# КРИТИЧНО: allocate=NULL! Если JSON поставить — Reality handshake ломается молча

# WS inbound (listen 127.0.0.1 — только Caddy к нему)
stream_ws = json.dumps({
    "network": "ws", "security": "none",
    "wsSettings": {"path": "/WS_PATH_HERE/", "host": "edgeN.veda-astro.ru", "headers": {}}
})
cur.execute("""INSERT INTO inbounds (...) VALUES (..., '127.0.0.1', 8080, ..., NULL)""",
  (json.dumps({"clients":[{"id":"ALEX_UUID_WS", "email":"alex-cf", "enable":True}], "decryption":"none"}), stream_ws, sniffing))

conn.commit()
```

### AWG 2.0 setup

```bash
cd /etc/amnezia/amneziawg
SERVER_KEY=$(awg genkey); echo "$SERVER_KEY" > server.key
SERVER_PUB=$(echo "$SERVER_KEY" | awg pubkey); echo "$SERVER_PUB" > server.pub

# Magic headers (рандом каждый раз → уникальный fingerprint)
cat > magic.env <<EOF
Jc=4
Jmin=40
Jmax=70
S1=39
S2=91
H1=$RANDOM$RANDOM
H2=$RANDOM$RANDOM
H3=$RANDOM$RANDOM
H4=$RANDOM$RANDOM
EOF
source magic.env

# Client (Alex)
ALEX_KEY=$(awg genkey)
ALEX_PUB=$(echo "$ALEX_KEY" | awg pubkey)
ALEX_PSK=$(awg genpsk)

cat > awg0.conf <<EOF
[Interface]
PrivateKey = $SERVER_KEY
Address = 10.67.67.1/24
ListenPort = 51445
Jc = $Jc
Jmin = $Jmin
Jmax = $Jmax
S1 = $S1
S2 = $S2
H1 = $H1
H2 = $H2
H3 = $H3
H4 = $H4
PostUp = iptables -I FORWARD -i awg0 -j ACCEPT; iptables -I FORWARD -o awg0 -j ACCEPT; iptables -t nat -A POSTROUTING -s 10.67.67.0/24 -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i awg0 -j ACCEPT; iptables -D FORWARD -o awg0 -j ACCEPT; iptables -t nat -D POSTROUTING -s 10.67.67.0/24 -o eth0 -j MASQUERADE

[Peer]
PublicKey = $ALEX_PUB
PresharedKey = $ALEX_PSK
AllowedIPs = 10.67.67.2/32
EOF

# Client config файл
cat > alex-client.conf <<EOF
[Interface]
PrivateKey = $ALEX_KEY
Address = 10.67.67.2/32
DNS = 1.1.1.1, 8.8.8.8
MTU = 1280
Jc = $Jc
Jmin = $Jmin
...
[Peer]
PublicKey = $SERVER_PUB
PresharedKey = $ALEX_PSK
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = NEW_IP:51445
PersistentKeepalive = 25
EOF

echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/99-awg.conf
sysctl -p /etc/sysctl.d/99-awg.conf
awg-quick up awg0
systemctl enable awg-quick@awg0
```

## Playbook: добавить нового клиента

```bash
# На Aeza (или FRA):
NEW_UUID_REALITY=$(uuidgen)
NEW_UUID_WS=$(uuidgen)
NEW_NAME="newuser"

# Add to Reality inbound (id=1)
python3 <<PYEOF
import json, sqlite3
conn = sqlite3.connect('/etc/x-ui/x-ui.db')
cur = conn.cursor()
cur.execute('SELECT settings FROM inbounds WHERE id=1')
s = json.loads(cur.fetchone()[0])
s['clients'].append({'id':'$NEW_UUID_REALITY','email':'$NEW_NAME','flow':'xtls-rprx-vision','limitIp':0,'totalGB':0,'expiryTime':0,'enable':True})
cur.execute('UPDATE inbounds SET settings=? WHERE id=1', (json.dumps(s),))
conn.commit()
PYEOF

systemctl restart x-ui
# Повторить на всех нодах (разные UUIDs!)

# Создать subscription file
SUB_HASH=$(openssl rand -hex 16)
mkdir -p /var/www/veda-sub/sub/$SUB_HASH
# ... положить vless:// ссылки ... see memory
```

## Диагностика — decision tree

**Симптом: «VPN не работает вообще»**

1. Проверить доступность сервера по ICMP/TCP:
   ```bash
   nc -z -w 5 <IP> 2053 && echo OK || echo BLOCKED
   ```
2. Если порт открыт — проблема в Reality handshake:
   - Проверить Xray версия `>= 26.2.6` на сервере
   - Проверить SNI в подписке совпадает с SNI в x-ui DB
   - Проверить key pair: `echo "$PRIV" | xray x25519 -i /dev/stdin` должен дать тот же PUB что в подписке
3. Если порт закрыт — провайдер/ТСПУ блочит → переключиться на CF-путь или AWG

**Симптом: «Медленно / через раз / CF edge packet loss»**

```bash
# RTT + packet loss
ping -c 10 edge.veda-astro.ru
# Если packet loss > 5% → маршрут ISP→CF битый, советовать Reality direct
```

**Симптом: «Happ показывает n/a пинг у сервера»**

- Это Happ пробует эхо через активный туннель. `n/a` не значит что сервер мёртв.
- **Правильный тест:** переключиться на сервер → curl ifconfig.me → проверить exit IP.

**Симптом: «ifconfig.me показал РФ IP при активном VPN»**

- НЕ баг. Happ «RU apps direct» split-tunnel: RU-сайты идут мимо VPN.
- Проверять на **не-RU** IP check (ifconfig.me/ipify/icanhazip) — они покажут VPN IP.
- Чтобы **всё** шло через VPN: в Happ → Маршрутизация → активный пресет → Редактировать → удалить все правила. Тумблер «Использовать роутинг» ON.

**Симптом: «REALITY: received real certificate (MITM)»**

- Xray сервер < 26.0 или client >= 26 — версия несовместима.
- Фикс: обновить Xray на сервере до 26.2.6+, `chattr +i` binary от auto-rollback.

**Симптом: «Caddy не получает LE cert»**

- HTTP-01 challenge фейлит если proxied=true в CF (CF TLS intercept).
- Решение: использовать **DNS-01** (через CF API). Собрать Caddy с `caddy-dns-cloudflare` plugin.

## 8 проверенных грабель (из продакшн-опыта)

### 1. `www.figma.com` / popular SNI — не проверен из РФ
**Симптом:** Reality подключается но ТСПУ через N дней начинает рубить.
**Причина:** SNI заблокирован/недоступен из РФ → ТСПУ видит «юзер лезет на заблоченный домен».
**Фикс:** ВСЕГДА проверять SNI через `openssl s_client` с РФ-сервера. Подробно см. секцию «SNI» выше.

### 2. `allocate` поле в Reality inbound ломает handshake
**Симптом:** Клиент подключается, но handshake молча таймаутит. Server log пуст.
**Причина:** x-ui ожидает `allocate: NULL`, при JSON-значении `{strategy: always, ...}` Reality не стартует.
**Фикс:** `UPDATE inbounds SET allocate = NULL WHERE protocol='vless';`

### 3. Xray 25.3.3 vs клиент 26.x — Reality несовместим
**Симптом:** Client log: `REALITY: received real certificate (potential MITM)`.
**Причина:** Reality протокольно изменился в 26.x.
**Фикс:** обновить Xray на сервере до 26.2.6+ (download from GitHub releases), `chattr +i` binary.

### 4. x-ui admin port 2053 конфликт с Reality
**Симптом:** После установки x-ui Xray не стартует (`bind: address already in use`).
**Причина:** x-ui дефолт admin panel = 2053, там же хотим Reality.
**Фикс:** `x-ui setting -port $RANDOM_PORT -webBasePath /...`

### 5. Caddy LE cert не оформляется если CF proxied=true (HTTP-01)
**Симптом:** `loading TLS app module` error, cert never issued.
**Причина:** HTTP-01 challenge приходит на CF, который не форвардит его с raw connection.
**Фикс:** Caddy с CF DNS plugin + `tls { dns cloudflare {env.CF_API_TOKEN} }` → DNS-01 не требует публичного порта 80.

### 6. Happ split-routing `RU apps direct` путает диагностику
**Симптом:** Alex проверяет на 2ip.ru → видит Moscow IP → «VPN не работает!»
**Причина:** 2ip.ru — RU сайт, Happ рутит его мимо VPN по правилу geosite:ru → direct.
**Фикс:** проверять на НЕ-RU сайтах (ifconfig.me, ipify). Или убрать правила в Маршрутизации.

### 7. Subscription URL hardcoded на один hash → regex не ловит новых юзеров
**Симптом:** Добавил Irina, создал sub-файл → URL отдаёт "OK" (default handler).
**Причина:** Caddyfile `path_regexp ^/sub/<hash>/.*` захардкожен на Alex'ов hash.
**Фикс:** `^/sub/[a-f0-9]{32}/.*` — универсальный regex для всех 32-char hex hashes.

### 8. Смена SNI на сервере без обновления subscription
**Симптом:** Alex открывает Happ — Reality не подключается.
**Причина:** vless:// URL в подписке содержит старый SNI. Client шлёт ClientHello с figma.com SNI, а сервер настроен на udemy.com → server отвечает реальным udemy cert → client FAIL.
**Фикс:** ВСЕГДА atomic: `server update + subscription rewrite + Alex нажимает 🔄 обновить в Happ`. Одним скриптом.

## Как пользователи импортируют клиенты

### Happ (Mac/iOS) — для VLESS Reality + WS/CF
1. App Store → Happ (бесплатно)
2. Открыть → + → Add subscription URL → вставить https://edge.veda-astro.ru/sub/HASH/NAME.txt
3. Подождать пинг-тест → тапнуть сервер → Connect
4. Настройки → Маршрутизация: удалить все правила из активного профиля (или выключить тумблер) — чтобы весь трафик через VPN

### AmneziaVPN (Mac/iOS) — для AWG 2.0
1. App Store → AmneziaVPN
2. Импорт .conf файла (Drag-and-drop на Mac, или через Files на iOS)
3. Connect

### sing-box CLI (Mac, для тестирования и диагностики)
```bash
brew install sing-box
# Создать config.json с vless outbound (см. /tmp/xray-sanity.json как референс)
sing-box run -c /path/to/config.json
# SOCKS5 proxy будет на 127.0.0.1:1080 (или другой listen_port)
```

## Мониторинг (минимальный baseline)

TODO: не настроен. Baseline план:

```bash
# Cron на Aeza, раз в 5 мин
*/5 * * * * /root/vpn-health-check.sh

# vpn-health-check.sh
#!/bin/bash
for endpoint in "109.172.95.112:2053" "72.56.107.55:2053" \
                "edge.veda-astro.ru:443" "edge2.veda-astro.ru:443"; do
  host=${endpoint%:*}; port=${endpoint#*:}
  if ! nc -z -w 5 $host $port 2>/dev/null; then
    curl -sS -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
      --data "chat_id=$TG_CHAT&text=🔴 VPN $endpoint DOWN"
  fi
done
```

## Что делать при полном блоке (disaster recovery)

**Сценарий:** РКН блочит весь Aeza ASN + Timeweb GE + CF fronting.

1. **Немедленно:** поднять резервную ноду на **третьем провайдере** (IncogNet US, BuyVM LU, Frantech NL) — принимают крипту, не-ЕС/не-РФ аккаунт.
2. Скопировать всю x-ui DB + Caddy config с existing nodes (есть backup в `/etc/x-ui/x-ui.db.bak-*`)
3. Обновить DNS A records на новую ноду
4. Алёрт клиентов: subscription URL **не меняется** (он на Aeza), но клиенты получат новые vless:// URLs после обновления подписки в Happ

**Если Aeza полностью лежит** и subscription URL (хостится на Aeza edge.veda-astro.ru) недоступен:
- Fallback subscription на FRA edge2 — уже готовится (TODO: P2)
- Ручная раздача vless:// через Telegram/почту

## Roadmap улучшений

**P0 (done 2026-04-24):** ✅ Atomic SNI change, ✅ CF fronting FRA, ✅ AWG FRA, ✅ UFW harden, ✅ Xray pin

**P1 (планируется):**
- [ ] **XHTTP transport** добавить как 5-й путь (по Хабр ресёрчу — горизонт 5-7 лет vs 3-9 мес Reality)
- [ ] **Mirror subscription на FRA** — если Aeza лежит, клиенты обновляют подписку с FRA
- [ ] **Monitoring + Telegram alerts** — watchdog на обеих нодах

**P2 (месяцы вперёд):**
- [ ] **Третья нода** на не-Aeza/не-Timeweb провайдере (IncogNet/BuyVM)
- [ ] **Автоматическая ротация Reality keys** каждые 90 дней
- [ ] **CF Workers XHTTP** (top-tier схема 2026, требует dev-работы)

## P0 runbook — команды выполненные 2026-04-24

### UFW CF-only на обеих нодах
```bash
# Aeza (109.172.95.112) и FRA (72.56.107.55):
for ip in $(curl -s https://www.cloudflare.com/ips-v4/); do
  ssh root@$NODE "ufw allow from $ip to any port 443 proto tcp comment CF"
  ssh root@$NODE "ufw allow from $ip to any port 80 proto tcp comment CF"
done
# (+ v6 ranges)
ssh root@$NODE 'ufw delete allow 443/tcp; ufw delete allow 80/tcp; ufw reload'
```

### Xray access/error log disable (Aeza)
```bash
ssh root@109.172.95.112 'python3 <<PYEOF
import json, sqlite3
conn = sqlite3.connect("/etc/x-ui/x-ui.db")
cur = conn.cursor()
cur.execute("SELECT value FROM settings WHERE key=?", ("xrayTemplateConfig",))
cfg = json.loads(cur.fetchone()[0])
cfg["log"] = {"loglevel": "none", "access": "none", "error": "/dev/null"}
cur.execute("UPDATE settings SET value=? WHERE key=?", (json.dumps(cfg), "xrayTemplateConfig"))
conn.commit()
PYEOF
systemctl restart x-ui
shred -u /var/log/xray-access.log /var/log/xray-error.log'
```

### Caddy log disable + HTML placeholder
```bash
# Replace respond "OK" 200 → file_server /var/www/veda-sub
# Удалить log block из Caddyfile
ssh root@109.172.95.112 'systemctl reload caddy; shred -u /var/log/caddy/edge.log'
```

### Subscription mirror Aeza → FRA
```bash
# Pull на local cache, push на FRA без большого pkg
mkdir -p /tmp/veda-sub-sync
rsync -az root@109.172.95.112:/var/www/veda-sub/ /tmp/veda-sub-sync/
rsync -rpt --exclude='*.pkg' --exclude='.*.pkg.*' \
  /tmp/veda-sub-sync/ root@72.56.107.55:/var/www/veda-sub/

# Caddyfile FRA: добавить routes /sub/, /dl/, default file_server (см. memory/veda-vpn-cloudflare-setup.md)
ssh root@72.56.107.55 'systemctl reload caddy'
```

### vpn-watchdog deploy (Moscow через deploy.sh)
```bash
cd ~/Projects/platform/scripts/ops
./deploy.sh vpn-watchdog    # единственный легитимный путь через deploy-guard
```

## Watchdog — мониторинг (installed 2026-04-24)

Cron на 109.73.194.217 (Timeweb Moscow, единственная РФ-точка):
- **hourly:** SNI warm-pool check (10 доменов: udemy/asus/notion/cloudflare/learn.microsoft/vercel/netlify/raw.githubusercontent/jsdelivr/zoom)
- **5 min:** endpoint TCP check + HTTP 200 + sub canary (alex.txt 200+1264 bytes)
- **alerts:** Telegram `@claude_alexey_bot` (chat_id 814865188) на state-change

### Быстрая диагностика
```bash
# Current watchdog state (что down сейчас)
ssh root@109.73.194.217 'cat /var/run/vpn-watchdog-endpoints.state; echo "---"; cat /var/run/vpn-watchdog-sni.state'

# Логи
ssh root@109.73.194.217 'tail -20 /var/log/vpn-endpoint-watchdog.log /var/log/vpn-sni-watchdog.log'

# Manual run (force re-check + potential alert)
ssh root@109.73.194.217 '. /etc/vpn-watchdog/env; /etc/vpn-watchdog/endpoint-check.sh'
```

### Как обновлять watchdog скрипты
1. Редактируй `~/Projects/platform/scripts/ops/vpn-watchdog/*.sh`
2. `chmod +x *.sh` (important — macOS rsync сохраняет permissions)
3. `./deploy.sh vpn-watchdog`
4. **Не** `scp ... root@109.73.194.217:` напрямую — deploy-guard блочит.

## Правила для future sessions (2026-04-24 update)

### Что НЕ делать
- ❌ Не использовать Hetzner (Alex отклонил — KYC + abuse policy)
- ❌ Не обходить deploy-guard через base64/tee/heredoc — нарушает `feedback_never_bypass_guards.md`
- ❌ Не ломать AWG без координации с клиентскими .conf (Alex+Ирина локально)
- ❌ Не планировать на WS+CF путь для реального трафика (16KB throttle) — только delivery подписки
- ❌ Не считать AWG v1.x = v2.0 — наш стек пока v1.x с fixed headers

### Что ДЕЛАТЬ
- ✅ Fact-check через SSH/openssl/curl ДО экспертных утверждений
- ✅ Новая нода = прописываем через `./deploy.sh vpn-<name>` (расширяем deploy.sh профилем)
- ✅ После каждого change → verify через watchdog state + Telegram
- ✅ Subscription rewrite = atomic update server + rewrite sub file + Alex "обновить" в Happ

## Ссылки и источники

### Аудит 2026-04-24 (все источники — в audit §14)

- `memory/vpn-audit-roadmap-2026-04-24.md` §14 — полный список 80+ референсов
- [treasury.gov sb0185](https://home.treasury.gov/news/press-releases/sb0185) — Aeza OFAC sanctions
- [blog.cloudflare.com Russian throttling](https://blog.cloudflare.com/russian-internet-users-are-unable-to-access-the-open-internet/) — 16KB curtain
- [github.com/XTLS/Xray-core/issues/4778](https://github.com/XTLS/Xray-core/issues/4778) — Aparecium
- [net4people/bbs #490](https://github.com/net4people/bbs/issues/490) — 16KB+CIDR attack mobile
- [tomsguide — AWG 2.0](https://www.tomsguide.com/computing/vpns/amneziavpn-launches-amneziawg-2-0-and-its-a-fundamental-shift-from-its-predecessor)

### Классика (предыдущий research)
- `habr.com/ru/articles/1009542` — «Как ТСПУ ловит VLESS в 2026 и почему XHTTP — следующий шаг»
- `amnezia.org/blog/amneziawg-2-0-available-for-self-hosted`
- `xtls.github.io/en/config/transport.html`
- `github.com/XTLS/REALITY`
