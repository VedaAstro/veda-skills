---
name: veda-presentation-design
description: Создание продуктовых PPTX-презентаций через pptxgenjs. Палитры, layout-паттерны, язык, QA. Используй при любой задаче на создание deck/slides/презентации.
---

# Презентации продуктов (PPTX)

## Когда использовать
Любая задача на создание презентации: pitch deck, продуктовая преза, концепция, demo deck.

## Стек
- **pptxgenjs** (Node.js) — генерация PPTX
- **react-icons** + **sharp** — иконки (SVG → PNG растеризация)
- **LibreOffice** (`soffice`) — конвертация PPTX → PDF
- **pdftoppm** — PDF → изображения для QA

## Процесс

### Step 1: Согласование перед кодом
Перед написанием `build-deck.js` уточни:
1. **Язык** — какие слова переводить, какие оставить. ПРАВИЛО: бренды (Zoom, TG, Groq, Claude, VEDA), аббревиатуры (CEO, API, STT, LLM, CR), метрики — НЕ переводить. Переводить только "человеческие английские слова" (Chief of Staff → ассистент, Workflow → Процесс).
2. **Стиль** — тёмный/светлый, палитра, шрифты.
3. **Логотип** — путь к файлу, размеры для расчёта aspect ratio.

### Step 2: Архитектура файла

```
build-deck.js — один файл, все слайды последовательно.
Структура:
  1. Imports + helpers (iconToBase64Png, makeShadow)
  2. Color palette (const C = {...})
  3. async function build() — слайды по порядку
  4. Каждый слайд в собственном {} блоке
```

**CRITICAL — makeShadow как функция, не объект:**
```javascript
// pptxgenjs мутирует shadow объекты — каждый вызов нужен свежий
const makeShadow = () => ({ type: "outer", blur: 4, offset: 2, angle: 135, color: "000000", opacity: 0.1 });
```

### Step 3: Layout-паттерны

| Тип слайда | Layout | Примечания |
|-----------|--------|-----------|
| Обложка | Центрированный: лого → заголовок → подзаголовок → тэглайн → футер | Тёмный фон. Без сеток/паттернов. |
| Карточки ×3 | 3 колонки, cardW=2.8, gap=0.3, startX = (10 - 3*cardW - 2*gap) / 2 | Акцент сверху (h=0.06). |
| Карточки ×4 | 4 колонки, cardW=2.0, gap=0.35-0.4 | Стрелки между карточками. |
| Горизонтальный flow | Круги на линии, лейблы снизу, зоны сверху | stepW=1.1, stepGap=0.22. |
| Список (тёмный) | Строки с accent bar слева, иконка + имя + описание + тег | rowH=0.6, rowGap=0.12. |
| Инсайты/цитаты | Карточки с accent bar слева + badge тегом + italic текст в кавычках | «Кавычки-ёлочки» для русского. |

### Step 4: Координатные расчёты

**ОБЯЗАТЕЛЬНО проверяй перед сборкой:**
```
Последний элемент Y + H < Footer Y
Footer Y обычно = 5.2 (для LAYOUT_16x9, высота 5.625")
Минимальный зазор = 0.3"
```

**Формула центрирования N элементов:**
```javascript
const startX = (10 - N * itemW - (N-1) * gap) / 2;
```

**LINE shape (pptxgenjs):**
- `w` и `h` — это размеры, НЕ дельты от (x,y)
- Горизонтальная линия: `{ x, y, w: длина, h: 0 }`
- Диагональные линии ненадёжны — избегай сателлитных диаграмм с линиями от центра
- Для связей между элементами используй стрелки-иконки (FiArrowRight), не LINE

### Step 5: Иконки

```javascript
const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");

function renderIconSvg(Icon, color, size = 256) {
  return ReactDOMServer.renderToStaticMarkup(
    React.createElement(Icon, { color, size: String(size) })
  );
}

async function iconToBase64Png(Icon, color, size = 256) {
  const svg = renderIconSvg(Icon, color, size);
  const png = await sharp(Buffer.from(svg)).png().toBuffer();
  return "image/png;base64," + png.toString("base64");
}
```

**Популярные иконки (react-icons/fi):**
- FiCheckCircle, FiAlertTriangle, FiClock, FiEyeOff, FiCalendar
- FiMic, FiEdit3, FiShield, FiTrendingUp, FiTarget, FiUsers
- FiVideo, FiMessageCircle, FiDatabase, FiCpu, FiSearch, FiArrowRight

### Step 6: Палитры

**Midnight Executive (проверенная):**
```javascript
const C = {
  navy: "1E2761", navyDark: "161D4A", ice: "CADCFC",
  white: "FFFFFF", offWhite: "F8F9FC",
  violet: "7C3AED", violetBg: "F3EEFF",
  teal: "0D9488", tealBg: "ECFDF5",
  amber: "D97706", amberBg: "FFFBEB",
  red: "DC2626", redBg: "FEF2F2",
  green: "16A34A",
  gray900: "111827", gray700: "374151", gray500: "6B7280",
  gray300: "D1D5DB", gray100: "F3F4F6",
};
```

## Антипаттерны

| НЕ делай | Делай вместо |
|----------|-------------|
| Сетки/паттерны на тёмных обложках | Чистый тёмный фон, пространство |
| Переводить бренды и аббревиатуры | Оставлять: Zoom, TG, CEO, API, STT, LLM, CR |
| Unicode буллеты "•" | `bullet: true` в pptxgenjs |
| Общий shadow объект | `makeShadow()` — свежий каждый раз |
| LINE для диагональных связей | Иконки-стрелки (FiArrowRight) |
| Элементы ниже y=4.8 при футере на 5.2 | Считать: lastY + lastH + 0.3 < footerY |
| `#` в hex цветах | Только 6 символов без # |
| 8-char hex для opacity | `opacity: 0.15` отдельным свойством |
| Подзаголовок дублирующий заголовок | Разный смысл: заголовок = имя, подзаголовок = value prop |

## QA

1. **Сборка**: `node build-deck.js`
2. **Конвертация**: `soffice --headless --convert-to pdf output.pptx` (или через soffice.py)
3. **Визуальная проверка**: `pdftoppm -jpeg -r 150 output.pdf slide && ls slide-*.jpg`
4. **Субагент для QA** — свежие глаза находят коллизии которые автор пропускает
5. **Чеклист:**
   - [ ] Нет наложений элементов
   - [ ] Футер не перекрыт контентом
   - [ ] Иконки контрастные к фону
   - [ ] Текст читаемый (min 8pt)
   - [ ] Язык: бренды на англ, остальное на русском
   - [ ] Кавычки-ёлочки «» для русского текста

## Зависимости

```bash
npm install pptxgenjs react react-dom react-icons sharp
brew install --cask libreoffice  # для PDF конвертации
brew install poppler              # для pdftoppm
```

---

## Готовые изображения VEDA (использовать вместо эмодзи/placeholder)

Источник: iCloud `~/Library/Mobile Documents/com~apple~CloudDocs/Pictures/PNG/`
Уже сжаты в WebP, залиты в veda-presentation:

| Папка в проекте | Размер | Содержимое |
|-----------------|--------|-----------|
| `/public/images/program-icons/` | 128×128px | 48 иконок: Астрология, Карма, Предназначение, Деньги, Любовь, Семья, Рост_дохода, Сертификат, Куратор, Чат, AI___НЕЙРО и др. |
| `/public/images/program-modules/` | 400×400px | 11 иллюстраций модулей: Базовая_астрология, Карма, Прогнозы, Энергия, деньги, любовь, предназначение, семья |
| `/public/images/program-bonuses/` | 300×300px | 8 изображений бонусов: Нейроастролог, НейроКуратор, Гарантия, Магнит_клиентов, эфиры, чат |

Полный маппинг → `memory/program-images-map.md`

**Правило**: НЕ использовать эмодзи в слайдах — только иконки из этих папок.

## Генерация новых иконок через Imagen 4

Когда нет нужной иконки в библиотеке:

```javascript
// Ключ: из переменной окружения GOOGLE_AI_API_KEY (Oregon, 0% tax)
const res = await fetch(
  'https://generativelanguage.googleapis.com/v1beta/models/imagen-4.0-fast-generate-001:predict',
  {
    method: 'POST',
    headers: { 'x-goog-api-key': API_KEY, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      instances: [{ prompt: 'Minimalist 3D icon, warm gold and deep violet gradient, [ТЕМА], transparent background, soft glow, no text, clean, premium' }],
      parameters: { sampleCount: 2, aspectRatio: '1:1' }
    })
  }
);
const data = await res.json();
// base64 PNG → data.predictions[0].bytesBase64Encoded
// Сохранить через fs.writeFileSync + конвертировать cwebp -q 80 -resize 128 128
```

Стиль для единообразия: `"Minimalist 3D icon, warm gold and deep violet gradient, [тема], transparent background, soft glow, no text, clean, premium"`
