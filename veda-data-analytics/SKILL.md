---
name: veda-data-analytics
description: Дашборды из готовых UUI компонентов + Recharts. Cookbook с copy-paste кодом. Управленческая методология (PGAC) - в ceo-consulting.
---

# Veda Data Analytics - Dashboard Cookbook

> **ГЛАВНОЕ ПРАВИЛО**: каждый элемент дашборда = готовый UUI компонент.
> Ручная верстка карточек, progress bars, таблиц, графиков **ЗАПРЕЩЕНА**.
> Конкретный код каждого компонента: `reference/dashboard-components.md`

---

## Шаг 0: Перед написанием любого кода

```
1. READ reference/dashboard-templates.md    (ГОТОВЫЕ ШАБЛОНЫ — скопируй, подставь данные)
2. READ reference/dashboard-components.md   (компоненты с props — если нужен элемент не из шаблона)
3. READ reference/dashboard-architecture.md (принципы — если нужно обосновать решение или ревью)
4. ПРОВЕРЬ: установлены ли UUI компоненты в проекте?
   ls components/application/metrics/
   ls components/application/table/
   ls components/application/charts/
   Если нет -> установи:
   npx untitledui@latest add metrics table charts-base progress-indicators badges filter-bar pagination
4. ТОЛЬКО ПОСЛЕ ЭТОГО: пиши код
```

---

## Шаг 1: Структура любого дашборда

```
[Заголовок страницы]                         <- h1 + subtitle
[KPI Row: 4-5 MetricsSimple/MetricsChart03]  <- grid cols-4/cols-5
[Charts: 1-2 TableCard.Root + Recharts]      <- grid cols-2
[Table: TableCard.Root + Table]              <- full width
```

Конкретный код структуры: `reference/dashboard-components.md` секция 7.

---

## Шаг 2: Выбор компонента

| Что показать | UUI компонент | НЕ делать |
|---|---|---|
| KPI число + тренд | `MetricsSimple` | Ручная карточка `<div class="bg-white">` |
| KPI + sparkline | `MetricsChart03` | Ручной `<svg>` |
| KPI + иконка | `MetricsIcon03` | Ручная иконка + число |
| Стрелка +/- % | `MetricChangeIndicator` | Ручной `<span class="text-green">` |
| Таблица с заголовком | `TableCard.Root` + `Table` | Ручной `<table class="w-full">` |
| Фильтры таблицы | `FilterBarTabsAndSearchDemo` | Ручные табы и инпуты |
| Bar/Line chart | Recharts + `ChartTooltipContent` | Ручной `<svg viewBox>` |
| Progress bar | `ProgressBar` (labelPosition="right") | Ручной `<div style="width:36%">` |
| Статус badge | `Badge` / `BadgeWithDot` | Ручной `<span class="rounded-full">` |
| Пагинация | `PaginationCardMinimal` | Ручная пагинация |

**Если нужного компонента нет в таблице -> СТОП, спроси Алекса.**

---

## Шаг 3: CSS-классы

**Семантические токены, НЕ Tailwind defaults:**

| Роль | Правильно | ЗАПРЕЩЕНО |
|---|---|---|
| Текст | `text-primary`, `text-secondary`, `text-tertiary` | `text-gray-900`, `text-gray-500` |
| Фон | `bg-primary`, `bg-secondary` | `bg-white`, `bg-gray-50` |
| Бордер | `ring-1 ring-secondary ring-inset`, `border-secondary` | `ring-gray-200`, `border-gray-100` |
| Тень | `shadow-xs` | `shadow-sm` |
| KPI число | `text-display-sm font-semibold text-primary` | `text-3xl font-bold` |
| Заголовок | `text-display-xs font-semibold text-primary` | `text-xl font-bold` |
| Подпись | `text-sm font-medium text-tertiary` | `text-xs text-gray-500` |

---

## Шаг 4: Recharts правила

- Recharts для ВСЕХ графиков (Line, Bar, Area, Pie)
- `ChartTooltipContent` из `@/components/application/charts/charts-base` для tooltip
- `ChartLegendContent` для легенды
- `ChartActiveDot` для активной точки на линиях
- CSS-классы для цветов: `className="fill-utility-brand-600"`, НЕ `fill="#3b82f6"`
- `<ResponsiveContainer width="100%" height={240}>` - всегда
- `<CartesianGrid vertical={false} strokeDasharray="3 3" className="stroke-border-secondary" />`
- `tickLine={false} axisLine={false}` на осях

---

## Шаг 5: Status colors (план/факт)

```tsx
// Цвет по отклонению от плана
const getStatusColor = (percent: number) => {
  if (percent >= 90) return "success";   // >= 90% плана = зеленый
  if (percent >= 70) return "warning";   // 70-90% = желтый
  return "error";                        // < 70% = красный
};

// Для ProgressBar
<ProgressBar
  value={percent}
  labelPosition="right"
  progressClassName={
    percent >= 90 ? "bg-fg-success-primary"
    : percent >= 70 ? "bg-fg-warning-primary"
    : "bg-fg-error-primary"
  }
/>

// Для Badge
<Badge color={getStatusColor(percent)} size="sm">
  {percent}%
</Badge>

// Для MetricChangeIndicator
<MetricChangeIndicator
  type="simple"
  trend={percent >= 100 ? "positive" : "negative"}
  value={`${percent}%`}
/>
```

Без плана = нейтральный цвет (без status colors).

---

## Шаг 5.5: Источник истины для метрик продаж — `gc_payment_events`

**КРИТИЧЕСКОЕ ПРАВИЛО** для всех дашбордов operations/sales/launches:

- **Cashflow-метрики** (выручка, оплачено за день, средний чек) — ВСЕГДА из `gc_payment_events WHERE payment_status='success'`, НЕ из `gc_orders.paid_amount`.
- **Причина:** `gc_orders.paid_at`, `gc_orders.raw_data->>'Оплачен'`, `gc_orders.status='Завершен'` — всё это top-level snapshot, который отстаёт от реальных платежей на 1-3 дня (пока банк закроет рассрочку). В живой сверке 10.04.2026 было: 2 заказа "Завершён" vs 4 реальных успешных платежа — разница критическая.
- **Один заказ = несколько events** (каждый транш рассрочки — отдельный event). `COUNT(DISTINCT gc_order_id)` даёт "сколько заказов получили платёж".

**Пример корректного aggregate_day:**
```sql
-- Сколько заказов получили оплату за 10.04
SELECT
  COUNT(DISTINCT gc_order_id)    AS paid_orders,
  SUM(gross_amount)              AS revenue_gross,     -- оплачено клиентами
  SUM(received_amount)           AS revenue_net,       -- пришло на счёт (gross - комиссии ПС)
  SUM(commission_amount)         AS commission_total
FROM gc_payment_events
WHERE payment_date::date = '2026-04-10'
  AND payment_status = 'success';
```

**Разрез по типу заказа (hot/manual/diagnostic):**
```sql
SELECT go.order_type,
       COUNT(DISTINCT pe.gc_order_id) AS cnt,
       SUM(pe.received_amount) AS amount
FROM gc_payment_events pe
JOIN gc_orders go ON go.id = pe.gc_order_id
WHERE pe.payment_date::date = :d AND pe.payment_status = 'success'
GROUP BY go.order_type;
```

### Когортный CR (две метрики рядом)

Для любого CR "заказ→оплата" показывать **обе** метрики:

**1. CR штучный когортный** — доля заказов когорты у которых есть успешный платёж:
```sql
WITH cohort AS (SELECT id FROM gc_orders WHERE created_at::date = :d),
cohort_paid AS (
  SELECT DISTINCT c.id FROM cohort c
  JOIN gc_payment_events pe ON pe.gc_order_id = c.id
  WHERE pe.payment_date::date = :d AND pe.payment_status = 'success'
)
SELECT
  COUNT(DISTINCT cp.id)::float / NULLIF((SELECT COUNT(*) FROM cohort), 0) AS c2b_orders_cohort
FROM cohort_paid cp;
```

**2. CR денежный когортный** — доля потенциальной выручки когорты что уже на счету:
```sql
SELECT
  SUM(pe.received_amount) FILTER (WHERE pe.payment_status='success' AND pe.payment_date::date = :d)
  / NULLIF(SUM(c.amount), 0) AS c2b_money_cohort
FROM gc_orders c
LEFT JOIN gc_payment_events pe ON pe.gc_order_id = c.id
WHERE c.created_at::date = :d;
```

В UI обе метрики рядом с пояснениями в tooltip. Штучный — основная (стабильнее между днями), денежный — дополнительная (отражает рассрочки как частичное закрытие). НЕ смешивать в одну цифру.

### Flow vs Cohort — не путать

- **Flow CR** (`paid_today / orders_today`) — может давать >100% и смешивает когорты разных дней. НЕ использовать.
- **Cohort CR** (`(paid from cohort X) / (orders in cohort X)`) — корректно. Всегда используем его.

---

## Шаг 6: PGAC привязка к компонентам

| Фаза | Что показать | Компонент |
|---|---|---|
| PLAN | План / факт / ГЭП | `MetricsSimple` (KPI row) |
| GAP: driver | Какой driver просел | `TableCard` + `Table` с `ProgressBar` в ячейке |
| GAP: тренд | 4-8 недель | `MetricsChart03` (sparkline) или Recharts `LineChart` |
| GAP: цена | Потери в R | `Badge color="error"` с суммой |
| ACT | Задачи | `TableCard` + `Table` |
| CHECK | Прогноз vs факт | Recharts `BarChart` (grouped) |

---

## Шаг 7: Dashboard Review Checklist

```
КОМПОНЕНТЫ (блокер - ручная верстка = переделка)
[ ] Все KPI через MetricsSimple/MetricsIcon/MetricsChart?
[ ] Все таблицы через TableCard.Root + Table?
[ ] Все графики через Recharts + ChartTooltipContent?
[ ] Все progress bars через ProgressBar?
[ ] Все badges через Badge/BadgeWithDot?
[ ] Нет ручных <div class="bg-white rounded-xl">?
[ ] Нет ручных <svg viewBox>?
[ ] Нет ручных <table class="w-full">?

CSS (блокер - gray-* = переделка)
[ ] Все цвета семантические (text-primary, НЕ text-gray-900)?
[ ] shadow-xs, НЕ shadow-sm?
[ ] bg-primary, НЕ bg-white?
[ ] tabular-nums на всех числах?

ДАННЫЕ
[ ] KPI row visible без скролла?
[ ] Есть план + ГЭП где определен план?
[ ] Нет плана = нейтральный цвет?
[ ] Тренды мин. 4 точки?
[ ] ГЭП result в R, ГЭП driver в % / pp?

STRUCTURE
[ ] Max 4-5 KPI в ряду?
[ ] Max 3-4 смысловых группы на экране?
[ ] Progressive Disclosure: Result - Drivers - Health?
```

---

## References

| Файл | Что | Когда читать |
|------|-----|-------------|
| `reference/dashboard-templates.md` | **ГОТОВЫЕ ШАБЛОНЫ**: 3 template'а (CEO, РОП, Funnel) с полным кодом. Читать ПЕРВЫМ | Всегда при создании дашборда |
| `reference/dashboard-components.md` | **Компоненты**: copy-paste код MetricsSimple, TableCard, Recharts, ProgressBar, Badge | Если нужен элемент не из шаблона |
| `reference/dashboard-architecture.md` | **Принципы**: иерархия, логика данных, план/факт, run rate, воронки. 62 правила | Обоснование решений, ревью |
| `platform/docs/profit-formula-methodology.md` | **Формула прибыли**: полная декомпозиция, 4 источника, 3 типа заказов, бенчмарки | Проектирование metrics structure |
| `reference/chart-patterns.md` | Recharts рецепты | Работа с графиками |
| `reference/api-analytics.md` | API endpoints | Подключение данных |
| `ceo-consulting/SKILL.md` | Управленческая методология PGAC | Выбор метрик и структуры |
