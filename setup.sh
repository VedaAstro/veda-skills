#!/bin/bash
# Одноразовая настройка навыков Veda для Claude Code
# Запусти один раз: ./setup.sh
# Создаёт симлинк ~/.claude/skills → Google Drive/Claude Skills

set -e

SKILLS_DIR="$HOME/.claude/skills"

echo ""
echo "=== Настройка навыков Veda для Claude Code ==="
echo ""

# Ищем Google Drive
GDRIVE_ROOT="$HOME/Library/CloudStorage"
GDRIVE_SKILLS=""

if [ -d "$GDRIVE_ROOT" ]; then
  for gd in "$GDRIVE_ROOT"/GoogleDrive-*/; do
    for drive_name in "Мой диск" "My Drive"; do
      candidate="$gd/$drive_name/Claude Skills"
      if [ -d "$candidate" ]; then
        GDRIVE_SKILLS="$candidate"
        break 2
      fi
    done
  done
fi

if [ -z "$GDRIVE_SKILLS" ]; then
  echo "  Google Drive не найден или папка 'Claude Skills' не доступна."
  echo ""
  echo "  Что сделать:"
  echo "  1. Установи Google Drive for Desktop"
  echo "  2. Попроси расшарить тебе папку 'Claude Skills'"
  echo "  3. Запусти ./setup.sh ещё раз"
  exit 1
fi

echo "  Google Drive: $GDRIVE_SKILLS"

# Проверяем навыки
skill_count=$(find "$GDRIVE_SKILLS" -maxdepth 2 -name "SKILL.md" | wc -l | tr -d ' ')
echo "  Навыков найдено: $skill_count"

if [ "$skill_count" -eq 0 ]; then
  echo "  Папка пустая. Подожди пока навыки синхронизируются с Google Drive."
  exit 1
fi

# Если ~/.claude/skills — обычная папка, бэкапим
if [ -d "$SKILLS_DIR" ] && [ ! -L "$SKILLS_DIR" ]; then
  echo "  Бэкаплю старые навыки в ~/.claude/skills-backup"
  mv "$SKILLS_DIR" "$HOME/.claude/skills-backup"
fi

# Если уже симлинк — удаляем
if [ -L "$SKILLS_DIR" ]; then
  rm "$SKILLS_DIR"
fi

# Создаём симлинк
mkdir -p "$HOME/.claude"
ln -s "$GDRIVE_SKILLS" "$SKILLS_DIR"

echo ""
echo "=== Готово! ==="
echo ""
echo "  ~/.claude/skills -> $GDRIVE_SKILLS"
echo ""
echo "  $skill_count навыков доступны. Обновления приходят через Google Drive автоматически."
echo ""
