---
name: veda-seo
description: SEO-навык VEDA: Яндекс-first + Google. Используй при SEO-аудите, техничке, GEO, programmatic SEO, индексации и упаковке страниц/контента под поиск.
---

# VEDA SEO

## Когда использовать

- Нужен SEO-аудит страницы или сайта
- Нужна техпроверка: robots, sitemap, canonicals, metadata, schema
- Нужен workflow для programmatic SEO, community SEO, author/profile SEO, hreflang
- Нужна подготовка контента под AI search: Яндекс Нейро, Google AI Overviews, ChatGPT, Perplexity
- Нужен SEO-план для migration/cutover, batch pages или comparison pages

## Ключевые правила

- VEDA = `Яндекс-first`, но без игнора Google
- Для аудита сначала запускай локальный раннер, потом делай выводы
- Runtime-аудит = основа. Hreflang / competitor pages / visual QA / programmatic quality gates идут через playbook'и, а не через выдуманные автопроверки
- Не путай page-level findings с off-page гипотезами
- Не заявляй про backlinks, SERP, позиции и Core Web Vitals, если их не измеряли
- Для Google AI features сначала индексируемость, visible text, internal linking, валидная schema
- Для VEDA важнее полезность, коммерческая полнота, авторство и индексация, чем keyword stuffing
- Не тащи в рекомендации псевдо-точные GEO-метрики без официальной опоры или собственных измерений
- `SKILL.md` только маршрутизирует; детали открывай из `reference/`

## Быстрый маршрут

### 1. Если нужен аудит URL

```bash
cd /Users/alex/Projects/shared/veda-skills/veda-seo
npm install
node scripts/run-audit.js --url "https://example.com" --tier standard --engines google,yandex --output ./deliverables/
```

После запуска:
- Сначала `Critical Issues`, потом `Warnings`
- Потом `Google Signals`, `Yandex Signals`, `GEO Diagnostics`

### 2. Если задача про специальный SEO-workflow

- Открой `reference/specialized-workflows.md`
- Выбери нужный playbook: `programmatic`, `offpage`, `hreflang`, `competitor-pages`, `eeat`, `visual-qa`

### 3. Если задача про упаковку страниц и контента

- Открой `reference/content-templates.md`
- Для schema открой `reference/schema-types.md`
- Для Яндекс-логики открой `reference/yandex-factors.md`
- Для AI-search и цитируемости открой `reference/geo-playbook.md`
- Для measurement и расследования падений открой `reference/measurement-debug.md`
- Для policy guardrails открой `reference/search-policies.md`

### 4. Если задача про сам навык

- Не раздувай этот файл
- Новые инструкции клади в `reference/`
- Runtime меняй аккуратно: это практическая основа навыка

## Команды

- `/seo audit [url]`
- `/seo technical [url]`
- `/seo content [url|тип страницы]`
- `/seo schema [url|тип страницы]`
- `/seo geo [url|тип страницы]`
- `/seo programmatic [url|тип кластера]`
- `/seo hreflang [url|кластер]`
- `/seo competitor-pages [бренд|страница]`
- `/seo visual [url]`
- `/seo plan [site|migration|launch]`

## Self-check

- Сначала запущен аудит, потом формулируются выводы
- Яндекс-специфика явно отделена от Google-специфики
- Практические шаги идут раньше общих советов
- Если workflow не покрывается runtime, открыт правильный playbook из `reference/`
- Слабые upstream-эвристики не выдаются как факты
- Используются реальные `reference/*`, а не мёртвые ссылки

## Reference-файлы

- Core: `audit-runtime.md`, `audit-checks.md`, `specialized-workflows.md`
- Page/content: `content-templates.md`, `schema-types.md`, `geo-playbook.md`, `eeat-playbook.md`, `visual-qa-playbook.md`
- Strategy/risk: `programmatic-playbook.md`, `offpage-playbook.md`, `competitor-pages.md`, `hreflang-playbook.md`, `search-policies.md`
- Measurement/ops: `measurement-debug.md`, `mcp-stack.md`, `domain-onboarding-checklist.md`, `yandex-factors.md`
- Research/upstream: `research-sources-2026.md`, `upstream-indexlift.md`, `upstream-claude-seo.md`
