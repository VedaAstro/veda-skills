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

## Golden Rule

**ВСЕГДА сначала:** `pm2 show <app-name>` — чтобы увидеть `exec cwd` (реальный каталог кода на сервере).

## Карта сервера (109.73.194.217)

| Проект | Путь на сервере | PM2 имя | Порт | Команда деплоя |
|--------|----------------|---------|------|----------------|
| Frontend (Next.js) | `/var/www/veda-presentation/` | `veda-presentation` | 3001 | `git pull && npm install && npm run build && pm2 restart veda-presentation` |
| WebSocket | `/var/www/veda-presentation/` | `veda-websocket` | 8080 | `pm2 restart veda-websocket` |
| Backend (FastAPI) | `/var/www/veda-backend/` | `veda-api` | 8000 | `git pull && pip install -r requirements.txt && pm2 restart veda-api` |
| Tanya_bot | `/root/Tanya_bot/` | `tanya-bot` | -- | `pm2 restart tanya-bot` |
| bot-admin-api | `/root/bot-admin-api/` | `bot-admin-api` | 8090 | `pm2 restart bot-admin-api --update-env` |
| bot-admin-ui | `/var/www/bot-admin-ui/` | nginx static | -- | `npm run build` + upload dist/ |
| veda-bot-v2 | `/root/veda-bot-v2/` | `veda-bot-v2` + `veda-bot-v2-api` | 8081 | `pm2 restart veda-bot-v2 && pm2 restart veda-bot-v2-api` |
| vedalab | `/root/vedalab/` | `vedalab` | -- | `pm2 restart vedalab` |

**Домены:** sales.myveda.ru (frontend), app.myveda.ru (alias), funnel.myveda.ru (bot-admin-ui)

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

### 3. Frontend деплой

```bash
ssh root@109.73.194.217 "cd /var/www/veda-presentation && git pull && npm install && npm run build && pm2 restart veda-presentation"
```

### 4. Backend деплой

```bash
ssh root@109.73.194.217 "cd /var/www/veda-backend && git pull && pip install -r requirements.txt && pm2 restart veda-api"
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

## Reference-файлы

- `reference/incidents.md` -- инциденты и их разбор (rsync .env, ASTRO_DB_URL)
- `reference/server-env.md` -- таблица всех .env на сервере

## Скрипты

- `scripts/deploy-frontend.sh` -- деплой фронтенда одной командой
- `scripts/deploy-backend.sh` -- деплой бэкенда одной командой
- `scripts/health-check.sh` -- проверка здоровья после деплоя
