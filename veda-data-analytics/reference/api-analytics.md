# Analytics API — VEDA Platform

## Источники данных

| API | Порт | Назначение |
|-----|------|-----------|
| veda-api (FastAPI) | 8000 | CRM: сессии, клиенты, сделки, сотрудники |
| bot-admin-api (FastAPI) | 8090 | Бот: воронки, рассылки, аналитика |
| BFF (Next.js) | 3001 | Прокси к veda-api, JWT на клиенте не хранится |

---

## Существующие аналитические эндпоинты (veda-api)

### 1. KPI / Metrics Overview
```
GET /api/analytics/kpi
Query: period_start, period_end, staff_id? (фильтр по сотруднику)
Response: { data: { sessions_count, conversion_rate, revenue, avg_check, cancellation_rate } }
```

### 2. Funnel Analysis
```
GET /api/analytics/funnel
Query: period_start, period_end, funnel_type? (diagnostics|sales)
Response: {
  data: [
    { step: "leads", count: 1000 },
    { step: "sessions", count: 750 },
    { step: "orders", count: 300 },
    { step: "paid", count: 210 }
  ]
}
```

### 3. Staff Performance (диагностологи / продажники)
```
GET /api/analytics/staff-performance
Query: period_start, period_end, role? (diagnostician|sales)
Response: {
  data: [{
    staff_id, name, role,
    sessions_count, sessions_quota, sessions_ratio,
    avg_session_duration,
    orders_count, conversion_rate, revenue,
    okk_score, sla_compliance,
    cancellation_count
  }]
}
```

### 4. Revenue Trends
```
GET /api/analytics/revenue-trends
Query: period_start, period_end, granularity (day|week|month), staff_id?
Response: {
  data: [{ date: "2026-03-01", revenue: 45000, orders: 3 }]
}
```

### 5. Conversion Trends
```
GET /api/analytics/conversion-trends
Query: period_start, period_end, granularity (day|week|month)
Response: {
  data: [{ date: "2026-03-01", cr_diag_to_order: 0.32, cr_order_to_paid: 0.7 }]
}
```

### 6. OKK Summary
```
GET /api/analytics/okk-summary
Query: period_start, period_end, staff_id?
Response: {
  data: [{ staff_id, name, evaluations_count, avg_score, criteria_breakdown: {} }]
}
```

### 7. Goals Progress
```
GET /api/goals
Response: [{ id, metric, target, current, period }]
```

---

## BFF Прокси (Next.js app/api/)

Все вызовы из React-компонентов — через BFF:

```typescript
// Клиент → BFF → veda-api (JWT добавляется BFF)
const res = await fetch('/api/analytics/staff-performance?period_start=2026-03-01&period_end=2026-03-31');
const { data } = await res.json();
```

**Важно**: `cache: 'no-store'` обязателен для всех аналитических запросов.

---

## Стандартный формат ответа

```json
{
  "data": [...],
  "meta": {
    "total": 42,
    "period_start": "2026-03-01",
    "period_end": "2026-03-31"
  },
  "error": null
}
```

---

## Проектирование новых эндпоинтов

При добавлении аналитического эндпоинта:

```python
# veda-api FastAPI
@router.get("/analytics/{resource}")
async def get_analytics(
    period_start: date,
    period_end: date,
    granularity: Literal["day", "week", "month"] = "day",
    staff_id: int | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: Staff = Depends(require_permission("analytics:read"))
):
    ...
    return {"data": result, "meta": {"period_start": period_start, "period_end": period_end}}
```

**Обязательные query params**: `period_start`, `period_end`
**Опциональные**: `granularity`, `staff_id`, `role`, `group_by`

---

## Паттерн загрузки данных (React)

```tsx
// hooks/useAnalytics.ts
import useSWR from 'swr';

function useStaffPerformance(params: { start: string; end: string }) {
  const url = `/api/analytics/staff-performance?period_start=${params.start}&period_end=${params.end}`;
  const { data, error, isLoading } = useSWR(url, fetcher, {
    revalidateOnFocus: false,
    dedupingInterval: 60_000, // кэш 1 минута
  });
  return { data: data?.data ?? [], isLoading, error };
}

// Использование
const { data, isLoading } = useStaffPerformance({ start: '2026-03-01', end: '2026-03-31' });
if (isLoading) return <TableSkeleton />;
```

---

## bot-admin-api аналитика (порт 8090)

```
GET /api/analytics/bots/{bot_id}/funnel    # воронка бота
GET /api/analytics/bots/{bot_id}/retention # D1/D7/D30 retention
GET /api/analytics/broadcasts/{id}/stats   # статистика рассылки
GET /api/analytics/segments                # размеры сегментов
```
