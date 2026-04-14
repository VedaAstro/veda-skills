# Hooks & State Management Reference

> Comprehensive reference for all hooks, contexts, and Zustand stores in `veda-presentation`.
> Base path: `~/Projects/platform/veda-presentation/app/`

---

## Summary Table

| Name | Type | Domain | File | Purpose |
|------|------|--------|------|---------|
| `useAuth` | Context | Auth | `context/AuthContext.tsx` | Current user, login/logout, permissions |
| `useRequireAuth` | Hook | Auth | `context/AuthContext.tsx` | Guard: redirect if not authenticated |
| `useRequirePermission` | Hook | Auth | `context/AuthContext.tsx` | Guard: redirect if missing permission |
| `useAuthToken` | Hook | Auth | `context/AuthContext.tsx` | Read JWT token from localStorage |
| `useAuthFetch` | Hook | Auth | `context/AuthContext.tsx` | Authenticated fetch wrapper with 401 handling |
| `useDiagnostic` | Context | Diagnostics | `context/DiagnosticContext.tsx` | Full diagnostic session state + WebSocket |
| `useSlideStyles` | Context | Presentations | `context/SlideStyleContext.tsx` | Dynamic slide CSS variables |
| `useSidebar` | Context | UI | `context/SidebarContext.tsx` | Sidebar collapsed state |
| `useAI` | Context | Management | `components/admin/management/AI/AIProvider.tsx` | AI insights + chat panel for PDCA |
| `useSalesSessionStore` | Zustand | Sales | `stores/salesSessionStore.ts` | Sales call workstation state |
| `useManagementStore` | Zustand | Management | `stores/managementStore.ts` | PDCA sprints, metrics, tasks |
| `useAuraDiagnosticStore` | Zustand | Diagnostics | `stores/auraDiagnosticStore.ts` | Aura wheel visualization state |
| `useWebSocket` | Hook | Diagnostics | `hooks/diagnostic/useWebSocket.ts` | Low-level WebSocket connection (legacy) |
| `usePresentationSync` | Hook | Presentations | `hooks/usePresentationSync.ts` | Real-time script sync via WebSocket |
| `usePlanetImages` | Hook | Diagnostics | `hooks/usePlanetImages.ts` | Load planet PNG URLs from media library |
| `useTranscription` | Hook | Diagnostics | `diagnostician/hooks/useTranscription.ts` | Microphone recording + Groq Whisper STT |
| `useAISettings` | Hook | Diagnostics | `diagnostician/hooks/useAISettings.ts` | AI model configuration from DB |
| `useStats` | Hook | Diagnostics | `diagnostician/hooks/useApi.ts` | Dashboard KPI stats |
| `useTodaySessions` | Hook | Diagnostics | `diagnostician/hooks/useApi.ts` | Today's appointments list |
| `useSessionsRange` | Hook | Diagnostics | `diagnostician/hooks/useApi.ts` | Appointments by date range |
| `useSchedule` | Hook | Diagnostics | `diagnostician/hooks/useApi.ts` | Weekly schedule with slots |
| `useSessionDetail` | Hook | Diagnostics | `diagnostician/hooks/useApi.ts` | Full session detail (client + enrichment + AI) |
| `useQuizState` | Hook | Quiz | `quiz/hooks/useQuizState.ts` | Multi-step quiz state with localStorage |
| `useCountdown` | Hook | Quiz | `quiz/hooks/useCountdown.ts` | Countdown timer (default 72h) |
| `usePresentationState` | Hook | Presentations | `components/visuals/library/PresentationRenderer.tsx` | Simple slide index navigation |

---

## Auth Domain

### `useAuth()`
**File:** `context/AuthContext.tsx`
**Type:** Context hook
**Provider:** `<AuthProvider>`

Returns the full auth state and actions.

```ts
const { user, isAuthenticated, isLoading, login, logout, refreshAuth, hasPermission } = useAuth();
```

| Return | Type | Description |
|--------|------|-------------|
| `user` | `StaffUser \| null` | Current authenticated user with `permissions: string[]` |
| `isAuthenticated` | `boolean` | Whether user is logged in |
| `isLoading` | `boolean` | True during initial token validation |
| `login` | `(credentials: LoginCredentials) => Promise<void>` | Login with email/password |
| `logout` | `() => void` | Clear tokens and redirect |
| `refreshAuth` | `() => Promise<void>` | Refresh JWT token |
| `hasPermission` | `(permission: Permission) => boolean` | Check single permission |

**API endpoints:** `/api/auth/login`, `/api/auth/me`, `/api/auth/refresh`
**Storage keys:** `veda_auth_token`, `veda_refresh_token`, `veda_user`

---

### `useRequireAuth(redirectUrl?: string)`
**File:** `context/AuthContext.tsx`
**Type:** Guard hook

Redirects to `redirectUrl` (default `/login`) if user is not authenticated. Use at the top of protected pages.

```ts
export default function ProtectedPage() {
  useRequireAuth();           // redirect to /login
  useRequireAuth('/custom');  // redirect to /custom
  // ...
}
```

**Returns:** `{ isAuthenticated: boolean, isLoading: boolean }`

---

### `useRequirePermission(permission, redirectUrl?)`
**File:** `context/AuthContext.tsx`
**Type:** Guard hook

Same as `useRequireAuth` but also checks for a specific `Permission`.

```ts
useRequirePermission('manage_staff', '/');
```

**Returns:** `{ isAuthenticated: boolean, isLoading: boolean, hasPermission: boolean }`

---

### `useAuthToken()`
**File:** `context/AuthContext.tsx`
**Type:** Hook (simple)

Returns the raw JWT token string from localStorage. Returns `null` on server side.

```ts
const token = useAuthToken();
```

---

### `useAuthFetch()`
**File:** `context/AuthContext.tsx`
**Type:** Hook (factory)

Returns a stable `fetch` wrapper that injects the `Authorization: Bearer <token>` header. Reads token at call time (not at hook init). Automatically handles 401 by clearing auth and redirecting to `/login`.

```ts
const authFetch = useAuthFetch();
const res = await authFetch('/api/crm/clients');
```

**Returns:** `(url: string, options?: RequestInit) => Promise<Response>`

---

## Diagnostics Domain

### `useDiagnostic()`
**File:** `context/DiagnosticContext.tsx`
**Type:** Context hook
**Provider:** `<DiagnosticProvider>`
**Used on:** `/diagnostician/session/[sessionId]`, `/client/[sessionId]`

The central context for diagnostic sessions. Manages WebSocket (Socket.IO) connection, slide navigation, routing data, AI analysis, transit/dasha data, interactive natal chart, 9-slice system, and more.

```ts
const {
  state,             // DiagnosticState (full state object)
  session,           // DiagnosticSession | null (convenience getter)
  loadSession,       // (sessionId, role) => Promise<void>
  setVisual,         // (visualId) => void  (emits WS)
  nextVisual,        // () => void
  prevVisual,        // () => void
  // ... 60+ methods and state values
} = useDiagnostic();
```

**Key state fields:**

| Field | Type | Description |
|-------|------|-------------|
| `state.isConnected` | `boolean` | WebSocket connection status |
| `state.currentVisual` | `VisualId` | Current slide index |
| `state.currentBlock` | `DiagnosticBlock` | Current phase block |
| `state.analysisResult` | `AnalysisResult \| null` | LLM analysis output |
| `state.transitData` | `TransitData \| null` | Current planetary transits |
| `state.dashaEnd` | `DashaEndData \| null` | Dasha period end date |
| `state.wheelResult` | `WheelResult \| null` | Fortune wheel result |
| `state.balanceWheelScores` | `Record<number, number> \| null` | 7-sphere balance scores |
| `state.presentationVersion` | `PresentationVersion` | `'v2' \| 'v3'` |
| `state.chartSlices` | `ChartSliceData[]` | 9-slice diagnostic data |
| `state.currentSlice` | `ChartSliceData \| null` | Active slice |
| `state.aiProfile` | `ClientAIProfile \| null` | AI-generated client profile |
| `state.slideHints` | `SlideHint[]` | Per-slide AI hints |
| `state.product` | `Product \| null` | Active product for offer |
| `state.selectedCase` | `CaseEntry \| null` | Selected success case |

**Key actions:**

| Action | Description | API/WS |
|--------|-------------|--------|
| `loadSession(id, role)` | Fetch session + connect WebSocket | `GET /api/diagnostic/:id` + WS |
| `setVisual(id)` | Navigate to slide | WS emit `change_visual` |
| `analyzeClientWords(words)` | LLM pain analysis | `POST /api/analyze` |
| `requestHint()` | Get AI hint for current context | `POST /api/llm/hint` |
| `fetchTransitData()` | Load planetary transits | `GET /api/transit` |
| `fetchDashaEnd()` | Load dasha period data | `GET /api/dasha` |
| `loadChartSlices()` | Generate 9-slice diagnostic | `POST /api/chart-interpretation/slices` |
| `sendChartInteraction(payload)` | Sync chart highlights to client | WS emit `chart_interaction` |
| `suggestCase()` | Auto-select matching case study | `GET /api/cases/suggest` |
| `setShowPaymentButton(v)` | Toggle payment button on client screen | WS emit `show_payment_button` |

---

### `useWebSocket(sessionId, options?)`
**File:** `hooks/diagnostic/useWebSocket.ts`
**Type:** Hook (legacy)
**Note:** This is a low-level WebSocket hook. The main diagnostic session uses Socket.IO via `DiagnosticContext` instead. This hook exists for potential standalone use.

```ts
const { isConnected, error, send, reconnect } = useWebSocket(sessionId, {
  onSlideChange: (slide) => {},
  onDataUpdate: (field, value) => {},
  onInteraction: (elementId, value) => {},
});
```

---

### `usePlanetImages(authFetch?)`
**File:** `hooks/usePlanetImages.ts`
**Type:** Hook

Loads planet PNG image URLs from the media library. Retries up to 3 times if initial fetch returns empty (handles auth token race condition).

```ts
const { planetImageUrls, isLoading } = usePlanetImages(authFetch);
// planetImageUrls: Record<string, string>  e.g. { "sun": "https://...", "moon": "https://..." }
```

**API endpoint:** `GET /api/media?tag=planet` (via `fetchPlanetImageUrls`)

---

### `useTranscription(options?)`
**File:** `diagnostician/hooks/useTranscription.ts`
**Type:** Hook

Real-time microphone transcription using Groq Whisper. Records audio in chunks, sends to API, accumulates transcript segments. Optionally saves to DB periodically.

```ts
const {
  isRecording,
  isProcessing,
  transcript,              // TranscriptSegment[]
  startRecording,          // () => Promise<void>
  stopRecording,           // () => void
  startRecordingFromElement, // (audioElement) => Promise<void>
  clearTranscript,         // () => void
  getFullTranscriptText,   // () => string
  saveTranscriptToDB,      // (segments) => Promise<void>
} = useTranscription({
  chunkDuration: 5,        // seconds per chunk
  language: 'ru',
  autoStart: false,
  bookingId: '123',        // for DB save
  saveIntervalSec: 30,
});
```

**API endpoint:** `POST /api/transcribe`
**DB save:** `PATCH /api/crm/appointments/:bookingId/transcript`

---

### `useAISettings()`
**File:** `diagnostician/hooks/useAISettings.ts`
**Type:** Hook (cached)

Loads AI configuration from the `presentation_settings` table. Uses module-level cache so multiple instances share data. Deduplicates parallel requests.

```ts
const { settings, isLoading, error, refetch, getSetting } = useAISettings();
const model = getSetting('llm_model', 'gemini-2.0-flash');
```

**API endpoint:** `GET /api/settings/ai`

---

### `useStats()`
**File:** `diagnostician/hooks/useApi.ts`
**Type:** Hook (data fetching)

Dashboard KPI statistics for the diagnostician.

```ts
const { data, loading, error, refetch } = useStats();
// data: Stats | null (today_total, today_sales, week_conversion, month_revenue, etc.)
```

**API endpoint:** `GET /api/analytics/kpi`

---

### `useTodaySessions()`
**File:** `diagnostician/hooks/useApi.ts`
**Type:** Hook (data fetching)

Today's diagnostic session list.

```ts
const { data, loading, error, refetch } = useTodaySessions();
// data: Session[] | null
```

**API endpoint:** `GET /api/crm/appointments/today`

---

### `useSessionsRange(dateFrom, dateTo)`
**File:** `diagnostician/hooks/useApi.ts`
**Type:** Hook (data fetching)

Appointments within a date range.

```ts
const { data, loading, error, refetch } = useSessionsRange('2026-02-01', '2026-02-28');
```

**API endpoint:** `GET /api/crm/appointments/range?start=...&end=...`

---

### `useSchedule(weekOffset?)`
**File:** `diagnostician/hooks/useApi.ts`
**Type:** Hook (data fetching)

Weekly schedule view with slots. Transforms raw appointments into day/slot structure.

```ts
const { days, loading, error, refetch } = useSchedule(0);
// days: ScheduleDay[] (7 items, each with date, day_name, is_today, slots[])
```

**API endpoint:** `GET /api/crm/appointments/range?start=...&end=...`

---

### `useSessionDetail(sessionId)`
**File:** `diagnostician/hooks/useApi.ts`
**Type:** Hook (data fetching)

Full session detail including client info, enrichment data, AI data, and messages.

```ts
const { data, loading, error } = useSessionDetail(sessionId);
// data: SessionDetail | null (client, session, enrichment, ai, messages)
```

**API endpoint:** `GET /api/admin/sessions/:id`

---

### `useAuraDiagnosticStore`
**File:** `stores/auraDiagnosticStore.ts`
**Type:** Zustand store

Manages the aura wheel visualization state (7 life zones scored 1-10).

```ts
const { scores, currentSlide, showAura, showChart, showLabels } = useAuraDiagnosticStore();
const { setScore, setScores, setCurrentSlide, setShowAura, setShowChart } = useAuraDiagnosticStore();
```

| State | Type | Description |
|-------|------|-------------|
| `scores` | `AuraScores` | 7 zones: purpose, karma, intuition, health, finance, relations, family (1-10) |
| `currentSlide` | `number` | Active slide index |
| `showAura` | `boolean` | Aura visualization visibility |
| `showChart` | `boolean` | Chart overlay visibility |
| `showLabels` | `boolean` | Label visibility |
| `headerText` | `string` | Dynamic header |
| `bottomContent` | `ReactNode \| null` | Dynamic bottom area |

---

## Sales Domain

### `useSalesSessionStore`
**File:** `stores/salesSessionStore.ts`
**Type:** Zustand store

Full state management for the sales call workstation. Handles call lifecycle, transcription, AI hints, AI chat, call timer, script navigation, product comparison, and notes.

```ts
const session = useSalesSessionStore((s) => s.currentSession);
const client = useSalesSessionStore((s) => s.currentClient);
const startSession = useSalesSessionStore((s) => s.startSession);
```

**State fields:**

| State | Type | Description |
|-------|------|-------------|
| `currentSession` | `SalesSession \| null` | Active sales session |
| `currentClient` | `SalesClientView \| null` | Client being called |
| `transcript` | `TranscriptChunk[]` | Call transcript chunks |
| `isTranscribing` | `boolean` | Recording active |
| `aiHints` | `AIHint[]` | AI-generated hints |
| `aiChatMessages` | `AIChatMessage[]` | AI chat history |
| `isAIChatLoading` | `boolean` | AI chat processing |
| `activeTab` | `WorkstationTab` | Active UI tab (`'script' \| 'transcript' \| ...`) |
| `scriptStep` | `number` | Current script phase (0-5) |
| `callTimer` | `number` | Call duration in seconds |
| `isCallTimerRunning` | `boolean` | Timer active |
| `comparedProductIds` | `number[]` | Products being compared (max 3) |
| `selectedTier` | `1 \| 2 \| 3 \| null` | Selected offer tier |

**Key actions:**

| Action | Signature | Description |
|--------|-----------|-------------|
| `startSession` | `(client, managerId, managerName) => void` | Initialize new sales session |
| `updateSessionStatus` | `(status) => void` | Change session status |
| `endSession` | `(outcome, productId?, dealAmount?) => void` | Finalize session |
| `setScriptStep` / `nextScriptStep` / `prevScriptStep` | `(step?) => void` | Script navigation |
| `tickTimer` / `startCallTimer` / `stopCallTimer` | `() => void` | Call timer control |
| `addTranscriptChunk` | `(chunk) => void` | Add transcript segment |
| `addAIHint` / `dismissHint` | `(hint) / (hintId) => void` | AI hint management |
| `addChatMessage` | `(message) => void` | AI chat message |
| `toggleCompareProduct` | `(productId) => void` | Add/remove product comparison |
| `setSelectedTier` | `(tier) => void` | Select offer tier |
| `resetAll` | `() => void` | Reset entire store |

---

## Management Domain

### `useManagementStore`
**File:** `stores/managementStore.ts`
**Type:** Zustand store

Complete PDCA management system state: units, metrics, sprints, tasks, daily facts, analytics, and What-If simulations.

```ts
const sprints = useManagementStore((s) => s.sprints);
const fetchSprints = useManagementStore((s) => s.fetchSprints);
```

**State fields:**

| State | Type | Description |
|-------|------|-------------|
| `units` | `ManagementUnit[]` | Organizational units |
| `metrics` | `ManagementMetric[]` | KPI metrics |
| `sprints` | `ManagementSprint[]` | Sprint list |
| `currentSprint` | `ManagementSprintDetail \| null` | Active sprint with targets |
| `tasks` | `ManagementTask[]` | Tasks in current view |
| `dailyFacts` | `ManagementDailyFact[]` | Daily metric values |
| `escalationAlerts` | `EscalationAlert[]` | Red-zone alerts |
| `overview` | `OverviewData \| null` | Dashboard overview |
| `totals` | `CompanyTotals \| null` | Company-wide totals |
| `executionDiscipline` | `ExecutionDisciplineResponse \| null` | Execution analytics |
| `personPerformance` | `PersonPerformanceResponse \| null` | Person-level analytics |
| `selectedSprintId` | `number \| null` | Currently selected sprint |
| `selectedUnitId` | `number \| null` | Currently selected unit |

**Key fetch actions (all return `Promise<void>`):**

| Action | API Endpoint |
|--------|-------------|
| `fetchUnits()` | `GET /api/management/units` |
| `fetchMetrics(unitId?)` | `GET /api/management/metrics` |
| `fetchSprints()` | `GET /api/management/sprints` |
| `fetchCurrentSprint()` | `GET /api/management/sprints/current` |
| `fetchSprintDetail(id)` | `GET /api/management/sprints/:id` |
| `fetchTasks(filters?)` | `GET /api/management/tasks` |
| `fetchDailyFacts(metricId, from, to)` | `GET /api/management/daily-facts` |
| `fetchOverview(sprintId?)` | `GET /api/management/analytics/overview` |
| `fetchGapDecomposition(sprintId, rootMetricId?)` | `GET /api/management/analytics/gap-decomposition` |
| `callWhatIf(metricId, delta, sprintId)` | `POST /api/management/metrics/what-if` |
| `exportSprintExcel(sprintId)` | `GET /api/management/export/sprint/:id` |

**Key mutation actions:**

| Action | API Endpoint |
|--------|-------------|
| `createSprint(data)` | `POST /api/management/sprints` |
| `activateSprint(id)` | `POST /api/management/sprints/:id/activate` |
| `closeSprint(id)` | `POST /api/management/sprints/:id/close` |
| `saveDailyFact(metricId, date, value)` | `POST /api/management/daily-facts` |
| `saveDailyFactBulk(facts)` | `POST /api/management/daily-facts/bulk` |
| `createTask(data)` | `POST /api/management/tasks` |
| `updateTask(id, data)` | `PUT /api/management/tasks/:id` |
| `deleteTask(id)` | `DELETE /api/management/tasks/:id` |

---

### `useAI()`
**File:** `components/admin/management/AI/AIProvider.tsx`
**Type:** Context hook
**Provider:** `<AIProvider>`
**Used on:** Management pages (`/admin/management/`)

AI insights and chat panel for the PDCA management module. Loads insights on mount and refreshes every 5 minutes.

```ts
const { chatOpen, setChatOpen, insights, unreadCount, markRead, markAllRead, currentSprintId, setCurrentSprintId } = useAI();
```

| Return | Type | Description |
|--------|------|-------------|
| `chatOpen` | `boolean` | AI chat panel visibility |
| `insights` | `AIInsight[]` | AI-generated management insights |
| `unreadCount` | `number` | Count of unread insights |
| `markRead` | `(id: string) => void` | Mark single insight as read |
| `markAllRead` | `() => void` | Mark all insights as read |
| `currentSprintId` | `number \| null` | Sprint context for AI queries |

**API endpoint:** `GET /api/management/ai/insights`

---

## Presentations Domain

### `useSlideStyles()`
**File:** `context/SlideStyleContext.tsx`
**Type:** Context hook (safe -- returns defaults if used outside provider)
**Provider:** `<SlideStyleProvider presentationId?>`

Dynamic slide styling system. Fetches merged styles (global defaults + per-presentation overrides) and provides CSS custom properties.

```ts
const { styles, cssVars, updateGlobal, updatePresentation } = useSlideStyles();
// Apply: <div style={cssVars}> ... </div>
```

| Return | Type | Description |
|--------|------|-------------|
| `styles` | `SlideStyles \| null` | Typography, colors, spacing, decoration |
| `cssVars` | `React.CSSProperties` | CSS custom properties (e.g., `--slide-title-size`) |
| `updateGlobal` | `(styles: SlideStyles) => Promise<void>` | Save global styles (debounced 800ms) |
| `updatePresentation` | `(presId, overrides) => Promise<void>` | Save per-presentation overrides (debounced 800ms) |

**API endpoints:** `GET /api/slide-styles/merged`, `PUT /api/slide-styles/global`, `PUT /api/slide-styles/presentation/:id`

**CSS variables exposed:**
`--slide-title-size`, `--slide-title-weight`, `--slide-title-color`, `--slide-title-lh`,
`--slide-body-size`, `--slide-body-weight`, `--slide-body-color`, `--slide-body-lh`,
`--slide-meta-size`, `--slide-meta-weight`, `--slide-meta-color`, `--slide-meta-lh`,
`--slide-bg`, `--slide-accent`, `--slide-border`, `--slide-surface-alt`,
`--slide-padding`, `--slide-radius`

---

### `usePresentationSync(presentationId, onScriptUpdated)`
**File:** `hooks/usePresentationSync.ts`
**Type:** Hook

Real-time script synchronization via WebSocket (Socket.IO). Used by the presentation editor to broadcast script changes and the session page to receive them.

```ts
const { emitScriptUpdate } = usePresentationSync(presentationId, (slideOrder, script, checklist, timeLimit) => {
  // Handle incoming script update from another user
});

// Broadcast own change:
emitScriptUpdate(slideOrder, scriptText, checklistItems, timeLimitSec);
```

**WebSocket events:** `join_presentation`, `leave_presentation`, `script_updated`

---

### `usePresentationState(initialSlide?)`
**File:** `components/visuals/library/PresentationRenderer.tsx`
**Type:** Hook (simple)

Minimal slide index navigation. Used by `PresentationRenderer` for client-facing slide decks.

```ts
const { currentSlide, next, prev, goTo, setCurrentSlide } = usePresentationState(0);
```

---

## UI Domain

### `useSidebar()`
**File:** `context/SidebarContext.tsx`
**Type:** Context hook
**Provider:** `<SidebarProvider>`

Manages sidebar collapsed state across the admin layout.

```ts
const { isCollapsed, setIsCollapsed } = useSidebar();
```

---

## Quiz Domain

### `useQuizState()`
**File:** `quiz/hooks/useQuizState.ts`
**Type:** Hook (with localStorage persistence)

Multi-step quiz state management. Auto-saves to localStorage on every change and restores on mount.

```ts
const {
  state,           // QuizState (all quiz fields)
  isLoaded,        // boolean (localStorage loaded)
  progress,        // number (0-100 percentage)
  updateField,     // <K extends keyof QuizState>(field: K, value: QuizState[K]) => void
  updateFields,    // (updates: Partial<QuizState>) => void
  nextStep,        // () => void
  prevStep,        // () => void
  goToStep,        // (step: number) => void
  reset,           // () => void (clears localStorage)
} = useQuizState();
```

**Storage key:** `veda-quiz-state`

---

### `useCountdown(durationHours?)`
**File:** `quiz/hooks/useCountdown.ts`
**Type:** Hook (with localStorage persistence)

Countdown timer that persists across page reloads. Starts on first visit, ticks every second. Default duration: 72 hours.

```ts
const { days, hours, minutes, seconds, isExpired, totalSeconds, formatted, isLoaded, reset } = useCountdown(72);
// formatted: "2д 14ч 33м 12с" or "33м 12с"
```

**Storage key:** `veda-quiz-countdown-start`

---

## Patterns & Conventions

### 1. Context vs Zustand Decision

| Use Context when... | Use Zustand when... |
|---------------------|---------------------|
| State has complex side effects (WebSocket, timers) | State is a flat data store |
| Provider scoping matters (per-session) | Global singleton access needed |
| State ties to component lifecycle | State persists across navigations |
| Few consumers, deep nesting | Many consumers, cross-cutting |

**Current split:**
- **Context:** Auth, Diagnostics, SlideStyles, Sidebar, AI (management)
- **Zustand:** Sales Session, Management, Aura Diagnostic

### 2. Auth Pattern in Pages

```tsx
'use client';
import AdminLayout from '@/app/components/admin/AdminLayout';
import { useRequireAuth, useAuth } from '@/app/context/AuthContext';

export default function SomePage() {
  useRequireAuth();                    // redirect guard
  const { user } = useAuth();         // get user data
  if (!user?.permissions.includes('some_perm')) return null;

  return <AdminLayout>{/* ... */}</AdminLayout>;
}
```

### 3. Data Fetching Pattern (Diagnostician Hooks)

The `diagnostician/hooks/useApi.ts` file exports a generic `useFetch<T>` pattern (internal) used by all domain hooks:

```ts
// Pattern: hook calls useFetch which manages loading/error/data + provides refetch
export function useStats() {
  return useFetch<Stats>('/api/analytics/kpi');
}
```

All return `{ data: T | null, loading: boolean, error: string | null, refetch: () => Promise<void> }`.

### 4. Zustand Selector Pattern

Always use selectors to avoid unnecessary re-renders:

```ts
// Good: only re-renders when transcript changes
const transcript = useSalesSessionStore((s) => s.transcript);

// Bad: re-renders on any state change
const store = useSalesSessionStore();
```

### 5. Auth in Zustand Stores

Zustand stores read the JWT token directly from localStorage (since they live outside React tree):

```ts
const token = typeof window !== 'undefined' ? localStorage.getItem('veda_auth_token') : null;
```

Context hooks use `useAuthFetch()` from `AuthContext` instead.

### 6. WebSocket Convention

- Main diagnostic session uses **Socket.IO** via `DiagnosticContext` (path: `/ws/diagnostic`)
- Presentation sync uses **Socket.IO** via `usePresentationSync` (same path, different room)
- Legacy `useWebSocket` uses native **WebSocket** API (not Socket.IO)

### 7. Storage Keys Reference

| Key | Used by | Purpose |
|-----|---------|---------|
| `veda_auth_token` | AuthContext, Zustand stores | JWT access token |
| `veda_refresh_token` | AuthContext | JWT refresh token |
| `veda_user` | AuthContext | Cached user object |
| `veda-quiz-state` | useQuizState | Quiz progress |
| `veda-quiz-countdown-start` | useCountdown | Countdown start timestamp |
| `chart-slices-{sessionId}` | DiagnosticContext | Cached 9-slice data |

### 8. Module-Level Caching

`useAISettings` uses module-level variables for caching:
```ts
let cachedSettings: AISettings | null = null;
let cachePromise: Promise<AISettings> | null = null;
```
This means all hook instances share one cache and parallel requests are deduplicated. Call `refetch()` to invalidate.
