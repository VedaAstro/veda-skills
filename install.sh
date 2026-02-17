#!/bin/bash
# Установка навыков Veda для Claude Code
# Использование: ./install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

mkdir -p "$SKILLS_DIR"

installed=0
for skill_dir in "$SCRIPT_DIR"/*/; do
  name=$(basename "$skill_dir")

  # Пропускаем служебные папки
  [[ "$name" == ".git" ]] && continue
  [[ "$name" == "scripts" ]] && continue

  # Проверяем что это навык (есть SKILL.md)
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    continue
  fi

  cp -r "$skill_dir" "$SKILLS_DIR/"
  echo "  Installed: $name"
  installed=$((installed + 1))
done

echo ""
echo "Done! $installed skills installed to $SKILLS_DIR"
echo ""
echo "Skills will be available in your next Claude Code session."
