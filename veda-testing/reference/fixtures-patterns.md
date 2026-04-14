# Фикстуры и паттерны тестирования

## E2E (Playwright) — veda-presentation

### Auth Fixtures (`tests/e2e/fixtures/auth.fixture.ts`)

3 стратегии авторизации:

#### 1. `loginViaUI(page, email?, password?)`
- Полный логин через форму
- Вводит credentials в `#email` и `#password`
- Кликает `button[type="submit"]`

#### 2. `loginViaMock(page)` — РЕКОМЕНДУЕТСЯ
- Быстрая мок-авторизация без формы
- Перехватывает `**/api/auth/me` и `**/api/auth/login`
- Инжектит токены + user data напрямую в localStorage
- Дефолтные credentials: `test@myveda.ru` / `test123`

#### 3. `authenticatedTest` — расширение test
- Предварительная авторизация для всех тестов
- Сейчас не используется, но готов к применению

### Mock Data (`tests/e2e/fixtures/mock-data.ts`)

```typescript
MOCK_USER = {
  id: 'test-user-001',
  email: 'test@myveda.ru',
  name: 'Тест Диагност',
  role: 'diagnostician',
  permissions: ['diagnostic_sessions', 'clients_view', 'clients_edit', 'appointments_view', 'deals_view'],
  isActive: true,
}

MOCK_CLIENT = {
  id: 'client-test-001',
  name: 'Мария Тестова',
  birthDate: '1986-05-14',
  birthTime: '14:30',
  birthCity: 'Москва',
  anketaMessage: 'Устала жить не своей жизнью...',
  segment: 'realization',
  age: 39,
}

MOCK_PLANETS = {
  sun: { house: 10, sign: 'Овен', degree: 23.5, isRetrograde: false, isExalted: true, isDebilitated: false },
  moon: { house: 4, sign: 'Весы', degree: 12.3, ... },
  // ... 7 more planets (mars, mercury, jupiter, venus, saturn, rahu, ketu)
}

MOCK_SESSION = {
  id: 'session-e2e-001',
  client: MOCK_CLIENT,
  chart: { chartId: 999999, planets: MOCK_PLANETS, ... },
}

MOCK_ANALYSIS = {
  painSphere: 'money',
  blockedPlanet: 'Сатурн',
  resourcePlanet: 'Юпитер',
}
```

### Паттерн перехвата API (page.route)

```typescript
await page.route('**/api/endpoint', (route) =>
  route.fulfill({
    status: 200,
    contentType: 'application/json',
    body: JSON.stringify(mockData),
  })
);
```

## Unit/Integration (Vitest) — vedalab

### Паттерн tRPC createCaller

```typescript
function createAuthContext(): { ctx: TrpcContext; clearedCookies: CookieCall[] } {
  const clearedCookies: CookieCall[] = [];
  return {
    ctx: {
      setCookie: () => {},
      clearCookie: (name, options) => { clearedCookies.push({ name, options }); },
      sessionData: { userId: 'test-user', email: 'test@test.com' },
    },
    clearedCookies,
  };
}

it("does something", async () => {
  const { ctx, clearedCookies } = createAuthContext();
  const caller = appRouter.createCaller(ctx);
  const result = await caller.auth.logout();
  expect(result).toEqual({ success: true });
});
```

### Паттерн vi.mock для DB

```typescript
vi.mock('../db/queries', () => ({
  getFiles: vi.fn().mockResolvedValue([{ id: 1, name: 'test.txt' }]),
  createFile: vi.fn().mockResolvedValue({ id: 2, name: 'new.txt' }),
}));
```

## Demo Data (OKK)

### Файл: `app/lib/okk-demo-data.ts`

Генераторы реалистичных демо-данных для OKK:
- `generateDemoResults(count)` — генерирует OKK-результаты
- `generateDemoAnalytics()` — генерирует аналитику
- 2 шаблона: Diagnost (27 критериев, binary scoring) + Manager (10 критериев, fractional scoring)
- 8 имён сотрудников, 8 номеров телефонов
- Качество: good/medium/bad (60/20/20 распределение)

## Backend (veda-backend) — ПОКА НЕТ

Рекомендуемая структура:

```
tests/
├── conftest.py              # pytest fixtures
├── fixtures/
│   ├── models.py            # Mock ORM
│   ├── auth.py              # Auth helpers
│   └── data.py              # Test data factories
├── api/
│   ├── test_auth.py
│   └── test_clients.py
└── services/
    └── test_astro.py
```

### Рекомендуемый conftest.py

```python
import pytest
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from api.app import app

@pytest.fixture
async def db():
    engine = create_async_engine("postgresql+asyncpg://test_user:test@localhost/veda_crm_test")
    async with AsyncSession(engine) as session:
        yield session
        await session.rollback()

@pytest.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac

@pytest.fixture
def auth_headers():
    return {"Authorization": "Bearer test-token-diagnostician"}
```

## Ключевые паттерны

| Паттерн | Где используется | Пример |
|---------|-----------------|--------|
| page.route() | E2E Playwright | Перехват API без бэкенда |
| loginViaMock() | E2E auth | Быстрая авторизация |
| tRPC createCaller | Vedalab Vitest | Вызов серверных функций напрямую |
| vi.mock() | Vedalab Vitest | Мок DB-запросов |
| generateDemo*() | OKK frontend | Реалистичные демо-данные |
