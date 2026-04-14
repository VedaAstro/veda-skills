---
name: veda-deploy
description: Деплой проектов Veda на сервер 109.73.194.217. rsync, PM2, env-переменные, build. Используй при любом деплое, переносе кода на сервер или перезапуске сервисов.
---

# Деплой Veda Platform

## Когда использовать

- Деплой фронтенда или бэкенда на сервер
- Перезапуск PM2-сервисов
- Добавление новой env-переменной
- rsync файлов на сервер
- Диагностика упавшего сервиса
- Проверка здоровья после деплоя

## КРИТИЧЕСКОЕ ПРАВИЛО: Деплой только с явного подтверждения

```
ЗАПРЕЩЕНО деплоить без отдельного явного «да» от Алекса.

Алгоритм ВСЕГДА:
1. Выполнить задачу локально
2. Дать POST-DEPLOY REPORT (что сделано + как проверить)
3. Спросить: «Задеплоить?»
4. ЖДАТЬ отдельного сообщения с явным «да, деплой» / «деплой» / «да»

НЕ является разрешением:
- Вопрос «почему не задеплоил?»
- Любая реплика Алекса, не содержащая явного «да» на деплой
- Молчаливое согласие или контекст предыдущих сообщений

Нарушение = критический инцидент.
```

## ⚠️ ОБЯЗАТЕЛЬНО ПЕРЕД КАЖДЫМ ДЕПЛОЕМ: проверка диагностик (MSK + online presence)

```
БЛОКИРУЮЩИЙ ШАГ — выполнять ДО любого git pull/pm2 reload на сервере.
Касается ВСЕХ сервисов (не только veda-api/presentation/websocket).

Почему: сервер живёт в UTC, но операционное время продукта — Europe/Moscow.
Проверка только по статусам в БД недостаточна: "онлайн" в календаре берётся из presence WS.

1) Снять online presence (источник истины для "онлайн" в календаре):
   curl -sS https://sales.myveda.ru/api/ws/health
   Если есть sessions с clientCount > 0 → это активные онлайн-сессии.

2) Снять МСК-время + ближайшие встречи из БД:
   ssh root@109.73.194.217 "date '+UTC:%Y-%m-%d %H:%M:%S'; TZ=Europe/Moscow date '+MSK:%Y-%m-%d %H:%M:%S %Z'"
   sudo -u postgres psql -d veda_crm -t -c "
     SELECT id, scheduled_date, scheduled_time, status
     FROM diagnostic_bookings
     WHERE scheduled_date = (now() at time zone 'Europe/Moscow')::date
       AND status IN ('confirmed','in_progress')
       AND (is_deleted IS NULL OR is_deleted = false)
     ORDER BY scheduled_time;"

3) Интерпретация (одна строка Алексу):
   - 🟢 Нет online sessions и нет встреч в ближайший час (MSK) → "деплой безопасен".
   - 🟡 Нет online sessions, но есть встречи позже → "деплой безопасен сейчас, ближайшая HH:MM MSK".
   - 🔴 Есть online sessions ИЛИ встреча в ближайший час → "активная диагностика, деплой отложить".

4) При 🔴 — НЕ деплоить. Ждать отдельного явного окна.
5) Для выката использовать pm2 reload (не restart) для zero-downtime.
```

## Golden Rule

**ВСЕГДА сначала:** `pm2 show <app-name>` — чтобы увидеть `script path` и `exec cwd` (реальный каталог кода на сервере). Для `app-myveda` этого недостаточно угадывать по памяти: см. раздел ниже.

## app-myveda (AstroGuru, Next.js standalone)

**Проблема:** в `/var/www/app-myveda/` symlink `current` → `releases/<релиз>/`. PM2 (`app-myveda`) запускает `server.js` из **этого** релиза. Заливка в голый `/var/www/app-myveda/server.js` или `.next/` **вне** активного release **не обновляет** то, что крутит PM2.

**Источник истины (любой вариант):**
```bash
ssh root@109.73.194.217 'pm2 show app-myveda | egrep "script path|exec cwd"'
ssh root@109.73.194.217 'dirname "$(readlink -f /var/www/app-myveda/current/server.js)"'
```

**Деплой** (локально из корня репо `app-myveda`, после `npm run build`):
```bash
DEPLOY_ROOT="$(ssh root@109.73.194.217 'dirname "$(readlink -f /var/www/app-myveda/current/server.js)"')"
scp .next/standalone/server.js "root@109.73.194.217:${DEPLOY_ROOT}/server.js"
rsync -az --delete .next/standalone/.next/ "root@109.73.194.217:${DEPLOY_ROOT}/.next/"
rsync -az --delete .next/static/ "root@109.73.194.217:${DEPLOY_ROOT}/.next/static/"
rsync -az --delete public/ "root@109.73.194.217:${DEPLOY_ROOT}/public/"
ssh root@109.73.194.217 'pm2 restart app-myveda'
```

Обязательно все три части standalone: `server.js`, дерево `.next/` из `standalone`, и `.next/static/` из обычного build — иначе 404 на чанки.

## Карта сервера (109.73.194.217)

| Проект | Путь на сервере | PM2 имя | Порт | Команда деплоя |
|--------|----------------|---------|------|----------------|
| app-myveda | `/root/app-myveda/` | `app-myveda` | 3003 | **`/root/deploy-app-myveda.sh`** (flock + pnpm build + pm2 reload + health check) |
| veda-presentation | `/root/veda-presentation/` | `veda-presentation` | 3001 | **`/root/deploy-veda-presentation.sh`** (flock + npm build + pm2 reload + health check) |
| bot-admin-api | `/root/bot-admin-api/` | `bot-admin-api` | 8090 | **`/root/deploy-bot-admin-api.sh`** (flock + pip install + pm2 reload + health check) |
| Backend (FastAPI) | `/var/www/veda-backend/` | `veda-api` | 8000 | `git pull && pip install -r requirements.txt && pm2 reload veda-api --update-env` |
| WebSocket | `/var/www/veda-presentation/` | `veda-websocket` | 8080 | `pm2 reload veda-websocket --update-env` |
| Tanya_bot | `/root/Tanya_bot/` | `tanya-bot` | -- | `pm2 reload tanya-bot --update-env` |
| bot-admin-ui | `/var/www/bot-admin-ui/` | nginx static | -- | `npm run build` + upload dist/ |
| veda-bot-v2 | `/root/veda-bot-v2/` | `veda-bot-v2` + `veda-bot-v2-api` | 8081 | `pm2 reload veda-bot-v2 && pm2 reload veda-bot-v2-api` |
| vedalab | `/root/vedalab/` | `vedalab` | -- | `pm2 reload vedalab --update-env` |

**ПРАВИЛО:** Для app-myveda, veda-presentation, bot-admin-api — ВСЕГДА использовать deploy-скрипты. Они обеспечивают flock (один деплой за раз), pm2 reload (zero downtime), health check. НИКОГДА raw `pm2 restart`.

**Домены:** sales.myveda.ru (frontend), app.myveda.ru (alias), funnel.myveda.ru (bot-admin-ui), astro.myveda.ru / new.astroguru.ru (app-myveda при соответствующем DNS)

## Ключевые правила

### 1. rsync: ОБЯЗАТЕЛЬНЫЕ exclude

```bash
rsync -avz \
  --exclude '.env' \
  --exclude '.venv' \
  --exclude 'venv' \
  --exclude '__pycache__' \
  --exclude '.git' \
  --exclude '*.pyc' \
  --exclude 'node_modules' \
  . root@109.73.194.217:/path/to/project/
```

**Без exclude = инцидент.** Серверный `.env` перезапишется локальным, venv сломается.

### 2. Новая env-переменная: 4 шага

1. Добавить в `.env.example` проекта
2. Добавить в `_validate_env()` (если bot-admin-api)
3. Прописать на сервере: `ssh root@109.73.194.217 "echo 'VAR=value' >> /root/<project>/.env"`
4. **ОБЯЗАТЕЛЬНО:** `pm2 restart <app> --update-env` (без --update-env PM2 НЕ подхватит!)

### 3. Frontend деплой (veda-presentation)

```bash
# Синхронизировать код, потом запустить деплой-скрипт:
rsync -avz --exclude '.env' --exclude 'node_modules' --exclude '.git' --exclude '.next' \
  . root@109.73.194.217:/root/veda-presentation/
ssh root@109.73.194.217 "/root/deploy-veda-presentation.sh"
```

**НИКОГДА не использовать `npm install --production` для фронтенда** — build упадёт без devDependencies.

### 4. Backend деплой (veda-api)

```bash
ssh root@109.73.194.217 "cd /var/www/veda-backend && git pull && pip install -r requirements.txt && pm2 reload veda-api --update-env"
```

### 4b. bot-admin-api деплой

```bash
rsync -avz --exclude '.env' --exclude 'venv' --exclude '__pycache__' --exclude '.git' \
  . root@109.73.194.217:/root/bot-admin-api/
ssh root@109.73.194.217 "/root/deploy-bot-admin-api.sh"
```

### 5. Git push (с токеном)

```bash
# Push
git remote set-url origin https://TOKEN@github.com/VedaAstro/<repo>.git
git push origin main
git remote set-url origin https://github.com/VedaAstro/<repo>.git

# Pull на сервере
ssh root@109.73.194.217 "cd /path/to/project && git pull https://TOKEN@github.com/VedaAstro/<repo>.git main"
```

### 6. veda-bot-v2: два PM2 процесса

- `veda-bot-v2` = `bot_only.py` (бот)
- `veda-bot-v2-api` = uvicorn (API, порт 8081)
- **НЕ использовать main.py** (multiprocessing -> дубли polling)

### 7. 409 Conflict (боты)

```bash
pkill -f "Tanya_bot.*python main.py" && pm2 restart tanya-bot
```

## AstroGuru Docker-сервисы (Beget Cloud)

### Карта Docker-сервисов

| Сервис | Сервер | Path | Container | Port | DB |
|--------|--------|------|-----------|------|----|
| veda_kurator | 45.90.34.181 | `/home/deployuser/veda_kurator/` | `veda_kurator_veda_kurator_1` | 8008→8000 | PG:5439 kurator/kurator |
| Astro Calc | 109.73.194.217 | `/root/astro-calc/` | 7 контейнеров | host network | PG:5433 |

### Docker deploy (без docker-compose)

docker-compose v1 (1.29.2) СЛОМАН на новых Docker Engine. Используй docker run:

```bash
# 1. Build
cd /home/deployuser/veda_kurator
docker build -t veda_kurator_veda_kurator .

# 2. Stop old
docker stop veda_kurator_veda_kurator_1
docker rm veda_kurator_veda_kurator_1

# 3. Run new (сохраняй network, ports, volumes, env!)
docker run -d \
  --name veda_kurator_veda_kurator_1 \
  --restart always \
  -p 8008:8000 \
  --env-file .env \
  -v $(pwd):/app \
  -v $(pwd)/logs:/app/logs \
  --network veda_kurator_default \
  veda_kurator_veda_kurator:latest

# 4. Verify
docker logs --tail 20 veda_kurator_veda_kurator_1
curl -s http://localhost:8008/api/v3/get_user_progress/?user_id=1&sphere_id=1
```

### SSH к Beget Cloud серверам

```bash
# Через expect (пароли в credentials.md)
expect -c '
spawn ssh -o StrictHostKeyChecking=no root@45.90.34.181
expect "password:"
send "PASSWORD\r"
expect "# "
send "COMMAND\r"
expect "# "
'
# 5.35.94.118: SSH по ключу (sshpass не работает с ! в пароле)
ssh root@5.35.94.118
```

### CORS fix (nginx на AstroGuru серверах)
```bash
# Проверить текущие CORS
grep -n "Access-Control" /etc/nginx/sites-available/app.astroguru.ru
# Заменить localhost на prod
sed -i 's|http://localhost:3000|https://app.astroguru.ru|g' /etc/nginx/sites-available/app.astroguru.ru
nginx -t && systemctl reload nginx
```

## Reference-файлы

- `reference/incidents.md` -- инциденты и их разбор (rsync .env, ASTRO_DB_URL)
- `reference/server-env.md` -- таблица всех .env на сервере

## Post-deploy: закрытие задач Debugger Bot

Если деплой связан с задачей из Telegram (Debugger Bot), после успешного деплоя вызови:

```bash
ssh root@109.73.194.217 "cd /root/veda-monitor-bot && python3 complete_task.py <TASK_ID> '<что сделано — техническое описание>'"
```

Скрипт:
1. Генерирует user-friendly инструкции для тестирования (через AI)
2. Отправляет в групповой чат сообщение с кнопками "Работает / Не работает"
3. Уведомляет админа
4. Репортер подтверждает — задача закрывается

**Пример:**
```bash
ssh root@109.73.194.217 "cd /root/veda-monitor-bot && python3 complete_task.py 5 'Added date filter inputs to analytics page toolbar. Two date-input fields with reset button.'"
```

## Итоговая таблица при работе с Debugger Bot (ОБЯЗАТЕЛЬНО)

Когда в сессии выполняются задачи из Debugger Bot, после всех деплоев выдать **одну итоговую таблицу**:

```
| # | Задача | Проблема | Решение | Деплой | Отчёт в чат |
|---|--------|----------|---------|--------|-------------|
| #XX | Краткое название | Root cause | Что сделано | ✅/❌ | ✅/❌ |
```

- **Деплой**: ✅ задеплоено / ❌ не задеплоено (причина)
- **Отчёт в чат**: ✅ complete_task.py отправлен / ❌ не отправлен
- Таблица выдаётся ОДИН РАЗ в конце, а не после каждой задачи

## Post-deploy report (ОБЯЗАТЕЛЬНО)

После КАЖДОГО успешного деплоя выдать одно краткое сообщение для Алекса.
Без кода и технических терминов. Только факты и шаги для проверки.

```
## Задеплоено: <название проекта>

**Что сделано:**
- <что исправлено или добавлено — на языке пользователя>
- <что исправлено или добавлено>

**Как проверить:**
- <конкретное действие: открыть, нажать, посмотреть>
- <конкретное действие>
```

Без этого сообщения деплой считается незавершённым.

## Скрипты

- `scripts/deploy-frontend.sh` -- деплой фронтенда одной командой
- `scripts/deploy-backend.sh` -- деплой бэкенда одной командой
- `scripts/health-check.sh` -- проверка здоровья после деплоя
