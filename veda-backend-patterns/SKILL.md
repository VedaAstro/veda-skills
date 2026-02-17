---
name: veda-backend-patterns
description: Паттерны и ловушки FastAPI бэкенда Veda. Enum gotchas, порядок роутов, SQLAlchemy async, Alembic миграции, BFF-паттерн. Используй при написании или отладке бэкенд-кода.
---

# Паттерны бэкенда Veda

## Когда использовать

- Создание нового эндпоинта (backend или BFF)
- Работа с моделями и Enum'ами
- Alembic миграции
- Отладка багов в бэкенде
- Создание нового роутера

## Топ-3 ловушки (КРИТИЧНО)

### 1. Enum `.value` в SQLAlchemy

```python
# НЕПРАВИЛЬНО -- сравнение с объектом Enum, не найдёт ничего
query = select(Deal).where(Deal.status == DealStatus.PAYMENT)

# ПРАВИЛЬНО -- сравнение со строковым значением
query = select(Deal).where(Deal.status == DealStatus.PAYMENT.value)
```

**Правило:** В SQLAlchemy WHERE-условиях ВСЕГДА `.value`

### 2. Порядок роутов: статические ПЕРЕД динамическими

```python
# ПРАВИЛЬНО
router.get("/diagnosticians")   # статический -- первый
router.get("/{user_id}")        # динамический -- второй

# НЕПРАВИЛЬНО -- /diagnosticians никогда не сработает
router.get("/{user_id}")
router.get("/diagnosticians")
```

### 3. StaffRole.DIAGNOSTIC_MANAGER.value

```python
# Значение enum'а -- "diagnostician", НЕ "diagnostic_manager"!
StaffRole.DIAGNOSTIC_MANAGER.value == "diagnostician"  # True
```

## Все Enum'ы (cheatsheet)

| Enum | Значения |
|------|----------|
| `StaffRole` | diagnostician, department_head, tech_admin, super_admin |
| `ClientStatus` | new, qualified, scheduled, diagnostic_done, thinking, purchased, rejected |
| `DealStatus` | thinking, followup, payment, completed, rejected |
| `PaymentStatus` | pending, partial, paid, refunded |
| `AppointmentResult` | sale, thinking, rejected, no_show, followup |
| `TaskType` | call, followup, documentation, research, analysis, custom |
| `TaskStatus` | pending, in_progress, completed, skipped |
| `GoalType` | conversion, revenue, session_count, average_check |
| `GoalPeriod` | daily, weekly, monthly, quarterly |

## Шаблон нового роутера (Backend)

```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from db.database import get_db
from services.auth import get_current_user
from db.models import StaffUser

router = APIRouter(prefix="/api/your-entity", tags=["your-entity"])

@router.get("/")
async def list_entities(
    db: AsyncSession = Depends(get_db),
    current_user: StaffUser = Depends(get_current_user)
):
    result = await db.execute(select(YourModel).order_by(YourModel.created_at.desc()))
    return result.scalars().all()

@router.get("/{entity_id}")
async def get_entity(
    entity_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: StaffUser = Depends(get_current_user)
):
    result = await db.execute(select(YourModel).where(YourModel.id == entity_id))
    entity = result.scalar_one_or_none()
    if not entity:
        raise HTTPException(status_code=404, detail="Not found")
    return entity
```

## Шаблон BFF-роута (Next.js → FastAPI)

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { getAuthUser, getAuthHeaders, unauthorizedResponse } from '@/app/lib/auth';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8000';

export async function GET(request: NextRequest) {
  const user = await getAuthUser(request);
  if (!user) return unauthorizedResponse();

  const res = await fetch(`${BACKEND_URL}/api/your-endpoint`, {
    headers: getAuthHeaders(request),
    cache: 'no-store',  // ОБЯЗАТЕЛЬНО для CRM-данных
  });
  return NextResponse.json(await res.json(), { status: res.status });
}
```

## Sales Session End Logic

При завершении сессии (`POST /sales/sessions/{id}/end`):

| outcome | Что создаётся | Детали |
|---------|---------------|--------|
| `sale` | Deal | status=payment |
| `thinking` | Task | type=followup, due через 2 дня |
| `callback` | Task | type=call, due через 1 день |
| `rejected` | -- | Обновляет client status, логирует interaction |

## Модели-синонимы

| В коде | Что это по-человечески |
|--------|----------------------|
| `DiagnosticProfile` | Клиент (Client) |
| `DiagnosticBooking` | Запись (Appointment) |
| `DiagnosticSlot` | Слот расписания |

## OKK Snapshot-паттерн

При сохранении OKK-результата, полная конфигурация шаблона замораживается в поле `template_snapshot`. Это гарантирует историческую целостность -- даже если шаблон позже изменится, оценка привязана к той версии, по которой проводилась.

## Alembic миграции

```bash
# Создать миграцию
alembic revision --autogenerate -m "description"

# Применить
alembic upgrade head

# Проверить текущую версию
alembic current
```

## Reference-файлы

- `reference/models-map.md` -- 47 моделей, группировка, связи между ними
