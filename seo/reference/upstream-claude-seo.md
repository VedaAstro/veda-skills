# Upstream Note — claude-seo

Источник:
- Repo: `https://github.com/AgriciDaniel/claude-seo`
- License: MIT

Что взято в `veda-seo`:
- command surface как оркестратор workflow'ов
- идея разделять runtime-аудит и специализированные playbook'и
- направления: `programmatic`, `hreflang`, `competitor-pages`, `visual`, `E-E-A-T`
- актуальные guardrails по INP вместо FID и нюансам FAQPage

Что сознательно не принято:
- неподтверждённые GEO-числа и корреляции как “оптимальная длина пассажа”
- громкие метрики про AI citation без собственных измерений
- Claude-specific install/agent architecture как будто она у нас есть 1:1
- рекомендации, которые требуют внешних платных данных без реальной интеграции

Практический вывод:
- upstream ценен как упаковка workflows и command design
- наш skill остаётся VEDA-specific, runtime-first и факт-ориентированным
