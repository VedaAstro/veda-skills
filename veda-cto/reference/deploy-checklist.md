# Чеклист деплоя VEDA Platform

> Деплой - как переезд магазина в новое помещение, пока старый еще работает. Нужно убедиться что в новом все на месте, и только потом переключить вывеску.

## Перед деплоем (PRE)

| # | Что проверить | Зачем | Как |
|---|---|---|---|
| 1 | **git status чистый** | Нет забытых изменений | `git status` - должен быть пустой |
| 2 | **git push сделан** | Код в облаке, не только на ноуте | `git log --oneline -3` совпадает с GitHub |
| 3 | **Build прошел** | Сайт собирается без ошибок | `pnpm build` (или `pnpm build --webpack` для Next 16 standalone) |
| 4 | **npm audit clean** | Нет критичных дыр в библиотеках | `npm audit` - 0 critical, 0 high |
| 5 | **ENV переменные** | На сервере есть все нужные переменные окружения | Сверить `.env.example` с серверным `.env` |
| 6 | **Миграции БД** | Если менялась схема - миграция готова | `alembic upgrade head` (бэкенд) или `prisma migrate` (veda-base) |

## Универсальное правило rsync (ВСЕ проекты без исключений)

| Что деплоим | --delete | Почему |
|---|---|---|
| **Build-артефакты** (.next/standalone/.next/, .next/static/, dist/) | РАЗРЕШЕНО | Это скомпилированные файлы, безопасно перезаписать |
| **Исходный код** (src/, app/, pages/, public/, корень проекта) | ЗАПРЕЩЕНО | --delete удалит файлы которые не в git = потеря данных |
| **Python-проекты** | --exclude=venv/ ОБЯЗАТЕЛЬНО | macOS venv на Linux = сервер падает |

Это правило защищено hook'ом в `~/.claude/hooks/deploy-guard.sh`. Даже если забудешь - hook заблокирует.

## Деплой по проектам

| # | Проект | Команда | Подводные камни |
|---|---|---|---|
| 1 | **veda-backend** | `rsync -a` (без -z на macOS!) | Всегда из локальной копии, НЕ править на сервере |
| 2 | **bot-admin-api** | `rsync -a --exclude=venv/` | venv на сервере другой, не перетирать |
| 3 | **app-myveda** | `rsync -a .next/` (БЕЗ --delete!) | --delete убивает файлы пока PM2 работает = 502 |
| 4 | **app-myveda-funnel** | `rsync -avz --delete .next/` | Тут наоборот: --delete обязателен (старые JS чанки) |
| 5 | **veda-presentation** | `rsync -a .next/` (БЕЗ --delete!) | Аналогично app-myveda |
| 6 | **vedantica-site** | `pnpm build` -> `rsync -a .next/` | PM2 :3012 |
| 7 | **veda-base** | deploy.sh (TODO: создать!) | Пока нет скрипта - риск ручных ошибок |
| 8 | **veda-chat** | deploy.sh (TODO: создать!) | Пока нет скрипта |
| 9 | **vedalab** | deploy.sh (TODO: создать!) | Пока нет скрипта |
| 10 | **hr-bot** | deploy.sh (TODO: создать!) | Пока нет скрипта |
| 11 | **veda-bot-v2** | deploy.sh (TODO: создать!) | Пока нет скрипта |
| 12 | **veda-diagnostic-bot** | Даже не в git! | Первым делом: git init + git remote |

**Если проекта нет в этом списке - деплой запрещён до создания скрипта.**

## После деплоя (POST)

| # | Что проверить | Как |
|---|---|---|
| 1 | **PM2 restart** | `pm2 reload <name>` (НЕ restart если симлинк - тогда `pm2 delete + start`) |
| 2 | **Сайт открывается** | Зайти на URL в браузере, проверить главную |
| 3 | **API отвечает** | `curl` ключевого эндпоинта с реальным JWT |
| 4 | **Логи чистые** | `pm2 logs <name> --lines 20` - нет ошибок |
| 5 | **БД данные** | Если миграция - проверить что данные на месте |

## Критические правила (грабли на которые уже наступали)

1. **НИКОГДА не править файлы на сервере напрямую** - rsync затрет при следующем деплое
2. **macOS rsync: флаг -a без -z** - сжатие ломает передачу
3. **Деплой фронта + бэка ВМЕСТЕ** - иначе фронт вызывает API которого еще нет
4. **PM2 reload НЕ перечитывает симлинк current/** - нужен delete + start
5. **Деплой app-myveda-funnel = ТОЛЬКО Алекс** - Claude не деплоит
6. **.next/cache/ переживает pm2 restart** - если кеш проблема, удалить вручную
7. **UNTITLEDUI_PRO_TOKEN** нужен для npm install veda-presentation на сервере

## Серверные пути (PM2 читает отсюда)

```
bot-admin-api     → /root/bot-admin-api/
veda-api          → /var/www/veda-backend/
app-myveda        → /var/www/app-myveda/releases/<sha>/
app-myveda-funnel → /var/www/app-myveda-funnel/
veda-presentation → /var/www/veda-presentation/
veda-base         → /var/www/veda-base/
vedantica-site    → /var/www/vedantica-site/
```

Дубликаты `/root/veda-backend/`, `/root/veda-presentation/`, `/var/www/bot-admin-api/` - мертвые, PM2 их не читает.
