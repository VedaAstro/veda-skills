---
name: veda-debugging
description: Систематический debugging через 4 фазы. Root cause BEFORE fix. Адаптирован из Superpowers (obra) под VEDA stack (FastAPI + Next.js + PM2 + Docker). Используй при любом баге, ошибке, unexpected behavior.
---

# Systematic Debugging — VEDA Edition

## Правило #1
**ВСЕГДА находи root cause ДО попытки фикса. Лечение симптомов = провал.**

Запрещено предлагать фиксы до завершения Phase 1.

## Phase 1: Root Cause Investigation

```
1. READ error message carefully (полностью, не первую строку)
2. REPRODUCE consistently (один и тот же путь к ошибке)
3. CHECK recent changes: git log --oneline -10, git diff
4. TRACE data flow backward через call stack
5. MULTI-COMPONENT: проверь каждый слой отдельно
```

### VEDA-specific checkpoints
| Слой | Что проверить |
|------|--------------|
| Frontend (Next.js) | Console errors, Network tab, BFF response shape |
| BFF (api routes) | `no-store` cache, JWT forwarding, response format {data,error,meta} |
| Backend (FastAPI) | pm2 logs, .env vars, Pydantic validation errors |
| Database | Alembic head vs current, enum `.value`, NULL constraints |
| Docker (AstroGuru) | Container status, port mapping, volume mounts |
| WebSocket | Connection state, message format, reconnect logic |

## Phase 2: Pattern Analysis

```
1. FIND working example (код который работает правильно)
2. COMPARE полностью — не только "похожие" строки
3. IDENTIFY ALL differences (не только очевидные)
4. CHECK dependencies (версии, imports, env vars)
```

## Phase 3: Hypothesis & Test

```
1. FORM одну чёткую гипотезу
2. PREDICT что произойдёт если гипотеза верна
3. TEST минимальным изменением (одна переменная)
4. VERIFY результат соответствует предсказанию
5. IF не совпало → новая гипотеза, НЕ "а давай ещё попробуем"
```

## Phase 4: Implementation

```
1. WRITE failing test first (если возможно)
2. IMPLEMENT single fix addressing ROOT CAUSE only
3. VERIFY fix works + no regression
4. npm run build / pytest (обязательно)
```

### Правило 3 попыток
**После 3 неудачных фиксов — СТОП.**
Не продолжай патчить. Вернись к Phase 1 и поставь под сомнение:
- Правильно ли я понимаю архитектуру?
- Может проблема в другом слое?
- Может нужно переделать approach целиком?

## Docker-специфичные паттерны

### Dependency version hell (реальный кейс)
```
Симптом: 500 Internal Server Error, "argument 'by_alias': 'NoneType' object cannot be converted to 'PyBool'"
Root cause: Dockerfile содержал `RUN pip install --upgrade openai` ПОСЛЕ requirements.txt
→ openai 1.43→2.x сломал совместимость с pydantic_core + langchain-openai
```
**Правило:** НИКОГДА не `pip install --upgrade <pkg>` в Dockerfile если pkg зафиксирован в requirements.txt. Это бомба замедленного действия — ломается при rebuild.

### Docker debugging checklist
```
1. docker logs --tail 50 <container>        # логи (первый шаг!)
2. docker exec <container> pip list | grep <pkg>  # реальные версии
3. docker exec <container> python -c "import <pkg>; print(<pkg>.__version__)"
4. Проверить Dockerfile на `--upgrade` / unfixed versions
5. CORS в nginx: grep -n "Access-Control" /etc/nginx/sites-available/*
```

### docker-compose v1 vs v2
- v1 (`docker-compose`, Python): `KeyError: 'ContainerConfig'` с новым Docker Engine → BROKEN
- v2 (`docker compose`, Go plugin): может быть не установлен
- **Workaround:** `docker build` + `docker run` напрямую, сохраняя тот же `--network`, ports, volumes, env-file

### FK violation при auto-create
```
Симптом: INSERT в таблицу с FK → ForeignKeyViolation "user_id not in users"
Fix: auto-create user перед INSERT (как в submit_answer — скопируй паттерн)
```

## Red Flags (ты нарушаешь процесс)
- Предлагаешь фикс до завершения расследования
- Меняешь несколько вещей одновременно
- Пропускаешь создание теста
- 3+ неудачных попыток без переосмысления
- "Попробуем ещё вот это" без гипотезы

## Метрики
| Подход | Время | Успех с 1 раза | Новые баги |
|--------|-------|----------------|------------|
| Systematic | 15-30 мин | ~95% | ~0 |
| Random fixes | 2-3 часа | ~40% | часто |
