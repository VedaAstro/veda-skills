#!/bin/bash
# Одноразовая настройка навыков Veda для Claude Code
# Запусти один раз: ./setup.sh
# После этого навыки синхронизируются через Google Drive автоматически

set -e

SKILLS_DIR="$HOME/.claude/skills"
HOOKS_DIR="$HOME/.claude/hooks"
SETTINGS="$HOME/.claude/settings.json"

echo ""
echo "=== Настройка навыков Veda для Claude Code ==="
echo ""

# 1. Создаем папки
mkdir -p "$SKILLS_DIR" "$HOOKS_DIR"

# 2. Ищем Google Drive
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
  echo "  Google Drive не найден или папка 'Claude Skills' не расшарена."
  echo "  Попроси админа расшарить папку 'Claude Skills' на Google Drive."
  echo ""
  echo "  Пока установлю навыки из этого репо..."

  # Fallback: копируем из текущей папки
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  installed=0
  for skill_dir in "$SCRIPT_DIR"/*/; do
    name=$(basename "$skill_dir")
    [ ! -f "$skill_dir/SKILL.md" ] && continue
    cp -r "$skill_dir" "$SKILLS_DIR/"
    echo "  Installed: $name"
    installed=$((installed + 1))
  done
else
  echo "  Google Drive найден: $GDRIVE_SKILLS"

  # Копируем навыки из Google Drive
  installed=0
  for skill_dir in "$GDRIVE_SKILLS"/*/; do
    name=$(basename "$skill_dir")
    [ ! -f "$skill_dir/SKILL.md" ] && continue
    cp -r "$skill_dir" "$SKILLS_DIR/"
    echo "  Installed: $name"
    installed=$((installed + 1))
  done
fi

# 3. Создаем скрипт автосинхронизации
cat > "$HOOKS_DIR/sync-skills.sh" << 'HOOKEOF'
#!/bin/bash
cat > /dev/null
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"
GDRIVE_ROOT="$HOME/Library/CloudStorage"
GDRIVE_SKILLS=""
if [ -d "$GDRIVE_ROOT" ]; then
  for gd in "$GDRIVE_ROOT"/GoogleDrive-*/; do
    for dn in "Мой диск" "My Drive"; do
      candidate="$gd/$dn/Claude Skills"
      if [ -d "$candidate" ]; then
        GDRIVE_SKILLS="$candidate"
        break 2
      fi
    done
  done
fi
if [ -n "$GDRIVE_SKILLS" ] && [ -d "$GDRIVE_SKILLS" ]; then
  for skill_dir in "$GDRIVE_SKILLS"/*/; do
    name=$(basename "$skill_dir")
    [ ! -f "$skill_dir/SKILL.md" ] && continue
    cp -r "$skill_dir" "$SKILLS_DIR/"
  done
fi
exit 0
HOOKEOF
chmod +x "$HOOKS_DIR/sync-skills.sh"

# 4. Добавляем хук в settings.json
if [ -f "$SETTINGS" ]; then
  if grep -q "sync-skills" "$SETTINGS" 2>/dev/null; then
    echo "  Хук уже настроен"
  else
    python3 -c "
import json
with open('$SETTINGS', 'r') as f:
    data = json.load(f)
data['hooks'] = {
    'SessionStart': [{
        'matcher': 'startup',
        'hooks': [{
            'type': 'command',
            'command': '\$HOME/.claude/hooks/sync-skills.sh',
            'timeout': 30
        }]
    }]
}
with open('$SETTINGS', 'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')
" 2>/dev/null && echo "  Хук добавлен в settings.json" || echo "  Не удалось обновить settings.json, добавь хук вручную"
  fi
else
  cat > "$SETTINGS" << 'SETTINGSEOF'
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/hooks/sync-skills.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
SETTINGSEOF
  echo "  settings.json создан с хуком"
fi

echo ""
echo "=== Готово! ==="
echo ""
echo "$installed навыков установлено."
echo "Навыки обновляются автоматически через Google Drive при каждом запуске Claude Code."
echo ""
