# Bundle Optimization -- Vite/React

## Анализ текущего бандла

```bash
# 1. Размеры файлов
ls -lhS dist/assets/*.js | head -10

# 2. Gzip-размеры
for f in dist/assets/*.js; do
  gz=$(gzip -c "$f" | wc -c)
  raw=$(wc -c < "$f")
  echo "$(basename $f): $(($raw/1024))KB raw, $(($gz/1024))KB gzip"
done

# 3. Визуализатор (treemap)
npx vite-bundle-visualizer

# 4. Source map explorer (если есть source maps)
npx source-map-explorer dist/assets/index-*.js
```

## Vite manualChunks

```typescript
// vite.config.ts
export default defineConfig({
  build: {
    rollupOptions: {
      output: {
        manualChunks(id) {
          // React core -- кешируется надолго (редко меняется)
          if (id.includes('react-dom') || id.includes('react/'))
            return 'react-vendor';

          // UI библиотеки
          if (id.includes('react-aria') || id.includes('react-virtuoso'))
            return 'ui-vendor';

          // State + storage
          if (id.includes('zustand') || id.includes('idb'))
            return 'state';

          // node_modules остальное
          if (id.includes('node_modules'))
            return 'vendor';
        }
      }
    },
    // Предупреждение если chunk > 500KB
    chunkSizeWarningLimit: 500,
  }
});
```

**Целевые размеры чанков (gzip):**

| Chunk | Бюджет | Что внутри |
|-------|--------|-----------|
| react-vendor | ~45KB | react, react-dom, react-router |
| ui-vendor | ~35KB | react-aria, react-virtuoso |
| state | ~10KB | zustand, idb |
| vendor | ~30KB | остальные node_modules |
| app (initial) | <50KB | routes, shell, auth |
| lazy chunks | <30KB each | секции (bot, library, settings) |

## Dynamic Imports (React.lazy)

```typescript
// App.tsx -- каждая секция загружается отдельно
import { lazy, Suspense } from 'react';

const ChatView = lazy(() => import('./sections/ChatView'));
const VedaBot = lazy(() => import('./sections/VedaBot'));
const Library = lazy(() => import('./sections/LibraryPage'));
const Settings = lazy(() => import('./sections/SettingsPage'));
const Schedule = lazy(() => import('./sections/SchedulePage'));

function App() {
  return (
    <Suspense fallback={<PageSkeleton />}>
      <Routes>
        <Route path="/" element={<ChatView />} />
        <Route path="/bot" element={<VedaBot />} />
        <Route path="/library" element={<Library />} />
        <Route path="/settings" element={<Settings />} />
        <Route path="/schedule" element={<Schedule />} />
      </Routes>
    </Suspense>
  );
}
```

## Tree-shaking checklist

```
1. Иконки: import { IconName } from '@untitledui-pro/icons/line/IconName'
   НЕ: import * as Icons from '@untitledui-pro/icons'

2. lodash: import debounce from 'lodash/debounce'
   НЕ: import { debounce } from 'lodash'

3. date-fns: import { format } from 'date-fns/format'
   (или убедиться что bundler трясит правильно)

4. Проверить sideEffects в package.json зависимостей
```

## Preload критических чанков

```html
<!-- index.html -->
<link rel="modulepreload" href="/assets/react-vendor-[hash].js" />
<link rel="modulepreload" href="/assets/app-[hash].js" />

<!-- Prefetch вероятных маршрутов -->
<link rel="prefetch" href="/assets/ChatView-[hash].js" />
```

```typescript
// Программный prefetch при hover
function NavItem({ to, children }) {
  const prefetch = () => {
    // Vite создаёт chunk с предсказуемым именем
    import(/* webpackPrefetch: true */ `./sections/${to}`);
  };
  return <Link to={to} onMouseEnter={prefetch}>{children}</Link>;
}
```

## Мониторинг размера в CI

```bash
#!/bin/bash
# scripts/check-bundle-size.sh
MAX_JS_KB=200  # gzip
MAX_CSS_KB=60  # gzip

npm run build

JS_SIZE=$(gzip -c dist/assets/index-*.js | wc -c)
CSS_SIZE=$(gzip -c dist/assets/index-*.css | wc -c)

JS_KB=$((JS_SIZE / 1024))
CSS_KB=$((CSS_SIZE / 1024))

echo "JS: ${JS_KB}KB gzip (budget: ${MAX_JS_KB}KB)"
echo "CSS: ${CSS_KB}KB gzip (budget: ${MAX_CSS_KB}KB)"

if [ $JS_KB -gt $MAX_JS_KB ]; then
  echo "BUDGET EXCEEDED: JS ${JS_KB}KB > ${MAX_JS_KB}KB"
  exit 1
fi
```
