#!/bin/bash
# Одноразовая настройка автосинхронизации навыков Veda
# Запусти один раз: ./setup.sh
# После этого навыки обновляются автоматически при каждом запуске Claude Code

set -e

REPO_URL="https://github.com/VedaAstro/veda-skills.git"
REPO_DIR="$HOME/.claude/skills-repo"
SKILLS_DIR="$HOME/.claude/skills"
HOOKS_DIR="$HOME/.claude/hooks"
SETTINGS="$HOME/.claude/settings.json"

echo ""
echo "=== Настройка навыков Veda для Claude Code ==="
echo ""

# 1. Создаем нужные папки
mkdir -p "$SKILLS_DIR" "$HOOKS_DIR"

# 2. Клонируем репо с навыками
if [ -d "$REPO_DIR/.git" ]; then
  echo "  Репо уже есть, обновляю..."
  git -C "$REPO_DIR" pull --quiet
else
  echo "  Клонирую навыки из GitHub..."
  git clone --quiet "$REPO_URL" "$REPO_DIR"
fi

# 3. Копируем навыки
installed=0
for skill_dir in "$REPO_DIR"/*/; do
  name=$(basename "$skill_dir")
  [ "$name" = ".git" ] && continue
  [ ! -f "$skill_dir/SKILL.md" ] && continue
  cp -r "$skill_dir" "$SKILLS_DIR/"
  echo "  Installed: $name"
  installed=$((installed + 1))
done

# 4. Создаем скрипт автосинхронизации
cat > "$HOOKS_DIR/sync-skills.sh" << 'HOOKEOF'
#!/bin/bash
cat > /dev/null
REPO_DIR="$HOME/.claude/skills-repo"
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"
if [ -d "$REPO_DIR/.git" ]; then
  git -C "$REPO_DIR" pull --quiet 2>/dev/null
fi
if [ -d "$REPO_DIR" ]; then
  for skill_dir in "$REPO_DIR"/*/; do
    name=$(basename "$skill_dir")
    [ "$name" = ".git" ] && continue
    [ ! -f "$skill_dir/SKILL.md" ] && continue
    cp -r "$skill_dir" "$SKILLS_DIR/"
  done
fi
exit 0
HOOKEOF
chmod +x "$HOOKS_DIR/sync-skills.sh"

# 5. Добавляем хук в settings.json
if [ -f "$SETTINGS" ]; then
  # Проверяем, есть ли уже хук
  if grep -q "sync-skills" "$SETTINGS" 2>/dev/null; then
    echo "  Хук уже настроен"
  else
    # Добавляем hooks в существующий settings.json
    # Используем python для корректного мёрджа JSON
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
  # Создаем settings.json с нуля
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
echo "Теперь при каждом запуске Claude Code навыки обновляются автоматически."
echo ""
