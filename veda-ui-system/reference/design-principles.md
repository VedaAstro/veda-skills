# World-Class UI Principles

> Эти принципы применяются ДО кода. Каждый — блокер: нарушение = посредственный результат.
> Референсы: Apple (craft), Aesop (editorial warmth), Linear (hierarchy), Arc (motion delight).

---

## 1. HIERARCHY — что видно первым

Пользователь сканирует страницу за 2-3 секунды. Визуальный вес = важность.

**Правила:**
- Один primary CTA на экран. Два = ноль
- Headline → supporting text → action. Не наоборот
- Размер, вес, контраст — три инструмента hierarchy. Используй все три, не только размер
- F-паттерн для контентных страниц, Z-паттерн для лендингов
- Squint test: прищурься и посмотри на экран. Что видно? Это и есть hierarchy

**Размерная иерархия:**
```
Level 1 (hero/display):    48-96px, weight 500-600, tight leading (1.05-1.1)
Level 2 (section title):   24-36px, weight 500-600, leading 1.2
Level 3 (card/block title): 18-20px, weight 500, leading 1.3
Body:                       14-16px, weight 400, leading 1.5-1.6
Caption/meta:               12-13px, weight 400-500, leading 1.4
```

**Запрещено:**
- Больше 3 уровней типографики на одном экране
- Все заголовки одного размера (нет hierarchy = нет reading order)
- Bold на всём подряд (если всё bold — ничего не bold)

---

## 2. TYPOGRAPHY — шрифт как голос

Типографика — 80% визуального quality. Плохая типографика убивает любой дизайн.

**Правила:**
- Max 2 шрифта: один для display (может быть serif), один для body (sans)
- Line-height: заголовки 1.05-1.2, body 1.5-1.6. Ни при каких обстоятельствах 1.0 или 2.0
- Letter-spacing: заголовки -0.01 to -0.03em (tighter), body 0 (normal), caps +0.05-0.15em (looser)
- Measure (длина строки): 45-75 символов для body. Длиннее = нечитаемо
- Вертикальный ритм: все baseline на сетке 4px или 8px
- Числа в таблицах: tabular-nums (моноширинные цифры, колонки выровнены)
- Не смешивай bold + italic в одной фразе

**Оптическое выравнивание:**
- Текст всегда left-aligned (кроме centered hero headlines)
- Кавычки и тире выносятся за left edge (hanging punctuation)
- Заголовок + body: baseline заголовка на одной линии с первой строкой параграфа (если рядом)

**Serif vs Sans:**
- Serif (Fraunces, Cormorant, Playfair Display): для editorial, premium, emotional
- Sans (Inter, ABC Favorit, GT America): для functional, UI, data
- Mix: serif для headlines + sans для body = классический editorial приём

---

## 3. SPACING — воздух как инструмент

White space — не пустота, а конструктивный элемент. Больше воздуха = больше премиума.

**Шкала:**
```
4px   → micro (иконка-к-лейблу, тег внутри)
8px   → tight (элементы одной группы)
12px  → compact (между мелкими блоками)
16px  → standard (padding контейнера, gap в формах)
24px  → comfortable (между секциями)
32px  → spacious (между крупными разделами)
48px  → generous (top-level breathing)
64px  → editorial (hero sections, page breaks)
96px  → cinematic (Apple-style hero spacing)
```

**Правило 1:3:**
Spacing между группами ≥ 3× spacing внутри группы. Это создаёт Gestalt proximity.
```
gap-2 внутри карточки → gap-6 между карточками ✓
gap-3 везде одинаковый → нет groups, нет hierarchy ✗
```

**Padding:**
| Контекст | Padding |
|----------|---------|
| Compact card | p-4 (16px) |
| Standard card | p-6 (24px) |
| Page container | px-6 + max-w-7xl |
| Hero section | py-24 to py-32 (96-128px) |
| Button | px ≈ 2× py |

**Правило последовательности:**
Если выбрал 24px между секциями — ВСЕ секции 24px. Разные spacing между однотипными элементами = визуальный шум.

---

## 4. COLOR — меньше = сильнее

**Budget:** 1 brand + 1 accent + neutral ramp. Три цвета + оттенки серого. Всё.

**Принципы:**
- Цвет = смысл. Красный = error/danger. Зелёный = success. Синий = action. Жёлтый = warning. Без исключений
- Neutral ramp — 80% интерфейса. Цвет только для акцентов и статусов
- Контраст body text ≥ 4.5:1 (WCAG AA). Large text ≥ 3:1. Без компромиссов
- Не используй чистый чёрный (#000) на чистом белом (#fff) — слишком жёстко. Off-black (#1A1917) + off-white (#F7F3EC) мягче

**Тёплый vs холодный neutral:**
- Warm neutrals (cream, sand, taupe): для premium, editorial, luxury
- Cool neutrals (gray-50 → gray-900): для продуктовых UI, SaaS, data
- Vedantica: warm. Продукт (app-myveda): cool

**Запрещено:**
- Больше 3 хроматических цветов на странице
- Градиенты без функциональной причины
- Cyan-on-dark, neon на тёмном фоне (2018 год)
- Glassmorphism как декорация

---

## 5. DENSITY — под контент, не под привычку

Плотность определяется контекстом, не вкусом.

| Тип | Density | Spacing | Font size | Пример |
|-----|---------|---------|-----------|--------|
| Dashboard/CRM | Dense | 8-16px | 12-14px | Linear, Stripe Dashboard |
| Product page | Balanced | 16-24px | 14-16px | Notion, GitHub |
| Landing/Editorial | Spacious | 32-96px | 16-20px body, 48-96px hero | Apple, Aesop |
| Reading | Comfortable | 24-32px | 16-18px, max 65ch | Medium, Substack |

**Правило единообразия:** вся страница — одна density. Не mix dense header + spacious body + dense footer.

---

## 6. DEPTH & ELEVATION — тени как иерархия

4 уровня. Не больше. Каждый уровень = смысл.

```
Level 0: Flat        → основная поверхность, без тени
Level 1: Raised      → карточки, кнопки
         shadow-sm: 0 1px 2px rgba(0,0,0,0.05)
Level 2: Floating    → dropdowns, popovers, side panels
         shadow-md: 0 4px 6px -1px rgba(0,0,0,0.1)
Level 3: Overlay     → модалки, toasts, command palettes
         shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.1)
```

**Правила:**
- Тень = что-то выше остального. Без физического смысла тень не ставится
- Теплее фон → теплее тень (rgba(20,15,10,0.08) вместо rgba(0,0,0,0.1))
- Не стакай тени (card с тенью внутри modal с тенью)
- Border vs shadow: border = разделитель, shadow = elevation. Не оба одновременно на одном элементе

---

## 7. MOTION — каждое движение = смысл

**Timing:**
- Micro (hover, toggle): 100-150ms
- Standard (fade, slide): 200-300ms
- Complex (page transition, modal): 400-600ms
- Editorial (hero reveal, scroll animation): 600-1200ms

**Easing:**
- Появление: `cubic-bezier(0.16, 1, 0.3, 1)` — быстрый старт, мягкий финиш
- Исчезновение: `cubic-bezier(0.4, 0, 1, 1)` — мягкий старт, быстрый финиш
- Никогда: `linear` (роботично), `bounce` (игриво, не профессионально)

**Правила:**
- Max 3 одновременных анимации на viewport
- Stagger (последовательное появление): 60-100ms между элементами
- Scroll-linked: subtle (translateY 20-40px, opacity 0→1), не aggressive
- `prefers-reduced-motion: reduce` → отключить ВСЁ кроме opacity transitions
- Анимация должна быть незаметной при повторном просмотре. Если раздражает на 3й раз — убрать

---

## 8. RESPONSIVE — mobile не второй класс

**Breakpoints (Tailwind v4):**
```
sm:  640px   (мобайл → планшет)
md:  768px   (планшет)
lg:  1024px  (десктоп)
xl:  1280px  (широкий десктоп)
2xl: 1536px  (ultra-wide)
```

**Правила:**
- Mobile-first: базовые стили = mobile, добавляй md: / lg: для десктопа
- Touch targets: min 44×44px. 32px кнопка = невозможно нажать
- Типографика scale down: hero 96px desktop → 40-48px mobile. Не пропорционально, по ощущению
- Spacing scale down: py-24 desktop → py-12 mobile. Не 1:1
- Grid: 12 columns desktop → 4 columns tablet → 1 column mobile
- Изображения: `sizes` атрибут обязательно. `100vw` на mobile, `50vw` на desktop (если split)
- Sidebar → bottom sheet или hamburger на mobile. Не скрывай без замены
- Таблицы: horizontal scroll на mobile, не stack (данные теряют контекст)

---

## 9. ACCESSIBILITY — не опция, а основание

**Минимум (non-negotiable):**
- Contrast ratio ≥ 4.5:1 для body, ≥ 3:1 для large text (18px+ или 14px bold)
- `focus-visible` на ВСЕХ интерактивных элементах (outline, не box-shadow)
- Keyboard navigation: Tab/Shift+Tab/Enter/Escape работают
- `alt` на всех `<img>` (пустой `alt=""` для декоративных)
- `aria-label` на icon-only buttons
- `role` и `aria-*` на кастомных контролах (React Aria делает это автоматически)
- `prefers-reduced-motion` — отключить анимации
- `prefers-color-scheme` — если есть dark mode

---

## 10. MICRO-DETAILS — что отличает professional от good

- Оптическое выравнивание иконок: icon 20px + text 14px → icon `mt-[1px]` чтобы baseline совпал
- Border-radius: консистентный по всему проекту. Если card = rounded-xl, то всё = rounded-xl
- Truncation: `truncate` + `title={fullText}` для длинных строк
- Loading states: skeleton (не spinner) для контента, spinner для actions
- Empty states: иллюстрация + текст + CTA, не пустая страница
- Error states: inline (не toast) для form validation
- Hover: subtle bg change (bg-tertiary), не border change (CLS)
- Disabled: opacity-50 + cursor-not-allowed + pointer-events-none
