# FixerAIbot Memory

SSOT по работе с контуром `@FixerAIbot`.

## 1. Что это за контур

`@FixerAIbot` — бот для приёма, ведения и проверки багов из Telegram-группы `Veda платформа`.

Он связан с:

- PostgreSQL БД `veda`
- таблицей `monitor_tasks`
- PM2-процессом `veda-monitor`
- кодом в `/Users/alex/Projects/platform/veda-monitor-bot`

## 2. Источник правды

Если что-то расходится между “кажется” и фактами, смотри сюда:

- `/Users/alex/Projects/platform/veda-monitor-bot/tasks/handlers.py`
- `/Users/alex/Projects/platform/veda-monitor-bot/tasks/formatters.py`
- `/Users/alex/Projects/platform/veda-monitor-bot/complete_task.py`
- `/Users/alex/Projects/platform/veda-monitor-bot/db.py`
- прод-логи `pm2 logs veda-monitor`
- прод-БД `monitor_tasks`

## 3. Карта проектов и куда вести баг

| Домен / URL | Проект | PM2 | Локальный путь | Прод-путь |
|---|---|---|---|---|
| `new.astroguru.ru`, `/chat` | `app-myveda` | `app-myveda` | `/Users/alex/Projects/platform/app-myveda` | `/root/app-myveda` |
| `sales.myveda.ru` | `veda-presentation` | `veda-presentation` | `/Users/alex/Projects/platform/veda-presentation` | `/root/veda-presentation` + runtime `/var/www/veda-presentation` |
| `funnel.myveda.ru`, chat/admin API | `bot-admin-api` | `bot-admin-api` | `/Users/alex/Projects/platform/bot-admin-api` | `/root/bot-admin-api` |
| sales backend / CRM / bookings | `veda-backend` | `veda-api` | `/Users/alex/Projects/platform/veda-backend` | `/var/www/veda-backend` |
| Fixer bot | `veda-monitor-bot` | `veda-monitor` | `/Users/alex/Projects/platform/veda-monitor-bot` | `/root/veda-monitor-bot` |

## 4. Статусы задач

Базовый lifecycle:

`new -> clarifying -> ready -> in_progress -> testing -> done/rejected`

Также в коде и практике встречаются:

- `analyzing`
- `review`

Фактическая семантика:

- `new` — задача принята, ещё не формализована до конца
- `clarifying` — бот ждёт уточнений
- `ready` — задача оформлена и готова к работе
- `in_progress` — задача в работе или вернулась после `❌`
- `testing` — fix задеплоен, ждём валидацию репортёра
- `done` — репортёр нажал `✅`
- `rejected` — задача закрыта как неактуальная/не нужна

## 5. Поля monitor_tasks, которые реально важны

| Поле | Что значит |
|---|---|
| `id` | Номер задачи |
| `title` | Короткий заголовок |
| `description` | Исходный текст задачи |
| `formalized_text` | Формализованная карточка + история итераций отказа |
| `resolution_text` | Что было сделано на последнем цикле |
| `rejection_reason` | Последняя явная причина отказа |
| `status` | Текущий статус |
| `reporter_id` | Telegram id автора |
| `reporter_name` | Имя автора |
| `reporter_username` | username для тега |
| `group_chat_id` | id группы |
| `group_message_id` | id исходного сообщения автора |
| `group_bot_message_id` | id сообщения бота для group log / follow-ups |
| `group_log_text` | накапливаемый лог задачи в группе |
| `github_issue_url` | связанная issue, если есть |

Критично:

- `formalized_text` часто содержит реальную историю проблемы лучше, чем `description`
- старые отказы могли попасть только в `formalized_text`, без `rejection_reason`

## 6. Реальный callback lifecycle

### 6.1 Успех

Кнопка:

- `test:ok:{id}`

Что делает:

- переводит задачу в `done`
- ставит `completed_at`
- может закрыть GitHub issue
- редактирует сообщение в группе на подтверждённое

Смотри: `testing_callback_handler()`

### 6.2 Отказ

Кнопка:

- `test:fail:{id}`

Что делает:

- не завершает задачу сразу
- редактирует тестовое сообщение
- показывает три кнопки детализации:
  - `fail_detail:{id}:unchanged`
  - `fail_detail:{id}:partial`
  - `fail_detail:{id}:other`

### 6.3 fail_detail

#### `unchanged`

Сразу вызывает `_handle_failure_description(...)` с автотекстом:

- задача уходит в `in_progress`
- отказ пишется в `formalized_text`
- отказ пишется в `rejection_reason`

#### `partial` / `other`

Бот делает follow-up:

- сообщение вида `#{id} — Что работает, а что нет? Ответь на это сообщение.`
- id этого bot-message кладётся в `_pending_failure_msgs`
- когда тестер отвечает reply-сообщением, бот сопоставляет reply -> task_id -> `_handle_failure_description(...)`

### 6.4 Что сейчас важно помнить

- Если в чате видно follow-up вопрос бота, это ещё не значит, что callback “потерялся”.
- Нужно проверять:
  - ушла ли задача в `in_progress`
  - появился ли новый кусок в `formalized_text`
  - записался ли `rejection_reason`

С 2026-04-04 новый fail-flow пишет причину ещё и в `rejection_reason`.

## 7. Как понять, что отказ реально записался

Признаки настоящего зафиксированного отказа:

- `status='in_progress'`
- в `formalized_text` добавлен блок `--- Итерация N — Что не работало ---`
- для новых отказов есть `rejection_reason`

Если этого нет, смотри:

- был ли вообще callback `test:fail:{id}`
- ответил ли тестер reply именно на бот-сообщение
- нет ли traceback в `pm2 logs veda-monitor`

## 8. Канонический формат отчёта в группу

Правила:

- первая строка — `@username`
- текст короткий, без техжаргона
- обязательно написать, что сделано для пользователя
- обязательно дать понятные шаги проверки
- в конце: `Ctrl+Shift+R если кеш`
- кнопки: `✅ Работает` / `❌ Не работает`

Хороший шаблон:

```text
@alina_khoryaeva
🔧 Задача #126 на проверке

Что сделано: исправлена логика выбора времени при смене диагноста. Теперь можно выбрать только реальные открытые слоты.

Как проверить:
1. Открыть нужную запись в календаре
2. Сменить диагноста или выбрать "Не назначен"
3. Убедиться, что доступны только реальные свободные слоты
4. Если слотов нет, время не выбирается и запись не сохраняется

Ctrl+Shift+R если кеш
```

Плохо:

- без `@тега`
- длинное техническое объяснение root cause
- отчёт без кнопок
- отчёт без шагов проверки

## 9. Что писать в resolution_text

`resolution_text` — это внутренняя выжимка “что сделали”.

Пиши:

- коротко
- на понятном русском
- без лишних инфраструктурных деталей

Хорошо:

- `Исправлена логика выбора времени при смене диагноста. Теперь доступны только реальные свободные слоты.`

Плохо:

- `Прокинут diagnosticianId в move route, убран stale fallback, добавлена серверная валидация slot availability.`

## 10. Что обычно идёт не так

### 10.1 Кажется, что callback не записался

Частая ложная тревога.

Проверь:

- `status`
- `formalized_text`
- `rejection_reason`
- логи `veda-monitor`

Исторически проблема была не в потере callback, а в том, что причина отказа не дублировалась в `rejection_reason`.

### 10.2 Отчёт ушёл, но без тега

Это ошибка процесса.

Новый стандарт: каждый отчёт начинается с `@reporter_username`.

### 10.3 Deploy-скрипт `veda-presentation` упал на `.next/cache`

Рабочий fallback:

1. `rsync` runtime `.next/` без `.next/cache`
2. `rsync public/`
3. `pm2 reload veda-presentation --update-env`
4. `curl` health-check

### 10.4 Кажется, что баг “не починился”, но на деле не обновился кеш

Если это фронт:

- укажи в отчёте `Ctrl+Shift+R если кеш`
- при перепроверке сам тоже учитывай кеш браузера

## 11. Минимальный checklist перед отчётом

- root cause проверен
- fix применён
- локальная проверка пройдена
- deploy подтверждён пользователем
- prod reload прошёл
- health-check зелёный
- `monitor_tasks.status` обновлён
- `resolution_text` записан
- tagged-отчёт отправлен в группу

## 12. Рабочие команды

### Проверить задачу на проде

```bash
ssh root@109.73.194.217 "python3 - <<'PY'
import psycopg2
conn = psycopg2.connect(host='localhost', dbname='veda', user='veda', password='vedalab2026')
cur = conn.cursor()
cur.execute(\"\"\"
SELECT id, status, title, reporter_username, rejection_reason, resolution_text
FROM monitor_tasks
WHERE id = %s
\"\"\", (126,))
print(cur.fetchone())
cur.close()
conn.close()
PY"
```

### Посмотреть историю отказов

```bash
ssh root@109.73.194.217 "python3 - <<'PY'
import psycopg2
conn = psycopg2.connect(host='localhost', dbname='veda', user='veda', password='vedalab2026')
cur = conn.cursor()
cur.execute('SELECT formalized_text FROM monitor_tasks WHERE id = %s', (126,))
row = cur.fetchone()
print(row[0] if row else 'not found')
cur.close()
conn.close()
PY"
```

### Проверить fail-flow бота

```bash
ssh root@109.73.194.217 "pm2 logs veda-monitor --lines 100 --nostream"
```

## 13. Где делать deploy

### app-myveda

```bash
rsync -avz --exclude '.env' --exclude 'node_modules' --exclude '.git' --exclude '.next' \
  /Users/alex/Projects/platform/app-myveda/ root@109.73.194.217:/root/app-myveda/
ssh root@109.73.194.217 '/root/deploy-app-myveda.sh'
```

### bot-admin-api

```bash
rsync -avz --exclude '.env' --exclude 'venv' --exclude '__pycache__' --exclude '.git' \
  /Users/alex/Projects/platform/bot-admin-api/ root@109.73.194.217:/root/bot-admin-api/
ssh root@109.73.194.217 '/root/deploy-bot-admin-api.sh'
```

### veda-presentation

```bash
rsync -avz --exclude '.env' --exclude 'node_modules' --exclude '.git' --exclude '.next' \
  /Users/alex/Projects/platform/veda-presentation/ root@109.73.194.217:/root/veda-presentation/
ssh root@109.73.194.217 '/root/deploy-veda-presentation.sh'
```

### veda-backend

```bash
rsync -avz --exclude '.env' --exclude 'venv' --exclude '__pycache__' --exclude '.git' \
  /Users/alex/Projects/platform/veda-backend/ root@109.73.194.217:/var/www/veda-backend/
ssh root@109.73.194.217 'pm2 reload veda-api'
```

### veda-monitor-bot

```bash
rsync -avz --exclude '__pycache__' --exclude '.git' \
  /Users/alex/Projects/platform/veda-monitor-bot/ root@109.73.194.217:/root/veda-monitor-bot/
ssh root@109.73.194.217 'pm2 reload veda-monitor'
```

## 14. Главное правило

У дебагера цикл считается завершённым не после фикса и не после deploy, а только после:

1. deploy
2. обновления `monitor_tasks`
3. tagged-отчёта в группу
4. кнопки `✅` от репортёра или явного решения owner-а закрыть задачу
