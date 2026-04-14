# VEDA SEO Measurement And Debug

## Когда открывать

- Нужно понять, растёт SEO или нет
- Есть падение трафика, CTR или индексации
- Нужно измерять эффект публикаций, а не просто “делать SEO”

## Главный принцип

Сильный современный SEO skill должен не только аудировать HTML, но и уметь замыкать цикл:
- `диагностика`
- `изменение`
- `измерение`
- `разбор причин`

## Google: что использовать

### Search Console

Что смотреть:
- clicks
- impressions
- CTR
- average position
- indexing / coverage / URL inspection

Практически важно:
- AI Overviews и AI Mode не требуют отдельной “AI schema”; Google пишет, что действуют обычные SEO best practices
- трафик из AI features учитывается внутри общего `Web` трафика в Search Console
- в 2025 Google добавил hourly data в Search Analytics API: это удобно для свежих публикаций и инцидентов
- в конце 2025 появился branded vs non-branded analysis в Search Console: нужен для разделения brand demand и реального SEO growth

### Google Analytics

Что смотреть:
- sessions из organic search
- engagement rate
- conversions / leads

Правило:
- Search Console отвечает на вопрос “что видно и кликают ли”
- GA отвечает на вопрос “приходит ли качественный трафик и делает ли целевое действие”

## Yandex: что использовать

### Yandex Webmaster

Что смотреть:
- site diagnostics
- indexing / crawl stats
- region
- sitemap status
- structured data validator

Факты:
- `Sitemap` у Яндекса часто обрабатывается до двух недель
- для удаления страницы из поиска нужен `noindex`/`X-Robots-Tag`, а не только `robots.txt`
- `Clean-param` полезен для UTM и дублей по параметрам

### Yandex Metrica

Что смотреть:
- search traffic
- engagement / depth / time on site
- goal conversion
- Webvisor / click maps для проблем первого экрана и CTA

## Debug Loop

### Если упал Google organic

Порядок:
1. Проверить Search Console Performance
2. Разделить branded и non-branded
3. Сравнить clicks, impressions, CTR, position
4. Проверить URL Inspection и indexability
5. Проверить, не затронули ли страницу policy/quality issues
6. Сопоставить с GA: просел ли engagement / conversions

### Если упал Yandex

Порядок:
1. Проверить Site diagnostics
2. Проверить `robots.txt`, `Sitemap`, server response
3. Проверить regionality и contact signals
4. Проверить crawl stats / indexing lag
5. Проверить сниппет, title, description, commercial completeness

## KPI, которые реально нужны skill-у

- indexable pages
- indexed pages
- non-branded clicks
- CTR by template type
- engagement rate by landing type
- lead conversion by landing type
- publication-to-index lag
- first 7 days performance for new pages

## Чего нам сейчас не хватает в skill

- прямой интеграции с Search Console API
- прямой интеграции с Yandex Webmaster / Metrica
- шаблона расследования traffic drops на уровне skill-команды
- автоматического hourly monitoring для новых публикаций
