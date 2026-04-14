---
name: webinar-types-deprecated
description: ⚠️ DEPRECATED. Этот раздел устарел — контент переехал в formats/ и playbooks/. Оставлен как редирект, чтобы старые ссылки не сломались.
status: DEPRECATED 2026-04-11
---

# ⚠️ types/ — DEPRECATED (перенесено в formats/ и playbooks/)

**Эта папка устарела.** Её содержание интегрировано в новую action-структуру скилла:

| Было | Стало |
|---|---|
| `types/warm-up.md` | → `formats/3-webs-series.md §Веб 1 — Прогрев` + `formats/single-web.md §Блоки 1-5` |
| `types/offer.md` | → `formats/single-web.md §Блоки 7-9` + `formats/3-webs-series.md §Веб 2 — Оффер` |
| `types/follow-up.md` | → `formats/3-webs-series.md §Веб 3 — Дожим` |
| Общая архитектура вебов | → `formats/` + `playbooks/` |
| Детали фаз | → `playbooks/P3-warmup-flow.md` |
| Детали возражений | → `playbooks/P5-objections-aikido.md` |
| Детали urgency | → `playbooks/P6-now-this-way.md` |

## Почему структура изменилась

Старые `types/*.md` были написаны как **архитектурные описания типов вебов** — полутеория «вот как устроен прогревочный веб». Это плохо работало: LLM читала всё подряд и перегружалась контекстом.

Новая структура — **action**:
- `formats/` — готовые skeleton под задачу (1 веб или 3 веба)
- `playbooks/` — как именно решать каждую подзадачу (зацепить / удержать / провести / закрыть)
- `lang/` — готовые блоки для вставки

Это даёт LLM ответ на вопрос **«что делать»**, а не «как это теоретически устроено».

## Куда идти вместо старых types/

**Если ты пишешь сценарий:**
1. Открой `../SKILL.md` — Decision Router подскажет путь
2. Для одного веба → `../formats/single-web.md`
3. Для серии из 3 → `../formats/3-webs-series.md`
4. Дальше — плейбуки P1-P6 по ссылкам из формата

**Не читай** `types/warm-up.md`, `types/offer.md`, `types/follow-up.md` — они устарели и остались только для совместимости.

---

## История

- **2026-04-11** — папка помечена DEPRECATED. Содержание перенесено в `../formats/` и `../playbooks/`. Старые файлы оставлены для совместимости, но читать их не нужно.
