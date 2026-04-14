# DESIGN.md — Vedantica PDF Design System

> Дизайн-система для AI-агентов. Читай перед генерацией любого PDF.

---

## 1. Visual Theme & Atmosphere

**Mood:** Celestial cartography — точность астронома, тепло наставника.
**Density:** Просторная. Воздух между элементами. Никогда не забивать страницу.
**Philosophy:** PDF = артефакт, а не документ. Каждая страница выглядит как страница из астрономического атласа — точная, красивая, с благоговением к предмету.

---

## 2. Color Palette & Roles

> Палитра извлечена из vedantica.pro — SSOT бренда.

### Primary

| Token | Hex | RGB | Role |
|-------|-----|-----|------|
| `dark` | #0D0C0B | 13, 12, 11 | Фон обложки, тёмные секции, gap-блоки |
| `cream` | #F7F3EC | 247, 243, 236 | Основной фон страниц |
| `white` | #FFFFFF | 255, 255, 255 | Фон карточек |

### Accent

| Token | Hex | RGB | Role |
|-------|-----|-----|------|
| `bronze` | #C2823A | 194, 130, 58 | Главный акцент — заголовки на тёмном, CTA, линии |
| `bronze-soft` | rgba(194,130,58,0.12) | — | Фон акцентных карточек |
| `bronze-hover` | rgba(194,130,58,0.15) | — | Hover-состояния |

### Neutral

| Token | Hex | RGB | Role |
|-------|-----|-----|------|
| `text` | #1A1917 | 26, 25, 23 | Основной текст |
| `muted` | #8A857C | 138, 133, 124 | Подписи, футер |
| `subtle` | #6B6560 | 107, 101, 96 | Вторичный текст |
| `border` | #E8E2D9 | 232, 226, 217 | Линии, разделители |
| `highlight` | #FFF9E8 | 255, 249, 232 | Выделение featured строк |

### Запрещённые цвета
- Индиго/фиолетовый (не в бренде vedantica.pro)
- Красный, зелёный, синий (RGB-примитивы)
- Чёрный (#000000) — использовать `dark` (#0D0C0B)
- Любые цвета вне палитры

---

## 3. Typography Rules

### Font Stack

**Бренд vedantica.pro:** Cormorant Garamond (заголовки) + Inter (body).

**Для reportlab (с кириллицей):**
- Заголовки: Arial Bold (ArB) — ближайший доступный serif-fallback
- Body: Arial (Ar) — чистый sans, кириллица проверена
- Если нужен serif: `Lora-Regular.ttf` или `LibreBaskerville-Regular.ttf` из canvas-fonts (проверить кириллицу!)

| Роль | Шрифт | Размер | Цвет |
|------|-------|--------|------|
| Заголовок обложки | ArB | 28-32pt | `bronze` |
| Подзаголовок обложки | Ar | 14-16pt | `cream` или `white` |
| Заголовок страницы | ArB | 16-18pt | `bronze` на `dark` полосе |
| Заголовок блока | ArB | 12-14pt | `text` |
| Body text | Ar | 10-11pt | `text` |
| Таблица заголовки | ArB | 9-10pt | `cream` на `dark` |
| Таблица данные | Ar | 9-10pt | `text` |
| Таблица акцент | ArB | 9-10pt | `bronze` |
| Подписи / футер | Ar | 7-8pt | `muted` |

### Правила
- **Межстрочный:** 1.4-1.6 от размера шрифта
- **Выравнивание:** по левому краю для текста, по центру для заголовков
- **КАПС:** разреженный (letter-spacing +1pt), только для badge-текста
- **Italic:** только для цитат и санскрита

---

## 4. Component Styles

### Обложка (страница 1)
```
Фон: dark (#0D0C0B)
Декор: бронзовая линия (1pt) сверху, margin 30mm
Заголовок: bronze (#C2823A), ArB 28-32pt, по центру
Подзаголовок: cream (#F7F3EC), Ar 14-16pt, по центру
Центральный блок: бронзовая рамка (0.5pt), roundRect 5mm
Внутри блока: cream текст, Ar 10-11pt
Футер: muted, Ar 8pt
```

### Полоса-заголовок (внутренние страницы)
```
Фон полосы: dark, полная ширина, высота 20mm
Текст: bronze, ArB 16pt, по центру
```

### Таблица
```
Заголовок: dark фон, cream текст ArB 9pt
Строки: чередование cream (#F7F3EC) и white (#FFFFFF)
Featured: highlight (#FFF9E8) + bronze полоска 2mm слева
Разделители: border (#E8E2D9) 0.3pt
Отступы: 3mm от края ячейки
```

### Карточки (3 в ряд)
```
Фон: white
Рамка: border (#E8E2D9) 0.5pt
Скругление: 4mm
Заголовок: ArB 10pt, text (#1A1917)
Описание: Ar 8.5pt, muted (#8A857C)
Gap между карточками: 5mm
```

### Gap-блок (продающий)
```
Фон: dark (#0D0C0B)
Скругление: 5mm
Заголовок: bronze, ArB 13pt, по центру
Текст: cream с alpha 0.7, Ar 9.5pt, по центру
CTA: bronze, ArB 10pt
```

### Подсказка (tip box)
```
Фон: highlight (#FFF9E8)
Скругление: 4mm
Заголовок: ArB 10pt, text
Текст: Ar 9pt, text
```

### Футер (каждая страница)
```
Позиция: 8-10mm от нижнего края
Текст: muted, Ar 7-8pt, по центру
«Академия Vedantica • vedantica.pro • Astroguru.ru»
```

---

## 5. Layout Principles

### Отступы
```
Боковые поля: 15-20mm
Верхнее поле: 25mm (под полосу-заголовок)
Нижнее поле: 15mm (над футером)
Gap между блоками: 8-10mm
Gap между строками таблицы: 0 (строки впритык)
```

### Сетка
- Одна колонка для текста и таблиц
- Три колонки для карточек
- Две колонки для сравнений (было/стало)

### Пустое пространство
- Минимум 30% страницы = воздух
- Никогда не заполнять страницу «до упора»
- Если контент не влезает — разбить на 2 страницы

---

## 6. Depth & Elevation

- **Нет теней** — стиль плоский, как гравюра
- **Глубина через цвет:** тёмный фон = «дальше», светлый = «ближе»
- **Золотые линии** создают структуру вместо теней
- **Скругления:** только на карточках и gap-блоках (4-5mm)

---

## 7. Do's and Don'ts

### DO
- Золотые линии для визуальной структуры
- Чередование цвета строк в таблицах
- Астро-символы Unicode в заголовках (☽ ♈ ★)
- Изображения планет/знаков из ASSETS.md
- Воздух, пространство, дыхание

### DON'T
- Emoji в body-тексте (квадратики при рендере)
- Цвета вне палитры
- Тени и 3D-эффекты
- Заливка страницы текстом без отступов
- Шрифты без проверки на кириллицу
- Рисовать планеты средствами reportlab — использовать PNG
- Больше 4 визуальных элементов на странице

---

## 8. Image Integration

### Планеты (для астро-контента)
```python
# Конвертация WebP → PNG для reportlab
from PIL import Image
src = '/Users/alex/Projects/platform/app-myveda/public/images/planets/moon.webp'
Image.open(src).convert('RGBA').save('/tmp/moon.png')
c.drawImage('/tmp/moon.png', x, y, width=15*mm, height=15*mm, mask='auto')
```

### Правила вставки изображений
- Размер на странице: 12-20mm (иконки), 30-50mm (иллюстрации)
- Всегда `mask='auto'` для прозрачности
- Не растягивать — сохранять пропорции
- Не ставить больше 3 изображений на страницу

---

## 9. Agent Prompt Guide

### Быстрая палитра для copy-paste
```python
DK = HexColor('#0D0C0B')   # dark — фон обложки, тёмные секции
CR = HexColor('#F7F3EC')   # cream — фон страниц
W  = HexColor('#FFFFFF')   # white — карточки
BR = HexColor('#C2823A')   # bronze — главный акцент
TX = HexColor('#1A1917')   # text — основной текст
MU = HexColor('#8A857C')   # muted — подписи, футер
SU = HexColor('#6B6560')   # subtle — вторичный текст
BD = HexColor('#E8E2D9')   # border — линии, разделители
HL = HexColor('#FFF9E8')   # highlight — featured строки
BRS = HexColor('#C2823A')  # bronze для drawString (тот же BR)
```

### Шрифты для copy-paste
```python
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
pdfmetrics.registerFont(TTFont('Ar', '/System/Library/Fonts/Supplemental/Arial.ttf'))
pdfmetrics.registerFont(TTFont('ArB', '/System/Library/Fonts/Supplemental/Arial Bold.ttf'))
pdfmetrics.registerFont(TTFont('ArI', '/System/Library/Fonts/Supplemental/Arial Italic.ttf'))
```
