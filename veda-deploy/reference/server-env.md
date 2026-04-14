# Серверные .env файлы

## Таблица env-файлов

| Проект | .env на сервере | DATABASE_URL | Ключевые переменные |
|--------|-----------------|--------------|---------------------|
| veda-backend | `/var/www/veda-backend/.env` | `postgresql+asyncpg://root@/veda_crm` | JWT_SECRET, OPENROUTER_API_KEY, ASTROGURU_API_URL, S3_* |
| bot-admin-api | `/root/bot-admin-api/.env` | `postgresql+asyncpg://root@/bot_admin` | API_KEY, OPENROUTER_API_KEY, ASTRO_DB_URL, GETCOURSE_* |
| Tanya_bot | `/root/Tanya_bot/.env` | -- (PicklePersistence) | BOT_TOKEN, OPENROUTER_API_KEY, ASTROGURU_API_URL, ADMIN_BOT_KEY |
| veda-bot-v2 | `/root/veda-bot-v2/.env` | `postgresql+asyncpg://root@/veda` (Unix socket) | BOT_TOKEN, OPENROUTER_API_KEY, REDIS_HOST, ADMIN_API_URL |
| veda-presentation | `/var/www/veda-presentation/.env` (ожидаемо), фактически сейчас `/var/www/veda-presentation/.env.local` | -- (BFF, no direct DB) | BACKEND_URL, OPENROUTER_API_KEY, GROQ_API_KEY, DAILY_API_KEY |

## Важно

- Все серверные DATABASE_URL через **Unix socket** (peer auth): `root@/dbname`
- Локальные Mac DATABASE_URL через **TCP**: `alexlee@localhost:5432/dbname`
- **НИКОГДА** не перезаписывать серверный .env локальным (см. incidents.md)
- PostgreSQL: пользователь `root` на сервере = superuser
- 2026-03-17: у `veda-presentation` был prod incident из-за env drift: `GROQ_API_KEY` отсутствовал в фактическом серверном env-файле `.env.local`, поэтому `/api/transcribe` отвечал `500 GROQ_API_KEY not configured`
