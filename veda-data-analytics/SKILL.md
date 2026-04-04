---
name: veda-data-analytics
description: Техническая реализация дашбордов и визуализации данных. Стек: Recharts + AG Grid + Untitled UI. Методология PGAC берется из ceo-consulting, здесь только визуализация и API shell.
---

# Veda Data Analytics — Техническая реализация

> Управленческая методология (PGAC, Result/Driver/Health, декомпозиция прибыли, management OS) живет в `ceo-consulting`.
> Этот скилл — только про реализацию: какой chart, какой компонент, как связать с API.
> Здесь НЕ живут: `one-on-one`, `weekly review`, `maturity`, `performance review`, управленческие ритуалы.

---

## 1. Привязка цикла PGAC к дашборду

Каждая фаза PGAC → конкретный визуальный паттерн:

| Фаза | Что показывать | Паттерн |
|------|---------------|---------|
| PLAN | План по result + декомпозиция на drivers | Scorecard row: план / факт / ГЭП |
| GAP: какой driver | Декомпозиция ГЭПа | KPI Tree или table с подсветкой просевшего |
| GAP: тренд | Driver за 4-8 недель | Line chart (тренд, не точка) |
| GAP: цена | Потери в ₽ | Badge/callout: "потери: 47 000 ₽/мес" |
| GAP: RCA | Почему просел | Health-метрики за drill-down |
| ACT | Driver + задача + прогноз | Action card или строка в таблице |
| CHECK | Прогноз vs факт | Bar chart: прогноз / факт, delta |

---

## 2. Chart Selection Rules

| Вопрос | Тип | Компонент |
|--------|-----|-----------|
| Как меняется во времени? | Line/Area | `<LineChart>` / `<AreaChart>` |
| Как соотносятся шаги воронки? | Horizontal Bar (убывающие) | `<BarChart layout="vertical">` |
| Кто лучший / хуже нормы? | Scorecard + Bar | AG Grid mini-bar cell |
| Как распределены значения? | Bar (sorted desc) | `<BarChart>` |
| Сравнение двух периодов | Line (два ряда) | `<LineChart>` с двумя `<Line>` |
| Состав целого | Stacked Bar | `<BarChart>` stacked |
| План vs Факт | Grouped Bar | `<BarChart>` с двумя `<Bar>` |
| Прогноз vs Факт (CHECK) | Bar + reference line | `<BarChart>` + `<ReferenceLine>` |

**NEVER**: pie chart, donut chart — человек не считывает углы точно.

---

## 3. Dashboard Patterns

### Pattern 1: KPI Row (PLAN + GAP)
```
[Scorecard]     [Scorecard]     [Scorecard]     [Scorecard]     [Scorecard]
 Выручка         CR воронки      Лиды            Ср. чек         Retention
 План: 500K      План: 25%       План: 200       План: 10K       План: 40%
 Факт: 420K      Факт: 18%       Факт: 210       Факт: 9.3K      Факт: 38%
 ГЭП: -80K ❌    ГЭП: -7pp ❌    ГЭП: +10 ✅     ГЭП: -700 ⚠️    ГЭП: -2pp ⚠️
```
- Result-метрики слева, driver-метрики справа
- Каждая: план / факт / ГЭП (₽ или %) + цвет по отклонению
- ГЭП result всегда в ₽, ГЭП driver в % или pp

### Pattern 2: Table с mini-bars
```
Имя | Метрика 1 [====    ] | Метрика 2 [==      ] | Badge
```
- AG Grid: `cellRenderer` для mini-bar, `cellStyle` для цвет по норме
- Сортировка: по умолчанию — по главной метрике desc
- Строка = сущность (человек, продукт, канал)

### Pattern 3: Funnel View
```
Шаг 1: 1000  [██████████████████████] 100%
Шаг 2: 750   [█████████████████     ] 75%    ← CR: 75%
Шаг 3: 300   [███████               ] 30%    ← CR: 40%
```
- Horizontal bars, убывающие
- Показывай % конверсии между шагами
- `<BarChart layout="vertical">` в Recharts

### Pattern 4: Trend + Comparison (GAP: тренд)
```
[Line Chart: текущий период vs предыдущий]
```
- Два ряда: current (brand-solid) + previous (fg-disabled)
- Легенда под графиком, не сбоку
- Y-axis: не начинать с нуля если вариация мала
- Аннотация: отметка момента изменения (если известна причина)

### Pattern 5: Action Log (ACT + CHECK)
```
| Driver      | Действие              | Прогноз   | Факт      | Delta    |
|-------------|----------------------|-----------|-----------|----------|
| CR шаг 3    | Новый скрипт         | +5pp      | +3pp      | -2pp ⚠️  |
| Ср. чек     | Допродажа в боте     | +1.5K     | +2.1K     | +0.6K ✅ |
```
- Таблица экспериментов: что делали → что ожидали → что получили
- Накопительная база знаний: что работает в этом бизнесе

---

## 4. Стек

### Таблицы → AG Grid Community
```tsx
import { AgGridReact } from 'ag-grid-react';
```
- Используй когда: >15 строк, нужна сортировка/фильтрация, cell renderers
- Cell renderer для mini-bar: `reference/chart-patterns.md#mini-bar`
- CellStyle для conditional color: `reference/chart-patterns.md#cell-color`

### Графики → Recharts
```tsx
import { LineChart, BarChart, ... } from 'recharts';
```
- Используй когда: воронка, тренды, сравнения
- Цвета: ТОЛЬКО токены через CSS variables — `reference/chart-patterns.md#colors`
- Tooltip: кастомный `<CustomTooltip>` — `reference/chart-patterns.md#tooltip`

### UI Shell → Untitled UI
- Tabs: переключение между видами (воронка / тренды / рейтинг)
- DateRangePicker: фильтр периода (если есть в проекте — иначе нативный input)
- Badge: статус, норма, план/факт
- Skeleton: состояние загрузки

---

## 5. UX Принципы восприятия данных (для дашбордов)

**V1 — Якорные метрики**: Result-метрики (1-3) — самые крупные, всегда видны без скролла. С планом и ГЭПом.

**V2 — Группировка**: max 3-4 смысловых группы (Result → Drivers → Trends → Actions). Больше — когнитивная перегрузка.

**V6 — Люди = строки**: таблица людей/сущностей — каждая строка = одна сущность. Не агрегируй в ячейки.

**V7 — Бар + число**: всегда показывай и бар, и числовое значение. Бар — для сравнения, число — для точности.

**V10 — Цвет = контекст**: зелёный/красный только если есть план/норма. Без плана — нейтральный. ГЭП > 10% = красный, 5-10% = жёлтый, < 5% = зелёный.

**V12 — Progressive Disclosure**: Result всегда виден → Drivers при скролле → Health за tabs/drill-down.

**V13 — Тренд > точка**: любая метрика показывается как динамика (4-8 точек), а не одно число. Одно число — скрывает направление движения.

**V14 — Рубли > проценты**: ГЭП по result всегда в ₽. Проценты — для drivers. Руководитель думает деньгами, а не процентами.

---

## 6. IF/THEN

```
IF dashboard/chart/table/KPI → READ veda-ui-system/SKILL.md FIRST
IF scorecard → reference/usage-patterns.md#2 (KPI-карточка)
IF table > 15 строк → AG Grid (НЕ UUI Table)
IF custom component → СТОП, проверь UUI MCP search_components

IF таблица > 15 строк → AG Grid (не HTML table, не Untitled UI Table)
IF таблица < 15 строк → Untitled UI Table компонент
IF воронка → horizontal bar, убывающий, с % между шагами
IF тренд → line chart, два ряда (current + prev), мин. 4 точки
IF KPI одного значения → Scorecard (план / факт / ГЭП + тренд-спарклайн)
IF нет данных → Empty State (Untitled UI empty-state компонент)
IF загрузка → Skeleton (не спиннер для таблиц)
IF есть план → цвет по ГЭПу (>10% красный, 5-10% жёлтый, <5% зелёный)
IF нет плана → нейтральный цвет, не красить ничего
IF result просел → подсвети просевший driver в декомпозиции
IF действие выполнено → покажи прогноз vs факт (Pattern 5)
```

---

## 7. Spec Checklist (перед реализацией)

### Методология
- [ ] Определены result-метрики (1-3, с планами в ₽)
- [ ] Result декомпозирован на drivers (формула: result = driver1 × driver2 × ...)
- [ ] Для каждого driver есть план (числовой target)
- [ ] Определены health-метрики (что смотреть при просадке driver)
- [ ] Определён цикл: частота замера, длина спринта

### Визуализация
- [ ] Выбран правильный chart type по таблице (секция 4)
- [ ] ГЭП result в ₽, ГЭП drivers в % / pp
- [ ] Тренды — минимум 4 точки, не одно число
- [ ] Progressive disclosure: result → drivers → health

### Техника
- [ ] API эндпоинты существуют или спроектированы
- [ ] Определён формат ответа (grouped_by, period, granularity)
- [ ] Состояния: loading (skeleton), empty, error
- [ ] Фильтры: period, группировка — зафиксированы в спеке

---

## 8. Dashboard Design Methodology

### 8a. Information Architecture Rules

- Max 3-4 смысловых группы на экран (V2) — больше = когнитивная перегрузка
- Max 5-6 колонок в таблице управленческого уровня
- Max 4-5 data points на ячейку таблицы
- Progressive Disclosure: Result (above fold) → Drivers (scroll/tab) → Health (drill-down/collapsible)
- Scorecard row всегда visible без скролла

### 8b. Management Dashboard Anti-patterns

| Антипаттерн | Почему плохо | Как исправить |
|-------------|-------------|---------------|
| Стены чисел без mini-bars | Невозможно сравнить по строкам | Добавить AG Grid mini-bar cellRenderer |
| Бейджи-шум (>2 бейджа на строку) | Внимание рассеивается, всё кажется важным | Max 1-2 badge на строку, только критичные |
| Числа без контекста (без плана/нормы/тренда) | Непонятно хорошо или плохо | Всегда: план + ГЭП + тренд |
| Технические метрики на управленческом экране | Руководитель не знает что делать с "покрытием 87%" | Health-слой (drill-down), не в main view |
| Цвет без привязки к плану (красный при plan=0) | Ложная тревога, потеря доверия | IF нет плана → нейтральный цвет |
| Точка вместо тренда (одно число без динамики) | Скрывает направление движения | Минимум 4 точки, sparkline или line chart |
| Горизонтальный скролл в таблице (>8 колонок) | Управленец не скроллит вправо | Сокращай до 5-6 колонок, drill-down для остального |
| Кастомные карточки вместо UUI компонентов | Визуальный разнобой, нет дизайн-системы | Использовать UUI MetricsSimple, TableCard и др. |

### 8c. SPEC → Visualization Bridge

```
IF спека "план/факт" → Scorecard (план/факт/ГЭП/progress bar)
IF спека "реестр" → Table (UUI <15 строк, AG Grid >15)
IF спека "по менеджерам" → Table с mini-bars и conditional color
IF спека "CR" → Scorecard + trend line (не одно число)
IF спека "контроль/синхронизация" → Health-слой (collapsible/drill-down)
IF спека "риски" → перевести в ₽ потерь, не count проблем
IF спека "динамика/тренд" → LineChart мин. 4 точки
IF спека "воронка" → BarChart horizontal, убывающий
IF спека "рейтинг" → BarChart sorted desc + Table с mini-bars
```

### 8d. Dashboard Review Checklist

```
[ ] PGAC: есть план, ГЭП в ₽, виновный driver?
[ ] V13: все метрики с трендом (мин. 4 точки)?
[ ] V12: Progressive Disclosure (Result → Driver → Health)?
[ ] V14: ГЭП result в ₽, не в %?
[ ] V10: цвет привязан к плану/норме? Без плана = нейтральный?
[ ] V7: таблицы имеют mini-bars?
[ ] V2: max 3-4 группы на экране?
[ ] Charts: правильный тип по таблице (секция 2)?
[ ] UUI: все компоненты из дизайн-системы, нет кастомных?
[ ] Anti-patterns: нет стен чисел, бейджей-шума, технического шума?
```

### 8e. Reference Dashboards

**Stripe Dashboard**: Scorecard row (план/факт/тренд) → Line chart (тренд выручки) → Table (транзакции). Всё Result и Drivers, никаких технических метрик на главном экране.

**Linear Analytics**: Progressive disclosure — summary row сверху, detail chart в центре, breakdown table снизу. Drill-down скрыт за кликом.

**3-блочная структура (каноническая)**:
```
[KPI row: 4-5 Scorecard с планом/ГЭПом]
[Chart: Line/Bar тренд главного result]
[Table: разбивка по сущностям с mini-bars]
```
Этот паттерн покрывает 80% управленческих дашбордов.

---

## References

- `docs/profit-formula-methodology.md` — каноническая методология Формулы Прибыли VEDA
- `reference/chart-patterns.md` — Recharts + AG Grid code recipes
- `reference/api-analytics.md` — существующие аналитические эндпоинты veda-api
