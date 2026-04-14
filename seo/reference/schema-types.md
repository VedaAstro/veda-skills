# VEDA SEO Schema Types

## Когда открывать

- Нужно выбрать JSON-LD для страницы
- Нужно понять, какие schema комбинировать
- Нужно быстро собрать минимальный валидный шаблон

## Базовые правила

- Не ставь schema ради schema
- Выбирай тип по назначению страницы
- Сначала обязательные поля, потом enrichment
- Для programmatic и AI search важнее валидность и ясность entity, чем экзотика

## 1. Article

Для:
- programmatic knowledge pages
- editorial pages
- long-form explanations

Минимум:

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Марс в 7 доме натальной карты",
  "author": {
    "@type": "Organization",
    "name": "AstroGuru"
  },
  "publisher": {
    "@type": "Organization",
    "name": "AstroGuru"
  },
  "datePublished": "2026-03-14",
  "dateModified": "2026-03-14",
  "mainEntityOfPage": "https://astro.myveda.ru/planeta/mars-v-7-dome"
}
```

## 2. FAQPage

Для:
- FAQ-блоков на knowledge/service pages
- GEO и answer-first структуры

Замечание:
- Rich results у Google для FAQ сильно урезаны
- Но для AI search и ясности структуры schema всё ещё полезна

## 3. BreadcrumbList

Для:
- практически любой индексируемой страницы

Нужна всегда, когда есть иерархия:
- главная -> раздел -> страница

## 4. DiscussionForumPosting

Для:
- community threads
- страницы с основным UGC и комментариями

Минимум:
- headline
- author
- datePublished
- interactionStatistic

## 5. Person

Для:
- профиль астролога
- авторские материалы

Минимум:
- name
- jobTitle
- image
- sameAs
- alumniOf / worksFor при наличии

## 6. AggregateRating

Для:
- профилей и услуг, где реально есть отзывы

Не использовать:
- если отзывов нет
- если rating нельзя подтвердить на странице

## 7. Offer / Service

Для:
- страниц услуг
- профилей с записью
- лендингов консультаций

Минимум:
- name
- description
- price
- priceCurrency
- availability при наличии

## Рекомендуемые связки

| Тип страницы | Schema |
|--------------|--------|
| Programmatic knowledge | `Article` + `FAQPage` + `BreadcrumbList` |
| Community thread | `DiscussionForumPosting` + `BreadcrumbList` |
| Профиль астролога | `Person` + `AggregateRating` + `Offer` |
| Лендинг услуги | `Service` + `Offer` + `FAQPage` + `BreadcrumbList` |

## 8. Entity SEO (для programmatic страниц)

Entity SEO — оптимизация под сущности (entities), а не ключевые слова.
Google Knowledge Graph содержит миллиарды сущностей и связей.

### Зачем

Поисковики всё больше работают на уровне сущностей, а не keywords.
Astro-ниша идеально ложится: знаки, планеты, дома, накшатры — все есть в Wikidata.

### Как реализовать

1. **`about` в Article schema:**
```json
{
  "@type": "Article",
  "about": {
    "@type": "Thing",
    "name": "Марс в 7 доме",
    "sameAs": "https://www.wikidata.org/wiki/Q111"
  }
}
```

2. **Связи между сущностями через перелинковку:**
- Планета → все дома, где эта планета
- Дом → все планеты в этом доме
- Знак → все планеты в этом знаке
- Строим внутренний knowledge graph сайта

3. **Явное описание атрибутов:**
- Не «Марс влияет», а «Марс (планета энергии и действия) в 7 доме (партнёрство, брак)»
- Первое упоминание сущности — с пояснением в скобках

4. **Alignment с Wikidata:**
- Использовать те же названия и связи, что в Wikidata
- `sameAs` ссылки на Wikidata entities где применимо

### Для VEDA

Астрология — одна из лучших ниш для entity SEO:
- Конечный набор сущностей с математически определёнными связями
- Каждая комбинация = уникальная entity
- Полное покрытие = topical authority

## Антипаттерны

- Не добавляй `FAQPage`, если FAQ визуально нет на странице
- Не ставь `AggregateRating` без реальных отзывов
- Не смешивай 5-6 несовместимых сущностей в один page blob
- Не забывай `mainEntityOfPage`, даты и автора там, где контент авторский
- Не пиши `about` без `sameAs` — без ссылки на внешнюю сущность это пустая разметка
