# Design Tokens — Untitled UI + Tailwind v4

> **СТАТУС:** Полностью мигрировано на Untitled UI (февраль 2026).
> Старые токены (`var(--v-*)`, `bg-v-*`, `text-v-*`) УДАЛЕНЫ. Не использовать.

---

## КРИТИЧНО: Tailwind v4 Property-Specific Tokens

В `styles/theme.css` определены **property-specific tokens** (`--background-color-*`, `--border-color-*`, `--ring-color-*`).
В Tailwind v4 они создают **ОТДЕЛЬНЫЙ namespace** от `--color-*`.

### Что это значит

```
bg-brand-600   → ищет --background-color-brand-600  → НЕ СУЩЕСТВУЕТ → ПРОЗРАЧНЫЙ ФОН ❌
bg-brand-solid → ищет --background-color-brand-solid → СУЩЕСТВУЕТ    → РАБОТАЕТ ✅

text-brand-600 → ищет --text-color-brand-600 → нет → fallback на --color-brand-600 → РАБОТАЕТ ✅
```

### Маппинг: что НЕЛЬЗЯ → что ПРАВИЛЬНО

| Intent | НЕЛЬЗЯ ❌ | ПРАВИЛЬНО ✅ |
|--------|-----------|-------------|
| Primary button bg | `bg-brand-600` | `bg-brand-solid` |
| Primary button hover | `hover:bg-brand-700` | `hover:bg-brand-solid_hover` |
| Error button bg | `bg-error-600` | `bg-error-solid` |
| Error button hover | `hover:bg-error-700` | `hover:bg-error-solid_hover` |
| Success bg | `bg-success-600` | `bg-success-solid` |
| Warning bg | `bg-warning-500` | `bg-warning-solid` |
| Primary border | `border-brand-600` | `border-brand-solid` |
| Error border | `border-error-600` | `border-error` |
| Focus ring | `ring-brand-600` | `ring-brand-solid` |
| Focus ring opacity | `ring-brand-600/20` | `ring-brand-solid/20` |

### Классы text-* — работают с палитрой напрямую

`text-*` классы используют `--color-*` напрямую (нет конфликта с property-specific):

```
text-brand-600  ✅   text-error-600  ✅   text-success-600  ✅   text-warning-600  ✅
text-gray-500   ✅   text-gray-700   ✅   text-gray-900      ✅
```

### Arbitrary values (крайний случай)

Если semantic-token существует в `--background-color-*`, но Tailwind не резолвит (баг с var-chain):

```tsx
// bg-brand-primary не работает → arbitrary value:
className="bg-[color:var(--color-bg-brand-primary)]"
```

---

## Семантические токены (ОСНОВНОЙ СПОСОБ стилизации)

### Текст

| Tailwind класс | Назначение | Пример |
|---------------|-----------|--------|
| `text-primary` | Основной текст, заголовки | Имя клиента, заголовок страницы |
| `text-secondary` | Вторичный текст | Описания, подписи под именем |
| `text-tertiary` | Третичный текст | Мета-информация, timestamps |
| `text-quaternary` | Четвертичный текст | Hints, disabled |
| `text-placeholder` | Placeholder | Input placeholders |
| `text-brand-600` | Акцентный текст (синий) | Ссылки, активные элементы |
| `text-error-600` | Ошибки (красный) | Сообщения об ошибках |
| `text-success-600` | Успех (зелёный) | Подтверждения, "Активен" |
| `text-warning-600` | Предупреждения | Замечания |

### Фон

| Tailwind класс | Назначение |
|---------------|-----------|
| `bg-primary` | Белый фон (карточки, панели) |
| `bg-secondary` | Серый фон (страница, подложка) |
| `bg-tertiary` | Hover-фон на элементах |
| `bg-quaternary` | Ещё более выраженный фон |
| `bg-primary_hover` | Hover на белых элементах |
| `bg-brand-solid` | Primary кнопки (синий) |
| `bg-brand-solid_hover` | Hover primary кнопок |
| `bg-error-solid` | Danger кнопки (красный) |
| `bg-error-solid_hover` | Hover danger кнопок |
| `bg-success-solid` | Success индикаторы |
| `bg-warning-solid` | Warning индикаторы |
| `bg-brand-primary` | Лёгкий синий фон (используй `bg-[color:var(--color-bg-brand-primary)]`) |
| `bg-error-primary` | Лёгкий красный фон (`bg-[color:var(--color-bg-error-primary)]`) |
| `bg-success-primary` | Лёгкий зелёный фон (`bg-[color:var(--color-bg-success-primary)]`) |
| `bg-warning-primary` | Лёгкий жёлтый фон (`bg-[color:var(--color-bg-warning-primary)]`) |

### Бордеры

| Tailwind класс | Назначение |
|---------------|-----------|
| `border-primary` | Основной бордер |
| `border-secondary` | Стандартный бордер (карточки, таблицы) |
| `border-tertiary` | Лёгкий бордер (разделители) |
| `border-disabled` | Disabled элементы |
| `border-brand` | Акцентный бордер (синий, тонкий) |
| `border-brand-solid` | Акцентный бордер (синий, яркий) |
| `border-error` | Бордер ошибки |

### Foreground (иконки, SVG)

| Tailwind класс | Назначение |
|---------------|-----------|
| `fg-primary` | Наивысший контраст (иконки) |
| `fg-secondary` | Высокий контраст |
| `fg-tertiary` | Средний контраст |
| `fg-quaternary` | Иконки в кнопках, инпутах |
| `fg-white` | Всегда белый |
| `fg-disabled` | Disabled |
| `fg-disabled_subtle` | Disabled subtle |
| `fg-brand-primary` | Брендовый (featured icons, progress) |
| `fg-brand-secondary` | Брендовый вторичный |
| `fg-error-primary` | Ошибка featured icons |
| `fg-error-secondary` | Ошибка в инпутах |
| `fg-success-primary` | Успех featured icons |
| `fg-success-secondary` | Успех (dot-indicators) |
| `fg-warning-primary` | Предупреждение |

> `fg-*` работает через `text-`, `bg-`, `fill-`, `stroke-` префиксы.

### Кольца (focus ring)

| Tailwind класс | Назначение |
|---------------|-----------|
| `ring-brand-solid` | Focus ring primary |
| `ring-brand-solid/20` | Focus ring с прозрачностью |
| `ring-brand-solid/30` | Focus ring побольше |
| `ring-error-solid` | Focus ring error |

---

## Паттерны стилизации

### Кнопка Primary

```tsx
className="px-4 py-2 rounded-xl text-sm font-semibold text-white
  bg-brand-solid hover:bg-brand-solid_hover active:bg-brand-solid_hover
  focus:ring-2 focus:ring-brand-solid/20 transition-colors"
```

### Кнопка Secondary

```tsx
className="px-4 py-2 rounded-xl text-sm font-semibold text-secondary
  bg-primary border border-secondary
  hover:bg-primary_hover hover:text-primary transition-colors"
```

### Кнопка Danger

```tsx
className="px-4 py-2 rounded-xl text-sm font-semibold text-white
  bg-error-solid hover:bg-error-solid_hover transition-colors"
```

### Input

```tsx
className="w-full px-4 py-2.5 border border-secondary rounded-xl
  text-[14px] text-primary placeholder:text-placeholder
  focus:ring-2 focus:ring-brand-solid/20 focus:border-brand-solid
  outline-hidden transition bg-white"
```

### Карточка

```tsx
className="p-3 rounded-xl bg-primary border border-secondary shadow-xs
  hover:border-primary hover:shadow-sm transition-all"
```

### Таблица

```tsx
// Заголовок
<th className="px-[18px] py-2.5 text-left text-[12px] font-medium text-tertiary whitespace-nowrap">
// Ячейка
<td className="px-[18px] py-2.5 text-[13px] font-medium text-primary">
// Строка
<tr className="border-b border-secondary hover:bg-primary_hover transition-colors">
```

### Статус-точка

```tsx
// Активен
<span className="inline-block w-1.5 h-1.5 rounded-full bg-success-solid" />
// Неактивен
<span className="inline-block w-1.5 h-1.5 rounded-full bg-quaternary" />
```

### Бейдж/Тег

```tsx
// Brand
<span className="px-2 py-0.5 text-[11px] font-semibold rounded-full text-brand-600"
  style={{ background: 'rgba(59,130,246,.08)' }}>Диагност</span>

// Error
<span className="px-2 py-0.5 text-[11px] font-semibold rounded-full text-error-600"
  style={{ background: 'rgba(239,68,68,.08)' }}>Отклонён</span>

// Success
<span className="px-2 py-0.5 text-[11px] font-semibold rounded-full text-success-600"
  style={{ background: 'rgba(34,197,94,.08)' }}>Оплачен</span>
```

### Навигация (sidebar)

```tsx
// Активный пункт
className="flex items-center gap-2.5 py-[9px] px-[14px] rounded-xl
  bg-primary_hover text-primary font-semibold"

// Обычный пункт
className="flex items-center gap-2.5 py-[9px] px-[14px] rounded-xl
  text-tertiary hover:bg-primary_hover hover:text-primary transition-colors"
```

### Icon button

```tsx
className="p-1.5 rounded-lg text-tertiary
  hover:text-primary hover:bg-primary_hover transition-colors"
```

---

## Типографика

### Шрифт

```css
/* theme.css */
--font-body: var(--font-inter, "Inter"), -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
--font-display: var(--font-inter, "Inter"), -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
```

### Иерархия размеров (CRM)

| Уровень | Tailwind | Weight | Цвет | Использование |
|---------|----------|--------|------|--------------|
| **Page title** | `text-[14px] font-semibold` | 600 | `text-primary` | Заголовок страницы |
| **Section title** | `text-[13px] font-semibold` | 600 | `text-primary` | Имя в таблице, заголовок секции |
| **Body** | `text-[13px] font-medium` | 500 | `text-secondary` | Основной текст |
| **Small** | `text-[12px] font-medium` | 500 | `text-secondary` | Мета-информация |
| **Tiny** | `text-[11px] font-medium` | 500 | `text-tertiary` | Timestamps, hints |
| **Table header** | `text-[12px] font-medium` | 500 | `text-tertiary` | Заголовки столбцов |

### Правила типографики

```
ЗАПРЕТ: text-transform: uppercase
ЗАПРЕТ: font-size > 16px в CRM-интерфейсе (кроме dashboard KPI)
ЗАПРЕТ: font-weight: 400 для интерактивных элементов (минимум 500)
ПРАВИЛО: tabular-nums для чисел (font-variant-numeric: tabular-nums)
ПРАВИЛО: whitespace-nowrap для заголовков таблиц
ПРАВИЛО: truncate (text-overflow: ellipsis) для длинных текстов
```

---

## Spacing (8px grid)

| Токен | Значение | Tailwind | Где |
|-------|----------|----------|-----|
| **xs** | 4px | `gap-1`, `p-1` | Между иконкой и текстом |
| **sm** | 8px | `gap-2`, `p-2` | Между элементами в группе |
| **md** | 10px | `gap-2.5` | Padding маленьких карточек |
| **base** | 12px | `gap-3`, `p-3` | Padding карточек |
| **lg** | 16px | `gap-4`, `p-4` | Между секциями |
| **xl** | 20px | `gap-5`, `p-5` | Padding страницы |
| **2xl** | 24px | `gap-6`, `p-6` | Между крупными блоками |

---

## Border Radius

| Элемент | Tailwind | Реальное значение |
|---------|----------|-----------------|
| Кнопки (Button) | `rounded-lg` | 8px (из компонента) |
| Input / Select | `rounded-lg` | 8px (из компонента) |
| Карточки | `rounded-xl` | 12px |
| Модалка | `rounded-xl` | 12px |
| Badge/Tag | `rounded-full` или `rounded-md` | зависит от type |
| Аватар | `rounded-full` | — |
| Tooltip | `rounded-md` | 6px |

---

## Тени (Elevation)

Используй Tailwind shadow-классы из Untitled UI:

| Уровень | Tailwind | Где |
|---------|----------|-----|
| Level 0 | нет | Обычные элементы |
| Level 1 | `shadow-xs` | Карточки в покое |
| Level 2 | `shadow-sm` | Карточки при hover |
| Level 3 | `shadow-md` | Dropdowns |
| Level 4 | `shadow-lg` | Модалки |

---

## Иконки

### Иконки: @untitledui-pro/icons (veda-presentation)

```tsx
// Импорт
import { Home01, Settings01 } from "@untitledui-pro/icons";         // line (default)
import { Home01 } from "@untitledui-pro/icons/solid";
import { Home01 } from "@untitledui-pro/icons/duotone";
import { Home01 } from "@untitledui-pro/icons/duocolor";

// ЗАПРЕЩЕНО — lucide-react УДАЛЁН
// import { Search } from 'lucide-react';

// В компоненте — передавать как ref (предпочтительно)
<Button iconLeading={ChevronDown}>Опции</Button>
// Как JSX — нужен data-icon
<Button iconLeading={<ChevronDown data-icon className="size-4" />}>Опции</Button>
// Standalone
<Home01 className="size-5 text-fg-secondary" />
```

### Размеры иконок

| Tailwind | Пикселей | Контекст |
|----------|---------|---------|
| `size-4` | 16px | В кнопках, в таблицах |
| `size-5` | 20px | Стандарт (navigation, standalone) |
| `size-6` | 24px | Декоративные, крупные |

### Цвет иконок (fg-* токены)

| fg-класс | Назначение |
|---------|-----------|
| `text-fg-primary` | Главные иконки |
| `text-fg-secondary` | Вторичные иконки |
| `text-fg-tertiary` | Третичные иконки |
| `text-fg-quaternary` | Иконки в инпутах, кнопках (по умолчанию) |
| `text-fg-brand-primary` | Брендовые иконки |
| `text-fg-error-primary` | Иконки ошибки |
| `text-fg-error-secondary` | Иконки ошибки в инпутах |
| `text-fg-disabled` | Disabled иконки |
| `text-fg-disabled_subtle` | Disabled иконки subtle |

---

## Анимации

| Анимация | Длительность | Easing |
|----------|-------------|--------|
| Hover | 150-200ms | ease |
| Appear | 300ms | ease-out |
| Slide-up | 300ms | ease-out |
| Modal open | 200ms | ease-out |

```tsx
// Стандартный hover transition
className="transition-colors"  // или transition-all duration-150
```

---

## Астро-палитра (презентации / диагностика)

Определены в `globals.css` → `@theme`:

| Tailwind | Назначение |
|----------|-----------|
| `text-veda-pain` / `bg-veda-pain` | Проблемы, боль (#D32F2F) |
| `text-veda-resource` / `bg-veda-resource` | Ресурсы (#388E3C) |
| `text-veda-period` / `bg-veda-period` | Периоды (#FFC107) |
| `text-veda-accent` / `bg-veda-accent` | Акцент (#7C3AED) |

---

## Diagnostic Workstation токены

Определены в `globals.css`:

| Токен | Значение | Назначение |
|-------|----------|-----------|
| `--ds-font-xs` | 11px | Метки, hints |
| `--ds-font-sm` | 12px | Подписи |
| `--ds-font-base` | 13px | Основной текст |
| `--ds-font-md` | 14px | Заголовки блоков |
| `--ds-gap-xs..lg` | 4-16px | Spacing внутри панелей |
| `--ds-panel-bg` | white | Фон панели |
| `--ds-panel-border` | `var(--color-border-secondary)` | Граница панели |
| `--ds-panel-radius` | 8px | Скругление |

---

## ЗАПРЕЩЁННЫЕ ПАТТЕРНЫ (гарантия качества)

```
❌ var(--v-ink)           → ✅ text-primary
❌ var(--v-muted)         → ✅ text-secondary
❌ var(--v-muted2)        → ✅ text-tertiary
❌ var(--v-bg)            → ✅ bg-secondary
❌ var(--v-surface)       → ✅ bg-primary
❌ var(--v-line)          → ✅ border-secondary
❌ var(--v-line2)         → ✅ border-tertiary
❌ var(--v-blue)          → ✅ text-brand-600
❌ var(--v-red)           → ✅ text-error-600
❌ var(--v-green)         → ✅ text-success-600
❌ var(--v-yellow)        → ✅ text-warning-600
❌ bg-brand-600           → ✅ bg-brand-solid
❌ hover:bg-brand-700     → ✅ hover:bg-brand-solid_hover
❌ border-brand-600       → ✅ border-brand-solid
❌ ring-brand-600         → ✅ ring-brand-solid
❌ color: '#344054'       → ✅ text-secondary
❌ color: '#101828'       → ✅ text-primary
❌ color: '#667085'       → ✅ text-tertiary
❌ background: '#F9FAFB'  → ✅ bg-secondary
❌ border: '#EAECF0'      → ✅ border-secondary
❌ className="v-btn-primary"  → ✅ inline Tailwind (см. паттерны выше)
❌ className="v-card"         → ✅ inline Tailwind (см. паттерны выше)
❌ className="v-th" / "v-td"  → ✅ inline Tailwind (см. паттерны выше)
```
