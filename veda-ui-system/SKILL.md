---
name: veda-ui-system
description: World-class UI для Veda. Три слоя: design intelligence (принципы), visual canon (бренд), operational (компоненты). Используй при любой работе с интерфейсом.
---

# Veda UI System

## Три слоя

Каждая UI-задача проходит через три слоя. Пропуск слоя = посредственный результат.

```
СЛОЙ 1 — DESIGN (до кода)
  Какой тип страницы? Какая плотность? Какая иерархия?
  → reference/design-principles.md

СЛОЙ 2 — CANON (до кода)
  Как это выглядит в мире Vedantica? Палитра? Типографика? Mood?
  → reference/vedantica-canon.md

СЛОЙ 3 — BUILD (код)
  Untitled UI компоненты, семантические токены, Tailwind v4
  → reference/untitled-ui-cheatsheet.md + reference/component-registry.md
```

## IF/THEN Router

```
IF новая страница или крупный блок:
  READ design-principles.md → vedantica-canon.md → page-layouts.md
  DECIDE: тип контента → плотность → иерархия → палитра → компоненты
  ONLY THEN: код

IF UI-элемент (кнопка, модалка, таблица):
  CHECK components/ в проекте → MCP search_components → CLI add
  IF нет готового → создай по паттерну (untitled-ui-cheatsheet.md)

IF цвет:
  Продукт (app-myveda, bot-admin-ui): семантические токены (text-primary, bg-brand-solid)
  Маркетинг (vedantica.pro, лендинги): vedantica-canon.md палитра

IF иконка:
  @untitledui-pro/icons (veda-presentation) / @untitledui/icons (остальные)

IF layout:
  reference/page-layouts.md

IF слайд/PDF/PPTX:
  reference/slide-layouts.md + reference/pdf-pptx-rules.md

IF «выглядит не так» / «что-то не то»:
  reference/anti-patterns.md → чеклист 20 признаков любительского UI
```

## Design Phase (Слой 1 + 2, ДО кода)

Перед написанием первой строки CSS ответь на 5 вопросов:

1. **Тип контента** — dashboard / editorial / reading / transactional / marketing?
2. **Density** — dense (CRM, таблицы) / balanced (страницы) / spacious (лендинг, hero)?
3. **Hierarchy** — что видит пользователь первым? вторым? третьим? Один primary CTA на экран
4. **Color budget** — max 1 brand + 1 accent + neutral ramp. Больше = шум
5. **Motion budget** — 0-3 анимации на viewport. Каждая = смысл, не декор

## Build Phase (Слой 3)

### Архитектура Untitled UI
- Модель: copy-paste через CLI (код в проекте, не npm)
- Стек: React 19 + Tailwind v4 + React Aria Components
- Структура: `components/{base,application,foundations}/`
- Токены продуктовые: `styles/theme.css` (brand = Veda Blue #3B82F6)
- Версия: **v8** (MCP default)

### CLI / MCP

**ПРАВИЛО: если CLI команда дана — выполнять первой, не писать код вручную.**

```bash
npx untitledui@latest init --nextjs --color blue --overwrite  # токены
npx untitledui@latest add button                               # компонент
npx untitledui@latest example dashboards-02/02                 # готовый пример
npx untitledui@latest login                                    # PRO (allee3131@gmail.com)
```
```
search_components("date picker")    # MCP поиск
get_component("button")             # код
list_components(version="8")        # полный список
```

### Компоненты — quick reference

**Button**
```tsx
import { Button } from "@/components/base/buttons/button";
<Button size="sm" color="primary" onClick={handler}>Текст</Button>
// onClick (не onPress). size: sm|md|lg|xl. color: primary|secondary|tertiary|link-gray|link-color
```

**Modal**
```tsx
import { ModalOverlay, Modal, Dialog } from "@/components/application/modals/modal";
<ModalOverlay isDismissable isOpen={open} onOpenChange={(v) => { if (!v) close(); }}>
  <Modal><Dialog><div>контент</div></Dialog></Modal>
</ModalOverlay>
// Escape и backdrop click — автоматически. Ручной useEffect для Escape не нужен
```

**Checkbox**
```tsx
import { Checkbox } from "@/components/base/checkbox/checkbox";
<Checkbox isSelected={bool} onChange={(isSelected) => void} label="Текст" />
```

### Семантические цвета (продуктовые)

| Роль | Используй | Вместо |
|------|-----------|--------|
| Text | `text-primary`, `text-secondary`, `text-tertiary` | `text-gray-900` |
| Background | `bg-primary`, `bg-secondary`, `bg-brand-solid` | `bg-blue-700`, `#hex` |
| Border | `border-primary`, `border-secondary`, `border-brand` | `border-gray-200` |
| Icons | `fg-primary`, `fg-secondary`, `fg-brand-primary` | — |

Tailwind v4: `bg-brand-solid` (→ `--background-color-brand-solid`). `bg-brand-600` → прозрачный.

### Lessons Learned (баги которые повторялись)

1. **`space-y-*` ненадёжен в Tailwind v4** — используй `flex flex-col gap-*`
2. **`h-full justify-center` обрезает при overflow** — используй `min-h-full`
3. **`flex-[N]` ненадёжен для split** — используй `w-1/2 shrink-0` + `flex-1`

### Правила

| Правило | Как |
|---------|-----|
| Компоненты из библиотеки | Проверь components/ → MCP → только потом кастом |
| Семантические цвета | `text-primary`, `bg-brand-solid` (не hex, не gray-*) |
| Иконки из Untitled UI | `@untitledui-pro/icons` / `@untitledui/icons` (не lucide) |
| 3D WebP изображения | Из /public/ или Drive (не emoji) |
| Файлы kebab-case | `date-picker.tsx` (не DatePicker.tsx) |
| Spacing шкала | 4/8/12/16/24/32/48/64/96 (не px) |
| Шрифт ≥ 11px | Мин. 11px |
| React Aria с префиксом | `import { Button as AriaButton }` |
| onClick на Button | Не onPress (тип = ButtonHTMLAttributes) |
| ModalOverlay для модалок | isDismissable — Escape + backdrop встроены |
| Тире в текстах | Одинарный дефис `-` с пробелами. Не `--` (двойной), не `—` (длинное). Повторяющаяся ошибка |

## Verify Phase (БЛОКЕР перед деплоем)

### Visual Verification
1. `preview_start` → `preview_screenshot`
2. Прогнать чеклист quality bar (ниже)
3. Только после этого → deploy

### Quality Bar — world-class чеклист

```
HIERARCHY (что видно первым?)
□ Один primary CTA на экран?
□ Визуальный вес = важность? (крупнее = важнее)
□ Не больше 3 уровней типографики на экране?

SPACING & RHYTHM
□ Все spacing из шкалы 4/8/12/16/24/32/48?
□ Правило 1:3 — spacing между группами ≥ 3× внутри группы?
□ Колонки одной высоты? Блоки заполняют пространство?

COLOR
□ Max 1 brand + 1 accent + neutral ramp?
□ Контраст текста ≥ 4.5:1 (body) / ≥ 3:1 (large text)?
□ Семантические токены (не hex, не gray-*)?

TYPOGRAPHY
□ Line-height: 1.2-1.3 заголовки, 1.5-1.6 body?
□ Max 2 размера шрифта в одном компоненте?
□ tabular-nums для чисел в таблицах?

MOTION
□ 150-250ms длительность?
□ ease-out для появления, ease-in для ухода?
□ Не больше 3 одновременных анимаций на viewport?
□ prefers-reduced-motion учтён?

ACCESSIBILITY
□ Touch targets ≥ 44px?
□ focus-visible на интерактивных элементах?
□ Keyboard navigation работает?

ANTI-PATTERNS (каждый = стоп)
□ Нет карточек внутри карточек?
□ Нет emoji в UI?
□ Нет приплюснутых изображений?
□ Нет bounce/elastic анимаций?
□ Нет glassmorphism как декорации?
```

## Изображения в UI

3D WebP из `/public/` или Google Drive ("Logo VEDA / 3D иконки"). Конвертация: `cwebp -q 85 input.png -o output.webp` (max 300KB). Всегда `width`, `height`, `loading="lazy"`.

## Reference

| Файл | Что | Когда читать |
|------|-----|-------------|
| `reference/design-principles.md` | World-class UI принципы: hierarchy, density, typography, spacing, color, motion, accessibility | Новая страница, крупный рефакторинг, ревью |
| `reference/vedantica-canon.md` | DESIGN.md Vedantica: mood, палитра, типографика, референсы Apple+Aesop+Arc | Маркетинг-сайт, лендинги, editorial |
| `reference/anti-patterns.md` | 20 признаков любительского UI с примерами и фиксами | Ревью, self-check, «что-то не то» |
| `reference/untitled-ui-cheatsheet.md` | Untitled UI: быстрый справочник props и паттернов | При использовании компонентов |
| `reference/untitled-ui-full.md` | Untitled UI: полная документация (38KB) | По требованию |
| `reference/component-registry.md` | Реестр установленных компонентов + props | При добавлении нового компонента |
| `reference/page-layouts.md` | Шаблоны страниц | Новая страница |
| `reference/slide-layouts.md` | Шаблоны слайдов | Презентация |
| `reference/pdf-pptx-rules.md` | PDF/PPTX: стек, логотипы, палитра, QA | PDF/PPTX генерация |

## Memory-файлы (формы заказа)

При работе с формами заказа/оплаты на vedantica.ru:
- `~/.claude/projects/-Users-alex-Projects/memory/feedback_order_form_ux.md` — UX формы: CTA, поля, trust, 152-ФЗ
- `~/.claude/projects/-Users-alex-Projects/memory/feedback_gc_widgets_broken.md` — НЕ использовать GC виджеты
