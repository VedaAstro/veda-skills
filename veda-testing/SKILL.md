---
name: veda-testing
description: Тестирование проектов Veda -- pytest (бэкенд), Vitest (фронтенд), Playwright (E2E). Стратегия, фикстуры, моки. Используй при написании тестов или настройке тестовой инфраструктуры.
---

# Тестирование Veda

## Когда использовать

- Написание unit/integration тестов для нового кода
- Настройка тестовой инфраструктуры (pytest, Vitest, Playwright)
- Проверка существующих тестов перед деплоем
- Создание фикстур и моков для тестов
- Добавление тестов при исполнении спеки (обязательный этап!)

## Текущее состояние (обновлять!)

| Проект | Unit | Integration | E2E | CI/CD |
|--------|:---:|:---:|:---:|:---:|
| veda-presentation | -- | -- | Playwright (2 спеки) | -- |
| veda-backend | -- | 1 скрипт (PDCA) | -- | -- |
| veda-astro-core | -- | -- | -- | -- (pytest настроен) |

## Ключевые правила

### Что тестировать (приоритеты)

```
КРИТИЧНО (всегда тестировать):
  - Auth: логин, refresh, валидация токена, проверка ролей
  - Денежные операции: оплаты, сделки, статусы
  - AI pipeline: промпты, парсинг ответов, fallback
  - CRUD ключевых сущностей: клиенты, записи, сделки

ВАЖНО (тестировать при изменении):
  - BFF routes: прокси, ошибки, авторизация
  - Resolvers (v2): маппинг данных -> props слайдов
  - WebSocket события: синхронизация

ЖЕЛАТЕЛЬНО (если есть время):
  - UI компоненты: рендер, состояния
  - Утилиты: форматирование, парсинг
```

### Backend (pytest + pytest-asyncio)

```bash
# Установка
cd platform/veda-backend
pip install pytest pytest-asyncio pytest-cov httpx

# Запуск
pytest tests/ -v
pytest tests/ --cov=api --cov-report=html
```

**Структура тестов:**
```
veda-backend/tests/
├── conftest.py          # DB fixtures, auth mocks
├── test_auth.py         # Login, token, permissions
├── test_clients.py      # CRUD diagnostic_profiles
├── test_appointments.py # Booking lifecycle
├── test_deals.py        # Sales pipeline
├── test_sales.py        # Sales sessions
├── test_okk.py          # OKK templates & results
├── test_management.py   # PDCA cycle
└── test_analytics.py    # Dashboard endpoints
```

**Паттерн conftest.py:**
```python
import pytest
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from api.app import app

@pytest.fixture
async def db():
    """Test DB session with rollback"""
    engine = create_async_engine("postgresql+asyncpg://test_user:test@localhost/veda_crm_test")
    async with AsyncSession(engine) as session:
        yield session
        await session.rollback()

@pytest.fixture
async def client():
    """Async HTTP client for API tests"""
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac

@pytest.fixture
def auth_headers():
    """Auth headers for authenticated requests"""
    return {"Authorization": "Bearer test-token-diagnostician"}
```

**Паттерн API-теста:**
```python
@pytest.mark.asyncio
async def test_create_client(client, auth_headers):
    response = await client.post("/api/clients", headers=auth_headers, json={
        "name": "Test Client",
        "phone": "+79001234567",
    })
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Test Client"
```

### Frontend (Vitest)

```bash
# Установка
cd platform/veda-presentation
npm install -D vitest @testing-library/react @testing-library/jest-dom jsdom

# Запуск
npx vitest run
npx vitest --coverage
```

**vitest.config.ts:**
```typescript
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./tests/setup.ts'],
    include: ['**/*.test.{ts,tsx}'],
  },
  resolve: {
    alias: { '@': path.resolve(__dirname, './app') },
  },
});
```

### E2E (Playwright) -- УЖЕ НАСТРОЕН

```bash
npx playwright test                    # Все тесты
npx playwright test --headed           # С браузером
npx playwright test --ui               # UI-режим
npx playwright show-report             # Отчёт
```

**Существующие фикстуры:** `tests/e2e/fixtures/`
- `auth.fixture.ts` -- loginViaUI(), loginViaMock(), authenticatedTest
- `mock-data.ts` -- MOCK_USER, MOCK_CLIENT, MOCK_PLANETS, MOCK_SESSION

## Быстрый маршрут

1. Определи что тестируешь (бэкенд API / фронтенд компонент / E2E)
2. Проверь есть ли уже conftest.py / setup.ts — используй существующие фикстуры
3. Напиши тест по паттерну выше
4. Запусти: `pytest -v` / `npx vitest run` / `npx playwright test`
5. Проверь coverage: `--cov` / `--coverage`

## Reference-файлы

| Файл | Когда открывать |
|------|----------------|
| `reference/testing-report.md` | Полный отчёт по текущей тестовой инфраструктуре |
| `reference/fixtures-patterns.md` | Шаблоны фикстур и моков |
