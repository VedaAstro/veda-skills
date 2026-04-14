# VEDA SEO Audit Runtime

## Что это

Локальный раннер для быстрого SEO/GEO-аудита страницы с артефактами:
- Markdown report
- JSON artifact

Он полезен как стартовая диагностика перед любыми выводами по SEO.

## Что умеет

- single-page аудит по умолчанию
- optional crawl mode для ограниченного обхода внутренних страниц
- отдельные findings для `google` и `yandex`
- отдельный GEO-слой
- scoring по technical / on-page / engine / performance

## Что не умеет

- backlink research
- SERP positions
- competitor intelligence
- реальный Core Web Vitals field data
- live LLM citation measurement
- JS-rendered DOM validation
- URL Inspection / Search Console data
- Yandex Webmaster / Metrica live diagnostics

## Как запускать

```bash
cd /Users/alex/Projects/shared/veda-skills/veda-seo
npm install
node scripts/run-audit.js --url "https://example.com" --tier standard --engines google,yandex --output ./deliverables/
```

Опции:
- `--url` — целевой URL
- `--mode` — `single-page` или `crawl`
- `--tier` — `basic`, `standard`, `pro`
- `--engines` — список движков, обычно `google,yandex`
- `--output` — папка для Markdown и JSON
- `--max-pages` — лимит страниц для crawl
- `--max-depth` — глубина crawl

## Как читать результат

Порядок:
1. `Critical Issues`
2. `Warnings`
3. `Technical SEO`
4. `Google Signals`
5. `Yandex Signals`
6. `GEO Diagnostics`

Правило:
- сначала фиксируем indexability / canonical / robots / noindex / broken metadata
- потом улучшаем snippet, structure, schema и trust
- потом обсуждаем стратегию, контент и GEO

## Что ещё нужно для полноценного modern SEO skill

- интеграция с Google Search Console API
- интеграция с Yandex Webmaster и Метрикой
- отдельный drop-debug workflow
- отдельная проверка JS-rendered content vs raw HTML
- шаблон оценки batch publishing / scaled content risk
