# Performance: бюджеты, метрики, аудит-воркфлоу

## Performance-бюджеты (ЦЕЛЕВЫЕ)

| Метрика | Бюджет | Текущее (chat, март 2026) |
|---------|--------|--------------------------|
| TTFB | <200ms (SW: <50ms) | 960ms |
| FCP | <1.5s | 6.3s |
| LCP | <2.5s | 6.3s |
| TBT | <200ms | 0ms |
| CLS | <0.1 | 0 |
| JS bundle (gzip) | <150KB initial | 195KB |
| CSS (gzip) | <50KB | 49KB |
| Lighthouse Perf | >85 | 58 |

> Разрыв 3-5x — aspirational targets. Нет CI для отслеживания регрессий.

## Архитектура кеша (по проектам)

### veda-chat (Vite SPA)
```
Zustand/память  →  <1ms     →  текущая сессия
IndexedDB       →  ~0.7ms   →  между перезагрузками
REST API        →  650-6000ms → сервер (RC, FastAPI)
```
**Правило:** Рендери из кеша СРАЗУ, синхронизируй в фоне (stale-while-revalidate).

### app-myveda (Next.js)
```
TanStack Query  →  0ms (память)  →  staleTime 5min, gcTime 30min
Next.js cache   →  0ms (RSC)     →  серверные компоненты
REST API        →  650-6000ms   →  FastAPI / veda-astro-core
```

### veda-astro-core (FastAPI бэкенд)
```
Redis           →  <1ms    →  warm на старте (300+ static records)
PostgreSQL      →  5-50ms  →  при cache miss
RC API          →  100-6000ms → внешние запросы
```

## Tech debt производительности (не реализовано)

| Пункт | Где нужно | Эффект |
|-------|-----------|--------|
| `loading="lazy"` на аватарках | veda-chat/Avatar.tsx | CLS, сетевой трафик |
| `width`+`height` на img | veda-chat/Avatar.tsx | CLS prevention |
| Web Vitals tracking | veda-chat/main.tsx | Мониторинг LCP/CLS/INP |
| Route prefetch (hover) | veda-chat/Nav | FCP при переходах |
| Performance budget в CI | all projects | Регрессии |

```typescript
// Avatar.tsx — быстрый фикс
<img src={src} alt={alt} loading="lazy" width={40} height={40}
  className="size-full rounded-full object-cover" />

// main.tsx — Web Vitals (5 минут работы)
import { onCLS, onFCP, onLCP, onTTFB, onINP } from 'web-vitals';
onCLS(m => console.log('[Vital]', m.name, m.value));
```

## Быстрый маршрут: полный аудит

```
1. LIGHTHOUSE CLI
   npx lighthouse <URL> --output=json --chrome-flags="--headless" --only-categories=performance
   → FCP, LCP, TBT, CLS, TTFB, Score

2. BUNDLE ANALYSIS
   npx vite-bundle-visualizer   # или
   ls -la dist/assets/*.js | awk '{sum+=$5} END {print sum/1024 "KB"}'

3. RUNTIME MEASUREMENT (Chrome DevTools Console)
   → reference/measurement-scripts.md (IDB timing, API timing, render timing)

4. NETWORK WATERFALL
   DevTools → Network → Disable cache → Hard reload
   → Считай: сколько запросов, самый медленный, waterfall

5. REACT PROFILER
   DevTools → React Profiler → Record → взаимодействие → Stop
   → Ищи: >16ms рендеры, лишние рендеры

6. РЕЗУЛЬТАТ
   Заполни таблицу бюджетов выше. Что красное — в план оптимизации.
```
