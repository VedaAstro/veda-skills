# Full Database Schema (veda_crm)

## Overview
- DB: PostgreSQL `veda_crm`
- ORM: SQLAlchemy 2.0 + asyncpg
- Tables: 49 (47 original + 2 quiz constructor)
- Models file: `platform/veda-backend/db/models.py` (2265 lines)
- Migrations: `platform/veda-backend/alembic/versions/` (16 files)

## Enums (CRITICAL -- always use .value in SQLAlchemy queries!)

| Enum | Values |
|------|--------|
| StaffRole | `diagnostician`, `department_head`, `tech_admin`, `super_admin` |
| ClientStatus | `new`, `qualified`, `scheduled`, `diagnostic_done`, `thinking`, `purchased`, `rejected` |
| DealStatus | `thinking`, `followup`, `payment`, `completed`, `rejected` |
| PaymentStatus | `pending`, `partial`, `paid`, `refunded` |
| AppointmentResult | `sale`, `thinking`, `rejected`, `no_show`, `followup` |
| ConfirmationStatus | `pending`, `confirmed`, `not_confirmed` |
| ProductStatus | `active`, `draft`, `archived` |
| InteractionType | `message`, `reminder_sent`, `confirmation`, `status_change`, `note`, `call`, `appointment` |
| InteractionChannel | `telegram`, `whatsapp`, `phone`, `email`, `system` |
| NoteType | `general`, `pain`, `barrier`, `followup`, `important` |
| TaskType (CRM) | `confirm`, `followup`, `schedule`, `call`, `custom` |
| TaskStatus (CRM) | `pending`, `done`, `skipped` |
| GoalType | `conversion`, `revenue`, `session_count`, `average_check` |
| GoalPeriod | `daily`, `weekly`, `monthly`, `quarterly` |
| TemplateType | `reminder_24h`, `reminder_2h`, `reminder_15min`, `confirmation`, `followup_soft`, `followup_hard`, `reactivation`, `no_show` |
| SprintStatus | `planning`, `active`, `review`, `closed` |
| MetricType | `percentage`, `currency`, `count` |
| MetricNature | `leading`, `lagging` |
| BottleneckStatus | `identified`, `action_planned`, `resolved`, `escalated` |
| RCACategory | `process`, `people`, `technology`, `market` |
| ManagementTaskStatus | `pending`, `in_progress`, `completed`, `cancelled`, `blocked` |
| TaskPriority | `critical`, `high`, `normal`, `low` |
| TaskType (PDCA) | `metric`, `operational`, `backlog` |
| TaskSource | `sprint`, `debug`, `retro`, `ad_hoc` |
| FactSource | `manual`, `api`, `calculated` |
| DailyActionStatus | `planned`, `done`, `failed`, `skipped` |
| Confidence | `high`, `medium`, `low` |
| ResultDecision | `continue`, `pivot`, `escalate`, `cancel` |
| TrendDirection | `up`, `down`, `flat` |

**GOTCHA:** `StaffRole.DIAGNOSTIC_MANAGER.value = "diagnostician"` (NOT `"diagnostic_manager"`!)

## Tables by Domain

### Staff & Auth (7 tables)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `staff_users` | id, uuid (unique), telegram_id (unique BigInt), email (unique), name, photo_url, role (String50), is_active, password_hash, refresh_token, token_expires_at, use_custom_schedule, last_login_at | Main user model. Relationship: `favorite_cases` (M2M with case_entries) |
| `staff_schedules` | id, staff_id (FK staff_users, CASCADE), day_of_week (1-7 ISO), is_working, work_start/end (String5), breaks (JSON), session_duration, buffer_time, max_per_day | UC: (staff_id, day_of_week) |
| `staff_schedule_exceptions` | id, staff_id (FK staff_users, CASCADE), date_from/to (Date), exception_type (`day_off`/`custom_hours`), work_start/end, breaks (JSON), reason | Date-range overrides |
| `role_permissions` | id, role (String50), permission (String100) | UC: (role, permission). 21 permissions across 7 groups |
| `staff_goals` | id, staff_user_id (FK), set_by_user_id (FK), goal_type, period, target_value, period_start/end (Date), current_value, is_achieved, achieved_at | KPI goals per staff |
| `goal_history` | id, goal_id (FK staff_goals), snapshot_date (Date), value | Historical snapshots for trends |
| `diagnost_staff_profiles` | id, staff_user_id (FK, unique), specialization, experience, bio (Text), fun_facts (JSON), photo_urls (JSON), diplomas (JSON) | Extended diagnostician profile for presentation slide |

### CRM Core (9 tables)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `diagnostic_profiles` | id, telegram_id (BigInt), phone, name, birth_date/time/city/lat/lon, source, source_detail, pain_text, goal_text, segment, pain_level, keywords (JSON), hidden_pain, natal_data (JSON), astro_highlights (JSON), recognition_hooks (JSON), learning_strengths (JSON), conversion_hooks (JSON), ai_profile (JSON), diagnostic_date/result/notes, objection_type, session_id, status (ClientStatus), topic, email, telegram_username, last_contact_at | = Client record. Central entity, referenced by bookings, deals, quiz_submissions, notes, interactions, sales_sessions |
| `diagnostic_slots` | id, diagnostician_id (String36), diagnostician_name, date (Date), time (String5), duration_minutes, is_available, is_booked | Bookable time slots |
| `diagnostic_bookings` | id, slot_id (FK), scheduled_date/time, profile_id (FK), telegram_id (BigInt), status (`pending`/`confirmed`/`cancelled`/`completed`/`no_show`/`in_progress`), confirmation_status, reminder_24h/2h/15min_sent, result (AppointmentResult), result_notes, rejection_reason, deal_id (FK), product_id (FK), session_data (JSON), presentation_version_id (FK presentations), current_slide, quiz_submission_id (FK), transcript_json (JSON), ai_hints_json (JSON), started_at, completed_at, confirmed_at | = Appointment. Full lifecycle with CRM fields |
| `bot_conversations` | id, telegram_id (BigInt, unique), state (ConversationState), collected_data (JSON), profile_id, source, messages_history (JSON), chart_data (JSON), hook_delivered, hook_text, short_answer_count, lead_temperature, is_low_budget, disqual_reason | Bot dialog state machine |
| `quiz_submissions` | id, name, phone, messenger, birth_date/time/city/lat/lon, birth_time_unknown, pain_sphere, pain_detail, pain_duration, tried_before, cost_lost, cost_future, income_now/goal, dream_change, urgency (1-10), time_ready, family_attitude, previous_diagnostics, is_repeat_lead, briefing, semantic_answers (JSON), status (`new`/`contacted`/`booked`/`completed`/`cancelled`), profile_id (FK) | Full quiz data with 4 blocks: Pain, Cost, Dream, Qualification |
| `client_notes` | id, profile_id (FK), author_id (FK staff_users), note_type (NoteType), content (Text), session_id, tags (JSON), is_pinned | Persistent notes across sessions |
| `deals` | id, client_id (FK profiles), appointment_id (FK bookings), diagnostician_id (FK staff_users), product_id (FK), amount, discount_applied, installment_enabled/payments, status (DealStatus), payment_status (PaymentStatus), paid_amount, followup_date, followup_notes, thinking_reason, rejection_reason, gc_order_id, closed_at | Sales pipeline / kanban |
| `interactions` | id, client_id (FK profiles), type (InteractionType), channel (InteractionChannel), direction (`inbound`/`outbound`), content (Text), auto_generated, template_id (FK message_templates), author_id (FK staff_users) | Communication log |
| `tasks` | id, client_id (FK), appointment_id (FK), deal_id (FK), assignee_id (FK staff_users), type (TaskType), title, due_date (Date), due_time (String5), status (TaskStatus), auto_created, completed_at | CRM action items for diagnosticians |

### Products (8 tables)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `product_groups` | id, name, description, is_default, status (ProductStatus) | Group of tiers (e.g. "5 spheres") |
| `products` | id, product_group_id (FK), name, short_name, description, tier_order, tier_label, price, discount_price, discount_until, installment_enabled, installment_options (JSON), duration_months, features (JSON), modules (JSON), bonuses (JSON), fast_decision_bonus, fast_decision_48h_bonus, fast_decision_bonuses (JSON), comparison_text, slide_title/subtitle/accent, gc_product_id, status | Full product with pricing, installments, modules, bonuses. Relationships: group, wheel_bonuses, table_versions |
| `product_wheel_bonuses` | id, product_id (FK), name, name_ru, value, sector_size, color, closes_barrier, sort_order, is_active | Fortune wheel sectors for offer slide |
| `product_table_versions` | id, product_id (FK, CASCADE), name, status (`draft`/`published`) | Versioned comparison tables per product |
| `product_comparison_table` | id, version_id (FK, CASCADE), row_label, row_category, row_type (`text` default), sort_order, tier1/2/3_value (Text), tier1/2/3_label, tier1/2/3_price, tier1/2/3_discount, tier1/2/3_installment_months/monthly, library_item_id, library_item_type | Comparison rows for 3 tiers |
| `product_tier_modules` | id, tier_number, library_item_id, version_id (FK, CASCADE), module_title, module_thumbnail, sort_order | UC: (tier_number, library_item_id, version_id) |
| `presentation_template_products` | id, presentation_id (FK, CASCADE), product_id (FK, CASCADE), table_version_id (FK, SET NULL) | Binds presentation to product + table version. UC: (presentation_id, product_id) |
| `message_templates` | id, name, type (unique, TemplateType), content (Text with {variables}), variables (JSON), is_active, auto_send | Message automation templates |

### Presentations (7 tables)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `presentations` | id, name, description, template_id (self-FK, nullable), version, status (`draft`/`active`/`archived`), is_default, is_active, is_visible, is_favorite, is_archived, is_system, style_overrides (JSON), presentation_key, created_by (FK staff_users) | Versioning: template_id=NULL = base template, template_id=N = version of template N. Only one active version per template |
| `presentation_slides` | id, presentation_id (FK, CASCADE), slide_type, visual_id (nullable), order, is_enabled, script (JSON), visual_config (JSON) | Slide types: "title", "rules", "natal_chart", "pain_element", "tpl_text", "tpl_video", etc. |
| `presentation_template_prompts` | id, template_id (FK, CASCADE), prompt_key, prompt_text (Text), updated_by (FK staff_users) | Per-template AI prompt overrides. UC: (template_id, prompt_key). Keys: "base", "pain_link", "financial_channel", etc. |
| `presentation_settings` | id, key (unique), value (JSON), description, updated_by (FK staff_users) | Global presentation settings |
| `script_versions` | id, visual_id (1-14), version, script_text (Text), question_text, trigger_text, sphere_scripts (JSON), barrier_scripts (JSON), time_limit_seconds, is_active, is_draft, created_by (FK staff_users) | UC: (visual_id, version). Versioned call scripts |
| `presentation_chat_messages` | id, presentation_id (FK, CASCADE), role (`user`/`assistant`), content (Text), tool_results (JSON), tokens_used, user_id (FK staff_users) | AI chat history for presentation editor |
| `template_assignments` | id, template_id (FK, CASCADE), diagnostician_id (FK staff_users, CASCADE), assigned_by (FK staff_users), assigned_at | UC: (template_id, diagnostician_id) |

### Management / PDCA (10 tables)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `management_units` | id, name, slug (unique), owner_id (FK staff_users), unit_type (`source`/`cross_cutting`), description, color, sort_order, is_active | Business units |
| `management_metrics` | id, unit_id (FK), name, slug, metric_type (MetricType), metric_nature (MetricNature), format_str, revenue_weight (deprecated), owner_id (FK), description, formula_note, is_active, sort_order | UC: (unit_id, slug). Relationships: targets, daily_facts |
| `management_sprints` | id, name, number (unique), start_date, end_date, status (SprintStatus), goal_text, max_tasks (default 15), closed_at | Two-week cycles. Relationships: targets, bottlenecks, tasks, retrospectives |
| `management_metric_targets` | id, sprint_id (FK, CASCADE), metric_id (FK, CASCADE), target_value, actual_value, impact_rub, prev_value, trend, trend_values (JSON) | UC: (sprint_id, metric_id). Properties: gap_value, gap_percent |
| `management_bottlenecks` | id, sprint_id (FK, CASCADE), metric_target_id (FK, CASCADE), priority_score, rank, cost_rub, rca_what, rca_why1/2/3, rca_category (RCACategory), status (BottleneckStatus) | RCA chain. Properties: completion_steps, completion_percent |
| `management_tasks` | id, sprint_id (FK, CASCADE, nullable), bottleneck_id (FK, nullable), metric_id (FK, nullable), task_type (TaskType PDCA), title, description, goal_text, owner_id (FK), deadline, priority (TaskPriority), priority_score, status (ManagementTaskStatus), forecast_delta_percent/rub, confidence, actual_delta_percent/rub, result_text, result_decision, source (TaskSource), retro_decision_id, artifact_url, completed_at | Sprint tasks with forecast/actual. Property: forecast_accuracy |
| `management_daily_actions` | id, task_id (FK, CASCADE), date, action_text, status (DailyActionStatus), result_text | Daily task actions |
| `management_daily_facts` | id, metric_id (FK, CASCADE), date, value, notes, source (FactSource) | UC: (metric_id, date). Daily metric values |
| `management_retrospectives` | id, sprint_id (FK, CASCADE), unit_id (FK, nullable), what_worked (JSON), what_failed (JSON), decisions (JSON), escalations (JSON), key_insight, next_focus, created_by (FK) | UC: (sprint_id, unit_id) |
| `management_metric_tree` | id, parent_metric_id (FK), child_metric_id (FK), weight, formula_type (`multiply`), description | UC: (parent_metric_id, child_metric_id). Revenue impact calculation |

### OKK (3 tables)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `okk_templates` | id, uuid (unique), name, slug (unique), type (`diagnost`/`sales_manager`), system_context (Text), evaluation_rules (Text), scoring_type (`binary`/`fractional`), threshold_green/amber, min_call_duration, auto_evaluate, is_active, is_default, ai_model, ai_temperature, ai_max_tokens, metadata_fields (JSON), objection_categories (JSON), text_fields (JSON) | Evaluation template with AI config |
| `okk_criteria` | id, template_id (FK, CASCADE), name, description, block_name, block_order, sort_order, weight, is_required | Ordered by block_order, sort_order |
| `okk_results` | id, uuid (unique), template_id (FK), template_snapshot (JSON), staff_id (FK), staff_name, session_id, sales_session_id (FK), caller/callee_number, duration, call_date, recording_url, transcript (Text), evaluation (JSON), metadata_values (JSON), text_field_values (JSON), total_score, raw_score, max_possible_score, source (`auto`/`manual`/`webhook`/`upload`), evaluated_by, evaluated_at, reviewed_by (FK), reviewed_at, review_comment | template_snapshot freezes config at evaluation time |

### Sales (1 table)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `sales_sessions` | id, manager_id (FK staff_users), client_id (FK profiles), status (`preparing`/`calling`/`in_call`/`post_call`/`completed`), outcome (`sale`/`callback`/`rejected`/`no_answer`/`thinking`/`pending`), product_id (FK), deal_amount, deal_id (FK), callback_date, script_step, call_duration (seconds), notes, transcript_json (JSON), ai_hints_json (JSON), session_data (JSON), started_at, ended_at | Sales call session with full data |

### Tokens (2 tables)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `token_balances` | id, user_id (FK staff_users, unique), monthly_limit, used_this_month, reset_day, last_reset_at | Per-user AI token credit |
| `token_usage_log` | id, user_id (FK), presentation_id, action (`update_slide`/`add_slide`/`delete_slide`/`reorder`/`chat`), input/output/total_tokens, model, message (Text) | Per-call token usage |

### Quiz Constructor (2 tables)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `quizzes` | id, name, slug (unique), description, is_active, is_default, is_system, settings (JSON), created_by (FK staff_users) | Quiz templates. Relationship: steps |
| `quiz_steps` | id, quiz_id (FK, CASCADE), step_type, order, is_enabled, config (JSON) | Step types: "intro", "process_steps", "radio", "checkbox", "textarea", "income", "radio_conditional", "radio_with_hints", "birth_data", "contact", "insight" |

### Other (4 tables)

| Table | Key Columns | Notes |
|-------|-------------|-------|
| `case_entries` | id, case_id (unique), name, age, occupation, photo_url, strength_score (1-100), daily_income, result_amount, result_period_days, result_description, barrier_type, barrier_subtype, pain_sphere, pain_subtype, funnel_stage (`Прогрев`/`Дожим`/`Оффер`), age_group, has_children, employed, previous_courses, story_full, story_short, quote_before/after, video_url, video_duration_seconds, is_active | Success stories for presentation. Relationship: favorited_by (M2M) |
| `diagnostician_favorite_cases` | staff_user_id (PK, FK staff_users, CASCADE), case_entry_id (PK, FK case_entries, CASCADE), created_at | Association table (composite PK) |
| `media_assets` | id, name, file_url, file_key, file_size, mime_type, category, tags (JSON), description, width, height, uploaded_by (FK staff_users) | S3/MinIO media storage |
| `ai_knowledge_docs` | id, title, content (Text), source_type (`text`/`file`), file_url, category, tags (JSON), token_estimate, is_active, created_by (FK staff_users) | AI knowledge base documents |

## Alembic Migrations (16)

| # | Filename | Revision | Description |
|---|----------|----------|-------------|
| 1 | 185c5eb6ae0c_initial_schema.py | 185c5eb6ae0c | Initial 47-table schema |
| 2 | add_quiz_tables.py | a3f2b7c9d1e4 | Quiz constructor (quizzes + quiz_steps) |
| 3 | add_management_tables.py | c5f9d3e6a8b1 | PDCA 10 tables |
| 4 | add_pdca_v4_fields.py | e8f1a2b3c4d5 | PDCA v4 extensions (task_type, source, forecast, etc.) |
| 5 | add_metric_nature.py | d7a2b3c4e5f6 | Leading/lagging metric nature |
| 6 | add_okk_tables.py | f9a2b3c4d5e6 | OKK 3 tables |
| 7 | add_diagnost_staff_profiles.py | a1b2c3d4e5f6 | Diagnostician extended profiles |
| 8 | add_diagnostician_favorite_cases.py | e7f8g9h0i1j2 | Favorite cases M2M association table |
| 9 | add_sales_sessions.py | b4e8c1d2f5a7 | Sales workstation session table |
| 10 | add_ai_pipeline_fields.py | b2c3d4e5f6a7 | AI pipeline fields (ai_profile, semantic_answers) |
| 11 | add_product_groups_and_wheel_bonuses.py | c5f9d3e7a2b1 | Product groups + wheel bonuses |
| 12 | add_product_comparison_table.py | f1a2b3c4d5e7 | Comparison table rows |
| 13 | add_product_table_versions_and_bind.py | a2b3c4d5e6f7 | Table versions + presentation binding |
| 14 | add_sales_session_data.py | b3c4d5e6f7a8 | Session data JSON fields |
| 15 | add_template_prompts.py | c4d5e6f7a8b9 | Template-level AI prompt overrides |
| 16 | expand_case_entry_model.py | d6a7b2c8f3e4 | Case entry expansion (strength_score, story_full, funnel_stage, etc.) |

## Key Relationships

```
diagnostic_profiles (Client)
  <- quiz_submissions.profile_id
  <- diagnostic_bookings.profile_id
  <- deals.client_id
  <- client_notes.profile_id
  <- interactions.client_id
  <- sales_sessions.client_id
  <- tasks.client_id

staff_users
  -> staff_schedules (1:many)
  -> staff_schedule_exceptions (1:many)
  -> staff_goals (1:many)
  -> diagnost_staff_profiles (1:1, unique)
  -> presentations.created_by
  -> management_units.owner_id
  -> okk_results.staff_id
  -> template_assignments.diagnostician_id
  <-> case_entries (M2M via diagnostician_favorite_cases)

presentations
  <- presentation_slides (1:many, CASCADE)
  <- presentation_chat_messages (1:many, CASCADE)
  <- template_assignments (1:many, CASCADE)
  <- presentation_template_products (1:many, CASCADE)
  <- presentation_template_prompts (1:many, CASCADE)
  -> presentations.template_id (self-ref for versioning)

management_sprints
  <- management_metric_targets (1:many, CASCADE)
  <- management_bottlenecks (1:many, CASCADE)
  <- management_tasks (1:many, CASCADE)
  <- management_retrospectives (1:many, CASCADE)

management_metrics
  <- management_metric_targets.metric_id
  <- management_daily_facts.metric_id
  <- management_tasks.metric_id
  <- management_metric_tree (parent/child self-ref)

products
  -> product_groups (many:1)
  <- product_wheel_bonuses (1:many)
  <- product_table_versions (1:many, CASCADE)
  <- deals.product_id
  <- presentation_template_products.product_id

product_table_versions
  <- product_comparison_table.version_id (1:many, CASCADE)
  <- product_tier_modules.version_id (1:many, CASCADE)

okk_templates
  <- okk_criteria (1:many, CASCADE)
  <- okk_results.template_id

quizzes
  <- quiz_steps (1:many, CASCADE)
```

## Critical Rules

1. **StaffRole.DIAGNOSTIC_MANAGER.value = "diagnostician"** (NOT "diagnostic_manager")
2. **SQLAlchemy enums:** ALWAYS use `.value` for comparisons (e.g. `PaymentStatus.PAID.value`, not `PaymentStatus.PAID`)
3. **Presentation versioning:** `template_id=NULL` = base template, `template_id=X` = version of template X. Only one `status='active'` version per template
4. **OKK:** `template_snapshot` (JSON) freezes the full template config at evaluation time for historical integrity
5. **DiagnosticProfile** = Client record, **DiagnosticBooking** = Appointment
6. **TaskType enum collision:** Two different TaskType enums exist (CRM and PDCA). The PDCA one (`metric`/`operational`/`backlog`) shadows the CRM one at module level
7. **ConversationState** is NOT an Enum, it's a plain class with string constants
8. **Cascade deletes:** Most child tables use `ondelete="CASCADE"` on ForeignKeys. Products use `CASCADE` for table_versions but `SET NULL` for presentation_template_products.table_version_id
9. **JSON fields:** natal_data, session_data, transcript_json, ai_hints_json, semantic_answers, collected_data, chart_data -- all use PostgreSQL native JSON type
10. **Unique constraints:** Many compound UCs -- check `__table_args__` in model before inserting
