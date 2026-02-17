---
name: vedic-astro-knowledge
description: Полная цепочка астро-данных Veda -- AstroGuru API, база трактовок, LLM-анализ, резолверы, VedicNatalChart. Используй при работе с натальными картами, трактовками или астро-компонентами.
---

# Астро-данные Veda: полная цепочка

## Когда использовать

- Работа с натальными картами (создание, отображение, анализ)
- Интеграция с AstroGuru API
- Работа с базой трактовок (planet_in_house, functional_nature и т.д.)
- Модификация резолверов (как данные попадают в слайды)
- Работа с VedicNatalChart.tsx компонентом
- Обновление veda-astro-core библиотеки
- AI-анализ карты (LLM через OpenRouter)

## Цепочка данных (полная схема)

```
Квиз (боль, желание клиента)
    |
    v
AstroGuru API (натальная карта: 9 планет с house/sign/degree/retro/exalt/debil)
    |
    v
AstroKnowledgeService (трактовки из 6 таблиц PostgreSQL + Redis-кеш)
    |
    v
LLM (Gemini 2.0 Flash, temperature 0.3) -- персонализирует под боль клиента
    |
    v
AnalysisResult (blockedPlanet, resourcePlanet, connectionExplanation...)
    |
    v
Resolvers (resolveLive04, resolveLive05) -- трансформируют в props
    |
    v
Visual-компоненты (Visual04_PainElement, Visual05_ResourceElement)
```

## AstroGuru API -- 5 ловушек

| # | Ловушка | Правильно | Неправильно |
|---|---------|-----------|-------------|
| 1 | Формат даты | `DD.MM.YYYY` | ISO 8601, YYYY-MM-DD |
| 2 | Формат времени | `HH:MM:SS` (с секундами!) | HH:MM |
| 3 | Параметр долготы | `lon` | `lng` |
| 4 | HTTP-метод | **POST** (chart.create, getPlanetData, getUTS) | GET |
| 5 | Кеширование | Игнорирует UTC. Workaround: микро-дельта +-0.0000001 к координатам | Ожидать уникальность по UTC |

**API Chain:** Nominatim (coords) --> chart.getUTS (timezone) --> chart.create --> chart.getPlanetData --> chart.GetChartDataImage

## 6 таблиц трактовок (AstroKnowledgeService)

PostgreSQL + Redis-кеш. 300+ записей прогреваются при старте.

| Таблица | Записей | Метод | Ключевые поля |
|---------|---------|-------|---------------|
| `planet_in_house` | 108 | `get_planet_in_house(planet_id, house_num)` | core, strength, shadow, action |
| `planet_in_sign` | 108 | `get_planet_in_sign(planet_id, sign_ru)` | status (экзальт/падение/свой), core |
| `functional_nature` | 84 | `get_functional_nature(lagna_id, planet_id)` | nature, reason, is_yogakaraka |
| `nakshatras` | 27 | `get_nakshatra(number)` | name_ru, name_sa, описания |
| `yogas` | 35-50 | `get_yogas_by_category(category)` | formation_rules, effects |
| `planet_conjunctions` | 36+ | `get_planet_conjunction(p1, p2)` | effects |

**9 планет:** sun, moon, mars, mercury, jupiter, venus, saturn, rahu, ketu

## Резолверы (как данные попадают в слайды)

**Файл:** `veda-presentation/app/components/visuals/v2/resolvers.ts`

**Приоритет разрешения данных:**
1. LLM-анализ (AnalysisResult) -- если есть
2. Колесо баланса (оценки клиента) -- если заполнено
3. Роутинг (URL-параметры)
4. Hardcoded fallback (SPHERE_TO_BLOCK, SPHERE_TO_RESOURCE)

| Резолвер | Визуал | Что выдаёт |
|----------|--------|------------|
| `resolveLive04()` | Visual04_PainElement | blockedPlanet + explanation |
| `resolveLive05()` | Visual05_ResourceElement | resourcePlanet + explanation |

## Ключевые файлы

| Файл | Проект | Что делает |
|------|--------|-----------|
| `veda_astro/knowledge.py` | veda-astro-core | AstroKnowledgeService -- запросы трактовок |
| `veda_astro/astro_service.py` | veda-astro-core | Клиент AstroGuru API |
| `services/astro.py` | veda-backend | Бэкенд-обёртка AstroGuru |
| `app/lib/openrouter.ts` | veda-presentation | LLM-анализ карты (analyzeChart) |
| `app/components/visuals/v2/resolvers.ts` | veda-presentation | Трансформация данных в props |
| `app/components/shared/VedicNatalChart.tsx` | veda-presentation | SVG-рендер натальной карты (654 строки) |

## VedicNatalChart.tsx -- ключевые факты

- 654 строки, SVG с PNG-планетами (заменяет картинку от AstroGuru)
- Props: `planets`, `planetImageUrls`, `highlightedHouses`, `showHouseIcons`, `showZodiacSigns`
- Размеры: small (200px), medium (340px), large (440px)
- Подсветка домов: `highlightedHouses: { house: number, color: 'red'|'green'|'orange', label?: string }[]`
- Геометрия: 12 домов -- cardinal (1,4,7,10 ромб), corner (2,6,8,12 треугольник), inner (3,5,9,11 треугольник)

## Библиотека veda-astro-core

- **Установка:** `pip install -e /path/to/veda-astro-core` (editable mode)
- **На сервере:** `pip install -e /root/veda-astro-core`
- **Импорт:** `from veda_astro import AstroService, AstroKnowledgeService`
- **Потребители:** Tanya_bot, veda-bot-v2, veda-backend
- **Redis:** DB=1 (отдельный от основного)
- **При обновлении:** перезапустить ВСЕ зависимые сервисы
