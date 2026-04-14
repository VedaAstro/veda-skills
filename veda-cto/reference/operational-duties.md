# Операционные обязанности CTO VEDA

> Конкретные действия. Не теория - чеклисты с частотой.

## Ежедневно (5 мин, автоматизировано)

- [x] **Uptime всех сервисов** - healthcheck.sh каждые 5 мин, алерт в Telegram при падении
- [x] **Бэкапы БД** - /root/backup-db.sh в 04:00 UTC, 6 баз, offsite на S3
- [ ] **PM2 рестарты** - проверять: если restarts растёт > 10/день, разобраться с причиной
- [ ] **Логи ошибок** - pm2 logs --err, grep CRITICAL/ERROR

## Еженедельно (понедельник, 30 мин)

- [ ] **Диск** - df -h, если > 80% - почистить логи и старые релизы
- [ ] **npm audit** - по всем проектам, 0 critical/high
- [ ] **Незакоммиченные файлы** - git status по всем 12 проектам
- [ ] **Deploy-guard.sh** - протестировать 3 обхода
- [ ] **Расходы AI** - ccusage monthly, бюджет в норме?
- [ ] **Техдолг** - 1-2 часа на любой пункт из TECH-DEBT-LOG.md

## Ежемесячно (1-е число, 2 часа)

- [ ] **SSL сертификаты** - проверить expiry всех доменов
- [ ] **Тест восстановления** - поднять 1 проект из бэкапа (БД + код)
- [ ] **Slow queries** - pg_stat_statements, добавить индексы
- [ ] **Web Vitals** - LCP/CLS для основных сайтов
- [ ] **Memory leaks** - pm2 monit, тренды RAM
- [ ] **Обновления ОС** - apt update/upgrade на сервере

## Ежеквартально (1 день)

- [ ] **Аудит доступов** - кто имеет SSH, БД, API-ключи, панели
- [ ] **Ротация секретов** - сменить API-ключи которым > 90 дней
- [ ] **Инвентаризация техдолга** - полный список, Impact/Effort
- [ ] **Disaster Recovery тест** - поднять платформу с нуля на чистом сервере
- [ ] **Vendor lock-in** - от каких сервисов зависим, есть ли альтернативы
- [ ] **Документация для преемника** - обновить, проверить полноту

## Что автоматизировано

| Что | Как | Где |
|-----|-----|-----|
| Uptime 8 сервисов | healthcheck.sh каждые 5 мин | /root/healthcheck.sh |
| Бэкап 6 БД | backup-db.sh ежедневно 04:00 | /root/backup-db.sh |
| Offsite бэкап | offsite-backup.sh 04:30 -> S3 | /root/offsite-backup.sh |
| Deploy guard | hook PreToolUse Bash | ~/.claude/hooks/deploy-guard.sh |
| Security scan | scheduled task Ср+Сб | security-scan |
| Memory hygiene | scheduled task 1-е и 15-е | memory-hygiene |

## Что НЕ автоматизировано (TODO)

| Что | Приоритет | Как автоматизировать |
|-----|-----------|---------------------|
| Лог деплоев (кто/когда/что) | Высокий | Добавить запись в /var/log/deploy.log в каждый deploy.sh |
| Deploy-скрипты для 6 проектов | Высокий | Написать deploy.sh для veda-base, veda-chat, vedalab, hr-bot, veda-bot-v2, diagnostic-bot |
| npm audit по всем проектам | Средний | Серверный cron или scheduled task |
| SSL expiry check | Средний | cron + telegram alert |
| Disk space alert | Средний | Добавить в healthcheck.sh |
| pg slow queries alert | Низкий | pg_stat_statements + cron |
