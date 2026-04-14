# Auth System Reference

> Source files:
> - `app/context/AuthContext.tsx` -- client-side state, hooks
> - `app/lib/auth.ts` -- server-side helpers for BFF routes
> - `app/api/auth/` -- BFF proxy routes (login, refresh, me, register, change-password)
> - `app/types/index.ts` -- StaffUser, Permission, StaffRole, AuthResponse

---

## 1. Overview

The platform uses **JWT + BFF (Backend-for-Frontend)** auth pattern:

```
Browser (localStorage tokens)
    |
    v
Next.js BFF routes (/api/auth/*)     <-- proxy layer, no business logic
    |
    v
FastAPI backend (BACKEND_URL)         <-- issues/validates JWTs
```

- **Access token** -- short-lived JWT, sent as `Authorization: Bearer <token>`
- **Refresh token** -- long-lived, used to obtain new access token
- **User data** -- cached in localStorage, refreshed on mount via `/api/auth/me`
- All BFF auth routes live under `app/api/auth/` and simply proxy to `BACKEND_URL/api/auth/`

---

## 2. Storage Keys

Defined in `AuthContext.tsx`:

```typescript
const TOKEN_KEY = 'veda_auth_token';
const REFRESH_TOKEN_KEY = 'veda_refresh_token';
const USER_KEY = 'veda_user';  // JSON-serialized StaffUser
```

All three are stored in `localStorage`. Cleared on logout or when token validation fails.

---

## 3. Auth Flow

### Login

```
1. User submits email + password
2. AuthContext.login() -> POST /api/auth/login (BFF)
3. BFF proxies to BACKEND_URL/api/auth/login
4. Backend returns { token, refreshToken, user, expiresAt }
5. AuthContext saves to localStorage (all 3 keys)
6. Dispatches LOGIN_SUCCESS -> isAuthenticated = true
```

### Page Load (Restore Session)

```
1. AuthProvider mounts -> useEffect reads localStorage
2. If token + user exist:
   a. GET /api/auth/me with stored token
   b. If 200: update user in localStorage (permissions may have changed), LOGIN_SUCCESS
   c. If 401 + refresh token exists: attempt refresh (step below)
   d. Otherwise: clearStorage, LOGOUT
3. If no stored token: SET_LOADING false (unauthenticated)
```

### Token Refresh

```
1. POST /api/auth/refresh with { refreshToken }
2. BFF proxies to backend
3. If success: new access token saved to localStorage, LOGIN_SUCCESS
4. If user not in localStorage: fetch /api/auth/me with new token
5. If refresh fails: clearStorage, LOGOUT
```

### Authenticated Requests (Client-Side)

```
1. Component calls useAuthFetch() hook
2. Returns a stable fetch wrapper that:
   a. Reads token from localStorage at call time (not at hook init)
   b. Sets Authorization: Bearer <token> header
   c. If response is 401: clears all 3 storage keys, redirects to /login
```

### Logout

```
1. AuthContext.logout()
2. Removes TOKEN_KEY, REFRESH_TOKEN_KEY, USER_KEY from localStorage
3. Dispatches LOGOUT -> resets state to initialState with isLoading: false
```

---

## 4. Client-Side Hooks

All exported from `app/context/AuthContext.tsx`.

### useAuth()

```typescript
function useAuth(): AuthContextType
```

Returns the full auth context. Must be used inside `<AuthProvider>`. Throws if used outside.

```typescript
interface AuthContextType {
  user: StaffUser | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (credentials: LoginCredentials) => Promise<void>;
  logout: () => void;
  refreshAuth: () => Promise<void>;
  hasPermission: (permission: Permission) => boolean;
}
```

### useRequireAuth(redirectUrl?)

```typescript
function useRequireAuth(redirectUrl: string = '/login'): {
  isAuthenticated: boolean;
  isLoading: boolean;
}
```

Redirects to `redirectUrl` via `window.location.href` when not authenticated (after loading completes). Use at the top of any protected page.

### useRequirePermission(permission, redirectUrl?)

```typescript
function useRequirePermission(
  permission: Permission,
  redirectUrl: string = '/'
): {
  isAuthenticated: boolean;
  isLoading: boolean;
  hasPermission: boolean;
}
```

Redirects when authenticated but lacks the required permission. Does NOT redirect unauthenticated users (combine with `useRequireAuth` if needed).

### useAuthToken()

```typescript
function useAuthToken(): string | null
```

Returns the raw JWT token from localStorage. Returns `null` during SSR (`typeof window === 'undefined'`). Reads at call time.

### useAuthFetch()

```typescript
function useAuthFetch(): (url: string, options?: RequestInit) => Promise<Response>
```

Returns a stable `fetch` wrapper (empty deps = same reference across renders). Behavior:
- Reads token from localStorage **at call time** (not at hook init)
- Adds `Authorization: Bearer <token>` header
- On 401 response: clears all 3 storage keys, redirects to `/login`
- Returns the raw `Response` object

---

## 5. Server-Side Helpers (lib/auth.ts)

All exported from `app/lib/auth.ts`. Used inside BFF route handlers.

### extractToken(request)

```typescript
function extractToken(request: NextRequest): string | null
```

Extracts JWT from `Authorization: Bearer <token>` header. Returns `null` if missing or malformed.

### validateToken(token)

```typescript
async function validateToken(token: string): Promise<StaffUser | null>
```

Validates token by calling `BACKEND_URL/api/auth/validate` with `POST` + `Authorization: Bearer <token>`. Returns the `StaffUser` or `null` on failure.

### getAuthUser(request)

```typescript
async function getAuthUser(request: NextRequest): Promise<StaffUser | null>
```

Combines `extractToken` + `validateToken`. The primary way to authenticate a BFF request. Returns `StaffUser` or `null`.

### hasPermission(user, permission)

```typescript
function hasPermission(user: StaffUser, permission: Permission): boolean
```

Checks if `user.permissions` array includes the given permission.

### hasAnyPermission(user, permissions)

```typescript
function hasAnyPermission(user: StaffUser, permissions: Permission[]): boolean
```

Returns `true` if user has **at least one** of the listed permissions.

### hasAllPermissions(user, permissions)

```typescript
function hasAllPermissions(user: StaffUser, permissions: Permission[]): boolean
```

Returns `true` if user has **all** of the listed permissions.

### unauthorizedResponse(message?)

```typescript
function unauthorizedResponse(message: string = 'Unauthorized'): NextResponse
```

Returns `NextResponse.json({ error, code: 'UNAUTHORIZED' }, { status: 401 })`.

### forbiddenResponse(message?)

```typescript
function forbiddenResponse(message: string = 'Forbidden'): NextResponse
```

Returns `NextResponse.json({ error, code: 'FORBIDDEN' }, { status: 403 })`.

### withAuth(handler)

```typescript
function withAuth<T>(
  handler: (request: NextRequest, user: StaffUser, context?: T) => Promise<NextResponse>
): (request: NextRequest, context?: T) => Promise<NextResponse>
```

Middleware wrapper. Calls `getAuthUser`, returns 401 if no user, returns 403 if `user.isActive === false`, then calls `handler` with the validated user.

### withPermission(permission, handler)

```typescript
function withPermission<T>(
  permission: Permission,
  handler: (request: NextRequest, user: StaffUser, context?: T) => Promise<NextResponse>
): (request: NextRequest, context?: T) => Promise<NextResponse>
```

Wraps `withAuth` + permission check. Returns 403 if user lacks the permission.

### withAnyPermission(permissions, handler)

```typescript
function withAnyPermission<T>(
  permissions: Permission[],
  handler: (request: NextRequest, user: StaffUser, context?: T) => Promise<NextResponse>
): (request: NextRequest, context?: T) => Promise<NextResponse>
```

Wraps `withAuth` + checks at least one permission matches.

### getAuthHeaders(request)

```typescript
function getAuthHeaders(request: NextRequest): HeadersInit
```

Builds headers object for proxying to backend:
- Always includes `Content-Type: application/json`
- Forwards `Authorization` header if present
- Forwards `X-Telegram-Id` header if present
- Falls back to `X-API-Key` (from `BACKEND_API_KEY` env) when no auth header (backward compat)

### getDevAuthHeaders()

```typescript
function getDevAuthHeaders(): HeadersInit
```

Returns `{ Content-Type, X-API-Key }` using `BACKEND_API_KEY` env variable. For backward compatibility / dev mode only.

### createAuthenticatedFetch(request)

```typescript
function createAuthenticatedFetch(request: NextRequest): (url: string, options?: RequestInit) => Promise<Response>
```

Creates a pre-configured `fetch` function with auth headers extracted from the incoming request. Useful when a BFF route needs to make multiple backend calls:

```typescript
const authFetch = createAuthenticatedFetch(request);
const res1 = await authFetch(`${BACKEND_URL}/api/foo`);
const res2 = await authFetch(`${BACKEND_URL}/api/bar`);
```

### refreshAccessToken(refreshToken)

```typescript
async function refreshAccessToken(refreshToken: string): Promise<RefreshTokenResponse | null>

interface RefreshTokenResponse {
  token: string;
  expiresAt: string;
}
```

Server-side token refresh. Calls `BACKEND_URL/api/auth/refresh`.

---

## 6. BFF Auth Routes

All routes under `app/api/auth/`. They are thin proxies to `BACKEND_URL/api/auth/`.

### POST /api/auth/login

**Input:** `{ email: string, password: string }`
**Output:** `AuthResponse` -- `{ token, refreshToken, user, expiresAt }`
**Auth:** None (public)
**Validation:** Returns 400 if email or password missing.

### POST /api/auth/refresh

**Input:** `{ refreshToken: string }`
**Output:** `{ token: string, expiresAt: string }`
**Auth:** None (refresh token is the credential)
**Validation:** Returns 400 if refreshToken missing.

### GET /api/auth/me

**Input:** None (reads Authorization header)
**Output:** `{ user: StaffUser }` (or the user object directly)
**Auth:** Required (Bearer token)
**Flow:** Uses `extractToken` -> proxies to `BACKEND_URL/api/auth/me`.

### POST /api/auth/register

**Input:** `{ email, password, name, role, telegramId?, photoUrl? }`
**Output:** Newly created user (status 201)
**Auth:** Required (Bearer token)
**Permission:** `manage_staff`
**Validation:**
- email, password, name, role are required
- role must be one of: `diagnostician`, `department_head`, `tech_admin`
- Uses `getAuthUser` + `hasPermission` for auth checks

### POST /api/auth/change-password

**Input:** Body forwarded as-is (typically `{ currentPassword, newPassword }`)
**Output:** Success confirmation from backend
**Auth:** Required (Bearer token)
**Flow:** Uses `extractToken` -> proxies with token to backend.

---

## 7. Data Types

All defined in `app/types/index.ts`.

### StaffRole

```typescript
type StaffRole = 'diagnostician' | 'department_head' | 'tech_admin' | 'super_admin';
```

Russian labels:
| Role | Label |
|------|-------|
| `super_admin` | Супер-админ |
| `diagnostician` | Диагност |
| `department_head` | Руководитель отдела |
| `tech_admin` | Администратор |

### Permission

```typescript
type Permission =
  | 'view_own_metrics'
  | 'view_all_metrics'
  | 'edit_scripts'
  | 'set_goals'
  | 'manage_staff'
  | 'view_client_data'
  | 'edit_presentation_settings'
  | 'edit_presentations'
  | 'view_presentations'
  | 'manage_presentations'
  | 'manage_roles'
  | 'manage_products'
  | 'manage_templates'
  | 'manage_schedule'
  | 'manage_okk_templates'
  | 'view_okk_results'
  | 'evaluate_okk'
  | 'sales_workstation'
  | 'sales_teaser_send'
  | 'view_management'
  | 'edit_daily_facts'
  | 'manage_sprints'
  | 'manage_management_tasks'
  | 'manage_targets'
  | 'manage_metrics'
  | 'view_all_management';
```

### StaffUser

```typescript
interface StaffUser {
  id: number;
  uuid: string;
  telegramId?: number;
  email: string;
  name: string;
  photoUrl?: string;
  role: StaffRole;
  permissions: Permission[];
  isActive: boolean;
  createdAt: string;
  lastLoginAt?: string;
}
```

### LoginCredentials

```typescript
interface LoginCredentials {
  email: string;
  password: string;
}
```

### AuthResponse

```typescript
interface AuthResponse {
  token: string;
  refreshToken: string;
  user: StaffUser;
  expiresAt: string;
}
```

### AuthContextType

```typescript
interface AuthContextType {
  user: StaffUser | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (credentials: LoginCredentials) => Promise<void>;
  logout: () => void;
  refreshAuth: () => Promise<void>;
  hasPermission: (permission: Permission) => boolean;
}
```

---

## 8. Common BFF Route Pattern

Every BFF route that needs auth follows this pattern:

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { getAuthUser, getAuthHeaders, unauthorizedResponse } from '@/app/lib/auth';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8000';

export async function GET(request: NextRequest) {
  // 1. Authenticate
  const user = await getAuthUser(request);
  if (!user) return unauthorizedResponse();

  // 2. (Optional) Check permissions
  // if (!hasPermission(user, 'some_permission')) return forbiddenResponse();

  // 3. Proxy to backend with forwarded auth headers
  const res = await fetch(`${BACKEND_URL}/api/your-endpoint`, {
    headers: getAuthHeaders(request),
    cache: 'no-store',  // IMPORTANT: always no-store for CRM data
  });

  return NextResponse.json(await res.json(), { status: res.status });
}
```

For routes needing multiple backend calls, use `createAuthenticatedFetch`:

```typescript
export async function GET(request: NextRequest) {
  const user = await getAuthUser(request);
  if (!user) return unauthorizedResponse();

  const authFetch = createAuthenticatedFetch(request);
  const [clients, deals] = await Promise.all([
    authFetch(`${BACKEND_URL}/api/clients`).then(r => r.json()),
    authFetch(`${BACKEND_URL}/api/deals`).then(r => r.json()),
  ]);

  return NextResponse.json({ clients, deals });
}
```

Alternative: use `withAuth` / `withPermission` wrappers to avoid boilerplate:

```typescript
import { withPermission } from '@/app/lib/auth';

export const GET = withPermission('manage_staff', async (request, user) => {
  const res = await fetch(`${BACKEND_URL}/api/staff`, {
    headers: getAuthHeaders(request),
    cache: 'no-store',
  });
  return NextResponse.json(await res.json());
});
```

---

## 9. Role-Based Access Patterns

### Page-Level Protection (Client-Side)

Standard admin page pattern:

```typescript
'use client';
import AdminLayout from '@/app/components/admin/AdminLayout';
import { useRequireAuth, useAuth } from '@/app/context/AuthContext';

export default function SomePage() {
  // Redirect to /login if not authenticated
  useRequireAuth();
  const { user, hasPermission } = useAuth();

  // Guard: hide page if user lacks permission (shows nothing while redirecting)
  if (!user?.permissions.includes('manage_staff')) return null;

  return (
    <AdminLayout>
      {/* content */}
    </AdminLayout>
  );
}
```

Using `useRequirePermission` for auto-redirect:

```typescript
export default function OKKPage() {
  useRequireAuth();
  const { hasPermission } = useRequirePermission('manage_okk_templates', '/');

  if (!hasPermission) return null;

  return <AdminLayout>...</AdminLayout>;
}
```

### Conditional UI Elements

```typescript
const { user, hasPermission } = useAuth();

// Show button only for users with permission
{hasPermission('evaluate_okk') && (
  <button onClick={runEvaluation}>Run OKK</button>
)}

// Role-based rendering
{user?.role === 'super_admin' && (
  <DangerZone />
)}
```

### BFF Route-Level Protection (Server-Side)

Manual approach:

```typescript
const user = await getAuthUser(request);
if (!user) return unauthorizedResponse();
if (!hasPermission(user, 'manage_staff')) return forbiddenResponse();
```

Wrapper approach:

```typescript
export const POST = withPermission('manage_staff', async (request, user) => {
  // user is guaranteed to be authenticated + have manage_staff
});
```

Multiple permissions (any match):

```typescript
export const GET = withAnyPermission(
  ['view_management', 'view_all_management'],
  async (request, user) => { ... }
);
```

### Important Notes

- Permissions are stored as a flat string array on `StaffUser.permissions`
- The backend is the source of truth for permissions. On page load, `AuthContext` re-fetches user via `/api/auth/me` and updates localStorage with fresh permissions.
- `super_admin` is a role, not a blanket bypass. Permission checks still apply -- the backend simply assigns all permissions to super_admin users.
- The `register` route validates that the role is one of `diagnostician | department_head | tech_admin`. The `super_admin` role cannot be assigned through the UI registration flow.
