# Veda Skills for Claude Code

Набор навыков (Skills) для Claude Code, содержащих проектные знания платформы Veda.

## Как работает

Навыки лежат в папке **Claude Skills** на Google Drive. При каждом запуске Claude Code они автоматически подтягиваются. Ничего делать не надо -- работает как синхронизация Google Drive.

### Для админа (обновление навыков)

Просто обновляешь файлы в папке `Google Drive / Claude Skills`. Google Drive синхронизирует. При следующем запуске Claude Code у всех членов команды навыки обновятся.

### Для члена команды (первая настройка)

1. Убедись что у тебя есть доступ к папке `Claude Skills` на Google Drive
2. Установи Google Drive for Desktop (если ещё нет)
3. Запусти в терминале:

```bash
git clone https://github.com/VedaAstro/veda-skills.git ~/veda-skills
~/veda-skills/setup.sh
```

Всё. Дальше навыки обновляются автоматически.

## Навыки

### Технические

| Навык | Описание |
|-------|----------|
| `veda-deploy` | Деплой на сервер: rsync, PM2, env-переменные, build |
| `veda-backend-patterns` | Паттерны FastAPI: Enum gotchas, роуты, BFF |
| `vedic-astro-knowledge` | Цепочка астро-данных: API, трактовки, LLM, резолверы |
| `veda-skill-creator` | Мета-навык: как создавать новые навыки |
| `diagnostic-workstation` | Сократическая диагностика: 3 волны, 9 срезов |

### Контент и маркетинг

| Навык | Описание |
|-------|----------|
| `prompt-engineering` | 28 техник создания промптов для LLM |
| `webinar-architect` | Проектирование вебинаров: Hormozi, слайды, скрипты |
| `buyer-persona` | Сегменты аудитории, барьеры, decision trees |
| `astro-content` | Справочник астрологии для контента |
| `webinar-production` | Голос спикера, продукт, кейсы, пруфы |
