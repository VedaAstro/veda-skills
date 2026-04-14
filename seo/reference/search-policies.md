# VEDA SEO Search Policies

## Когда открывать

- Делаем programmatic SEO
- Планируем массовый контент
- Подключаем third-party authors, guest content или marketplace content
- Хотим понять, где проходит граница между growth и spam risk

## Google: что критично в 2026

### People-first content

Google прямо пишет: полезный контент создаётся прежде всего для людей, а не для манипуляции ранжированием.

Для skill это означает:
- не оценивать страницу только по keyword coverage
- не генерировать thin pages ради масштаба
- не считать SEO-успехом рост страниц без engagement и value

### Anti-abuse policies

Официально зафиксированы риски:
- `scaled content abuse`
- `site reputation abuse`
- `expired domain abuse`

Для VEDA это значит:
- не публиковать массово однотипные AI-страницы без уникальной ценности
- не хостить сторонний SEO-контент на трастовом домене “ради трафика”
- не пытаться прятать проблему переносом такого контента на subdomain/subdirectory того же сайта

## Programmatic Quality Gates

Перед публикацией батча страниц skill должен проверять:

```text
□ у страницы есть уникальная ценность, а не только шаблон
□ контент реально отвечает на запрос
□ есть author/entity clarity
□ есть internal links и место в архитектуре сайта
□ есть CTA / business value, если запрос коммерческий
□ нет ощущения “1000 страниц ради long-tail”
```

## Structured Data Reality

Schema нужна, но не как фетиш.

Важно:
- structured data должна соответствовать видимому тексту страницы
- Google в 2025-2026 продолжил убирать часть search features и reporting для редких schema types
- опирайся на устойчивые типы: `Article`, `FAQPage`, `BreadcrumbList`, `Person`, `Organization`, `WebSite`, `Service`, `Offer`

Не строй стратегию вокруг исчезающих rich result features.

## AI Search Reality

Google официально пишет:
- для AI Overviews и AI Mode нет отдельных требований
- не нужен специальный AI markup
- не нужны специальные AI text files для появления в этих features

Практический вывод:
- `llms.txt` можно использовать как дополнительную навигацию для других систем, но это не ranking lever для Google Search
- GEO в skill должен идти как дополнение к обычному SEO, а не как замена

## Yandex Policy Reality

Для Яндекса важны:
- индексируемость
- структура текста
- региональность
- качество snippet/commercial signals
- корректные directives (`noindex`, `X-Robots-Tag`, `Clean-param`, `Sitemap`)

Практический вывод:
- `robots.txt` не удаляет страницу из поиска сам по себе
- для дублей по параметрам надо учитывать `Clean-param`
- region и контакты для коммерческих страниц обязательны
