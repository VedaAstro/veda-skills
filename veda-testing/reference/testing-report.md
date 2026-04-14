# Testing Infrastructure Report

## Summary Table

| Project | Framework | Type | Files | Tests | Status |
|---------|-----------|------|-------|-------|--------|
| veda-presentation | Playwright | E2E | 4 (2 specs + 2 fixtures) | 9 | Ready |
| vedalab | Vitest | Unit/Integration | 3 | 17+ | Ready |
| veda-backend | pytest | (none) | 0 | 0 | Missing |
| veda-bot-v2 | pytest | Manual scripts | 2 | 2 scripts | Manual only |
| veda-astro-core | pytest | (none) | 0 | 0 | Config only |

---

## Frontend (veda-presentation)

### Playwright Config
- File: `platform/veda-presentation/playwright.config.ts` (47 lines)
- Base URL: `localhost:3001` (dev auto-starts)
- Production: `E2E_BASE_URL=https://sales.myveda.ru npx playwright test`
- Screenshot/Video: Only on first retry

### Test Files

**`tests/e2e/login.spec.ts`** (144 lines, 5 tests)
- "отображает форму логина"
- "показывает ошибку при неверных данных"
- "успешный логин перенаправляет на /diagnostician"
- "сохраняет токен в localStorage"
- "показывает спиннер при отправке формы"

**`tests/e2e/diagnostic-session.spec.ts`** (150 lines, 4 tests)
- "страница сессии загружается без ошибки"
- "отображает имя клиента"
- "страница не показывает ошибку загрузки"
- "неавторизованный пользователь перенаправляется на логин"

### Fixtures

**`tests/e2e/fixtures/auth.fixture.ts`** (95 lines)
- `loginViaUI(page, email?, password?)` — form submission
- `loginViaMock(page)` — fast mock (RECOMMENDED)
- `authenticatedTest` — extended test with pre-auth

**`tests/e2e/fixtures/mock-data.ts`** (90 lines)
- MOCK_USER, MOCK_CLIENT, MOCK_PLANETS, MOCK_SESSION, MOCK_ANALYSIS

### NPM Scripts
```
"test": "node scripts/smoke-test.mjs"
"test:e2e": "npx playwright test"
"test:e2e:ui": "npx playwright test --ui"
"test:e2e:headed": "npx playwright test --headed"
"test:e2e:report": "npx playwright show-report"
```

### Smoke Test
- File: `scripts/smoke-test.mjs` (~100 lines)
- Tests `normalizeBackendDetail()` error handler
- Run: `npm run smoke`

---

## vedalab (Vitest)

### Config
- File: `platform/vedalab/vitest.config.ts` (19 lines)
- Pattern: `server/**/*.test.ts` and `server/**/*.spec.ts`
- Environment: Node.js

### Test Files
- `server/auth.logout.test.ts` (62 lines, 1 test)
- `server/services/avatarProfile.test.ts` (102 lines, 8 tests)
- `server/vedalab.test.ts` (288 lines, 17+ tests) — full tRPC integration

---

## veda-backend (Missing!)

No test suite exists. 33 route folders in `api/routes/`.

### Recommended Structure
```
tests/
├── conftest.py
├── fixtures/
│   ├── models.py
│   ├── auth.py
│   └── data.py
├── api/
│   ├── test_auth.py
│   ├── test_clients.py
│   ├── test_sales.py
│   └── test_okk.py
├── services/
│   ├── test_astro.py
│   └── test_llm.py
└── db/
    └── test_models.py
```

---

## Reusable Patterns

### Page Route Interception (Playwright)
```typescript
await page.route('**/api/endpoint', (route) =>
  route.fulfill({
    status: 200,
    contentType: 'application/json',
    body: JSON.stringify(mockData),
  })
);
```

### tRPC Test Pattern (Vitest)
```typescript
function createAuthContext() {
  const clearedCookies = [];
  const ctx = { ... };
  return { ctx, clearedCookies };
}

it("does something", async () => {
  const { ctx } = createAuthContext();
  const caller = appRouter.createCaller(ctx);
  const result = await caller.someRoute();
  expect(result).toEqual(expected);
});
```
