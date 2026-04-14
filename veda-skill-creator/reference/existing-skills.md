# Реестр навыков Veda

Последнее обновление: 2026-03-18

## Быстрый поиск по задаче

| Задача | Команда |
|--------|---------|
| Уточнить требования перед кодом | `/brainstorm` |
| Исполнить спеку по фазам | `/spec` |
| Найти баг, системная диагностика | `/debug` |
| Стратегический анализ (мульти-агент) | `/council` |
| Создать новый скилл | `/skill-new` |
| Промпт-инжиниринг, структура, XML | `/prompt` |
| Деплой на прод | `/deploy` |
| FastAPI, SQLAlchemy, Alembic | `/backend` |
| Next.js, BFF, auth, WebSocket | `/frontend` |
| Design tokens, компоненты, лейауты | `/ui` |
| Схема БД, таблицы, enum'ы | `/db` |
| Тесты (pytest, Vitest, Playwright) | `/test` |
| Аудит скорости, бандлы | `/perf` |
| Telegram разметка (HTML/MD) | `/tg-format` |
| Дашборды, KPI, воронки | `/analytics` |
| Курс VEDA: тарифы, модули, 7Н/5S | `/offer` |
| Проектирование обучения + удержание | `/edu` |
| UX-дизайн: Gestalt, когнитивная психология | `/ux` |
| Аудитория, боли, сегменты | `/buyer` |
| Найм, рекрутинг, адаптация, KPI new hires | `/hr` |
| AstroGuru API, трактовки, Redis | `/astro` |
| БПХШ: верификация астрорасчётов | `/bphs` |
| Генерация астро-контента | `/astro-content` |
| Диагностическая сессия 1-на-1 | `/diagnostic` |
| Вебинар: структура + продакшн | `/webinar` |
| CJM, бот-воронки, механики | `/cjm` |
| Архивация, валидация MEMORY | `/cleanup` |
| Статус инфраструктуры | `/status` |

## Полный каталог (25 скиллов, 31 команда)

### Process — как работать

| Команда | Скилл | Описание | Файлы |
|---------|-------|----------|-------|
| `/brainstorm` | veda-brainstorm | Design-first: уточнение требований, исследование перед кодом, генерация идей | SKILL.md |
| `/spec` | veda-spec-execution | Исполнение спеки: фазы, чеклисты, handoff между фазами | SKILL.md |
| `/debug` | veda-debugging | Systematic debugging: 4 фазы (symptoms→hypothesis→verify→fix), root cause first | SKILL.md |
| `/council` | ceo-council | Мульти-агентный стратегический анализ: 3-5 Opus-агентов с разными ролями | SKILL.md |
| `/skill-new` | veda-skill-creator | Мета-навык: шаблон SKILL.md, чеклист качества, протокол "сохрани как скилл" | SKILL.md, reference/existing-skills.md |
| `/prompt` | prompt-engineering | 28 техник промпт-инжиниринга: XML-теги, псевдокод, self-check, Few-Shot | SKILL.md |

### Platform — чем строить

| Команда | Скилл | Описание | Файлы |
|---------|-------|----------|-------|
| `/deploy` | veda-deploy | PM2, nginx, rsync, env-переменные, build | SKILL.md, reference/ |
| `/backend` | veda-backend-patterns | FastAPI паттерны: enum .value gotcha, роутеры, BFF, SQLAlchemy | SKILL.md |
| `/frontend` | veda-frontend-patterns | Next.js 14: BFF no-store, auth JWT, WebSocket, static routes first | SKILL.md |
| `/ui` | veda-ui-system | Untitled UI Pro: CLI, компоненты, токены, лейауты | SKILL.md, reference/ |
| `/db` | veda-database-schema | 48 таблиц veda_crm: схема, связи, enum'ы, миграции Alembic | SKILL.md, reference/ |
| `/test` | veda-testing | pytest + Vitest + Playwright | SKILL.md |
| `/perf` | veda-performance | Аудит скорости: code splitting, lazy loading, мемоизация | SKILL.md, reference/ |
| `/tg-format` | telegram-formatting | Telegram Bot API: HTML vs Markdown, экранирование, лимиты | SKILL.md |
| `/analytics` | veda-data-analytics | Дашборды, KPI, воронки, таблицы (AG Grid + Recharts) | SKILL.md |

### Domain — Продукт и обучение (4 скилла)

| Команда | Скилл | Описание | Файлы |
|---------|-------|----------|-------|
| `/offer` | *(ref в webinar-production)* | Курс VEDA 7Н/5S: тарифы, модули, НейроАстролог, Astroguru, value stack | reference/product.md |
| `/edu` | edu | Проектирование обучения + удержание: андрагогика, геймификация, churn, peer-learning, 4 слоя retention | SKILL.md, reference/ (8 файлов) |
| `/ux` | veda-product-design | UX-принципы: Gestalt, когнитивная психология, композиция, emotional design, value map | SKILL.md, reference/ |
| `/buyer` | buyer-persona | Аудитория: сегменты, боли, барьеры, мотивации, JTBD | SKILL.md |
| `/hr` | hr | Найм, рекрутинг, structured interviews, тестовые, onboarding, вывод на KPI | SKILL.md, reference/ |

### Domain — Астро

| Команда | Скилл | Описание | Файлы |
|---------|-------|----------|-------|
| `/astro` | vedic-astro-knowledge | AstroGuru API, трактовки планет/домов, Redis кеш, LLM-резолверы | SKILL.md |
| `/bphs` | bphs-playbook | БПХШ: 8 модулей, 7500+ строк, верификация всех астрорасчётов | SKILL.md |
| `/astro-content` | astro-content | Генерация астро-контента: прогнозы, транзиты, совместимость | SKILL.md |
| `/diagnostic` | diagnostic-workstation | Диагностическая сессия: сократический подход, 3 волны, 9 срезов карты | SKILL.md |

### Domain — Воронки и контент

| Команда | Скилл | Описание | Файлы |
|---------|-------|----------|-------|
| `/cjm` | cjm-bot-mechanics | CJM бот-воронок: AARRR, Hook Loop, 26 механик, 5 шаблонов воронок | SKILL.md, reference/ |
| `/webinar` | webinar-architect + webinar-production | Вебинары: структура (Hormozi) + продакшн (голос, кейсы, визуалы) | 2× SKILL.md, reference/ |

### Утилиты (без скилла)

| Команда | Описание |
|---------|----------|
| `/cleanup` | Архивация SPECs, валидация MEMORY.md |
| `/status` | Текущий статус серверов и сервисов |
| `/handoff` | Алиас для `/spec` |
