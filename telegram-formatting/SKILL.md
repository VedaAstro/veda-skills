---
name: telegram-formatting
description: Разметка текста в Telegram Bot API. HTML-теги, escape-правила, ограничения parse_mode. Используй при отправке форматированных сообщений через ботов.
---

# Telegram Formatting (Bot API)

## Когда использовать

- Отправка сообщений через Telegram Bot API с форматированием
- Генерация текста для Telegram-ботов (veda-monitor-bot, veda-bot-v2, tanya-bot)
- Любой `send_message`, `edit_message_text` с `parse_mode`

## Режим: HTML (рекомендуемый)

```python
await bot.send_message(chat_id=ID, text=html_text, parse_mode="HTML")
```

### Поддерживаемые теги

| Тег | Результат | Пример |
|-----|-----------|--------|
| `<b>text</b>` | **Жирный** | `<b>Важно</b>` |
| `<i>text</i>` | *Курсив* | `<i>примечание</i>` |
| `<u>text</u>` | Подчёркнутый | `<u>акцент</u>` |
| `<s>text</s>` | ~~Зачёркнутый~~ | `<s>старое</s>` |
| `<code>text</code>` | `Моноширинный` | `<code>var</code>` |
| `<pre>text</pre>` | Блок кода | `<pre>code block</pre>` |
| `<pre language="py">text</pre>` | Блок с подсветкой | |
| `<a href="URL">text</a>` | Ссылка | `<a href="https://...">клик</a>` |
| `<tg-spoiler>text</tg-spoiler>` | Спойлер | |
| `<blockquote>text</blockquote>` | Цитата | |

### Вложенность

Теги можно вкладывать:
```html
<b>жирный <i>и курсив</i></b>
```

### Упоминания пользователей

```html
@username                                    <!-- по юзернейму -->
<a href="tg://user?id=123456">Имя</a>       <!-- по user_id (даже без username) -->
```

## Escape-правила (КРИТИЧНО)

Символы `<`, `>`, `&` в пользовательском тексте ОБЯЗАТЕЛЬНО экранировать:

```python
def escape_html(text: str) -> str:
    """Escape для parse_mode='HTML' в Telegram."""
    if not text:
        return ""
    return (
        text
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
    )
```

**Порядок замены важен**: сначала `&`, потом `<` и `>`.

### Паттерн использования

```python
from tasks.formatters import escape_html

title = escape_html(task.get("title", ""))
text = f"<b>#{task_id}</b> выполнена: {title}"

await bot.send_message(chat_id=group_id, text=text, parse_mode="HTML")
```

## Ограничения

| Параметр | Лимит |
|----------|-------|
| Длина сообщения | 4096 символов |
| Длина caption (фото) | 1024 символа |
| Inline keyboard buttons | 64 байт callback_data |
| Теги внутри `<pre>` | Не работают |
| Теги внутри `<code>` | Не работают |

## Gotchas

1. **Незакрытые теги** → API вернёт ошибку `Can't parse entities`. Всегда проверяй парность.
2. **Неэкранированный `&`** → ошибка парсинга. Типичная ловушка: `A & B` → `A &amp; B`.
3. **`<` в тексте** → Telegram решит что это тег. Например: `3 < 5` → `3 &lt; 5`.
4. **Markdown в AI-ответах** → LLM генерирует `**bold**` и `# heading`. Используй `strip_markdown()` перед отправкой, или проси AI не использовать markdown.
5. **parse_mode с edit_message_text** → Если оригинал был без parse_mode, а edit с HTML — сработает, но проверь escape.
6. **Пустые теги** → `<b></b>` — ок, но бессмысленно. `<a href="">text</a>` — ошибка.

## MarkdownV2 (альтернатива, НЕ рекомендуется)

Escape-правила сложнее — нужно экранировать `_*[]()~>#+-=|{}.!\` обратным слешем. HTML проще и надёжнее.

## Чеклист перед отправкой

- [ ] `parse_mode="HTML"` указан
- [ ] Пользовательский текст пропущен через `escape_html()`
- [ ] Теги парные (каждый `<b>` имеет `</b>`)
- [ ] Нет raw `&`, `<`, `>` вне тегов
- [ ] Длина <= 4096 (или разбить на части)
