---
name: veda-backend-patterns
description: Паттерны и ловушки FastAPI бэкенда Veda. Enum gotchas, порядок роутов, SQLAlchemy async, Alembic миграции, BFF-паттерн. Используй при написании или отладке бэкенд-кода.
---

# Паттерны бэкенда Veda

## Когда использовать

- Создание/отладка эндпоинтов (backend или BFF)
- Работа с моделями, Enum'ами, миграциями
- Создание нового роутера

## SSOT -- архитектурные законы

### 1. Enum для каждого конечного множества

Голые строки расползаются по файлам и ломаются без валидации.

```python
class BookingStatus(str, Enum):  # enums.py -- единственный источник правды
    PENDING = "pending"
    CONFIRMED = "confirmed"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"
    NO_SHOW = "no_show"

if booking.status == BookingStatus.COMPLETED.value: ...
```

Новое поле с конечными значениями = сначала Enum в enums.py, потом использование.

### 2. Service Layer для shared логики

Дублированная логика в разных endpoints дрейфует. Общий service в `api/services/<domain>.py`:

```python
class DiagnosticViewService:
    @staticmethod
    def enrich(booking, ...) -> dict:
        """Единственное место обогащения booking для API."""
        ...
# Все endpoints: enriched = DiagnosticViewService.enrich(booking, ...)
```

Перед inline-логикой в handler -- проверь `api/services/`. Логика в >1 месте = service.

### 3. Один формат ответа для одной сущности

Одна сущность из разных endpoints = одинаковый формат через общий serializer в service.

### Чеклист нового endpoint

1. Enum для конечных значений? Создать в enums.py
2. Service для домена? Использовать / создать если >1 endpoint
3. Serializer? Один to_dict через service
4. Hardcoded строки? Заменить на Enum.value

---

## Топ-3 ловушки

### 1. Enum `.value` в SQLAlchemy

SQLAlchemy сравнивает column с Python-объектом, а column хранит строку -- 0 результатов без ошибки.

```python
query = select(Deal).where(Deal.status == DealStatus.PAYMENT.value)  # всегда .value
```

### 2. Статические роуты ПЕРЕД динамическими

FastAPI проверяет по порядку -- `/{user_id}` поглотит `/diagnosticians`.

```python
router.get("/diagnosticians")   # статический -- первый
router.get("/{user_id}")        # динамический -- второй
```

### 3. StaffRole.DIAGNOSTIC_MANAGER.value == "diagnostician"

Имя enum'а обманчиво -- значение `"diagnostician"`, проверяй в cheatsheet ниже.

## Enum cheatsheet

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

## Шаблон роутера (Backend)

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
async def get_entity(entity_id: int, db: AsyncSession = Depends(get_db),
                     current_user: StaffUser = Depends(get_current_user)):
    result = await db.execute(select(YourModel).where(YourModel.id == entity_id))
    entity = result.scalar_one_or_none()
    if not entity:
        raise HTTPException(status_code=404, detail="Not found")
    return entity
```

## Шаблон BFF-роута (Next.js -> FastAPI)

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { getAuthUser, getAuthHeaders, unauthorizedResponse } from '@/app/lib/auth';
const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8000';

export async function GET(request: NextRequest) {
  const user = await getAuthUser(request);
  if (!user) return unauthorizedResponse();
  const res = await fetch(`${BACKEND_URL}/api/your-endpoint`, {
    headers: getAuthHeaders(request),
    cache: 'no-store',  // обязательно -- stale cache = неверные CRM-данные
  });
  return NextResponse.json(await res.json(), { status: res.status });
}
```

## Sales Session End (`POST /sales/sessions/{id}/end`)

| outcome | Создаётся | Детали |
|---------|-----------|--------|
| `sale` | Deal | status=payment |
| `thinking` | Task | type=followup, due +2 дня |
| `callback` | Task | type=call, due +1 день |
| `rejected` | -- | Обновляет client status, логирует interaction |

## Модели-синонимы

`DiagnosticProfile` = Клиент, `DiagnosticBooking` = Запись, `DiagnosticSlot` = Слот расписания.

## OKK Snapshot-паттерн

При сохранении OKK конфигурация шаблона замораживается в `template_snapshot` -- шаблон может измениться, а оценка привязана к версии на момент проведения.

## Performance

### Запросы к БД

```python
# select только нужные поля -- полный select тянет blob'ы и раздувает память
query = select(Message.id, Message.text, Message.ts).where(
    Message.room_id == room_id
).order_by(Message.ts.desc()).limit(50)
```

- **Пагинация всегда** -- без неё один запрос может вернуть 100K строк
- **`selectinload()`/`joinedload()`** для связей -- N+1 = N лишних запросов
- **Индексы** на поля в WHERE + ORDER BY; `EXPLAIN ANALYZE` для запросов >10/мин

```sql
CREATE INDEX idx_messages_room_ts ON messages(room_id, ts DESC);
CREATE INDEX idx_clients_status ON clients(status) WHERE deleted_at IS NULL;
```

### Кеширование (Redis cache-aside)

```python
cached = await redis.get(f"rooms:{user_id}")  # TTL 60s списки, 300s справочники
if cached: return json.loads(cached)
data = await fetch_from_db()
await redis.setex(f"rooms:{user_id}", 60, json.dumps(data, default=str))
```

### Response Time бюджеты

| Эндпоинт | Бюджет | При превышении |
|----------|--------|----------------|
| GET список | <200ms | Пагинация, select полей, индекс |
| GET объект | <50ms | Индекс по PK |
| POST создание | <300ms | BackgroundTasks для тяжёлого |
| Агрегации | <500ms | Materialized view / Redis |

Тяжёлые операции -- `BackgroundTasks`. Подробнее: `/perf` скилл.

## Alembic миграции

```bash
alembic revision --autogenerate -m "description"  # создать
alembic upgrade head                               # применить
alembic current                                    # текущая версия
```

## OpenRouter (OpenAI-совместимый LLM gateway)

Тот же OpenAI SDK, другой base_url -- экономия на LLM-вызовах.

```python
client = AsyncOpenAI(api_key=Config.OPENROUTER_API_KEY, base_url="https://openrouter.ai/api/v1")
response = await client.chat.completions.create(
    model="google/gemini-2.0-flash-001",
    messages=[{"role": "system", "content": prompt}, {"role": "user", "content": question}],
    temperature=0.3, max_tokens=2000
)
```

| Модель | In/Out $/1M | Когда |
|--------|-------------|-------|
| `google/gemini-2.0-flash-001` | $0.10/$0.40 | Default |
| `openai/gpt-4o-mini` | $0.15/$0.60 | Если нужен OpenAI |
| `openai/gpt-4o` | $2.50/$10.00 | Сложные задачи |

- **tiktoken:** для не-OpenAI моделей `get_encoding("cl100k_base")` -- `encoding_for_model` не знает чужих моделей
- **Embeddings** остаются на прямом OpenAI API -- OpenRouter их не поддерживает

## FK auto-create паттерн

При INSERT с FK на users -- сначала ensure user exists, иначе ForeignKeyViolation:

```python
user = db.query(User).filter(User.user_id == request.user_id).first()
if not user:
    user = User(user_id=request.user_id, username=f"User_{request.user_id}")
    db.add(user); db.commit()
progress = UserProgress(user_id=request.user_id, task_id=request.task_id, ...)
db.add(progress); db.commit()
```

## Reference-файлы

- `reference/models-map.md` -- 47 моделей, группировка, связи между ними
