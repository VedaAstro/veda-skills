# Dashboard Templates — Ready-to-Build

> Каждый template = полная страница с конкретным кодом.
> AI берёт template, подставляет данные, готово.
> НЕ интерпретируй принципы — копируй структуру.
>
> Формула выручки: `platform/docs/profit-formula-methodology.md`

---

## Template A: Sales Dashboard (CEO Level)

**Назначение:** Здоровье бизнеса за 5 секунд. Ответ на "выполним план?"

### Структура страницы

```
[Header]
[KPI Row: 5 множителей формулы]
[Revenue Waterfall: потери в R по шагам]
[2 воронки: ОП (горячие+ручные) | ОД]
[Top проблемы: health-метрики по Revenue Impact]
```

### Код

```tsx
import { MetricsSimple, MetricsChart03, MetricChangeIndicator } from "@/components/application/metrics/metrics";
import { Table, TableCard } from "@/components/application/table/table";
import { ProgressBar } from "@/components/base/progress-indicators/progress-indicators";
import { Badge } from "@/components/base/badges/badges";
import { Bar, BarChart, CartesianGrid, Line, LineChart, ComposedChart, ResponsiveContainer, Tooltip, XAxis, YAxis, Cell } from "recharts";
import { ChartTooltipContent } from "@/components/application/charts/charts-base";

// === ДАННЫЕ ===
// Подставь реальные из API /api/sales-control/summary

const kpiData = {
  revenue:    { fact: 1_818_949, plan: 5_000_000, prevMonth: 3_800_000, trend: [3800, 3200, 2100, 1800] },
  payments:   { fact: 49, plan: 120, prevMonth: 68, trend: [68, 55, 42, 49] },
  avgCheck:   { fact: 37_121, plan: 41_667, prevMonth: 55_882, trend: [56000, 48000, 50000, 37000] },
  leads:      { fact: 376, plan: null, prevMonth: 420, trend: [420, 390, 410, 376] },  // plan null = нет плана
  crThrough:  { fact: 13.0, plan: 24.0, prevMonth: 16.2, trend: [16.2, 14.1, 10.2, 13.0] },
};

// Run rate (формула: fact * daysInMonth / daysPassed)
const daysPassed = 7;
const daysInMonth = 30;
const runRate = Math.round(kpiData.revenue.fact * daysInMonth / daysPassed);
const forecastPct = kpiData.revenue.plan ? Math.round(runRate / kpiData.revenue.plan * 100) : null;

// Revenue Waterfall: потери в R на каждом шаге
const waterfall = [
  { step: "КЛ поставлено",      count: 376, potential: 376 * 37121, lost: 0 },
  { step: "Набрано",             count: 281, potential: 281 * 37121, lost: 95 * 37121 },
  { step: "Дозвонились",         count: 172, potential: 172 * 37121, lost: 109 * 37121 },
  { step: "Горячие заказы",      count: 155, potential: 155 * 37121, lost: 17 * 37121 },
  { step: "Оплаты",              count: 49,  potential: 49 * 37121,  lost: 106 * 37121 },
];

// Health metrics с Revenue Impact
const healthMetrics = [
  { name: "Мин на линии / МОП",    fact: 5,      norm: 240,   pct: 2,   revenueImpact: 4_000_000 },
  { name: "SLA обработки",          fact: "7.5%", norm: "100%", pct: 8,  revenueImpact: 1_500_000 },
  { name: "Наборов / МОП / день",   fact: 3.9,    norm: 40,    pct: 10,  revenueImpact: 3_500_000 },
  { name: "Заказов / МОП / день",   fact: 0.9,    norm: 5.0,   pct: 18,  revenueImpact: 2_800_000 },
  { name: "Ср. время разговора",    fact: "1.4м", norm: "3.0м", pct: 47,  revenueImpact: 800_000 },
  { name: "Дозвон",                  fact: "61%",  norm: "60%",  pct: 102, revenueImpact: 0 },
  { name: "КЛ обработано",          fact: "74%",  norm: "100%", pct: 74,  revenueImpact: 600_000 },
].sort((a, b) => a.pct - b.pct); // самые красные сверху

// Helpers
const fmtMoney = (n: number) => {
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
  if (n >= 1_000) return `${Math.round(n / 1_000)}K`;
  return String(n);
};

const pctOfPlan = (fact: number, plan: number | null) => {
  if (!plan) return null;
  return Math.round(fact / plan * 100);
};

const getStatusColor = (pct: number | null) => {
  if (pct === null) return "neutral";
  if (pct >= 90) return "success";
  if (pct >= 70) return "warning";
  return "error";
};

export default function SalesDashboard() {
  return (
    <div className="flex flex-col gap-6 p-6">

      {/* ===== HEADER ===== */}
      <div className="flex items-baseline justify-between">
        <div>
          <h1 className="text-display-xs font-semibold text-primary">Аналитика продаж</h1>
          <p className="text-sm text-tertiary">9 мар - 7 апр 2026 - Все отделы</p>
        </div>
        <div className="text-right">
          <p className="text-sm text-tertiary">Run Rate к концу месяца</p>
          <p className="text-display-xs font-semibold text-primary tabular-nums">{fmtMoney(runRate)}</p>
          {forecastPct && (
            <p className={`text-sm font-medium ${forecastPct >= 90 ? "text-success-primary" : forecastPct >= 70 ? "text-warning-primary" : "text-error-primary"}`}>
              {forecastPct}% от плана
            </p>
          )}
        </div>
      </div>

      {/* ===== KPI ROW: 5 множителей формулы ===== */}
      {/* Порядок: Result (выручка) → множители формулы слева направо */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-5">

        {/* Выручка = RESULT */}
        <MetricsChart03
          title={fmtMoney(kpiData.revenue.fact)}
          subtitle="Выручка"
          type="trend"
          change={`${pctOfPlan(kpiData.revenue.fact, kpiData.revenue.plan)}% плана`}
          changeTrend={pctOfPlan(kpiData.revenue.fact, kpiData.revenue.plan)! >= 70 ? "positive" : "negative"}
          changeDescription={`GAP ${fmtMoney(kpiData.revenue.fact - kpiData.revenue.plan!)}`}
          chartData={kpiData.revenue.trend.map(v => ({ value: v }))}
        />

        {/* Оплаты = Result driver #1 */}
        <MetricsSimple
          title={String(kpiData.payments.fact)}
          subtitle="Оплаты"
          type="simple"
          trend={kpiData.payments.fact >= kpiData.payments.prevMonth ? "positive" : "negative"}
          change={kpiData.payments.plan
            ? `${pctOfPlan(kpiData.payments.fact, kpiData.payments.plan)}% плана`
            : `vs ${kpiData.payments.prevMonth} пр.мес`}
        />

        {/* Ср.чек = Множитель #2 */}
        <MetricsSimple
          title={`${fmtMoney(kpiData.avgCheck.fact)} R`}
          subtitle="Ср. чек"
          type="simple"
          trend={kpiData.avgCheck.fact >= kpiData.avgCheck.prevMonth ? "positive" : "negative"}
          change={`${Math.round((kpiData.avgCheck.fact / kpiData.avgCheck.prevMonth - 1) * 100)}% vs пр.мес`}
        />

        {/* Лиды = Множитель #1 (вход воронки) */}
        <MetricsSimple
          title={String(kpiData.leads.fact)}
          subtitle="Лиды (КЛ)"
          type="simple"
          trend={kpiData.leads.fact >= kpiData.leads.prevMonth ? "positive" : "negative"}
          change={kpiData.leads.plan
            ? `${pctOfPlan(kpiData.leads.fact, kpiData.leads.plan)}% плана`
            : `vs ${kpiData.leads.prevMonth} пр.мес`}
        />

        {/* CR сквозная = Множитель #3 */}
        <MetricsSimple
          title={`${kpiData.crThrough.fact}%`}
          subtitle="CR сквозная"
          type="simple"
          trend={kpiData.crThrough.fact >= (kpiData.crThrough.plan || kpiData.crThrough.prevMonth) ? "positive" : "negative"}
          change={kpiData.crThrough.plan
            ? `${pctOfPlan(kpiData.crThrough.fact, kpiData.crThrough.plan)}% таргета`
            : `vs ${kpiData.crThrough.prevMonth}% пр.мес`}
        />
      </div>

      {/* ===== REVENUE WATERFALL: где теряем деньги ===== */}
      <TableCard.Root>
        <TableCard.Header
          title="Потери по воронке в рублях"
          subtitle="На каком шаге теряем больше всего денег"
        />
        <div className="px-5 py-4">
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={waterfall} layout="vertical" barSize={20}>
              <CartesianGrid horizontal={false} strokeDasharray="3 3" className="stroke-border-secondary" />
              <XAxis type="number" tickLine={false} axisLine={false} className="text-xs text-tertiary"
                tickFormatter={(v) => fmtMoney(v)} />
              <YAxis type="category" dataKey="step" tickLine={false} axisLine={false}
                className="text-xs text-tertiary" width={120} />
              <Tooltip content={<ChartTooltipContent formatter={(v) => `${fmtMoney(Number(v))} R`} />} />
              <Bar dataKey="lost" name="Потери R" radius={[0, 4, 4, 0]}>
                {waterfall.map((entry, i) => (
                  <Cell key={i} className={entry.lost === 0 ? "fill-utility-gray-200" : "fill-utility-error-500"} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </TableCard.Root>

      {/* ===== 2 ВОРОНКИ: ОП | ОД ===== */}
      <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">

        {/* ОП: Две суб-воронки (горячие + ручные) */}
        <TableCard.Root>
          <TableCard.Header
            title="ОП - Продажи"
            subtitle="Горячие заказы (с вебинаров) + Ручные (обработка КЛ)"
          />
          <div className="px-5 py-4">
            {/* Scorecard row: два типа заказов */}
            <div className="mb-4 grid grid-cols-2 gap-4">
              <div className="flex flex-col gap-1">
                <p className="text-xs font-medium text-tertiary">Горячие заказы</p>
                <p className="text-lg font-semibold text-primary tabular-nums">87 заказов</p>
                <div className="flex items-center gap-2">
                  <p className="text-sm text-tertiary tabular-nums">CR→оплата: 32%</p>
                  <MetricChangeIndicator type="simple" trend="negative" value="−18pp от таргета" />
                </div>
              </div>
              <div className="flex flex-col gap-1">
                <p className="text-xs font-medium text-tertiary">Ручные заказы</p>
                <p className="text-lg font-semibold text-primary tabular-nums">68 заказов</p>
                <div className="flex items-center gap-2">
                  <p className="text-sm text-tertiary tabular-nums">CR→оплата: 25%</p>
                  <MetricChangeIndicator type="simple" trend="negative" value="−25pp от таргета" />
                </div>
              </div>
            </div>

            {/* Bar chart: заказы + оплаты по неделям */}
            <ResponsiveContainer width="100%" height={200}>
              <ComposedChart data={opWeeklyData}>
                <CartesianGrid vertical={false} strokeDasharray="3 3" className="stroke-border-secondary" />
                <XAxis dataKey="week" tickLine={false} axisLine={false} className="text-xs text-tertiary" />
                <YAxis yAxisId="left" tickLine={false} axisLine={false} className="text-xs text-tertiary" />
                <YAxis yAxisId="right" orientation="right" tickLine={false} axisLine={false}
                  className="text-xs text-tertiary" tickFormatter={(v) => `${v}%`} />
                <Tooltip content={<ChartTooltipContent />} />
                <Bar yAxisId="left" dataKey="orders" name="Заказы" className="fill-utility-brand-200" radius={[4, 4, 0, 0]} />
                <Bar yAxisId="left" dataKey="paid" name="Оплаты" className="fill-utility-brand-600" radius={[4, 4, 0, 0]} />
                <Line yAxisId="right" dataKey="cr" name="CR %" className="stroke-utility-success-500"
                  strokeWidth={2} strokeDasharray="4 4" dot={false} />
              </ComposedChart>
            </ResponsiveContainer>
          </div>
          <div className="border-t border-secondary px-5 py-3 text-right">
            <span className="text-sm font-medium text-error-primary tabular-nums">
              Потери от таргета: {fmtMoney(3_181_051)} R
            </span>
          </div>
        </TableCard.Root>

        {/* ОД: Диагностики */}
        <TableCard.Root>
          <TableCard.Header
            title="ОД - Диагностики"
            subtitle="Заявка - диагностика - заказ - оплата"
          />
          <div className="px-5 py-4">
            {/* Scorecard row */}
            <div className="mb-4 grid grid-cols-3 gap-4">
              <div className="flex flex-col gap-1">
                <p className="text-xs font-medium text-tertiary">CR Диа - Заказ</p>
                <p className="text-lg font-semibold text-primary tabular-nums">35.1%</p>
                <MetricChangeIndicator type="simple" trend="positive" value="+5pp от таргета" />
              </div>
              <div className="flex flex-col gap-1">
                <p className="text-xs font-medium text-tertiary">CR Диа - Оплата</p>
                <p className="text-lg font-semibold text-primary tabular-nums">4.6%</p>
                <p className="text-xs text-tertiary">таргет не задан</p>
              </div>
              <div className="flex flex-col gap-1">
                <p className="text-xs font-medium text-tertiary">Ср. чек ОД</p>
                <p className="text-lg font-semibold text-primary tabular-nums">7 051 R</p>
                <MetricChangeIndicator type="simple" trend="negative" value="−34% vs пр.мес" />
              </div>
            </div>

            {/* Chart */}
            <ResponsiveContainer width="100%" height={200}>
              <ComposedChart data={odWeeklyData}>
                <CartesianGrid vertical={false} strokeDasharray="3 3" className="stroke-border-secondary" />
                <XAxis dataKey="week" tickLine={false} axisLine={false} className="text-xs text-tertiary" />
                <YAxis yAxisId="left" tickLine={false} axisLine={false} className="text-xs text-tertiary" />
                <YAxis yAxisId="right" orientation="right" tickLine={false} axisLine={false}
                  className="text-xs text-tertiary" tickFormatter={(v) => `${v}%`} />
                <Tooltip content={<ChartTooltipContent />} />
                <Bar yAxisId="left" dataKey="diagnostics" name="Диагностики" className="fill-utility-brand-200" radius={[4, 4, 0, 0]} />
                <Bar yAxisId="left" dataKey="paid" name="Оплаты" className="fill-utility-brand-600" radius={[4, 4, 0, 0]} />
                <Line yAxisId="right" dataKey="cr" name="CR %" className="stroke-utility-success-500"
                  strokeWidth={2} strokeDasharray="4 4" dot={false} />
              </ComposedChart>
            </ResponsiveContainer>
          </div>
        </TableCard.Root>
      </div>

      {/* ===== HEALTH METRICS: сортировка по Revenue Impact ===== */}
      <TableCard.Root>
        <TableCard.Header
          title="Health-метрики ОП"
          subtitle="Сортировка: самые критичные по потерям в рублях"
        />
        <Table aria-label="Health metrics">
          <Table.Header>
            <Table.Column id="name" isRowHeader>Метрика</Table.Column>
            <Table.Column id="progress">% нормы</Table.Column>
            <Table.Column id="fact">Факт</Table.Column>
            <Table.Column id="norm">Норма</Table.Column>
            <Table.Column id="impact">Revenue Impact</Table.Column>
          </Table.Header>
          <Table.Body items={healthMetrics}>
            {(item) => (
              <Table.Row id={item.name}>
                <Table.Cell className="font-medium">{item.name}</Table.Cell>
                <Table.Cell>
                  <ProgressBar
                    value={Math.min(item.pct, 100)}
                    labelPosition="right"
                    progressClassName={
                      item.pct >= 90 ? "bg-fg-success-primary"
                      : item.pct >= 70 ? "bg-fg-warning-primary"
                      : "bg-fg-error-primary"
                    }
                  />
                </Table.Cell>
                <Table.Cell className="tabular-nums">{item.fact}</Table.Cell>
                <Table.Cell className="tabular-nums text-tertiary">{item.norm}</Table.Cell>
                <Table.Cell className="tabular-nums">
                  {item.revenueImpact > 0 ? (
                    <Badge color="error" size="sm">{fmtMoney(item.revenueImpact)} R</Badge>
                  ) : (
                    <Badge color="success" size="sm">OK</Badge>
                  )}
                </Table.Cell>
              </Table.Row>
            )}
          </Table.Body>
        </Table>
      </TableCard.Root>

      {/* ===== НАЙМ ===== */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
        <MetricsSimple title="86%" subtitle="Менеджеры (6/7 FTE)" type="simple" trend="negative" change="−1 FTE" />
        <MetricsSimple title="300%" subtitle="Диагносты (12/4 FTE)" type="simple" trend="positive" change="+8 FTE" />
      </div>
    </div>
  );
}
```

---

## Template B: Sales Dashboard (РОП Level)

**Назначение:** Детализация по менеджерам. Ответ на "кто не работает?"

### Структура страницы

```
[Header + фильтры: отдел / период]
[KPI Row: ОП-специфичные (обработка, дозвон, время, наборы)]
[Table: менеджеры с mini-bars по каждой health-метрике]
[Разбивка: горячие vs ручные по каждому менеджеру]
```

### Код

```tsx
// === Таблица менеджеров ===
// Каждая строка = менеджер. Каждая метрика = ProgressBar (% нормы).

const managers = [
  { name: "Иванова",   ordersPerDay: 2.1, minOnLine: 180, dialRate: 75, avgCallMin: 2.8, sla: 45, hotCR: 38, manualCR: 12, revenue: 420_000 },
  { name: "Петрова",   ordersPerDay: 0.3, minOnLine: 5,   dialRate: 60, avgCallMin: 0.8, sla: 5,  hotCR: 25, manualCR: 3,  revenue: 85_000 },
  { name: "Сидорова",  ordersPerDay: 1.5, minOnLine: 120, dialRate: 68, avgCallMin: 3.2, sla: 60, hotCR: 42, manualCR: 8,  revenue: 310_000 },
  // ... остальные
];

// Нормы
const norms = { ordersPerDay: 5, minOnLine: 240, dialRate: 60, avgCallMin: 3, sla: 100, hotCR: 50, manualCR: 30 };

<TableCard.Root>
  <TableCard.Header title="Менеджеры ОП" subtitle="Все health-метрики per person" />
  <Table aria-label="Менеджеры">
    <Table.Header>
      <Table.Column id="name" isRowHeader>Менеджер</Table.Column>
      <Table.Column id="orders">Заказов/день</Table.Column>
      <Table.Column id="minutes">Мин на линии</Table.Column>
      <Table.Column id="dial">Дозвон %</Table.Column>
      <Table.Column id="avgCall">Ср. разговор</Table.Column>
      <Table.Column id="sla">SLA %</Table.Column>
      <Table.Column id="hotCR">CR горяч</Table.Column>
      <Table.Column id="manualCR">CR ручн</Table.Column>
      <Table.Column id="revenue">Выручка</Table.Column>
    </Table.Header>
    <Table.Body items={managers}>
      {(m) => (
        <Table.Row id={m.name}>
          <Table.Cell className="font-medium">{m.name}</Table.Cell>
          <Table.Cell>
            <ProgressBar value={Math.round(m.ordersPerDay / norms.ordersPerDay * 100)} labelPosition="right"
              progressClassName={m.ordersPerDay / norms.ordersPerDay >= 0.7 ? "bg-fg-success-primary" : "bg-fg-error-primary"} />
          </Table.Cell>
          <Table.Cell>
            <ProgressBar value={Math.round(m.minOnLine / norms.minOnLine * 100)} labelPosition="right"
              progressClassName={m.minOnLine / norms.minOnLine >= 0.7 ? "bg-fg-success-primary" : "bg-fg-error-primary"} />
          </Table.Cell>
          <Table.Cell className="tabular-nums">{m.dialRate}%</Table.Cell>
          <Table.Cell className="tabular-nums">{m.avgCallMin} мин</Table.Cell>
          <Table.Cell className="tabular-nums">{m.sla}%</Table.Cell>
          <Table.Cell className="tabular-nums">{m.hotCR}%</Table.Cell>
          <Table.Cell className="tabular-nums">{m.manualCR}%</Table.Cell>
          <Table.Cell className="tabular-nums font-medium">{fmtMoney(m.revenue)}</Table.Cell>
        </Table.Row>
      )}
    </Table.Body>
  </Table>
</TableCard.Root>
```

---

## Template C: Funnel Dashboard

**Назначение:** Воронка запуска. Ответ на "где ломается конверсия?"

### Структура страницы

```
[Header: название запуска + период]
[KPI Row: визиты, регистрации, CR сквозная, выручка]
[Funnel: horizontal bars убывающие + step-to-step CR]
[Breakdown: по источникам трафика / устройствам]
```

### Код

```tsx
const funnelSteps = [
  { step: "Визиты",        count: 2711, cr: null },
  { step: "Регистрации",   count: 1823, cr: 67.2 },
  { step: "Построили карту", count: 1450, cr: 79.5 },
  { step: "Досмотрели видео", count: 890, cr: 61.4 },
  { step: "Начали квиз",   count: 620, cr: 69.7 },
  { step: "Записались",    count: 139, cr: 22.4 },
  { step: "Подтвердили",   count: 92, cr: 66.2 },
  { step: "Диагностика",   count: 65, cr: 70.7 },
  { step: "Заказ",          count: 42, cr: 64.6 },
  { step: "Оплата",         count: 15, cr: 35.7 },
];

// Найди шаг с наибольшим Revenue Impact
const avgCheck = 37_000;
const stepsWithImpact = funnelSteps.map((step, i) => {
  if (i === 0) return { ...step, lost: 0, lostRevenue: 0 };
  const lost = funnelSteps[i - 1].count - step.count;
  return { ...step, lost, lostRevenue: lost * avgCheck };
});

// Funnel = horizontal bar chart
<TableCard.Root>
  <TableCard.Header
    title="Воронка запуска"
    subtitle="Step-to-step CR + потери в рублях"
  />
  <div className="px-5 py-4">
    <ResponsiveContainer width="100%" height={funnelSteps.length * 40}>
      <BarChart data={funnelSteps} layout="vertical" barSize={24}>
        <CartesianGrid horizontal={false} strokeDasharray="3 3" className="stroke-border-secondary" />
        <XAxis type="number" tickLine={false} axisLine={false} className="text-xs text-tertiary" />
        <YAxis type="category" dataKey="step" tickLine={false} axisLine={false}
          className="text-xs text-tertiary" width={140} />
        <Tooltip content={<ChartTooltipContent />} />
        <Bar dataKey="count" name="Количество" className="fill-utility-brand-600" radius={[0, 4, 4, 0]} />
      </BarChart>
    </ResponsiveContainer>
  </div>

  {/* Step-to-step CR таблица */}
  <Table aria-label="Funnel steps">
    <Table.Header>
      <Table.Column id="step" isRowHeader>Шаг</Table.Column>
      <Table.Column id="count">Кол-во</Table.Column>
      <Table.Column id="cr">CR шага</Table.Column>
      <Table.Column id="lost">Потеряно</Table.Column>
      <Table.Column id="lostRevenue">Потери R</Table.Column>
    </Table.Header>
    <Table.Body items={stepsWithImpact}>
      {(item) => (
        <Table.Row id={item.step}>
          <Table.Cell className="font-medium">{item.step}</Table.Cell>
          <Table.Cell className="tabular-nums">{item.count}</Table.Cell>
          <Table.Cell className="tabular-nums">{item.cr ? `${item.cr}%` : "-"}</Table.Cell>
          <Table.Cell className="tabular-nums text-tertiary">{item.lost || "-"}</Table.Cell>
          <Table.Cell className="tabular-nums">
            {item.lostRevenue > 0 && (
              <Badge color="error" size="sm">{fmtMoney(item.lostRevenue)}</Badge>
            )}
          </Table.Cell>
        </Table.Row>
      )}
    </Table.Body>
  </Table>
</TableCard.Root>
```

---

## Как использовать templates

```
1. Определи тип дашборда:
   - Sales/Revenue → Template A (CEO) + Template B (РОП)
   - Запуск/воронка → Template C
   - Оба → Template A + C на разных вкладках

2. Скопируй template в проект

3. Подставь данные из API:
   - /api/sales-control/summary → kpiData
   - /api/sales-control/timeseries → weeklyData
   - /api/sales-control/manager/{id}/scorecard → managers

4. Проверь:
   - Все компоненты из UUI (MetricsSimple, TableCard, Table, ProgressBar, Badge)?
   - Все цвета семантические (text-primary, НЕ text-gray-900)?
   - Каждая метрика с контекстом (план/прошлый период/тренд)?
   - Health-метрики отсортированы по Revenue Impact?
   - Run rate есть в header?
```
