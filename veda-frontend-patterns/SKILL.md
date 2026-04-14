---
name: veda-frontend-patterns
description: Паттерны фронтенда Veda -- Next.js App Router, BFF, auth, WebSocket, Zustand, Context, компоненты. Используй при написании или отладке фронтенд-кода.
---

# Фронтенд-паттерны Veda

## Когда использовать

- Создание новых страниц, компонентов, BFF routes
- Работа с auth, WebSocket, состоянием
- Отладка фронтенд-проблем
- Проверка архитектурных решений

## SSOT — Canonical Constants и Shared Components (АРХИТЕКТУРНЫЙ ЗАКОН)

### Закон 1: Один файл маппинга для каждого домена

```typescript
// КАЖДЫЙ набор значений (status, result, type) с label/color/badge
// определяется ОДИН РАЗ в app/lib/<domain>-constants.ts
// ВСЕ страницы и компоненты импортируют оттуда

// НЕПРАВИЛЬНО — 7 копий в 7 файлах, каждая с расхождениями:
// diagnostic-log.ts:   no_show → "Неявка"
// types/index.ts:      no_show → "Не пришёл"
// today/page.tsx:      no_show → "Не пришла"
// calendar/page.tsx:   no_show → "не пришёл"

// ПРАВИЛЬНО — один canonical файл:
// app/lib/diagnostic-constants.ts
export const BOOKING_STATUS = {
  confirmed:   { label: 'Подтверждена', dot: 'bg-brand-solid' },
  completed:   { label: 'Проведена',    dot: 'bg-success-solid' },
  // ...
} as const;

export const APPOINTMENT_RESULT = {
  sale:     { label: 'Продажа', badge: 'success' as const },
  no_show:  { label: 'Неявка',  badge: 'gray' as const },
  // ...
} as const;
```

**Правило:** ЗАПРЕЩЕНО создавать `const statusLabels: Record<string, string>` или `switch(status)` с русскими метками внутри компонента. Всегда импорт из `lib/<domain>-constants.ts`.

### Закон 2: Shared компоненты для повторяющихся отображений

```typescript
// ЕСЛИ badge/dot/label для значения показывается на >1 странице:
// → ОБЯЗАТЕЛЕН shared компонент в components/shared/ или lib/

// НЕПРАВИЛЬНО — каждая page рендерит badge по-своему:
// today/page.tsx:    <span className="bg-green-100 text-green-700">Продажа</span>
// log/page.tsx:      <Badge color="success">Продажа</Badge>
// calendar/page.tsx: <div className={getStatusBorderColor(status)}>...

// ПРАВИЛЬНО — один компонент:
// components/shared/ResultBadge.tsx
import { APPOINTMENT_RESULT } from '@/app/lib/diagnostic-constants';
export function ResultBadge({ result }: { result: string }) {
  const cfg = APPOINTMENT_RESULT[result as keyof typeof APPOINTMENT_RESULT];
  if (!cfg) return null;
  return <Badge color={cfg.badge}>{cfg.label}</Badge>;
}
```

### Закон 3: Цвета через токены, не hex

```typescript
// НЕПРАВИЛЬНО — hardcoded hex в компоненте
return 'border-l-[#3B82F6]';  // что это за цвет?
return '#4FAE62';              // green? success? brand?

// ПРАВИЛЬНО — semantic tokens
return 'border-l-brand-solid';
return 'bg-success-solid';
```

### Чеклист перед добавлением нового UI для статуса/значения:
1. Существует ли canonical mapping в `lib/<domain>-constants.ts`? Если нет — создать.
2. Существует ли shared компонент (Badge, Dot, Label)? Если нет и >1 место — создать.
3. Импортируй и используй. НИКОГДА не копируй маппинг в компонент.
4. Цвета через design tokens. Никаких hex.

---

## Ключевые правила

### Архитектура проекта

```
app/
├── [route]/page.tsx         # Страницы (App Router)
├── api/*/route.ts           # BFF routes (215 штук) -- ПРОКСИ к бэкенду
├── components/              # 178 компонентов по фичам
│   ├── admin/               # AdminLayout, Sidebar, sales/, okk/, management/
│   ├── diagnostic/          # diagnost/, client/, shared/
│   ├── sales/               # CallScript, AIHintsPanel, ProductCatalog...
│   ├── visuals/v2/          # 16 Visual компонентов + resolvers.ts + types.ts
│   └── shared/              # VedicNatalChart.tsx
├── context/                 # AuthContext, DiagnosticContext, SidebarContext
├── stores/                  # salesSessionStore.ts (Zustand)
├── hooks/                   # useTranscription, usePlanetImages, usePresentationSync
├── lib/                     # 20+ утилит (auth.ts, openrouter.ts, groq-stt.ts...)
└── types/                   # index.ts + okk.ts + sales.ts + management.ts...
```

### BFF Route (паттерн)

```typescript
// app/api/crm/clients/route.ts
import { getAuthUser, getAuthHeaders, unauthorizedResponse } from '@/app/lib/auth';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8000';

export async function GET(request: NextRequest) {
  const user = await getAuthUser(request);
  if (!user) return unauthorizedResponse();

  const response = await fetch(`${BACKEND_URL}/api/clients`, {
    headers: getAuthHeaders(request),
    cache: 'no-store',  // ВСЕГДА для CRM данных
  });

  return NextResponse.json(await response.json(), { status: response.status });
}
```

**Правила BFF:**
- Без бизнес-логики (чистый прокси)
- `cache: 'no-store'` для CRM/real-time данных
- Форвардить `Authorization` header через `getAuthHeaders(request)`
- Возвращать status code от бэкенда
- Dynamic params: `{ params }: { params: Promise<{ id: string }> }`

### Auth (паттерн страницы)

```typescript
'use client';
import { useRequireAuth, useAuth, useAuthFetch } from '@/app/context/AuthContext';

export default function MyPage() {
  useRequireAuth('/login');
  const { user } = useAuth();
  const authFetch = useAuthFetch();  // fetch с auto-auth

  // Опционально: проверка роли
  if (user?.role !== 'department_head') return <div>Access denied</div>;

  return <AdminLayout>{/* ... */}</AdminLayout>;
}
```

**Хуки auth:**
- `useAuth()` -- состояние + методы (login, logout)
- `useRequireAuth(redirect?)` -- редирект если не авторизован
- `useAuthFetch()` -- fetch обёртка с Authorization + auto-401 refresh

### State Management

| Когда | Что использовать |
|-------|-----------------|
| Глобальный auth state | `AuthContext` (useReducer + localStorage) |
| Диагностическая сессия | `DiagnosticContext` (useReducer + Socket.IO) |
| Sales workstation | `salesSessionStore.ts` (Zustand) |
| Локальный UI state | `useState` / `useReducer` |
| Серверные данные | `useAuthFetch()` + useState |

### WebSocket (Socket.IO)

```
Сервер: websocket-server.js (порт 8080, PM2: veda-websocket)
Путь: /ws/diagnostic
События: slide_change, data_update, interaction, chart_highlights
```

**Клиент:** `app/hooks/usePresentationSync.ts`

### Visual компоненты (v2)

```
Данные -> resolvers.ts -> Visual*Props -> Visual*Component -> Render
```

**Resolver приоритет:** LLM анализ -> баланс-колесо -> роутинг -> hardcoded fallback

### CSS Variables (Veda Theme)

```css
--v-bg, --v-ink, --v-muted, --v-muted2
--v-line, --v-line2, --v-blue, --v-red
```

**Утилиты:** `.v-card`, `.v-th`, `.v-td`, `.v-tr`, `.v-iconbtn`

### Performance (фронтенд)

**Code splitting (обязательно для SPA):**
```typescript
// Каждая секция/страница -- lazy import
const Section = lazy(() => import('./sections/SectionName'));
<Suspense fallback={<Skeleton />}><Section /></Suspense>
```

**Рендеринг:**
- `memo()` -- компоненты в списках и виртуализированных контейнерах
- `useMemo()` -- тяжёлые вычисления (сортировка, фильтрация >100 элементов)
- `useCallback()` -- обработчики внутри memo-компонентов
- НЕ memo всё подряд -- только по данным профайлера

**Виртуализация:**
- Списки >50 элементов -- `react-virtuoso` (Virtuoso/VirtuosoGrid)
- `increaseViewportBy: { top: 200, bottom: 200 }` для плавного скролла

**Кеширование (три уровня):**
```
Zustand/память (<1ms) → IndexedDB (~1ms) → REST API (сотни ms)
```
- Рендери из кеша СРАЗУ, синхронизируй фоном (stale-while-revalidate)
- IDB для данных между перезагрузками (rooms, messages, settings)

**Bundle бюджеты (gzip):**
- Initial JS: <150KB
- Lazy chunk: <30KB each
- CSS: <50KB
- Vite `manualChunks`: react-vendor, ui-vendor, state, vendor

**Подробнее:** `/perf` скилл (`veda-performance`)

### Gotchas

| Проблема | Решение |
|----------|---------|
| `params` как Promise | Next.js 14+: `const { id } = await params;` |
| `'use client'` забыли | useState/useEffect не работают без этого |
| `cache: 'no-store'` забыли | Данные кешируются, не обновляются |
| Иконки не из Untitled UI | Только `@untitledui-pro/icons/line/IconName` |
| TypeScript ошибки при build | `next.config.js` игнорирует в dev, но ПОКАЗАТЬ при проверке |
| Bundle >200KB gzip | Code splitting + manualChunks + tree-shaking |
| Лишние рендеры | React Profiler → memo/useMemo/useCallback |
| Список тормозит | Виртуализация (react-virtuoso) для >50 элементов |

## Быстрый маршрут

1. Новая страница? -> `app/[route]/page.tsx` + `'use client'` + `useRequireAuth()`
2. Нужен API? -> BFF route `app/api/[path]/route.ts` -> прокси к бэкенду
3. Нужно состояние? -> AuthContext (auth) / DiagnosticContext (сессия) / Zustand (sales) / useState (локальное)
4. Новый компонент? -> `app/components/[feature]/ComponentName.tsx`

## Reference-файлы

| Файл | Когда открывать |
|------|----------------|
| `reference/bff-routes-list.md` | Полный список 215 BFF routes |
| `reference/hooks-guide.md` | Документация по хукам (useTranscription, useApi, etc.) |
| `reference/auth-system.md` | Детали auth: permissions, roles, token flow |

## Memory-файлы (формы заказа, GC интеграция)

При работе с формами заказа на vedantica.ru или любом лендинге — прочитать:
- `~/.claude/projects/-Users-alex-Projects/memory/feedback_order_form_ux.md` — UX формы: CTA текст, поля, trust signals, 152-ФЗ
- `~/.claude/projects/-Users-alex-Projects/memory/gc-deals-api-create.md` — GC API создание заказов с payment_link
- `~/.claude/projects/-Users-alex-Projects/memory/feedback_gc_widgets_broken.md` — НЕ использовать GC виджеты
- `~/.claude/projects/-Users-alex-Projects/memory/vedantica-site-deploy.md` — деплой vedantica-site
