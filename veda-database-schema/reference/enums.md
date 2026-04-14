# Enums Reference (Backend + Frontend)

## Backend (Python - db/models.py)

### Staff
**StaffRole**: diagnostician, department_head, tech_admin, super_admin
**Permission**: view_own_metrics, view_all_metrics, edit_scripts, set_goals, manage_staff, view_client_data, edit_presentation_settings, edit_presentations, view_presentations, manage_presentations, manage_roles, manage_products, manage_schedule, view_management, edit_daily_facts, manage_sprints, manage_management_tasks, manage_targets, manage_metrics, view_all_management

### CRM
**ClientStatus**: new, qualified, scheduled, diagnostic_done, thinking, purchased, rejected
**DealStatus**: thinking, followup, payment, completed, rejected
**PaymentStatus**: pending, partial, paid, refunded
**AppointmentResult**: sale, thinking, rejected, no_show, followup
**ConfirmationStatus**: pending, confirmed, not_confirmed
**InteractionType**: message, reminder_sent, confirmation, status_change, note, call, appointment
**InteractionChannel**: telegram, whatsapp, phone, email, system
**NoteType**: general, pain, barrier, followup, important
**TaskType** (CRM): confirm, followup, schedule, call, custom
**TaskStatus**: pending, done, skipped

### Goals
**GoalType**: conversion, revenue, session_count, average_check
**GoalPeriod**: daily, weekly, monthly, quarterly

### Products
**ProductStatus**: active, draft, archived
**TemplateType**: reminder_24h, reminder_2h, reminder_15min, confirmation, followup_soft, followup_hard, reactivation, no_show

### Management/PDCA
**SprintStatus**: planning, active, review, closed
**MetricType**: percentage, currency, count
**MetricNature**: leading, lagging
**TrendDirection**: up, down, flat
**BottleneckStatus**: identified, action_planned, resolved, escalated
**RCACategory**: process, people, technology, market
**ManagementTaskStatus**: pending, in_progress, completed, cancelled, blocked
**TaskPriority**: critical, high, normal, low
**Confidence**: high, medium, low
**ResultDecision**: continue, pivot, escalate, cancel
**DailyActionStatus**: planned, done, failed, skipped
**TaskType** (Management): metric, operational, backlog
**TaskSource**: sprint, debug, retro, ad_hoc
**FactSource**: manual, api, calculated

---

## Frontend (TypeScript - app/types/)

### Core Types (index.ts)
**PainSphere**: money, relationships, realization, health
**PainSubtype**: debts, ceiling, not_holding, hates_job, no_partner, conflicts, divorce, codependency, dont_know_want, know_but_dont_do, do_but_fail, success_but_empty, chronic_fatigue, psychosomatic, anxiety, addictions
**BarrierType**: money, time, think, husband, capability, age
**Planet**: sun, moon, mars, mercury, jupiter, venus, saturn, rahu, ketu
**House**: 1-12
**ZodiacSign**: aries..pisces
**PlanetStatus**: damaged, strong, transit, neutral
**DiagnosticBlock**: 0-6
**VisualId**: 1-17
**PresentationVersion**: v2, v3, custom-{number}

### Sales (sales.ts)
**SalesSessionStatus**: preparing, calling, in_call, post_call, completed
**CallOutcome**: sale, callback, rejected, no_answer, thinking, pending
**ScriptPhase**: greeting, astro_hook, pain_discovery, presentation, objection, close
**AIHintType**: objection, product, talking_point, warning, astro_tip

### Management (management.ts)
Same as backend PDCA enums (SprintStatus, MetricType, etc.)

### OKK (okk.ts)
**ScoringType**: binary, fractional, custom
**OKKResultSource**: manual, webhook, session, upload

---

## CRITICAL: StaffRole Gotcha
```python
StaffRole.DIAGNOSTIC_MANAGER.value = "diagnostician"  # NOT "diagnostic_manager"!
```

## CRITICAL: SQLAlchemy Comparisons
```python
# CORRECT
.filter(Deal.status == DealStatus.THINKING.value)

# WRONG (silently fails!)
.filter(Deal.status == DealStatus.THINKING)
```
