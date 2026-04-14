# BFF Routes (215+ endpoints)

## Auth
- POST /api/auth/login
- GET /api/auth/me
- POST /api/auth/refresh
- POST /api/auth/register
- POST /api/auth/change-password

## Staff
- GET/POST /api/staff/
- GET/PUT /api/staff/[userId]
- GET /api/staff/[userId]/schedule
- GET /api/staff/calendar-slots
- GET /api/staff/permissions
- GET /api/staff/roles

## CRM - Clients
- GET/POST /api/crm/clients/
- GET/PUT /api/crm/clients/[id]
- GET /api/crm/clients/[id]/history
- GET /api/crm/clients/[id]/quiz-data
- POST /api/crm/clients/[id]/rebuild-chart

## CRM - Appointments
- GET/POST /api/crm/appointments/
- GET/PUT /api/crm/appointments/[id]
- POST /api/crm/appointments/[id]/move
- GET /api/crm/appointments/[id]/data
- GET /api/crm/appointments/[id]/transcript
- GET/PUT /api/crm/appointments/[id]/result
- GET /api/crm/appointments/[id]/current-slide
- GET /api/crm/appointments/[id]/presentation
- POST /api/crm/appointments/quick
- GET /api/crm/appointments/by-profile/[profileId]
- GET /api/crm/appointments/range
- GET /api/crm/appointments/today

## CRM - Deals
- GET/POST /api/crm/deals/
- GET /api/crm/deals/kanban

## CRM - Funnel
- GET /api/crm/funnel/[funnelType]
- POST /api/crm/funnel/[funnelType]/[cardId]/move

## Sales
- GET/POST /api/sales/sessions
- GET/PUT /api/sales/sessions/[id]
- POST /api/sales/sessions/[id]/end
- GET /api/sales/clients
- POST /api/sales/teaser
- POST /api/sales/ai-hint
- POST /api/sales/ai-chat
- POST /api/sales/chart-reading

## Analytics
- GET /api/analytics/funnel
- GET /api/analytics/kpi
- GET /api/analytics/departments
- GET /api/analytics/managers
- GET /api/analytics/manager/[id]
- GET /api/analytics/sales-kpi
- GET /api/analytics/teaser-effectiveness
- GET /api/analytics/trends
- GET /api/analytics/week-stats

## OKK
- GET/POST /api/okk/templates
- GET/PUT /api/okk/templates/[id]
- POST /api/okk/templates/[id]/duplicate
- GET/POST /api/okk/templates/[id]/criteria
- PUT/DELETE /api/okk/templates/[id]/criteria/[criterionId]
- POST /api/okk/templates/[id]/criteria/reorder
- GET/POST /api/okk/results
- GET/PUT /api/okk/results/[id]
- GET /api/okk/results/analytics
- POST /api/okk/evaluate
- POST /api/okk/transcribe-long

## Presentations
- GET/POST /api/presentations
- GET/PUT/DELETE /api/presentations/[id]
- GET /api/presentations/available
- POST /api/presentations/[id]/batch
- GET/PUT/DELETE /api/presentations/[id]/slides/[slideId]
- POST/GET /api/presentations/[id]/slides/[slideId]/script
- POST /api/presentations/[id]/chat
- GET /api/presentations/[id]/chat/history
- POST /api/presentations/[id]/chat/undo

## Presentation Templates
- GET/POST /api/presentation-templates/
- GET/PUT/DELETE /api/presentation-templates/[id]
- POST /api/presentation-templates/[id]/duplicate
- GET/POST /api/presentation-templates/[id]/versions
- POST /api/presentation-templates/[id]/visibility
- POST /api/presentation-templates/[id]/activate
- POST /api/presentation-templates/[id]/archive
- GET/POST /api/presentation-templates/[id]/assignments
- DELETE /api/presentation-templates/[id]/assignments/[diagId]
- POST /api/presentation-templates/promote
- GET/PUT /api/presentation-templates/[id]/prompts

## Management
### Sprints
- GET/POST /api/management/sprints
- GET /api/management/sprints/current
- GET/PUT /api/management/sprints/[id]
- POST /api/management/sprints/[id]/activate
- POST /api/management/sprints/[id]/close
- GET/POST /api/management/sprints/[id]/targets
- GET /api/management/sprints/[id]/bottlenecks
- GET/POST /api/management/sprints/[id]/retro

### Metrics
- GET/POST /api/management/metrics
- GET/PUT /api/management/metrics/[id]
- GET /api/management/metrics/[id]/history
- GET /api/management/metrics/tree
- GET/POST /api/management/metrics/computed-values
- GET /api/management/metrics/what-if

### Tasks
- GET/POST /api/management/tasks
- GET/PUT/DELETE /api/management/tasks/[id]
- GET/POST /api/management/tasks/[id]/daily-actions
- POST /api/management/tasks/[id]/result

### Daily & Targets
- GET/PUT /api/management/daily-actions/[id]
- GET/POST /api/management/daily-facts
- POST /api/management/daily-facts/bulk
- GET/POST /api/management/targets
- GET/PUT /api/management/targets/[id]
- POST /api/management/targets/bulk
- GET/POST /api/management/bottlenecks
- GET/PUT /api/management/bottlenecks/[id]
- GET/POST /api/management/units
- GET/PUT /api/management/units/[id]

### Analytics & AI
- GET /api/management/analytics/overview
- GET /api/management/analytics/metric-trend
- GET /api/management/analytics/sprint-comparison
- GET /api/management/analytics/execution-discipline
- GET /api/management/analytics/forecast-accuracy
- GET /api/management/analytics/gap-decomposition
- GET /api/management/analytics/escalation-alerts
- POST /api/management/ai/chat
- POST /api/management/ai/suggest-rca
- POST /api/management/ai/weekly-report/[id]
- GET /api/management/export/dashboard
- GET /api/management/export/sprint/[id]

## Quizzes
- GET/POST /api/quizzes/
- GET/PUT/DELETE /api/quizzes/[id]
- POST /api/quizzes/[id]/duplicate
- POST /api/quizzes/[id]/batch
- GET /api/quiz/config
- POST /api/quiz/submit

## Products
- GET/POST /api/products/
- GET/PUT /api/products/[id]
- GET /api/products/groups
- GET /api/products/resolved-offer
- GET/POST /api/products/table/
- GET/PUT /api/products/table/[rowId]
- POST /api/products/table/reorder
- GET/POST /api/products/table-versions/
- GET/PUT /api/products/[id]/wheel-bonuses

## Astro & Diagnostic
- POST /api/create-chart
- POST /api/rebuild-chart
- POST /api/analyze
- POST /api/astro-context
- POST /api/chart-interpretation
- GET /api/chart-interpretation/slices
- POST /api/transit
- POST /api/dasha
- GET/POST /api/wheel-result
- POST /api/diagnostic/generate-script
- POST /api/diagnostic/generate-all
- GET/PUT /api/diagnostic/[sessionId]

## Other
- GET /api/admin/dashboard
- GET/POST /api/knowledge/
- POST /api/media/upload
- GET/POST /api/settings/
- GET /api/tokens/balance
- GET /api/tokens/usage
- POST /api/transcribe
- POST /api/video/room
- GET /api/geo/cities
- GET /api/diagnosticians
- GET/POST/PUT/DELETE /api/clients/[profileId]/notes/*
- GET/POST/PUT/DELETE /api/goals/*
- GET/POST /api/cases/*

## Key Patterns
- All routes proxy to BACKEND_URL (FastAPI port 8000)
- Auth via getAuthUser() + getAuthHeaders()
- CRM data: always cache: 'no-store'
- Public endpoints: /api/public/*, /api/quiz/config
