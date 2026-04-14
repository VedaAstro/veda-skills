# Alembic Migrations Reference

> Database: `veda_crm` (PostgreSQL) | Backend: `veda-backend` (FastAPI + SQLAlchemy 2.0 async)
> Last updated: 2026-02-18

---

## 1. Configuration

### alembic.ini

- **Location:** `/platform/veda-backend/alembic.ini`
- **script_location:** `alembic`
- **prepend_sys_path:** `.` (allows imports from project root)
- **sqlalchemy.url:** left blank -- set dynamically from `config.py` via `env.py`

### env.py

- **Location:** `/platform/veda-backend/alembic/env.py`
- **Engine:** async PostgreSQL via `create_async_engine(DATABASE_URL)`
- **Metadata:** `Base.metadata` from `db/models.py`
- **Pattern:** online mode runs `asyncio.run(run_async_migrations())`, wrapping the sync migration runner in `connection.run_sync()`
- **Offline mode:** uses `DATABASE_URL` directly with `literal_binds=True`

### DATABASE_URL

```python
# config.py
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+asyncpg://veda:veda@localhost:5432/veda_crm"
)
# Server: postgresql+asyncpg://root@/veda_crm (Unix socket)
# Local:  postgresql+asyncpg://alexlee@localhost:5432/veda_crm
```

### Directory Structure

```
veda-backend/
  alembic.ini
  alembic/
    env.py
    script.py.mako
    versions/
      185c5eb6ae0c_initial_schema.py
      add_quiz_tables.py
      add_sales_sessions.py
      add_management_tables.py
      add_metric_nature.py
      add_pdca_v4_fields.py
      add_okk_tables.py
      add_diagnost_staff_profiles.py
      add_ai_pipeline_fields.py
      add_product_comparison_table.py
      add_product_groups_and_wheel_bonuses.py
      add_product_table_versions_and_bind.py
      add_sales_session_data.py
      add_template_prompts.py
      expand_case_entry_model.py
      add_diagnostician_favorite_cases.py
```

---

## 2. Migration Chain (Chronological Order)

The chain has two branches that split from revision `b4e8c1d2f5a7` (add_sales_sessions), plus a sub-branch from `e8f1a2b3c4d5` (add_pdca_v4_fields). See the Dependency Graph section below for details.

---

### #1. Initial Schema

| Field | Value |
|-------|-------|
| **File** | `185c5eb6ae0c_initial_schema.py` |
| **Revision** | `185c5eb6ae0c` |
| **Down Revision** | `None` (root) |
| **Date** | 2026-02-08 |

**Description:** Baseline migration. Drops a stale index `ix_bookings_pres_version` on `diagnostic_bookings`. The full schema (47 tables) was created outside Alembic (pre-existing DB).

**Operations:**
- DROP INDEX `ix_bookings_pres_version` on `diagnostic_bookings`

---

### #2. Add Quiz Constructor Tables

| Field | Value |
|-------|-------|
| **File** | `add_quiz_tables.py` |
| **Revision** | `a3f2b7c9d1e4` |
| **Down Revision** | `185c5eb6ae0c` |
| **Date** | 2026-02-12 |

**Description:** Quiz constructor -- configurable multi-step quizzes for lead capture.

**Tables Created:**

**`quizzes`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | autoincrement |
| name | String(255) | NOT NULL |
| slug | String(100) | UNIQUE index |
| description | Text | nullable |
| is_active | Boolean | default `true` |
| is_default | Boolean | default `false` |
| settings | JSON | nullable |
| created_by | Integer FK -> staff_users.id | nullable |
| created_at | DateTime | server_default now() |
| updated_at | DateTime | server_default now() |

**`quiz_steps`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | autoincrement |
| quiz_id | Integer FK -> quizzes.id | CASCADE delete |
| step_type | String(50) | NOT NULL |
| order | Integer | default 0 |
| is_enabled | Boolean | default `true` |
| config | JSON | nullable |
| created_at | DateTime | server_default now() |
| updated_at | DateTime | server_default now() |

**Indexes:** `ix_quizzes_slug` (unique), `ix_quiz_steps_quiz_id`

---

### #3. Add Sales Sessions

| Field | Value |
|-------|-------|
| **File** | `add_sales_sessions.py` |
| **Revision** | `b4e8c1d2f5a7` |
| **Down Revision** | `a3f2b7c9d1e4` |
| **Date** | 2026-02-15 |

**Description:** Sales call session tracking with real-time auto-save, script progress, transcription, and AI hints.

**Tables Created:**

**`sales_sessions`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | autoincrement |
| manager_id | Integer FK -> staff_users.id | indexed |
| client_id | Integer FK -> diagnostic_profiles.id | indexed |
| status | String(20) | default `preparing`, indexed |
| outcome | String(20) | default `pending` |
| product_id | Integer FK -> products.id | nullable |
| deal_amount | Float | nullable |
| deal_id | Integer FK -> deals.id | nullable |
| callback_date | Date | nullable |
| script_step | Integer | default 0 |
| call_duration | Integer | nullable |
| notes | Text | nullable |
| transcript_json | JSON | nullable |
| ai_hints_json | JSON | nullable |
| started_at | DateTime | nullable |
| ended_at | DateTime | nullable |
| created_at | DateTime | server_default now() |
| updated_at | DateTime | server_default now() |

---

### #4. Add Management (PDCA) Tables

| Field | Value |
|-------|-------|
| **File** | `add_management_tables.py` |
| **Revision** | `c5f9d3e6a8b1` |
| **Down Revision** | `b4e8c1d2f5a7` |
| **Date** | 2026-02-15 |

**Description:** Complete PDCA management module -- units, metrics, sprints, targets, bottlenecks, tasks, daily actions/facts, retrospectives, and metric tree.

**Tables Created (10):**

**`management_units`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| name | String(100) | NOT NULL |
| slug | String(50) | UNIQUE |
| owner_id | Integer FK -> staff_users.id | nullable |
| description | Text | nullable |
| color | String(7) | nullable |
| sort_order | Integer | default 0 |
| is_active | Boolean | default `true` |
| created_at | DateTime | server_default now() |

**`management_metrics`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| unit_id | Integer FK -> management_units.id | NOT NULL |
| name | String(200) | NOT NULL |
| slug | String(100) | NOT NULL |
| metric_type | String(20) | NOT NULL |
| format_str | String(20) | default `0.0%` |
| revenue_weight | Float | default 0 |
| description | Text | nullable |
| formula_note | Text | nullable |
| is_active | Boolean | default `true` |
| sort_order | Integer | default 0 |
| created_at | DateTime | server_default now() |

Unique: `uq_unit_metric_slug` (unit_id, slug)

**`management_sprints`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| name | String(100) | NOT NULL |
| number | Integer | UNIQUE |
| start_date | Date | NOT NULL |
| end_date | Date | NOT NULL |
| status | String(20) | default `planning` |
| created_at | DateTime | server_default now() |
| closed_at | DateTime | nullable |

**`management_metric_targets`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| sprint_id | Integer FK -> sprints.id | CASCADE |
| metric_id | Integer FK -> metrics.id | CASCADE |
| target_value | Float | NOT NULL |
| actual_value | Float | nullable |
| impact_rub | Float | nullable |
| prev_value | Float | nullable |
| trend | String(10) | nullable |
| trend_values | JSON | nullable |
| created_at / updated_at | DateTime | server_default now() |

Unique: `uq_sprint_metric` (sprint_id, metric_id)

**`management_bottlenecks`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| sprint_id | Integer FK -> sprints.id | CASCADE |
| metric_target_id | Integer FK -> targets.id | CASCADE |
| priority_score | Float | nullable |
| rank | Integer | nullable |
| cost_rub | Float | NOT NULL |
| rca_what / rca_why1 / rca_why2 / rca_why3 | Text | nullable |
| rca_category | String(30) | nullable |
| status | String(20) | default `identified` |
| created_at / updated_at | DateTime | server_default now() |

**`management_tasks`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| sprint_id | Integer FK -> sprints.id | CASCADE, nullable |
| bottleneck_id | Integer FK -> bottlenecks.id | nullable |
| metric_id | Integer FK -> metrics.id | nullable |
| title | Text | NOT NULL |
| description / goal_text | Text | nullable |
| owner_id | Integer FK -> staff_users.id | nullable |
| deadline | Date | nullable |
| priority | String(20) | default `normal` |
| priority_score | Float | nullable |
| status | String(20) | default `pending` |
| forecast_delta_percent / forecast_delta_rub | Float | nullable |
| confidence | String(10) | nullable |
| actual_delta_percent / actual_delta_rub | Float | nullable |
| result_text | Text | nullable |
| result_decision | String(20) | nullable |
| source | String(30) | default `sprint` |
| artifact_url | Text | nullable |
| created_at / updated_at / completed_at | DateTime | |

**`management_daily_actions`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| task_id | Integer FK -> tasks.id | CASCADE |
| date | Date | NOT NULL |
| action_text | Text | NOT NULL |
| status | String(10) | default `planned` |
| result_text | Text | nullable |
| created_at | DateTime | server_default now() |

**`management_daily_facts`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| metric_id | Integer FK -> metrics.id | CASCADE |
| date | Date | NOT NULL |
| value | Float | NOT NULL |
| notes | Text | nullable |
| source | String(30) | default `manual` |
| created_at / updated_at | DateTime | server_default now() |

Unique: `uq_metric_date` (metric_id, date)

**`management_retrospectives`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| sprint_id | Integer FK -> sprints.id | CASCADE |
| unit_id | Integer FK -> units.id | nullable |
| what_worked / what_failed / decisions / escalations | JSON | nullable |
| key_insight / next_focus | Text | nullable |
| created_by | Integer FK -> staff_users.id | nullable |
| created_at / updated_at | DateTime | server_default now() |

Unique: `uq_sprint_unit_retro` (sprint_id, unit_id)

**`management_metric_tree`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| parent_metric_id | Integer FK -> metrics.id | NOT NULL |
| child_metric_id | Integer FK -> metrics.id | NOT NULL |
| weight | Float | default 1.0 |
| formula_type | String(20) | default `multiply` |
| description | Text | nullable |

Unique: `uq_parent_child_metric` (parent_metric_id, child_metric_id)

---

### #5. Add Metric Nature

| Field | Value |
|-------|-------|
| **File** | `add_metric_nature.py` |
| **Revision** | `d7a2b3c4e5f6` |
| **Down Revision** | `c5f9d3e6a8b1` |
| **Date** | 2026-02-15 |

**Description:** Adds leading/lagging classification to management metrics.

**Tables Altered:**
- `management_metrics`: ADD `metric_nature` String(10), default `leading`, NOT NULL

---

### #6. Add PDCA V4 Fields

| Field | Value |
|-------|-------|
| **File** | `add_pdca_v4_fields.py` |
| **Revision** | `e8f1a2b3c4d5` |
| **Down Revision** | `d7a2b3c4e5f6` |
| **Date** | 2026-02-15 |

**Description:** PDCA v4 enhancements -- unit types, metric ownership, task types, sprint goals.

**Tables Altered:**
- `management_units`: ADD `unit_type` String(20), default `source`
- `management_metrics`: ADD `owner_id` Integer FK -> staff_users.id
- `management_sprints`: ADD `goal_text` Text, `max_tasks` Integer (default 15)
- `management_tasks`: ADD `task_type` String(20) default `metric`, `retro_decision_id` String(100)

---

### #7. Add OKK Tables

| Field | Value |
|-------|-------|
| **File** | `add_okk_tables.py` |
| **Revision** | `f9a2b3c4d5e6` |
| **Down Revision** | `e8f1a2b3c4d5` |
| **Date** | 2026-02-16 |

**Description:** Quality control (OKK) system -- AI-driven call evaluation with templates, criteria, and scoring.

**Tables Created:**

**`okk_templates`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| uuid | String(36) | UNIQUE |
| name | String(200) | NOT NULL |
| slug | String(100) | UNIQUE |
| type | String(30) | indexed |
| system_context | Text | nullable |
| evaluation_rules | Text | nullable |
| scoring_type | String(20) | default `fractional` |
| threshold_green / threshold_amber | Integer | defaults 70 / 40 |
| min_call_duration | Integer | default 0 |
| auto_evaluate | Boolean | default `true` |
| is_active | Boolean | default `true` |
| is_default | Boolean | default `false` |
| ai_model | String(100) | nullable |
| ai_temperature | Float | default 0.2 |
| ai_max_tokens | Integer | default 2000 |
| metadata_fields / objection_categories / text_fields | JSON | nullable |
| created_at / updated_at | DateTime | server_default now() |

**`okk_criteria`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| template_id | Integer FK -> okk_templates.id | CASCADE, indexed |
| name | String(100) | NOT NULL |
| description | String(500) | NOT NULL |
| block_name | String(100) | NOT NULL |
| block_order | Integer | default 0 |
| sort_order | Integer | default 0 |
| weight | Float | default 1.0 |
| is_required | Boolean | default `true` |

**`okk_results`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| uuid | String(36) | UNIQUE |
| template_id | Integer FK -> okk_templates.id | nullable |
| template_snapshot | JSON | frozen config for history |
| staff_id | Integer FK -> staff_users.id | indexed |
| staff_name | String(200) | nullable |
| session_id | String(100) | indexed |
| sales_session_id | Integer FK -> sales_sessions.id | nullable |
| caller_number / callee_number | String(20) | nullable |
| duration | Integer | nullable |
| call_date | DateTime | nullable |
| recording_url | String(500) | nullable |
| transcript | Text | nullable |
| evaluation | JSON | nullable |
| metadata_values / text_field_values | JSON | nullable |
| total_score | Integer | default 0 |
| raw_score / max_possible_score | Float | default 0 |
| source | String(20) | default `manual` |
| evaluated_by | String(100) | default `ai` |
| evaluated_at | DateTime | nullable |
| reviewed_by | Integer FK -> staff_users.id | nullable |
| reviewed_at | DateTime | nullable |
| review_comment | Text | nullable |
| created_at / updated_at | DateTime | server_default now() |

**Tables Altered:**
- `diagnostic_bookings`: ADD `transcript_json` JSON, `ai_hints_json` JSON

---

### #8. Add Diagnost Staff Profiles

| Field | Value |
|-------|-------|
| **File** | `add_diagnost_staff_profiles.py` |
| **Revision** | `a1b2c3d4e5f6` |
| **Down Revision** | `f9a2b3c4d5e6` |
| **Date** | 2026-02-16 |

**Description:** Extended diagnostician profiles with specialization, bio, photos, diplomas.

**Tables Created:**

**`diagnost_staff_profiles`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| staff_user_id | Integer FK -> staff_users.id | UNIQUE, indexed |
| specialization | String(200) | nullable |
| experience | String(100) | nullable |
| bio | Text | nullable |
| fun_facts | JSON | default `[]` |
| photo_urls | JSON | default `[]` |
| diplomas | JSON | default `[]` |
| created_at / updated_at | DateTime | server_default now() |

---

### #9. Add AI Pipeline Fields

| Field | Value |
|-------|-------|
| **File** | `add_ai_pipeline_fields.py` |
| **Revision** | `b2c3d4e5f6a7` |
| **Down Revision** | `040d525c6a43` (merge point -- see Dependency Graph) |
| **Date** | 2026-02-16 |

**Description:** AI pipeline integration -- semantic quiz answers, AI-generated client profiles, quiz-to-booking link.

**Tables Altered:**
- `quiz_submissions`: ADD `semantic_answers` JSONB (PostgreSQL native)
- `diagnostic_profiles`: ADD `ai_profile` JSONB
- `diagnostic_bookings`: ADD `quiz_submission_id` Integer FK -> quiz_submissions.id (named constraint `fk_diagnostic_bookings_quiz_submission_id`)

---

### #10. Add Product Comparison Table

| Field | Value |
|-------|-------|
| **File** | `add_product_comparison_table.py` |
| **Revision** | `f1a2b3c4d5e7` |
| **Down Revision** | `e8f1a2b3c4d5` |
| **Date** | 2026-02-16 |

**Description:** Product comparison matrix for 3-tier pricing display in presentations. Includes seed data for baseline rows.

**Tables Created:**

**`product_comparison_table`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| row_label | String(255) | NOT NULL |
| row_category | String(100) | nullable |
| row_type | String(20) | default `text` |
| sort_order | Integer | default 0, indexed |
| tier1_value / tier2_value / tier3_value | Text | nullable |
| tier1_label / tier2_label / tier3_label | String(100) | nullable |
| tier1_price / tier2_price / tier3_price | Integer | nullable |
| tier1_discount / tier2_discount / tier3_discount | Integer | nullable |
| tier1_installment_months / tier2/tier3 | Integer | nullable |
| tier1_installment_monthly / tier2/tier3 | Integer | nullable |
| library_item_id | Integer | nullable |
| library_item_type | String(50) | nullable |
| created_at / updated_at | DateTime | server_default now() |

**`product_tier_modules`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| tier_number | Integer | NOT NULL, indexed |
| library_item_id | Integer | NOT NULL |
| module_title | String(255) | nullable |
| module_thumbnail | String(1000) | nullable |
| sort_order | Integer | default 0 |
| created_at | DateTime | server_default now() |

Unique: `uq_product_tier_module` (tier_number, library_item_id)

**Seed Data:** Inserts metadata row (id=0) with 3-tier pricing, plus 21 feature comparison rows.

---

### #11. Add Product Groups and Wheel Bonuses

| Field | Value |
|-------|-------|
| **File** | `add_product_groups_and_wheel_bonuses.py` |
| **Revision** | `c5f9d3e7a2b1` |
| **Down Revision** | `b4e8c1d2f5a7` |
| **Date** | 2026-02-16 |

**Description:** Product grouping system and "wheel of fortune" bonuses for closing technique. Also links products to diagnostic bookings.

**Tables Created:**

**`product_groups`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| name | String(255) | NOT NULL |
| description | Text | nullable |
| is_default | Boolean | default `false` |
| status | String(20) | default `active` |
| created_at / updated_at | DateTime | server_default now() |

**`product_wheel_bonuses`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| product_id | Integer FK -> products.id | indexed |
| name | String(255) | NOT NULL |
| name_ru | String(255) | NOT NULL |
| value | Integer | NOT NULL |
| sector_size | Integer | default 1 |
| color | String(20) | nullable |
| closes_barrier | String(100) | nullable |
| sort_order | Integer | default 0 |
| is_active | Boolean | default `true` |
| created_at | DateTime | server_default now() |

**Tables Altered:**
- `products`: ADD `product_group_id` FK, `tier_order` Integer, `tier_label` String(100), `modules` JSON, `fast_decision_bonuses` JSON, `comparison_text` Text
- `diagnostic_bookings`: ADD `product_id` Integer FK -> products.id (indexed)

---

### #12. Expand Case Entry Model

| Field | Value |
|-------|-------|
| **File** | `expand_case_entry_model.py` |
| **Revision** | `d6a7b2c8f3e4` |
| **Down Revision** | `c5f9d3e7a2b1` |
| **Date** | 2026-02-16 |

**Description:** Extends case entries with CSV-imported fields for diagnostician case library.

**Tables Altered:**
- `case_entries`: ADD `strength_score` Integer, `daily_income` Float, `funnel_stage` String(50) (indexed), `story_full` Text, `story_short` Text

---

### #13. Add Diagnostician Favorite Cases

| Field | Value |
|-------|-------|
| **File** | `add_diagnostician_favorite_cases.py` |
| **Revision** | `e7f8g9h0i1j2` |
| **Down Revision** | `d6a7b2c8f3e4` |
| **Date** | 2026-02-16 |

**Description:** Many-to-many association table for diagnosticians to bookmark/favorite case entries.

**Tables Created:**

**`diagnostician_favorite_cases`**
| Column | Type | Notes |
|--------|------|-------|
| staff_user_id | Integer FK -> staff_users.id | PK, CASCADE |
| case_entry_id | Integer FK -> case_entries.id | PK, CASCADE |
| created_at | DateTime | server_default now() |

Composite PK: (staff_user_id, case_entry_id)

---

### #14. Add Product Table Versions and Bind

| Field | Value |
|-------|-------|
| **File** | `add_product_table_versions_and_bind.py` |
| **Revision** | `a2b3c4d5e6f7` |
| **Down Revision** | `f1a2b3c4d5e7` |
| **Date** | 2026-02-17 |

**Description:** Versioning system for product comparison tables. Allows multiple versions per product and binds to presentation templates.

**Tables Created:**

**`product_table_versions`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| product_id | Integer FK -> products.id | CASCADE, indexed |
| name | String(255) | nullable |
| status | String(20) | default `draft` |
| created_at / updated_at | DateTime | server_default now() |

**`presentation_template_products`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| presentation_id | Integer FK -> presentations.id | CASCADE, indexed |
| product_id | Integer FK -> products.id | CASCADE, indexed |
| table_version_id | Integer FK -> product_table_versions.id | SET NULL, indexed |
| created_at | DateTime | server_default now() |

Unique: `uq_presentation_product` (presentation_id, product_id)

**Tables Altered:**
- `product_comparison_table`: ADD `version_id` FK -> product_table_versions.id (CASCADE, indexed)
- `product_tier_modules`: ADD `version_id` FK -> product_table_versions.id (CASCADE, indexed), unique constraint changed from `uq_product_tier_module` to `uq_product_tier_module_version` (tier_number, library_item_id, version_id)

---

### #15. Add Sales Session Data

| Field | Value |
|-------|-------|
| **File** | `add_sales_session_data.py` |
| **Revision** | `b3c4d5e6f7a8` |
| **Down Revision** | `a2b3c4d5e6f7` |
| **Date** | 2026-02-17 |

**Description:** Generic JSON blob for sales session state (selected tier, objections, etc.).

**Tables Altered:**
- `sales_sessions`: ADD `session_data` JSON (nullable)

---

### #16. Add Template Prompts

| Field | Value |
|-------|-------|
| **File** | `add_template_prompts.py` |
| **Revision** | `c4d5e6f7a8b9` |
| **Down Revision** | `b3c4d5e6f7a8` |
| **Date** | 2026-02-18 |

**Description:** Per-template AI prompt overrides for presentation generation.

**Tables Created:**

**`presentation_template_prompts`**
| Column | Type | Notes |
|--------|------|-------|
| id | Integer PK | |
| template_id | Integer FK -> presentations.id | CASCADE, indexed |
| prompt_key | String(100) | NOT NULL |
| prompt_text | Text | NOT NULL |
| updated_by | Integer FK -> staff_users.id | nullable |
| updated_at | DateTime | server_default now() |

Unique: `uq_template_prompt_key` (template_id, prompt_key)

---

## 3. Dependency Graph

```
185c5eb6ae0c  (initial_schema, root)
    |
a3f2b7c9d1e4  (add_quiz_tables)
    |
b4e8c1d2f5a7  (add_sales_sessions)
    |
    +---------------------------+------------------------------+
    |                           |                              |
    v                           v                              v
c5f9d3e6a8b1                c5f9d3e7a2b1                  (BRANCH A:
(management_tables)         (product_groups_               Management)
    |                        wheel_bonuses)
    v                           |
d7a2b3c4e5f6                    v
(add_metric_nature)         d6a7b2c8f3e4
    |                       (expand_case_entry)
    v                           |
e8f1a2b3c4d5                    v
(add_pdca_v4_fields)        e7f8g9h0i1j2
    |                       (favorite_cases)    <-- BRANCH C: Products/Cases
    |
    +----------------------------+
    |                            |
    v                            v
f9a2b3c4d5e6                f1a2b3c4d5e7
(add_okk_tables)            (product_comparison_table)
    |                            |
    v                            v
a1b2c3d4e5f6                a2b3c4d5e6f7
(diagnost_profiles)         (product_table_versions)
    |                            |
    v                            v
040d525c6a43 (merge)        b3c4d5e6f7a8
    |                       (sales_session_data)
    v                            |
b2c3d4e5f6a7                     v
(ai_pipeline_fields)        c4d5e6f7a8b9
                            (template_prompts)     <-- HEAD (Branch B)
```

### Branch Summary

| Branch | Parent | Path | Head |
|--------|--------|------|------|
| **A (Management -> OKK -> AI)** | `b4e8c1d2f5a7` | management -> metric_nature -> pdca_v4 -> okk -> diagnost_profiles -> [merge] -> ai_pipeline | `b2c3d4e5f6a7` |
| **B (Management -> Products -> Templates)** | `e8f1a2b3c4d5` | product_comparison -> product_versions -> sales_session_data -> template_prompts | `c4d5e6f7a8b9` |
| **C (Products/Cases)** | `b4e8c1d2f5a7` | product_groups -> expand_case -> favorite_cases | `e7f8g9h0i1j2` |

### Merge Point

Revision `040d525c6a43` is a merge migration that unifies branches A and C. It is referenced as the down_revision of `b2c3d4e5f6a7` (ai_pipeline_fields) but its file is not present in the versions directory -- it was likely generated by `alembic merge` and may have been applied directly on the server.

---

## 4. Usage Commands

```bash
# Navigate to backend directory
cd ~/Projects/platform/veda-backend/

# ---- Create Migrations ----

# Auto-generate from model changes (most common)
alembic revision --autogenerate -m "add_new_feature_tables"

# Manual empty migration (for data migrations, raw SQL)
alembic revision -m "seed_default_products"

# Merge two branch heads
alembic merge -m "merge branches" <rev1> <rev2>

# ---- Apply Migrations ----

# Upgrade to latest
alembic upgrade head

# Upgrade one step
alembic upgrade +1

# Upgrade to specific revision
alembic upgrade a3f2b7c9d1e4

# ---- Check Status ----

# Current applied revision(s)
alembic current

# Show all heads (useful when branches exist)
alembic heads

# Show migration history
alembic history --verbose

# Show pending migrations
alembic history --indicate-current

# ---- Downgrade ----

# Downgrade one step
alembic downgrade -1

# Downgrade to specific revision
alembic downgrade b4e8c1d2f5a7

# Downgrade to base (remove all)
alembic downgrade base

# ---- Server Deployment ----
# On server: ssh root@109.73.194.217
cd /var/www/veda-backend/
source venv/bin/activate
alembic upgrade head
pm2 restart veda-api
```

---

## 5. Key Patterns

### CASCADE Deletes

Used consistently on child-to-parent relationships:

| Parent | Child | Cascade |
|--------|-------|---------|
| quizzes | quiz_steps | CASCADE |
| management_sprints | metric_targets, bottlenecks, retrospectives | CASCADE |
| management_tasks | daily_actions | CASCADE |
| management_metrics | daily_facts | CASCADE |
| okk_templates | okk_criteria | CASCADE |
| products | product_table_versions | CASCADE |
| product_table_versions | product_comparison_table (version_id), product_tier_modules (version_id) | CASCADE |
| presentations | presentation_template_products, presentation_template_prompts | CASCADE |
| staff_users / case_entries | diagnostician_favorite_cases | CASCADE (both sides) |

Note: `product_table_versions -> presentation_template_products.table_version_id` uses `SET NULL` (not CASCADE) to preserve the association record.

### Auto Timestamps

Pattern: `server_default=sa.func.now()` on `created_at` and `updated_at` columns. Applied in every table.

**Not auto-updated:** `updated_at` server_default only sets the initial value. Application-level update (SQLAlchemy `onupdate`) is handled in models, not migrations.

### JSON / JSONB Fields

| Table | Column | Type | Purpose |
|-------|--------|------|---------|
| quizzes | settings | JSON | Quiz config |
| quiz_steps | config | JSON | Step config |
| sales_sessions | transcript_json, ai_hints_json, session_data | JSON | Real-time data |
| diagnostic_bookings | transcript_json, ai_hints_json | JSON | Session recording |
| management_metric_targets | trend_values | JSON | Sparkline data |
| management_retrospectives | what_worked, what_failed, decisions, escalations | JSON | Retro data |
| okk_templates | metadata_fields, objection_categories, text_fields | JSON | Template config |
| okk_results | evaluation, metadata_values, text_field_values, template_snapshot | JSON | Frozen evaluation |
| products | modules, fast_decision_bonuses | JSON | Product config |
| diagnost_staff_profiles | fun_facts, photo_urls, diplomas | JSON | Profile arrays |
| quiz_submissions | semantic_answers | **JSONB** | AI-parsed answers |
| diagnostic_profiles | ai_profile | **JSONB** | AI-generated profile |

**Note:** Most JSON columns use generic `sa.JSON()`. Only `semantic_answers` and `ai_profile` use PostgreSQL-native `JSONB` (from `sqlalchemy.dialects.postgresql`) for indexing and query support.

### Unique Constraints (Named)

| Name | Table | Columns |
|------|-------|---------|
| `uq_unit_metric_slug` | management_metrics | (unit_id, slug) |
| `uq_sprint_metric` | management_metric_targets | (sprint_id, metric_id) |
| `uq_metric_date` | management_daily_facts | (metric_id, date) |
| `uq_sprint_unit_retro` | management_retrospectives | (sprint_id, unit_id) |
| `uq_parent_child_metric` | management_metric_tree | (parent_metric_id, child_metric_id) |
| `uq_product_tier_module_version` | product_tier_modules | (tier_number, library_item_id, version_id) |
| `uq_presentation_product` | presentation_template_products | (presentation_id, product_id) |
| `uq_template_prompt_key` | presentation_template_prompts | (template_id, prompt_key) |

### Indexes

Explicit indexes beyond PKs and unique constraints:

| Index | Table | Columns |
|-------|-------|---------|
| `ix_quizzes_slug` | quizzes | slug (unique) |
| `ix_quiz_steps_quiz_id` | quiz_steps | quiz_id |
| `ix_product_comparison_table_sort_order` | product_comparison_table | sort_order |
| `ix_product_comparison_table_version_id` | product_comparison_table | version_id |
| `ix_product_tier_modules_tier_number` | product_tier_modules | tier_number |
| `ix_product_tier_modules_version_id` | product_tier_modules | version_id |
| `ix_products_product_group_id` | products | product_group_id |
| `ix_product_wheel_bonuses_product_id` | product_wheel_bonuses | product_id |
| `ix_product_table_versions_product_id` | product_table_versions | product_id |
| `ix_diagnostic_bookings_product_id` | diagnostic_bookings | product_id |
| `ix_case_entries_funnel_stage` | case_entries | funnel_stage |
| `ix_presentation_template_products_*` | presentation_template_products | presentation_id, product_id |
| sales_sessions implicit | sales_sessions | manager_id, client_id, status |
| okk_results implicit | okk_results | staff_id, session_id |

### Foreign Key Naming

Named constraints are used selectively:
- `fk_diagnostic_bookings_quiz_submission_id` -- explicit name on FK added in add_ai_pipeline_fields

Most FKs use Alembic auto-naming.

---

## 6. Summary Statistics

| Metric | Value |
|--------|-------|
| **Total migrations** | 16 files (+ 1 merge `040d525c6a43` not present) |
| **Date range** | 2026-02-08 to 2026-02-18 (11 days) |
| **New tables created** | 20 |
| **Tables altered** | 7 (management_units, management_metrics, management_sprints, management_tasks, products, diagnostic_bookings, sales_sessions, quiz_submissions, diagnostic_profiles, case_entries, product_comparison_table, product_tier_modules) |
| **Columns added to existing tables** | ~25 |
| **Branch heads** | 3 (`b2c3d4e5f6a7`, `c4d5e6f7a8b9`, `e7f8g9h0i1j2`) |
| **Named unique constraints** | 8 |
| **Explicit indexes** | 14+ |
| **JSON/JSONB columns** | 22 (20 JSON + 2 JSONB) |
| **CASCADE delete relationships** | 12+ |

### Tables Created by Migration

| Migration | Tables Created |
|-----------|----------------|
| add_quiz_tables | quizzes, quiz_steps |
| add_sales_sessions | sales_sessions |
| add_management_tables | management_units, management_metrics, management_sprints, management_metric_targets, management_bottlenecks, management_tasks, management_daily_actions, management_daily_facts, management_retrospectives, management_metric_tree |
| add_okk_tables | okk_templates, okk_criteria, okk_results |
| add_diagnost_staff_profiles | diagnost_staff_profiles |
| add_product_comparison_table | product_comparison_table, product_tier_modules |
| add_product_groups_and_wheel_bonuses | product_groups, product_wheel_bonuses |
| add_diagnostician_favorite_cases | diagnostician_favorite_cases |
| add_product_table_versions_and_bind | product_table_versions, presentation_template_products |
| add_template_prompts | presentation_template_prompts |
