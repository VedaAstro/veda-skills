# Техническая реализация: сообщения Веды (veda_timeline)

## Архитектура — 4 входа, 1 LLM-вызов

1. **Lesson plan** (из транскрипта) — что Ирина говорит в каждом окне
2. **VEDA_SYSTEM_PROMPT** — правила поведения Веды (уже в коде)
3. **Карта из AstroGuru** — дома, планеты, даши, йоги
4. **Cues** — что подсвечено на экране в каждый момент

## Два этапа генерации

**Stage 1 — Препроцессинг** (1 раз на урок, ~$0.003):
- Транскрипт → Gemini 2.5 Flash → `lesson_plan` JSON
- Хранится в `web_lessons.lesson_plan` (JSONB)
- Endpoint: `POST /api/web/admin/lessons/{id}/generate-plan`

**Stage 2 — Персонализация** (1 вызов на юзера, ~$0.0006):
- lesson_plan + compact_chart + cues → Gemini 2.5 Flash → массив сообщений
- Кэш: Redis db=1, `veda:messages:{user_id}:{slug}`, TTL 24ч

## Конверсионная роль (LESSON_ROLE)

| Урок | Фокус сообщений Веды |
|------|---------------------|
| 1 | WOW — карта показала конкретно |
| 2 | Привычное ВРЕДИТ, не ты плохая |
| 3 | Направление без рецепта, нужен навигатор |

## Критические правила

1. **Привязка к экрану обязательна:** сообщение привязано к cue. На экране дом 2 — сообщение только про дом 2
2. **System prompt содержит все правила:** user prompt = только данные. Не дублировать
3. **Redis при деплое:** очистить кэш ДО restart PM2:
```
redis-cli -n 1 EVAL "local k=redis.call('keys','veda:messages:*') if #k>0 then return redis.call('del',unpack(k)) else return 0 end" 0
pm2 restart bot-admin-api
```
4. **Legacy fallback отключён:** есть lesson_plan → legacy не вызывается

## Файлы на сервере (PM2 из /root/)

| Файл | Что |
|------|-----|
| `/root/bot-admin-api/app/services/veda_timeline.py` | Генератор: Stage 1/2, VEDA_SYSTEM_PROMPT |
| `/root/bot-admin-api/app/models/web_lesson.py` | Модель: lesson_plan поле |
| `/root/bot-admin-api/app/api/web/lessons.py` | API |
| `/root/bot-admin-api/app/api/web/admin_lessons.py` | Admin: generate-plan |
| `/root/bot-admin-api/app/services/llm_service.py` | LLM: call_llm через OpenRouter |

## Принципы (из реального опыта)

1. **Данные перед кодом:** выгрузи cues ВСЕХ уроков, посмотри edge cases (duration=5 = тизер, veda_message = пауза)
2. **Root cause — два уровня "почему?":** фикс = запрет в промпте → это симптом. Найди причину
3. **LLM — дай данные, не правила:** правильный контекст > 15 строк запретов
4. **Один деплой:** проверить ВСЕ уроки локально, потом 1 деплой
5. **Model file:** при scp veda_timeline.py модель НЕ обновляется — проверить web_lesson.py

## Проверка
- Арина Зайцева (user_id=60), astro.myveda.ru, Ctrl+Shift+R
- Критерии: привязка к речи, совпадение с подсвеченным домом, нет повторов
