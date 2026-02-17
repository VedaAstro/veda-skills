# Veda Skills for Claude Code

Набор навыков (Skills) для Claude Code, содержащих проектные знания платформы Veda.

## Установка

```bash
git clone https://github.com/VedaAstro/veda-skills.git
cd veda-skills
./install.sh
```

Навыки будут скопированы в `~/.claude/skills/` и станут доступны в следующей сессии Claude Code.

## Обновление

```bash
cd veda-skills
git pull
./install.sh
```

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
