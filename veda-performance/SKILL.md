---
name: veda-performance
description: Производительность платформы Veda — паттерны быстрого кода, code splitting, lazy loading, мемоизация, виртуализация. Используй при оптимизации скорости и написании кода.
---

# Performance — Veda Platform

## Когда использовать

- Code splitting / lazy loading при добавлении компонентов
- Оптимизация рендеринга (React, виртуализация)
- Настройка кеширования (TanStack Query, BFF)
- Аудит скорости (Lighthouse, Web Vitals, бандлы)
- Диагностика тормозов (API, рендер, загрузка)

## Ключевые правила

### 1. Code Splitting (обязательно для SPA)

```typescript
// Vite SPA — React.lazy для секций
const VedaBot = lazy(() => import('./sections/VedaBot'));
<Suspense fallback={<SectionSkeleton />}>
  <Route path="/bot" element={<VedaBot />} />
</Suspense>

// Next.js — next/dynamic (SSR-compatible)
import dynamic from 'next/dynamic';
const ChartDashboard = dynamic(() => import('@/features/chart/ChartDashboard'), {
  loading: () => <Loading />,
});
// Все тяжёлые компоненты (9+) на странице — через dynamic
```

```typescript
// vite.config.ts — manualChunks
manualChunks: {
  'react-vendor': ['react', 'react-dom', 'react-router-dom'],
  'ui-vendor': ['react-aria-components', 'react-virtuoso'],
  'state': ['zustand', 'idb'],
}
```

### 2. Виртуализация длинных списков

```typescript
import { Virtuoso } from 'react-virtuoso';
// Списки >50 элементов — ВСЕГДА виртуализация
<Virtuoso
  data={messages}
  itemContent={(index, msg) => <MessageItem key={msg._id} message={msg} />}
  followOutput="smooth"
  increaseViewportBy={{ top: 200, bottom: 200 }}
/>
```

### 3. Кеширование (TanStack Query + BFF)

```typescript
// QueryClient — глобальная конфигурация
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,    // 5 минут — не перезапрашиваем
      gcTime: 30 * 60 * 1000,      // 30 минут — держим в памяти
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});
```

**BFF:** `cache: 'no-store'` в fetch-запросах из Next.js API routes к FastAPI.
**Правило:** Рендери из кеша СРАЗУ, синхронизируй в фоне (stale-while-revalidate).

### 4. Изображения

```
WebP ONLY (cwebp -q 85, max 300KB)
loading="lazy" — ВСЕГДА
width + height ВСЕГДА (предотвращает CLS)
srcSet для responsive
```

```typescript
<img src={src} alt={alt} loading="lazy" width={40} height={40}
  className="size-full rounded-full object-cover" />
```

### 5. React мемоизация

```typescript
// memo — для компонентов в списках
const MessageItem = memo(({ message }: Props) => { ... });

// useMemo — для тяжёлых вычислений
const sorted = useMemo(() => rooms.sort(byLastMessage), [rooms]);

// useCallback — для обработчиков в memo-компонентах
const onSend = useCallback((text: string) => { ... }, [roomId]);
```

**НЕ memo всё подряд.** Только если профайлер показывает лишние рендеры.

### 6. API-оптимизации (FastAPI)

```python
# Параллельные запросы — asyncio.gather() вместо await x; await y
planets, chart_img = await asyncio.gather(fetch_planets(data), fetch_chart(data))

# Select только нужные поля
query = select(Message.id, Message.text, Message.ts).where(...)

# Индексы на частые WHERE
# CREATE INDEX idx_messages_room_ts ON messages(room_id, ts DESC);
```

## Reference-файлы

| Файл | Когда открывать |
|------|----------------|
| `reference/budgets.md` | Таблицы бюджетов, текущие метрики (март 2026), аудит-воркфлоу, tech debt |
| `reference/measurement-scripts.md` | Скрипты для замеров: IDB timing, API intercept, Navigation Timing |
| `reference/caching-patterns.md` | Service Worker, IDB, nginx, Redis — конфигурации и стратегии |
| `reference/bundle-optimization.md` | Vite manualChunks, tree-shaking, dynamic imports, анализ |
