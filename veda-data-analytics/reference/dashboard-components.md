# Dashboard Components — Copy-Paste Cookbook

> Каждый элемент дашборда собирается из готовых UUI компонентов.
> ЗАПРЕЩЕНО писать свои карточки, progress bars, таблицы, tooltips.
> Если компонент ниже не подходит - СТОП, спроси Алекса.

---

## 0. Установка (первый шаг ЛЮБОЙ dashboard-задачи)

```bash
# Установи базовые dashboard-компоненты если их нет в проекте
npx untitledui@latest add metrics
npx untitledui@latest add table
npx untitledui@latest add charts-base
npx untitledui@latest add progress-indicators
npx untitledui@latest add progress-circles
npx untitledui@latest add badges
npx untitledui@latest add filter-bar
npx untitledui@latest add pagination

# Или установи целый dashboard-пример как стартовый шаблон
npx untitledui@latest example dashboards-01/09
```

**Проверь что компоненты на месте:**
```bash
ls components/application/metrics/
ls components/application/table/
ls components/application/charts/
ls components/base/progress-indicators/
ls components/base/badges/
```

---

## 1. KPI-карточки (Metrics)

### MetricsSimple — базовая KPI-карточка
```tsx
import { MetricsSimple } from "@/components/application/metrics/metrics";

<MetricsSimple
  title="1 818 949 R"        // главное число (крупный шрифт)
  subtitle="Выручка"          // подпись сверху (мелкий серый)
  type="simple"               // "simple" | "trend" | "modern"
  trend="negative"            // "positive" | "negative"
  change="−36%"               // текст рядом со стрелкой
/>
```

### MetricsIcon03 — KPI с иконкой
```tsx
import { MetricsIcon03 } from "@/components/application/metrics/metrics";
import { CurrencyDollar } from "@untitledui/icons";

<MetricsIcon03
  icon={CurrencyDollar}
  title="1 818 949 R"
  subtitle="Выручка"
  change="36%"
  changeTrend="negative"
/>
```

### MetricsChart03 — KPI со sparkline
```tsx
import { MetricsChart03 } from "@/components/application/metrics/metrics";

<MetricsChart03
  title="29.5%"
  subtitle="CR горяч - оплата"
  type="trend"
  change="−22.6pp"
  changeTrend="negative"
  changeDescription="от таргета 50%"
  chartData={[{ value: 28.6 }, { value: 31 }, { value: 29 }, { value: 22.5 }]}
/>
```

### MetricChangeIndicator — стрелка + процент (внутри своих карточек)
```tsx
import { MetricChangeIndicator } from "@/components/application/metrics/metrics";

<MetricChangeIndicator
  type="simple"       // "simple" (стрелка вверх/вниз) | "trend" (линия тренда) | "modern" (в pill)
  trend="positive"    // "positive" | "negative"
  value="12%"         // текст
/>
```

### KPI Row — сетка карточек
```tsx
// 4-5 карточек в ряд
<div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 xl:grid-cols-5">
  <MetricsSimple title="1.8M R" subtitle="Выручка" type="simple" trend="negative" change="−36%" />
  <MetricsSimple title="29.5%" subtitle="CR горяч - оплата" type="simple" trend="negative" change="−22pp" />
  <MetricsSimple title="35.1%" subtitle="CR диа - заказ" type="simple" trend="positive" change="+17%" />
  <MetricsSimple title="376" subtitle="Поставка лидов" type="simple" trend="positive" change="+5%" />
</div>
```

---

## 2. Таблицы (Table + TableCard)

### TableCard — таблица с заголовком и фильтрами
```tsx
import { Table, TableCard } from "@/components/application/table/table";

<TableCard.Root>
  <TableCard.Header
    title="Продажи"
    subtitle="6 из 7 на линии"
  />
  {/* Фильтры если нужны */}
  <FilterBarTabsAndSearchDemo />

  <Table
    aria-label="Продажи"
    sortDescriptor={sortDescriptor}
    onSortChange={setSortDescriptor}
  >
    <Table.Header>
      <Table.Column id="name" isRowHeader allowsSorting>Метрика</Table.Column>
      <Table.Column id="value" allowsSorting>Факт</Table.Column>
      <Table.Column id="target">Норма</Table.Column>
      <Table.Column id="progress">% нормы</Table.Column>
    </Table.Header>
    <Table.Body items={data}>
      {(item) => (
        <Table.Row id={item.id}>
          <Table.Cell className="font-medium">{item.name}</Table.Cell>
          <Table.Cell className="tabular-nums">{item.value}</Table.Cell>
          <Table.Cell className="text-tertiary tabular-nums">{item.target}</Table.Cell>
          <Table.Cell>
            <ProgressBar value={item.percent} labelPosition="right" />
          </Table.Cell>
        </Table.Row>
      )}
    </Table.Body>
  </Table>

  <TableCard.Footer>
    <PaginationCardMinimal />
  </TableCard.Footer>
</TableCard.Root>
```

---

## 3. Графики (Recharts + UUI обертки)

### Bar Chart (план/факт по неделям)
```tsx
import { Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { ChartTooltipContent, ChartLegendContent } from "@/components/application/charts/charts-base";

<ResponsiveContainer width="100%" height={240}>
  <BarChart data={weeklyData} barGap={4}>
    <CartesianGrid vertical={false} strokeDasharray="3 3" className="stroke-border-secondary" />
    <XAxis
      dataKey="week"
      tickLine={false}
      axisLine={false}
      className="text-xs text-tertiary"
    />
    <YAxis
      tickLine={false}
      axisLine={false}
      className="text-xs text-tertiary"
    />
    <Tooltip content={<ChartTooltipContent />} />
    <Bar
      dataKey="orders"
      name="Заказы"
      className="fill-utility-brand-200"
      radius={[4, 4, 0, 0]}
    />
    <Bar
      dataKey="paid"
      name="Оплаты"
      className="fill-utility-brand-600"
      radius={[4, 4, 0, 0]}
    />
  </BarChart>
</ResponsiveContainer>
```

### Line Chart (тренд CR)
```tsx
import { Line, LineChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { ChartActiveDot, ChartTooltipContent } from "@/components/application/charts/charts-base";

<ResponsiveContainer width="100%" height={240}>
  <LineChart data={trendData}>
    <CartesianGrid vertical={false} strokeDasharray="3 3" className="stroke-border-secondary" />
    <XAxis dataKey="week" tickLine={false} axisLine={false} className="text-xs text-tertiary" />
    <YAxis tickLine={false} axisLine={false} className="text-xs text-tertiary" />
    <Tooltip content={<ChartTooltipContent />} />
    <Line
      dataKey="cr"
      name="CR %"
      className="stroke-utility-brand-600"
      strokeWidth={2}
      dot={false}
      activeDot={<ChartActiveDot />}
    />
    <Line
      dataKey="target"
      name="Таргет"
      className="stroke-border-primary"
      strokeWidth={1}
      strokeDasharray="4 4"
      dot={false}
    />
  </LineChart>
</ResponsiveContainer>
```

### Chart внутри карточки (типовой паттерн)
```tsx
<TableCard.Root>
  <TableCard.Header
    title="Продажи"
    subtitle="Заказы, оплаты и CR по неделям"
  />
  <div className="px-5 py-4">
    {/* Legend */}
    <div className="mb-3 flex items-center gap-3 text-xs text-tertiary">
      <span className="flex items-center gap-1.5">
        <span className="size-2 rounded-full bg-utility-brand-200" />Заказы
      </span>
      <span className="flex items-center gap-1.5">
        <span className="size-2 rounded-full bg-utility-brand-600" />Оплаты
      </span>
    </div>
    {/* Chart */}
    <ResponsiveContainer width="100%" height={240}>
      <BarChart data={data}>...</BarChart>
    </ResponsiveContainer>
  </div>
</TableCard.Root>
```

---

## 4. Progress Bars

### ProgressBar с процентом справа
```tsx
import { ProgressBar } from "@/components/base/progress-indicators/progress-indicators";

<ProgressBar value={36} labelPosition="right" />
// Рендерит: [====        ] 36%
```

### ProgressBar с кастомным цветом (по статусу)
```tsx
<ProgressBar
  value={36}
  labelPosition="right"
  progressClassName={
    percent >= 90 ? "bg-fg-success-primary"
    : percent >= 70 ? "bg-fg-warning-primary"
    : "bg-fg-error-primary"
  }
/>
```

### ProgressBarHalfCircle (полукруг)
```tsx
import { ProgressBarHalfCircle } from "@/components/base/progress-indicators/progress-circles";

<ProgressBarHalfCircle value={86} max={100} />
```

---

## 5. Badges (статусы)

```tsx
import { Badge, BadgeWithDot, BadgeWithIcon } from "@/components/base/badges/badges";

// Простой
<Badge color="success" size="sm">Норма</Badge>
<Badge color="error" size="sm">Ниже нормы</Badge>
<Badge color="warning" size="sm">Внимание</Badge>

// С точкой
<BadgeWithDot color="success" size="sm">Активен</BadgeWithDot>

// С иконкой
<BadgeWithIcon color="error" size="sm" icon={ArrowDown}>−22%</BadgeWithIcon>
```

---

## 6. Filter Bar

```tsx
import { FilterBarTabsAndSearchDemo } from "@/components/application/filter-bar/filter-bar.demo";

// Готовый компонент с табами + поиск + кнопка фильтров
<FilterBarTabsAndSearchDemo />
```

---

## 7. Типовая структура дашборда (собери из блоков выше)

```tsx
export default function SalesDashboard() {
  return (
    <div className="flex flex-col gap-6 p-6">
      {/* 1. Заголовок */}
      <div>
        <h1 className="text-display-xs font-semibold text-primary">Аналитика продаж</h1>
        <p className="text-sm text-tertiary">9 мар - 7 апр 2026 - Все отделы</p>
      </div>

      {/* 2. KPI Row */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <MetricsSimple title="1.8M R" subtitle="Выручка" type="simple" trend="negative" change="−36%" />
        <MetricsSimple title="29.5%" subtitle="CR горяч - оплата" type="simple" trend="negative" change="−22pp" />
        <MetricsChart03 title="35.1%" subtitle="CR диа - заказ" ... />
        <MetricsSimple title="376" subtitle="Поставка лидов" type="simple" trend="positive" change="+5%" />
      </div>

      {/* 3. Charts (2 колонки) */}
      <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
        <TableCard.Root>
          <TableCard.Header title="Продажи" subtitle="Заказы, оплаты и CR по неделям" />
          <div className="px-5 py-4">
            <ResponsiveContainer height={240}>
              <BarChart data={salesWeekly}>...</BarChart>
            </ResponsiveContainer>
          </div>
        </TableCard.Root>

        <TableCard.Root>
          <TableCard.Header title="Диагностики" subtitle="Диагностики, оплаты и CR по неделям" />
          <div className="px-5 py-4">
            <ResponsiveContainer height={240}>
              <BarChart data={diagWeekly}>...</BarChart>
            </ResponsiveContainer>
          </div>
        </TableCard.Root>
      </div>

      {/* 4. Table */}
      <TableCard.Root>
        <TableCard.Header title="Продажи" subtitle="6 из 7 на линии" />
        <Table aria-label="Продажи">
          ...
        </Table>
      </TableCard.Root>
    </div>
  );
}
```

---

## 8. CSS-классы (семантические токены, НЕ gray-*)

| Что | Правильно | ЗАПРЕЩЕНО |
|-----|-----------|-----------|
| Текст основной | `text-primary` | `text-gray-900` |
| Текст вторичный | `text-secondary` | `text-gray-700` |
| Текст третичный | `text-tertiary` | `text-gray-500` |
| Фон карточки | `bg-primary` | `bg-white` |
| Бордер карточки | `ring-1 ring-secondary ring-inset` | `ring-1 ring-gray-200` |
| Тень карточки | `shadow-xs` | `shadow-sm` |
| Бордер секции | `border-secondary` | `border-gray-100` |
| Числа | `tabular-nums` | (без tabular-nums) |
| Заголовок страницы | `text-display-xs font-semibold text-primary` | `text-xl font-bold text-gray-900` |
| Заголовок карточки | `text-md font-semibold text-primary` или через `TableCard.Header` | `text-lg font-semibold text-gray-900` |
| Подпись KPI | `text-sm font-medium text-tertiary` | `text-xs font-medium text-gray-500` |
| KPI число | `text-display-sm font-semibold text-primary` | `text-3xl font-bold text-gray-900` |

---

## 9. ЗАПРЕТЫ (каждый = переделка)

1. **НЕ писать `<div class="bg-white rounded-xl p-4 ring-1 ring-gray-200">`** - это кастомная карточка. Используй `MetricsSimple` или `TableCard.Root`.
2. **НЕ писать `<svg viewBox="...">`** для графиков - используй Recharts + `ChartTooltipContent`.
3. **НЕ писать `<div class="h-2 rounded-full bg-gray-200"><div style="width:36%">`** - используй `<ProgressBar value={36} labelPosition="right" />`.
4. **НЕ писать `<table class="w-full">`** - используй `<Table>` + `<TableCard.Root>`.
5. **НЕ писать `text-gray-*`** - используй `text-primary`, `text-secondary`, `text-tertiary`.
6. **НЕ писать `bg-white`** - используй `bg-primary`.
7. **НЕ писать `shadow-sm`** - используй `shadow-xs`.
8. **НЕ писать inline styles** для цветов (`style="background:#22c55e"`) - используй семантические классы.
