# Chart Patterns — Recharts + AG Grid

## Цвета (ТОЛЬКО токены, не hex)

```tsx
// CSS variables из theme.css — используй везде
const CHART_COLORS = {
  primary:  'var(--color-fg-brand-primary)',    // основная метрика
  previous: 'var(--color-fg-disabled)',          // предыдущий период
  success:  'var(--color-fg-success-primary)',   // выше нормы
  error:    'var(--color-fg-error-primary)',     // ниже нормы
  warning:  'var(--color-fg-warning-primary)',   // на границе
  neutral:  'var(--color-fg-secondary)',         // нейтральные данные
};
```

---

## Recharts: Line Chart (тренд + сравнение)

```tsx
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend } from 'recharts';

function TrendChart({ data }: { data: Array<{ date: string; current: number; previous: number }> }) {
  return (
    <ResponsiveContainer width="100%" height={280}>
      <LineChart data={data} margin={{ top: 8, right: 16, left: 0, bottom: 0 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="var(--color-border-secondary)" />
        <XAxis
          dataKey="date"
          tick={{ fontSize: 12, fill: 'var(--color-fg-tertiary)' }}
          tickLine={false}
          axisLine={false}
        />
        <YAxis
          tick={{ fontSize: 12, fill: 'var(--color-fg-tertiary)' }}
          tickLine={false}
          axisLine={false}
        />
        <Tooltip content={<CustomTooltip />} />
        <Legend
          verticalAlign="bottom"
          height={36}
          wrapperStyle={{ fontSize: 12, color: 'var(--color-fg-secondary)' }}
        />
        <Line
          type="monotone"
          dataKey="current"
          name="Текущий период"
          stroke="var(--color-fg-brand-primary)"
          strokeWidth={2}
          dot={false}
          activeDot={{ r: 4 }}
        />
        <Line
          type="monotone"
          dataKey="previous"
          name="Предыдущий период"
          stroke="var(--color-fg-disabled)"
          strokeWidth={1.5}
          strokeDasharray="4 4"
          dot={false}
        />
      </LineChart>
    </ResponsiveContainer>
  );
}
```

---

## Recharts: Funnel (horizontal bar, убывающий)

```tsx
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Cell, LabelList } from 'recharts';

interface FunnelStep {
  name: string;
  value: number;
  conversion?: string; // "↓ 75%"
}

function FunnelChart({ steps }: { steps: FunnelStep[] }) {
  const max = Math.max(...steps.map(s => s.value));
  return (
    <ResponsiveContainer width="100%" height={steps.length * 52 + 24}>
      <BarChart
        data={steps}
        layout="vertical"
        margin={{ top: 0, right: 80, left: 0, bottom: 0 }}
      >
        <XAxis type="number" hide domain={[0, max]} />
        <YAxis
          type="category"
          dataKey="name"
          width={160}
          tick={{ fontSize: 13, fill: 'var(--color-fg-secondary)' }}
          tickLine={false}
          axisLine={false}
        />
        <Tooltip content={<CustomTooltip />} cursor={{ fill: 'var(--color-bg-secondary)' }} />
        <Bar dataKey="value" radius={[0, 4, 4, 0]} maxBarSize={28}>
          {steps.map((_, idx) => (
            <Cell
              key={idx}
              fill={`color-mix(in srgb, var(--color-fg-brand-primary) ${100 - idx * 15}%, transparent)`}
            />
          ))}
          <LabelList
            dataKey="value"
            position="right"
            style={{ fontSize: 13, fontWeight: 600, fill: 'var(--color-fg-primary)' }}
          />
        </Bar>
      </BarChart>
    </ResponsiveContainer>
  );
}
```

---

## Recharts: Custom Tooltip

```tsx
function CustomTooltip({ active, payload, label }: any) {
  if (!active || !payload?.length) return null;
  return (
    <div className="bg-primary border border-secondary rounded-lg shadow-lg px-3 py-2 text-sm">
      {label && <p className="text-tertiary mb-1 text-xs">{label}</p>}
      {payload.map((entry: any, i: number) => (
        <div key={i} className="flex items-center gap-2">
          <span className="w-2 h-2 rounded-full" style={{ background: entry.color }} />
          <span className="text-secondary">{entry.name}:</span>
          <span className="text-primary font-semibold">{entry.value}</span>
        </div>
      ))}
    </div>
  );
}
```

---

## AG Grid: Mini-Bar Cell Renderer

```tsx
import { ICellRendererParams } from 'ag-grid-community';

interface MiniBarParams extends ICellRendererParams {
  max?: number;
  suffix?: string;
}

function MiniBarCellRenderer({ value, max = 100, suffix = '' }: MiniBarParams) {
  const pct = Math.min((value / max) * 100, 100);
  return (
    <div className="flex items-center gap-2 h-full">
      <div className="flex-1 h-1.5 bg-secondary rounded-full overflow-hidden">
        <div
          className="h-full bg-brand-solid rounded-full"
          style={{ width: `${pct}%` }}
        />
      </div>
      <span className="text-primary text-xs font-medium w-14 text-right tabular-nums">
        {value}{suffix}
      </span>
    </div>
  );
}
```

---

## AG Grid: Conditional Color Cell Style

```tsx
// По норме (есть target)
function colorByNorm(value: number, target: number) {
  const ratio = value / target;
  if (ratio >= 0.9) return { color: 'var(--color-fg-success-primary)' };
  if (ratio >= 0.7) return { color: 'var(--color-fg-warning-primary)' };
  return { color: 'var(--color-fg-error-primary)' };
}

// Использование в colDef
const colDef = {
  field: 'conversion_rate',
  cellStyle: (params: any) => colorByNorm(params.value, params.data.target),
};
```

---

## AG Grid: Базовая конфигурация

```tsx
import { AgGridReact } from 'ag-grid-react';
import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-quartz.css';

const defaultColDef = {
  sortable: true,
  resizable: false,
  suppressMovable: true,
  headerClass: 'text-xs font-medium text-tertiary uppercase tracking-wide',
};

<div className="ag-theme-quartz w-full" style={{ height: 480 }}>
  <AgGridReact
    rowData={data}
    columnDefs={columnDefs}
    defaultColDef={defaultColDef}
    rowHeight={52}
    headerHeight={40}
    suppressCellFocus
    onGridReady={(params) => params.api.sizeColumnsToFit()}
  />
</div>
```

---

## Scorecard Component

```tsx
interface ScorecardProps {
  label: string;
  value: string | number;
  delta?: number;      // +3.2 → положительный; -1.1 → отрицательный
  deltaLabel?: string; // "vs прошлый месяц"
  positiveIsGood?: boolean; // false если рост = плохо (например, отмены)
}

function Scorecard({ label, value, delta, deltaLabel, positiveIsGood = true }: ScorecardProps) {
  const isGood = delta !== undefined
    ? (positiveIsGood ? delta >= 0 : delta <= 0)
    : null;
  return (
    <div className="bg-primary border border-secondary rounded-xl p-4">
      <p className="text-tertiary text-xs mb-1">{label}</p>
      <p className="text-primary text-2xl font-semibold tabular-nums">{value}</p>
      {delta !== undefined && (
        <p className={`text-xs mt-1 ${isGood ? 'text-success-primary' : 'text-error-primary'}`}>
          {delta > 0 ? '↑' : '↓'} {Math.abs(delta)}% {deltaLabel}
        </p>
      )}
    </div>
  );
}
```

---

## Skeleton для загрузки

```tsx
// Таблица
function TableSkeleton({ rows = 8, cols = 5 }) {
  return (
    <div className="space-y-2">
      {Array.from({ length: rows }).map((_, i) => (
        <div key={i} className="flex gap-4">
          {Array.from({ length: cols }).map((_, j) => (
            <div key={j} className="h-8 bg-secondary rounded animate-pulse flex-1" />
          ))}
        </div>
      ))}
    </div>
  );
}

// KPI Row
function ScorecardRowSkeleton() {
  return (
    <div className="grid grid-cols-5 gap-4">
      {Array.from({ length: 5 }).map((_, i) => (
        <div key={i} className="bg-secondary rounded-xl p-4 h-20 animate-pulse" />
      ))}
    </div>
  );
}
```
