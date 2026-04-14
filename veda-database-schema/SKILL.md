---
name: veda-database-schema
description: Схема БД veda_crm -- 48 таблиц, связи, enum'ы, JSON-поля, миграции Alembic. Используй при работе с моделями, миграциями или запросами к БД.
---

# Схема БД Veda (veda_crm)

## Когда использовать

- Создание новых моделей / таблиц
- Написание SQLAlchemy запросов
- Создание Alembic миграций
- Проверка связей между таблицами
- Понимание структуры данных модуля

## Таблицы по доменам (48 объектов)

### Staff & Auth (4)

| Таблица | Ключевые поля | Связи |
|---------|--------------|-------|
| `staff_users` | id, uuid, email, telegram_id, name, role, password_hash | -> schedules, goals, notes |
| `staff_schedules` | staff_id, day_of_week (1-7), work_start/end, breaks (JSON) | staff_users.id |
| `staff_schedule_exceptions` | staff_id, date_from/to, exception_type | staff_users.id |
| `role_permissions` | role, permission (unique pair) | -- |

### Clients (7)

| Таблица | Ключевые поля | Связи |
|---------|--------------|-------|
| `diagnostic_profiles` | id, telegram_id, phone, name, birth_*, natal_data (JSON), status, pain_text, ai_profile (JSON) | -> bookings, deals, notes, quiz |
| `client_notes` | profile_id, author_id, note_type, content, tags (JSON) | diagnostic_profiles, staff_users |
| `bot_conversations` | telegram_id (unique), state, collected_data (JSON), chart_data (JSON) | -- |
| `quiz_submissions` | name, phone, pain_sphere, pain_detail, semantic_answers (JSON), profile_id | diagnostic_profiles |
| `diagnostic_slots` | diagnostician_id, date, time, is_available, is_booked | -- |
| `diagnostic_bookings` | profile_id, slot_id, status, result, deal_id, session_data (JSON), transcript_json | diagnostic_profiles, slots, deals, presentations |
| `case_entries` | case_id (unique), name, barrier_type, pain_sphere, story_full, result_amount | -> favorited_by (M2M) |

### Sales & Deals (5)

| Таблица | Ключевые поля | Связи |
|---------|--------------|-------|
| `deals` | client_id, product_id, amount, status, payment_status, paid_amount | diagnostic_profiles, products, bookings |
| `sales_sessions` | manager_id, client_id, status, outcome, session_data (JSON) | staff_users, diagnostic_profiles |
| `tasks` | client_id, assignee_id, type, due_date, status | diagnostic_profiles, staff_users |
| `interactions` | client_id, type, channel, content | diagnostic_profiles |
| `message_templates` | name, type (unique), content, variables (JSON) | -- |

### Presentations (4+1)

| Таблица | Ключевые поля | Связи |
|---------|--------------|-------|
| `presentations` | name, template_id, version, status, is_default | -> slides, prompts, chat, assignments |
| `presentation_slides` | presentation_id, slide_type, order, script (JSON) | presentations |
| `presentation_template_prompts` | template_id, prompt_key (unique pair), prompt_text | presentations |
| `presentation_chat_messages` | presentation_id, role, content | presentations, staff_users |
| `template_assignments` | template_id, diagnostician_id (unique pair) | presentations, staff_users |

### Products (5)

| Таблица | Ключевые поля | Связи |
|---------|--------------|-------|
| `product_groups` | name, is_default, status | -> products |
| `products` | name, tier_order, price, features (JSON), gc_product_id, status | product_groups |
| `product_wheel_bonuses` | product_id, name, value, color, closes_barrier | products |
| `product_table_versions` | product_id, name, status (draft/published) | products |
| `product_comparison_table` | version_id, row_label, tier1/2/3_* | product_table_versions |

### Management/PDCA (10)

| Таблица | Ключевые поля | Связи |
|---------|--------------|-------|
| `management_units` | name, slug, owner_id, unit_type | staff_users |
| `management_metrics` | unit_id, name, slug, metric_type, metric_nature | management_units |
| `management_sprints` | number (unique), start/end_date, status | -> targets, tasks |
| `management_metric_targets` | sprint_id + metric_id (unique), target/actual_value | sprints, metrics |
| `management_bottlenecks` | sprint_id, metric_target_id, rca_why1/2/3 | sprints, targets -> tasks |
| `management_tasks` | sprint_id, bottleneck_id, metric_id, owner_id, status | sprints, metrics, staff |
| `management_daily_actions` | task_id, date, action_text, status | tasks |
| `management_daily_facts` | metric_id + date (unique), value | metrics |
| `management_metric_tree` | parent_metric_id, child_metric_id (unique), weight | metrics |
| `management_retrospectives` | sprint_id + unit_id (unique), decisions (JSON) | sprints, units |

### OKK (3)

| Таблица | Ключевые поля | Связи |
|---------|--------------|-------|
| `okk_templates` | name, slug, type (diagnost/sales_manager), scoring_type | -> criteria |
| `okk_criteria` | template_id, name, block_name, weight, is_required | okk_templates |
| `okk_results` | template_id, staff_id, total_score, template_snapshot (JSON) | templates, staff, sales_sessions |

### GetCourse Integration (4) — ВАЖНО для аналитики продаж

| Таблица | Ключевые поля | Назначение |
|---------|--------------|-----------|
| `gc_orders` | id, user_id, order_type, amount, paid_amount, received_amount, paid_at, created_at, raw_data (jsonb), is_fully_paid | **Top-level snapshot** заказа ГК. Медленно обновляется (до 1-3 дней лаг пока ГК закроет рассрочки). НЕ использовать для оперативных cashflow-метрик. |
| `gc_payment_events` | gc_order_id, payment_date, payment_type, payment_status, gross_amount, commission_amount, received_amount | **SSOT для фактических платежей**. Один заказ = несколько events (каждый транш отдельно). Использовать для выручки, оплат за день, CR. |
| `gc_commissions` | gc_order_id, operation_date, payment_method, amount, commission, payout_amount, installment_amount | Сводка комиссий по методам оплаты (Геткурс/CloudPayments/PayAnyWay/Other=ОТП). |
| `gc_users` | id, email, phone, raw_data (jsonb), first_order_at | Users ГК, синкаются отдельно. |

**Критическое правило aggregate_day:**
```python
# ПРАВИЛЬНО — выручка/оплаты через gc_payment_events
SELECT
  COUNT(DISTINCT gc_order_id) AS paid_orders,
  SUM(received_amount) AS revenue_net,
  SUM(gross_amount) AS revenue_gross
FROM gc_payment_events
WHERE payment_date::date = :d AND payment_status = 'success';

# НЕПРАВИЛЬНО — gc_orders.paid_at отстаёт, is_fully_paid отстаёт
SELECT COUNT(*), SUM(paid_amount)
FROM gc_orders
WHERE paid_at::date = :d AND is_fully_paid = TRUE;  -- ТЕРЯЕТ рассрочки в работе
```

**payment_status значения:**
- `success` — платёж прошёл, деньги на счёт упали
- `ожидается` — будущий транш рассрочки (НЕ учитывать в выручке за день)
- `rejected` — отклонён банком

**payment_type значения:**
- `CloudPayments` — эквайринг (комиссия ~8-9%)
- `Геткурс` — внутренний processing ГК (разные комиссии)
- `PayAnyWay` — второй кошелёк ГК
- `Other` — обычно ОТП банк (банковская рассрочка, комиссия ~17-20%)
- `Tinkoff` — Тинькофф-рассрочка

### Прочее (8)

| Таблица | Назначение |
|---------|-----------|
| `staff_goals` | KPI цели сотрудников |
| `goal_history` | История достижения целей |
| `quizzes` | Шаблоны квизов |
| `quiz_steps` | Шаги/вопросы квиза |
| `token_balances` | Баланс AI-токенов |
| `token_usage_log` | Лог расхода токенов |
| `ai_knowledge_docs` | Документы базы знаний |
| `media_assets` | Медиа-библиотека |
| `diagnost_staff_profiles` | Расширенный профиль диагноста |
| `diagnostician_favorite_cases` | M2M: избранные кейсы |
| `presentation_settings` | Глобальные настройки AI |
| `presentation_template_products` | Привязка продукта к шаблону |

## Критические правила

### Enum'ы -- ВСЕГДА .value

```python
# ПРАВИЛЬНО
.filter(Deal.status == DealStatus.THINKING.value)
.filter(StaffUser.role == StaffRole.DIAGNOSTIC_MANAGER.value)  # "diagnostician"!

# НЕПРАВИЛЬНО (не работает!)
.filter(Deal.status == DealStatus.THINKING)
```

### Ключевые Enum значения

| Enum | Значения |
|------|---------|
| StaffRole | diagnostician, department_head, tech_admin, super_admin |
| ClientStatus | new, qualified, scheduled, diagnostic_done, thinking, purchased, rejected |
| DealStatus | thinking, followup, payment, completed, rejected |
| PaymentStatus | pending, partial, paid, refunded |
| AppointmentResult | sale, thinking, rejected, no_show, followup |
| SprintStatus | planning, active, review, closed |

### Связи клиентского пути

```
QuizSubmission -> DiagnosticProfile -> DiagnosticBooking -> Deal -> Payment
                                    -> SalesSession
                                    -> ClientNote
```

### JSON-поля (JSONB)

Активно используются для гибких данных:
- `natal_data` -- натальная карта (планеты, дома)
- `session_data` -- данные диагностической сессии
- `ai_profile` -- AI-анализ клиента
- `template_snapshot` -- замороженный шаблон OKK
- `evaluation` -- результаты OKK оценки

## Быстрый маршрут

1. Нужна новая таблица? -> Модель в `db/models.py` + миграция в `alembic/versions/`
2. Нужен запрос? -> Проверь enum'ы (.value!), связи, JSON-поля
3. Нужна миграция? -> `alembic revision --autogenerate -m "описание"` (но проверь SQL!)

## Reference-файлы

| Файл | Когда открывать |
|------|----------------|
| `reference/full-schema.md` | Полная схема со ВСЕМИ колонками каждой таблицы |
| `reference/migrations.md` | Список всех 17 миграций с описанием |
| `reference/enums.md` | Полный перечень всех enum'ов с значениями |
