# DESIGN.MD — Vedantica

> Visual canon для vedantica.pro и маркетинговых материалов Vedantica.
> Формат: awesome-design-md (VoltAgent). Референсы: Apple + Aesop + Arc.
> Для продуктового UI (app-myveda, bot-admin-ui) — используй семантические токены Untitled UI.

---

## 1. Visual Theme & Atmosphere

**Mood:** Премиум-минимализм с ведической глубиной.
Не Stripe-cleanness (слишком холодный). Не crypto-neon (слишком технологичный). Не Instagram-астролог (фиолетовый космос, луны, блёстки).

**Ощущение:** как зайти в Aesop — тихо, тепло, каждая деталь на месте, пахнет сандалом, не хочется уходить.

**Ключевые слова:** кинематографичный, человечный, тёплый, экспертный, editorial, тихая уверенность.

**Anti-keywords:** эзотерический, мистический, космический, технологичный, инфобиз, яркий, кричащий.

**Density:** Spacious. 64-96px между секциями. Воздух = премиум.

**Photography direction:**
- Ирина в ведических украшениях и сари — editorial, студийное освещение, тёплое
- Still life: руки с картой, книги, чай, свечи (Aesop-style)
- Никаких stock-фото, кристаллов, фиолетовых туманностей
- Фон: тёмный (студийный) или натуральный (тёплый свет)

---

## 2. Color Palette & Roles

### Hero / Dark mode (hero sections, editorial)
```
Background:   #0D0C0B   (near-black, warm undertone)
Surface:      #1A1917   (cards on dark)
Text primary: #F7F3EC   (warm off-white)
Text muted:   #8A857C   (warm gray)
Accent gold:  #C2823A   (ochre — из украшений Ирины)
Accent deep:  #8B2E2E   (burgundy — из сари)
```

### Light mode (body sections, reading)
```
Background:   #F7F3EC   (warm cream)
Surface:      #FFFFFF   (white cards)
Text primary: #1A1917   (near-black)
Text muted:   #6B6560   (warm gray)
Accent gold:  #C2823A   (ochre)
Border:       #E8E2D9   (warm border)
```

### Функциональные
```
Error:        #DC2626
Success:      #16A34A
Warning:      #D97706
Info:         #2563EB
```

### Правила
- Hero section: ВСЕГДА тёмный фон (#0D0C0B). Это signature Vedantica
- Body sections: чередование cream и white backgrounds
- Accent gold используется ТОЛЬКО для: hover, links, eyebrow text, decorative lines
- Burgundy — ТОЛЬКО для secondary highlights, никогда для buttons или text
- Чистый белый (#FFFFFF) и чистый чёрный (#000000) — НЕ использовать для text/bg основных секций

---

## 3. Typography Rules

### Font pair
```css
/* Display (headlines, hero, emotional) */
--font-display: 'Fraunces', 'Playfair Display', 'Georgia', serif;

/* Body (functional, reading, UI) */
--font-body: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;

/* Mono (if needed) */
--font-mono: 'JetBrains Mono', 'SF Mono', monospace;
```

Fraunces — variable weight (100-900), optical size, italic. Кириллица поддерживается.
Если Fraunces не подходит → Cormorant Garamond (100% кириллица, классический editorial).

### Hierarchy
```
Hero headline:     Fraunces, 64-96px, weight 400-500, leading 1.05, tracking -0.03em
Section headline:  Fraunces, 36-48px, weight 400-500, leading 1.15, tracking -0.02em
Card headline:     Inter, 20-24px, weight 600, leading 1.3
Body:              Inter, 16-18px, weight 400, leading 1.6, max-width 65ch
Caption/eyebrow:   Inter, 12-13px, weight 500, leading 1.4, tracking 0.08-0.15em, uppercase
Meta:              Inter, 13-14px, weight 400, leading 1.4, color text-muted
```

### Правила
- Hero headlines: serif (Fraunces). Всегда
- Body: sans (Inter). Всегда
- Eyebrow: sans, uppercase, wide tracking, accent gold color
- Не смешивай serif + sans в одном абзаце
- Кавычки: « » (French quotes) для русского текста
- Тире: одинарный дефис `-`, не двойной `--` и не длинное тире `—`. В HTML-документах и UI-текстах всегда `-` с пробелами по бокам

---

## 4. Component Stylings

### Navigation
```
Position: fixed top, transparent → solid on scroll
Height: 64px desktop, 56px mobile
Logo: wordmark "VEDANTICA" — Inter 600, tracking 0.08em, 14px
Links: Inter 14px, weight 500, text-muted → text-primary on hover
CTA button: gold accent, rounded-full, px-6 py-2.5
Transition: background 300ms ease
```

### Buttons
```
Primary:    bg #C2823A, text #F7F3EC, hover darken 10%, rounded-full
Secondary:  border 1px #E8E2D9, text #1A1917, hover bg #F7F3EC, rounded-full
Ghost:      no border, text-muted, hover text-primary, underline on hover
Size:       px-8 py-3 (lg), px-6 py-2.5 (md), px-4 py-2 (sm)
```

### Cards (on cream bg)
```
Background: white
Border: 1px solid #E8E2D9
Border-radius: 12px (rounded-xl)
Padding: p-8
Shadow: none (flat). Shadow appears ONLY on hover
Hover shadow: 0 4px 12px rgba(20, 15, 10, 0.06)
```

### Links
```
Color: #C2823A (gold accent)
Hover: underline, darken 10%
Visited: same as default (no purple)
```

### Dividers
```
Horizontal: 1px solid #E8E2D9 (cream) or rgba(247,243,236,0.12) (dark)
Vertical: same
Decorative: 2px solid #C2823A, width 48px (accent bar)
```

---

## 5. Layout Principles

### Grid
```
Desktop:  max-width 1280px, px-8 (32px gutters)
Tablet:   max-width 768px, px-6
Mobile:   100%, px-5 (20px)

Columns:  12 desktop → 8 tablet → 4 mobile
Gap:      32px desktop → 24px tablet → 16px mobile
```

### Spacing scale (Vedantica-specific, spacious)
```
Section spacing:  96px (py-24)  desktop → 64px (py-16) mobile
Block spacing:    48px (gap-12) desktop → 32px (gap-8)  mobile
Element spacing:  24px (gap-6)  desktop → 16px (gap-4)  mobile
Micro spacing:    8-12px
```

### Hero layout
```
Desktop: split — text left (55%) + photo right (45%), items-center
         photo bleeds to right edge (no padding right)
         text: pl-8, pr-16 (breathing room)
Mobile:  stack — photo top (aspect-square), text below (px-5 py-12)
```

### Section pattern
```
eyebrow (uppercase, gold, 12px, tracking wide)
↓ 16px
headline (serif, 36-48px)
↓ 24px
body paragraph (sans, 16-18px, max 65ch)
↓ 32px
CTA or content
```

---

## 6. Depth & Elevation

Минимальные тени. Vedantica = flat with subtle lift.

```
Level 0: Flat — no shadow, border only if needed
Level 1: Subtle lift — only on hover
         0 4px 12px rgba(20, 15, 10, 0.06)
Level 2: Floating — dropdowns, popovers
         0 8px 24px rgba(20, 15, 10, 0.1)
Level 3: Overlay — modals
         0 24px 48px rgba(20, 15, 10, 0.16)
```

Warm shadows (rgba 20,15,10 не 0,0,0). На тёмном фоне — без теней, только border rgba(247,243,236,0.08).

---

## 7. Do's and Don'ts

### DO
- Тёмный hero с тёплым cream body — signature контраст Vedantica
- Serif headlines + sans body — editorial premium
- Много воздуха между секциями (96px desktop)
- Фото Ирины как якорь страницы — человек в центре
- Eyebrow + headline + body + CTA — повторяющийся section pattern
- Один CTA на экран
- Stagger reveal animations on scroll (subtle, 20-40px translateY)

### DON'T
- Фиолетовый космос, звёзды, планеты как декор — клише астрологии
- Stock-фото, «женщина с кристаллом»
- Gradient rainbow / aurora с высокой saturation
- Таймеры, «осталось 3 места», pop-ups — downgrade к инфобизу
- Emoji в заголовках
- Bounce / elastic анимации
- Больше 3 хроматических цветов на странице
- Слова «судьба», «предназначение» в hero headline (клише)
- Mystic fonts (Cinzel, Trajan) — слишком theatrical
- Нагромождение testimonials (3-5 глубоких кейсов > 50 коротких)

---

## 8. Responsive Behavior

### Breakpoints
```
Mobile:   < 640px   — single column, stacked
Tablet:   640-1024  — 2 columns where useful, reduced spacing
Desktop:  > 1024    — full layout
Wide:     > 1280    — max-width container, centered
```

### Touch targets
- Min 44×44px tap area
- Links in body: underlined (no color-only indication on mobile)
- Buttons: full-width on mobile (< 640px)

### Typography adaptation
```
Hero headline:    96px → 40px
Section headline: 48px → 28px
Body:             18px → 16px
Spacing:          96px → 48px between sections
```

### Navigation
- Desktop: horizontal links + CTA button
- Mobile: hamburger → full-screen overlay, dark bg, large touch targets

---

## 9. Agent Prompt Guide

### Быстрая палитра для промптов
```
Dark hero:    bg #0D0C0B, text #F7F3EC, accent #C2823A
Light body:   bg #F7F3EC, text #1A1917, accent #C2823A
Fonts:        Fraunces (display serif) + Inter (body sans)
Spacing:      spacious, 96px sections, 48px blocks
Radius:       12px cards, full buttons
Motion:       600-800ms reveals, cubic-bezier(0.16, 1, 0.3, 1)
```

### Ready prompts

**Hero section:**
> Создай hero в стиле Vedantica: тёмный фон #0D0C0B, split layout — текст слева (serif headline Fraunces 80px, cream #F7F3EC, eyebrow uppercase gold #C2823A), фото справа bleeds to edge. CTA button с gold accent, rounded-full. Spacious: py-24. Animation: stagger fade-in 800ms с задержкой 100ms между элементами.

**Content section:**
> Секция на cream фоне #F7F3EC: eyebrow gold uppercase + serif headline 48px #1A1917 + body text Inter 18px max-65ch + 3 карточки в ряд (white bg, border #E8E2D9, rounded-xl, p-8, hover shadow). Spacing: py-24, gap-8 между карточками.

**About/editorial:**
> Editorial портрет: фото Ирины слева (rounded-xl, object-cover, aspect-[3/4]), текст справа — serif headline + body Inter 18px leading-relaxed + subtle gold accent line (2px, 48px wide). Cream background, max-w-5xl centered.

**Testimonial:**
> Кейс ученицы: cream bg, centered, max-w-3xl. Крупная цитата serif italic 24px, text-secondary. Имя + результат под цитатой, Inter 14px uppercase tracking-wide. Тонкий gold accent divider сверху.
