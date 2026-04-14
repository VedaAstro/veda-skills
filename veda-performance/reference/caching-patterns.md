# Паттерны кеширования -- VEDA Platform

## 1. Service Worker (Workbox)

### Стратегии

| Ресурс | Стратегия | TTL | Пример |
|--------|-----------|-----|--------|
| JS/CSS бандлы | CacheFirst | До нового билда | `*.js`, `*.css` (с хешем) |
| HTML shell | StaleWhileRevalidate | -- | `index.html` |
| API данные | NetworkFirst | 5min fallback | `/api/v1/*` |
| Аватарки | CacheFirst | 24h | `/avatar/*` |
| Шрифты | CacheFirst | 30d | `*.woff2` |
| Иконки SVG | CacheFirst | 7d | `*.svg` |

### Конфиг (sw.ts для injectManifest)

```typescript
import { precacheAndRoute } from 'workbox-precaching';
import { registerRoute } from 'workbox-routing';
import { CacheFirst, NetworkFirst, StaleWhileRevalidate } from 'workbox-strategies';
import { ExpirationPlugin } from 'workbox-expiration';

// Precache build assets (injected by vite-plugin-pwa)
precacheAndRoute(self.__WB_MANIFEST);

// API -- network first, fallback to cache
registerRoute(
  ({ url }) => url.pathname.startsWith('/api/'),
  new NetworkFirst({
    cacheName: 'api-cache',
    plugins: [new ExpirationPlugin({ maxEntries: 200, maxAgeSeconds: 5 * 60 })],
  })
);

// Avatars -- cache first, expire in 24h
registerRoute(
  ({ url }) => url.pathname.includes('/avatar/'),
  new CacheFirst({
    cacheName: 'avatars',
    plugins: [new ExpirationPlugin({ maxEntries: 500, maxAgeSeconds: 24 * 60 * 60 })],
  })
);

// Fonts
registerRoute(
  ({ request }) => request.destination === 'font',
  new CacheFirst({
    cacheName: 'fonts',
    plugins: [new ExpirationPlugin({ maxAgeSeconds: 30 * 24 * 60 * 60 })],
  })
);
```

## 2. IndexedDB (idb library)

### Схема (veda-chat)

```typescript
import { openDB } from 'idb';

const db = await openDB('veda-chat', 2, {
  upgrade(db, oldVersion) {
    if (oldVersion < 1) {
      db.createObjectStore('rooms', { keyPath: '_id' });
      const msgStore = db.createObjectStore('messages', { keyPath: '_id' });
      msgStore.createIndex('by-room', 'rid');
      db.createObjectStore('syncState', { keyPath: 'key' });
    }
    if (oldVersion < 2) {
      db.createObjectStore('readReceipts', { keyPath: 'rid' });
      db.createObjectStore('members', { keyPath: 'rid' });
    }
  }
});
```

### Паттерн: stale-while-revalidate

```typescript
async function getRoomMessages(roomId: string): Promise<Message[]> {
  // 1. Мгновенно из IDB
  const cached = await db.getAllFromIndex('messages', 'by-room', roomId);
  if (cached.length) {
    renderMessages(cached); // <1ms
  }

  // 2. Фоновая синхронизация
  const lastTs = cached.length ? cached[cached.length - 1].ts : undefined;
  const fresh = await api.getMessages(roomId, { since: lastTs });

  if (fresh.length) {
    await db.putAll('messages', fresh);
    renderMessages([...cached, ...fresh]);
  }

  return [...cached, ...fresh];
}
```

## 3. nginx proxy_cache (для RC REST API)

```nginx
# /etc/nginx/conf.d/rc-cache.conf

proxy_cache_path /tmp/rc_cache
  levels=1:2
  keys_zone=rc:10m
  max_size=100m
  inactive=5m
  use_temp_path=off;

server {
  location /api/v1/ {
    proxy_pass http://127.0.0.1:3000;
    proxy_cache rc;
    proxy_cache_valid 200 30s;
    proxy_cache_valid 404 10s;
    proxy_cache_use_stale error timeout updating http_500 http_502;
    proxy_cache_lock on;
    proxy_cache_lock_timeout 5s;

    # Bypass cache для POST/PUT/DELETE
    proxy_cache_methods GET HEAD;

    # Debug header
    add_header X-Cache-Status $upstream_cache_status always;
  }
}
```

## 4. Redis (для бэкенда FastAPI)

```python
import redis.asyncio as redis
import json

r = redis.Redis(host='localhost', port=6379, db=1)

async def get_cached(key: str, ttl: int, fetch_fn):
    """Generic cache-aside pattern."""
    cached = await r.get(key)
    if cached:
        return json.loads(cached)

    data = await fetch_fn()
    await r.setex(key, ttl, json.dumps(data, default=str))
    return data

# Использование:
rooms = await get_cached(
    f"user:{user_id}:rooms",
    ttl=60,
    fetch_fn=lambda: fetch_rooms_from_rc(user_id)
)
```

## 5. BFF Cache Headers (Next.js)

```typescript
// Статические данные (справочники, конфиги)
export async function GET() {
  const data = await fetchConfig();
  return NextResponse.json(data, {
    headers: { 'Cache-Control': 'public, max-age=300, s-maxage=600' }
  });
}

// CRM данные (всегда свежие)
export async function GET() {
  const data = await fetchClients();
  return NextResponse.json(data, {
    headers: { 'Cache-Control': 'no-store' }
  });
}
```

## Иерархия инвалидации

```
WebSocket event → Zustand store → IDB write → UI update
                                ↓
              SW cache untouched (только для offline)
              nginx cache expires (30s TTL)
              Redis invalidate (pub/sub или TTL)
```
