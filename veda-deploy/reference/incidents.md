# Инциденты деплоя

## Инцидент 1: rsync перезаписал .env (Feb 12, 2026)

**Что случилось:**
rsync без exclude перезаписал серверный `.env` (с `DATABASE_URL=root@/bot_admin`) локальным (`alexlee@localhost`). Также перезаписал серверный `venv/` Mac-бинарниками. API упала.

**Почему:**
```bash
# НЕПРАВИЛЬНАЯ команда (без exclude)
rsync -avz . root@server:/root/bot-admin-api/
```

**Как пофиксили:**
1. Восстановили .env на сервере вручную
2. Пересоздали venv:
```bash
ssh root@109.73.194.217 'cd /root/bot-admin-api && rm -rf venv && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt && pip install -e /root/veda-astro-core'
```
3. `pm2 restart bot-admin-api --update-env`

**Как не повторить:**
ВСЕГДА использовать exclude:
```bash
rsync -avz --exclude '.env' --exclude '.venv' --exclude 'venv' --exclude '__pycache__' --exclude '.git' --exclude '*.pyc' . root@server:/root/bot-admin-api/
```

---

## Инцидент 2: ASTRO_DB_URL не в .env на сервере (Feb 2026)

**Что случилось:**
`ASTRO_DB_URL` была в коде, но не в `.env` на сервере. Трактовки из astro_knowledge тихо возвращали пустые данные неделями. Код не падал, просто данные были неполные.

**Почему:**
Новая env-переменная добавлена в код, но не прописана на сервере. PM2 не подхватил.

**Как пофиксили:**
1. Добавили в `.env` на сервере
2. `pm2 restart bot-admin-api --update-env`

**Как не повторить:**
При каждой новой env-переменной -- 4 шага:
1. `.env.example`
2. `_validate_env()` (если есть)
3. Прописать на сервере
4. `pm2 restart --update-env`
