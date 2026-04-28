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

## SSOT: `platform/scripts/ops/deploy.sh <profile>` (с 2026-04)

**Все деплои идут через `bash platform/scripts/ops/deploy.sh <profile>`**, не ручной rsync.
Скрипт делает: ssh → git fetch/checkout deploy-branch → build → pm2 reload/docker compose up → health-check.
Профили в самом скрипте, добавляются по мере подключения проектов.

### Ключевые профили

| Профиль | Что делает | Deploy-ветка | Health-check |
|---|---|---|---|
| `astro-gateway` | Docker stack на 217 (gateway + astro-core) | `prod-snapshot-2026-04-26` | `127.0.0.1:8092/api/v2/chart.getYogasCategories` ждёт 20 категорий |
| `bot-admin-api` | atomic release `/var/www/bot-admin-api/releases/<sha>/` + symlink | `main` | `127.0.0.1:8090/api/health/db` |
| `app-myveda`, `app-myveda-funnel`, `veda-presentation`, `vedantica-site`, `veda-base` | rsync + PM2 reload | per-profile | per-profile |
| `vpn-watchdog` | sync scripts → /etc/vpn-watchdog/ + cron | `main` | свежий лог endpoint-check через 6 мин |

**Если проекта нет в `deploy.sh` — деплой запрещён до добавления профиля.**

## Astro stack — деплой кода Core/Gateway/Lagna/Planet

Особенности (важно для Wave 1 правок):

1. **PR base = `prod-snapshot-2026-04-26`** (не main). Это deploy-ветка, deploy.sh её и пуллит.
2. **Auth для PR в AstroAcademy/* org**: `gh auth switch -u AgentAstro1` (НЕ VedaAstro).
3. **Auth для git push в platform-ops**: `gh auth switch -u VedaAstro` (AgentAstro1 не имеет access). Симметрично — у Auth токенов разные org-scopes, помни какой репо где.
4. **Build verify** идёт на 217 (нужен libswe для CGO Swiss Ephemeris). На Mac `go build` фейлит на link stage — это норма; `go vet` достаточно для локальной валидации.
5. **После deploy ОБЯЗАТЕЛЬНО**: `python3 platform/scripts/astro/snapshot-diff.py --base-url http://109.73.194.217:8092/api/v2`. Ожидание `total=180 matched=180`. Любой mismatch = revert PR.

## Codex для рефакторинга (lessons from W1.3, 2026-04-28)

Codex запускается через `bash platform/scripts/codex_launcher.sh run --workdir <repo> --prompt-file /tmp/codex-*.txt --background --retry-once --run-id <name>`.

**ВСЕГДА проверяй diff Codex'а после reflactor**, особенно при параллелизации:

- **Кейс W1.3**: Codex положил `CreatePlanetsDegree` в errgroup рядом с `CalculateLagna`, но изменил вход с `LagnaFullDegree: lagnaResp.Ascendant` на `LagnaFullDegree: 0`. Параллелизм формально корректен, но **изменил входы → сломал бы snapshot**. Codex флагнул это как «uncertainty», но всё равно открыл PR. Если бы я мерджил без чтения diff'а — поломка астро-расчётов на проде, тихая регрессия.
- **Правило**: Codex не панацея. После каждого PR — read diff (`git show`), особенно ищи изменения **значений входов** в распараллеленных вызовах. Если Codex говорит «matches other call sites» — это не проверка, это отговорка.
- **Mitigation**: snapshot-diff.py 180/180 ловит такие изменения автоматически. Workflow: Codex → read diff → если сомнения, пиши fix сам → merge → deploy → snapshot-diff. Без snapshot-diff — не мерджи.

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

8. **Codex параллелизация** — обязательно read diff перед merge (см. §Codex выше)
9. **snapshot-diff.py** — золотой стандарт регрессии для astro-stack. 180/180 = ok, любой mismatch = revert
10. **astro PR base = prod-snapshot-2026-04-26** (НЕ main)
11. **gh auth context matters**: AgentAstro1 для AstroAcademy, VedaAstro для VedaAstro/platform-ops
12. **pg_stat_statements может быть `shared_preload_libraries` НО не `CREATE EXTENSION`** — две разные вещи. После каждого DB hardening: `SELECT extname FROM pg_extension WHERE extname='pg_stat_statements';` подтверждает что extension реально создана в нужной БД. Без этого top-20 slow queries недоступен.
13. **UFW на проде безопасно**: `ss -tlnp | grep 0\.0\.0\.0` → allowlist все текущие порты → enable. Self-test SSH ПОСЛЕ enable обязателен (recovery: Timeweb console + `ufw disable`).

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
