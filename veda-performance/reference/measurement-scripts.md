# Скрипты замеров производительности

## 1. Navigation Timing (вставить в Console)

```javascript
const t = performance.getEntriesByType('navigation')[0];
console.table({
  'DNS':          `${(t.domainLookupEnd - t.domainLookupStart).toFixed(0)}ms`,
  'TCP':          `${(t.connectEnd - t.connectStart).toFixed(0)}ms`,
  'TTFB':         `${(t.responseStart - t.requestStart).toFixed(0)}ms`,
  'Download':     `${(t.responseEnd - t.responseStart).toFixed(0)}ms`,
  'DOM Interactive': `${(t.domInteractive - t.navigationStart).toFixed(0)}ms`,
  'DOM Complete':  `${(t.domComplete - t.navigationStart).toFixed(0)}ms`,
  'Load':         `${(t.loadEventEnd - t.navigationStart).toFixed(0)}ms`,
});
```

## 2. IndexedDB Performance

```javascript
async function measureIDB(dbName, storeName) {
  const db = await new Promise((resolve, reject) => {
    const req = indexedDB.open(dbName);
    req.onsuccess = () => resolve(req.result);
    req.onerror = () => reject(req.error);
  });

  const t0 = performance.now();
  const tx = db.transaction(storeName, 'readonly');
  const store = tx.objectStore(storeName);
  const items = await new Promise((resolve, reject) => {
    const req = store.getAll();
    req.onsuccess = () => resolve(req.result);
    req.onerror = () => reject(req.error);
  });
  const t1 = performance.now();

  console.log(`IDB ${storeName}: ${items.length} items in ${(t1 - t0).toFixed(1)}ms`);
  db.close();
  return items;
}

// Использование (veda-chat):
measureIDB('veda-chat', 'rooms');
measureIDB('veda-chat', 'messages');
```

## 3. API Call Interceptor

```javascript
const originalFetch = window.fetch;
const apiLog = [];

window.fetch = async function(...args) {
  const url = typeof args[0] === 'string' ? args[0] : args[0].url;
  const t0 = performance.now();
  try {
    const res = await originalFetch.apply(this, args);
    const t1 = performance.now();
    const duration = t1 - t0;
    apiLog.push({ url, status: res.status, duration: `${duration.toFixed(0)}ms` });
    if (duration > 500) console.warn(`SLOW API: ${url} = ${duration.toFixed(0)}ms`);
    return res;
  } catch (e) {
    apiLog.push({ url, error: e.message });
    throw e;
  }
};

// Посмотреть все вызовы:
// console.table(apiLog);
```

## 4. React Render Counter (dev mode)

```javascript
// В компоненте:
import { useRef } from 'react';

function useRenderCount(name: string) {
  const count = useRef(0);
  count.current++;
  console.log(`[Render] ${name}: ${count.current}`);
}
```

## 5. Bundle Size Check (CLI)

```bash
# Общий размер
du -sh dist/assets/

# Топ-10 файлов
ls -lhS dist/assets/*.js | head -10

# Gzip-размер
gzip -c dist/assets/index-*.js | wc -c | awk '{print $1/1024 "KB gzip"}'

# Визуализатор
npx vite-bundle-visualizer
```

## 6. Lighthouse CLI

```bash
# Полный аудит
npx lighthouse https://URL --output=json --output=html \
  --chrome-flags="--headless" --only-categories=performance

# Только метрики (быстрее)
npx lighthouse https://URL --output=json --chrome-flags="--headless" \
  --only-audits=first-contentful-paint,largest-contentful-paint,total-blocking-time,cumulative-layout-shift,server-response-time

# Парсинг JSON
cat report.json | jq '.categories.performance.score * 100'
cat report.json | jq '.audits["first-contentful-paint"].numericValue'
```

## 7. Web Vitals (встроить в код)

```typescript
import { onCLS, onFCP, onLCP, onTTFB, onINP } from 'web-vitals';

function sendToAnalytics(metric: { name: string; value: number }) {
  console.log(`[Vital] ${metric.name}: ${metric.value.toFixed(1)}`);
}

onCLS(sendToAnalytics);
onFCP(sendToAnalytics);
onLCP(sendToAnalytics);
onTTFB(sendToAnalytics);
onINP(sendToAnalytics);
```
