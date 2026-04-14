# Veda Skills (canonical source)

Канонический каталог навыков VEDA для **Claude Code** и **Codex**: репозиторий на диске, без Google Drive как SSOT.

## Где лежит код

| Путь | Назначение |
|------|------------|
| **`/Users/alex/Projects/shared/veda-skills/`** | Исходники SKILL.md (эта папка) |
| `~/.codex/skills` | Рекомендуется symlink → `shared/veda-skills` (см. `AGENTS.md` → CODEX BOOTSTRAP) |
| `~/.claude/skills` | Можно symlink на тот же каталог или дублировать выборочно |

Обновление навыков: `git pull` в корне `Projects` (или в submodule, если подключите отдельный репозиторий).

## Политика секретов

В skills **не** кладём пароли, токены, приватные ключи. Операционные секреты — только вне git (`~/.claude/.../memory/`, `.env`, менеджеры секретов).

## Список навыков (кратко)

### Платформа / инженерия

| Навык | Назначение |
|-------|------------|
| `veda-deploy` | Деплой: rsync, PM2, env, build |
| `veda-backend-patterns` | FastAPI, Enum, роуты, BFF |
| `veda-frontend-patterns` | Next.js, BFF, auth |
| `veda-debugging` | Отладка по фазам |
| `veda-testing` | pytest / Vitest / Playwright |
| `veda-spec-execution` | Жизненный цикл SPEC |
| `veda-database-schema` | Схема veda_crm |
| `veda-ui-system` | Untitled UI, токены |

### Личное

| Навык | Назначение |
|-------|------------|
| `movie-picks` | Фильмы и сериалы для Алекса: solo и с женой. Вкусовой профиль + алгоритм + база просмотренного |

### Продукт / контент / орг

| Навык | Назначение |
|-------|------------|
| `veda-brainstorm` | Дизайн до кода |
| **`webinar`** | **Вебинары Ирины Чайки — ядро (метаправило, нарративы, голос, миссия), подпапки buyer/ (сегменты, барьеры), types/ (прогрев/оффер/дожим), library/ (кейсы, пруфы, продукт, визуалы, астро)** |
| `landing-architect` | Лендинги: регистрация + оффер |

**⚠️ Устарело (в `_archive/`):** `webinar-architect-v1`, `webinar-production-v1`, `buyer-persona-v1` — заменены единым скиллом `webinar/`. Старые не читать.
| `astro-content` | Астро-контент |
| `ceo-consulting` | PGAC, метрики (часто в глобальном `~/.claude/skills`) |

Полный список — в каталогах рядом с этим README (`*/SKILL.md`).

## Поведение агента (SSOT)

Правила поведения, архитектура, деплой, интеграции — в **`/Users/alex/Projects/AGENTS.md`**.  
Claude в этом workspace: **`.claude/CLAUDE.md`** — тонкий указатель на `AGENTS.md`, без дублирования длинных политик.
