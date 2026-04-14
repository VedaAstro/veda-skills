# PDF / PPTX / Визуальные материалы

## Стек генерации

| Формат | Инструмент | Конвертация |
|--------|-----------|-------------|
| PPTX → PDF | pptxgenjs (Node.js) | `soffice --headless --convert-to pdf` |
| QA визуал | pdftoppm → JPG | `pdftoppm -jpeg -r 150 out.pdf slide` |
| Патч PPTX | python-pptx | `from pptx import Presentation` |

## Логотипы

| Лого | Путь (iCloud) | Для |
|------|--------------|-----|
| AstroGuru (dark) | `Фирменный стиль/ЛОГОТИПЫ/Астрогуру✔️/Горизонтальная версия/Черная версия/прозрачный фон.png` | Светлый фон |
| AstroGuru (white) | `.../Белая версия/Прозрачный фон.png` | Тёмный фон |
| VEDA (dark) | `Фирменный стиль/ЛОГОТИПЫ/Веда✔️/Горизонтальная версия/Черная версия/прозрачный фон.png` | Светлый фон |
| VEDA (white) | `.../Белая версия/прозрачный фон.png` | Тёмный фон |

Конвертация SVG → PNG: `cairosvg.svg2png(url=path, write_to=out, output_width=400)`
Лого в PPTX: w ≤ 1.1", h пропорционально.

## Астро-ассеты

Все в `/public/images/` (app-myveda):
- `/images/planets/` — 9 планет (webp ~20KB)
- `/images/signs/` — 12 знаков 3D (webp 256px)
- `/images/signs-round/` — 12 знаков круглые
- `/images/houses/` — 12 домов 3D (webp 128px)
- `/images/houses-round/` — 12 домов круглые

Источник: `~/Library/Mobile Documents/com~apple~CloudDocs/Pictures/PNG/Планеты. Знаки. Дома. PNG/`

Для pptxgenjs — конвертировать webp → PNG:
```python
from PIL import Image
Image.open('icon.webp').convert('RGBA').save('icon.png')
```

Натальная карта: скриншот с new.astroguru.ru через Playwright или VedicNatalChart.tsx как HTML → screenshot. Путь: `platform/app-myveda/features/chart/components/VedicNatalChart.tsx`

## Правила визуала

| Правило | Как |
|---------|-----|
| Пропорции | Квадратная иконка → w=h строго одинаковые. Проверка: `Image.open('x.png').size` |
| Иерархия | Заголовок > подзаголовок > текст. Контраст между секциями |
| Стрелки | pptxgenjs LINE shape с endArrowType: "triangle". Gap ≥ 0.30" |
| Буллеты | Маленькие точки (0.06-0.08"). Маркер < 1/3 шрифта |
| Цвет | Max 3 акцента + серый. Brand #2563EB + error/success + серый |
| Шрифт | Inter (кириллица). Helvetica в PDF → прямоугольники |
| Изображения | 3D WebP из /public/. Конвертация: `cwebp -q 85 input.png -o output.webp` (max 300KB) |

## Палитра PDF/PPTX

```
brand:      #2563EB
brandLight: #EFF6FF
text:       #0F172A
textSec:    #475569
textTer:    #94A3B8
bg:         #F8FAFC
card:       #FFFFFF
border:     #E2E8F0
```

## Формула высот (pptxgenjs)

```
Slide: 10" × 5.625" (LAYOUT_16x9)
Header: 0 → 0.42"
Content start: ~1.16"
SAFE_BOTTOM: 5.35"
Available: 4.19"

Проверка: startY + rows * (cardH + gapY) - gapY ≤ SAFE_BOTTOM
```

## QA чеклист

```bash
node build-deck.js
soffice --headless --convert-to pdf output.pptx --outdir /Users/alex/Desktop/
pdftoppm -jpeg -r 150 output.pdf /tmp/qa_slides/slide
# Read каждый JPG:
# □ Иконки не приплюснуты
# □ Лого ≤ 1.1"
# □ Буллеты маленькие
# □ Стрелки — LINE, не текст "→"
# □ Max 3 акцентных цвета
# □ Контент в SAFE_BOTTOM
# □ Inter, кириллица читается
```
