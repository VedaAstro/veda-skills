---
name: veda-ui-system
description: World-class UI для Veda на Untitled UI React v8. Workflow CLI search → example install → data-swap. SSOT правил = AGENT.md в каждом проекте. Используй при ЛЮБОЙ работе с интерфейсом.
---

# Veda UI System v3 — based on Untitled UI React v8

> **Полностью переписан 2026-04-27** после ресёрча всей официальной документации UUI и AGENT.md.
> Старая версия скилла (v1, v2) использовала community MCP `get_example` для копирования markup. Это было неправильно — приводило к 6-итерационным переделкам.
> Новая версия использует **официальный workflow Untitled UI v8**: `search → example install → data-swap`.

---

## Стек платформы

- **Untitled UI React v8** (последняя версия, components.json `"version": "8"`)
- **Tailwind CSS v4.2** (color tokens, spacing scale, theme через @theme в CSS)
- **React 19.2** + **TypeScript 5.9**
- **React Aria Components 1.16** (a11y foundation)
- **Pro license**: lifetime, unlimited projects, активна (token в `~/.untitledui/config.json`)

---

## SSOT правил для AI агента

В корне каждого фронтенд-проекта VEDA лежит файл **`AGENT.md`** (37KB) — официальная инструкция Untitled UI для AI кодеров. Содержит:

- Naming conventions: `Aria*` prefix для react-aria imports, kebab-case file names
- Compound components с dot notation (`Select.Item`)
- Полный список цветовых токенов (text-primary, bg-brand-solid, fg-success-secondary и т.д.)
- Icon usage patterns с `data-icon` attribute
- Form/Animation/State management
- Reference самых частых компонентов (Button, Input, Select, Checkbox, Badge, Avatar, FeaturedIcon, Link)

**Перед любой UI задачей** — `Read /Users/alex/Projects/platform/<project>/AGENT.md`. Это базовый контекст. Без него ты не знаешь UUI conventions.

Если AGENT.md в проекте отсутствует:
```bash
cd <project>
curl -o AGENT.md https://www.untitledui.com/react/AGENT.md
```

---

## Workflow: SEARCH → EXAMPLE → DATASWAP (default mode)

### Шаг 1 — SEARCH (семантический поиск UUI)

Описываешь задачу естественным языком. Семантический AI-search на multimodal embeddings находит подходящие компоненты/templates/icons:

```bash
npx untitledui@latest search "orders table with filters and search" --limit 5
```

Возвращает:
- **Components** (5) — атомарные UI элементы (filter-bar, button, etc.)
- **Templates** (5) — full-page templates (informational-02/04, dashboards-02/09, etc.)
- **Icons** (5) — иконки

Каждый результат имеет `Install: npx untitledui@latest add NAME --yes` команду.

### Шаг 2 — EXAMPLE INSTALL (ставит page template целиком)

Если задача = новая страница / переделка существующей:

```bash
npx untitledui@latest example dashboards-02/09 --yes
```

CLI делает 5 действий автоматически:
1. **Add main example page** в `app/` или указанный path
2. **Install required components** что используются в template
3. **Install dependencies** (npm packages если нужны)
4. **Configure imports** под структуру проекта (читает components.json aliases)
5. **Prompt for component selection** только если есть конфликты (с `--yes` берёт defaults)

Результат: full functional page готова к использованию.

Опции:
- `-y, --yes` — non-interactive (для AI агентов и CI)
- `-p, --path <path>` — где разместить компоненты (default: `components/`)
- `-e, --example-path <path>` — где разместить page файл (default: `app/`)
- `-o, --overwrite` — перезаписать существующие файлы (по умолчанию НЕ перезаписывает)
- `--include-all-components` — поставить все требуемые компоненты без вопросов

### Шаг 3 — ADD INSTALL (отдельный компонент)

Если задача = добавить один компонент (Button, Filter Bar, Modal):

```bash
npx untitledui@latest add filter-bar --yes
npx untitledui@latest add button toggle avatar --yes  # несколько за раз
```

### Шаг 4 — DATA SWAP (только это разрешено модифицировать)

После установки template — единственное что разрешено менять:

1. **mock data → authFetch hooks**: API запросы, реальные данные
2. **EN labels → RU labels**: текстовые лейблы, заголовки, подсказки
3. **Иконки**: если template использует `<DollarSign01>` а нам нужно `<Phone01>`

**ЗАПРЕЩЕНО менять**: grid/flex/breakpoints, spacing классы, color tokens, padding, layout structure, padding/margin.

---

## Pro Components workflow

UUI Pro имеет 5,000+ компонентов и 250+ templates. Доступ:

### Authentication

Один раз на машину:
```bash
npx untitledui@latest login
```

Token сохраняется в `~/.untitledui/config.json`. На VEDA уже сделано (license token: `b2a0f68518f9be48d5d4b8bec35e8b45`).

### Pro registry для npm packages

Если template требует `@untitledui-pro/*` npm package:
```bash
# Один раз в ~/.zshrc:
export UNTITLEDUI_PRO_TOKEN=$(jq -r .license ~/.untitledui/config.json)
```

`.npmrc` в проекте:
```
@untitledui-pro:registry=https://pkg.untitledui.com
//pkg.untitledui.com/:_authToken=${UNTITLEDUI_PRO_TOKEN}
```

### MCP server (для AI ассистентов)

Официальный UUI MCP server: `https://www.untitledui.com/react/api/mcp`

```bash
claude mcp add --transport http untitledui https://www.untitledui.com/react/api/mcp
```

OAuth для Pro работает автоматически (через браузер при первом Pro запросе).

**ВАЖНО**: официальный MCP **не возвращает код** — он возвращает **CLI команды для install**. AI запускает CLI которая ставит template корректно. Это противоположно community sbilde MCP который возвращал markup для копирования (deprecated подход).

MCP tools:
- `search_components` — semantic search компонентов
- `list_components` — browse по категориям (base, application, marketing, foundations, shared-assets)
- `get_component` — return CLI install command для одного компонента
- `get_component_bundle` — bundle install
- `get_page_templates` — search templates
- `get_page_template_files` — return CLI install command для full template (Pro)
- `search_icons` — поиск иконок

---

## v8 Color tokens (semantic) — обязательно к использованию

Из AGENT.md (полный список см. в проектном `AGENT.md`):

### Text
- `text-primary` — page headings (НЕ `text-gray-900`)
- `text-secondary` — labels, section headings
- `text-tertiary` — supporting text, paragraph
- `text-quaternary` — subtle text, footer headings
- `text-brand-primary` — primary brand text (pricing headers)
- `text-brand-secondary` — buttons, accents
- `text-error-primary`, `text-warning-primary`, `text-success-primary` — semantic states
- `text-placeholder` — input placeholders

### Background
- `bg-primary` — primary white background для всех layouts
- `bg-secondary` — section backgrounds против white
- `bg-tertiary` — toggles
- `bg-brand-primary`, `bg-brand-secondary`, `bg-brand-solid` — brand variations
- `bg-error-primary`, `bg-warning-primary`, `bg-success-primary` — states

### Border
- `border-primary` — high contrast (input fields, button groups)
- `border-secondary` — most common (default для tables, dividers)
- `border-tertiary` — low contrast (axis dividers)
- `border-brand` — active states
- `border-error`, `border-error_subtle` — error states

### Foreground (icons)
- `fg-primary`, `fg-secondary`, `fg-tertiary`, `fg-quaternary` — contrast levels
- `fg-brand-primary`, `fg-brand-secondary` — brand
- `fg-success-primary`, `fg-success-secondary` — success (avatar online dot, positive metrics)
- `fg-error-primary`, `fg-error-secondary` — error

**Запрещено**: `text-gray-900`, `bg-blue-700`, `border-gray-200`, hex codes.

---

## v8 Disabled state

**ОБЯЗАТЕЛЬНО**: один паттерн для disabled — `disabled:opacity-50`. Это v8 unification.

```tsx
// ✅ v8 (правильно)
<Button className="disabled:cursor-not-allowed disabled:opacity-50" />

// ❌ v7 (legacy, НЕ использовать)
<Button className="disabled:bg-disabled_subtle disabled:text-disabled disabled:ring-disabled" />
```

Старые v7 disabled tokens (`text-disabled`, `ring-disabled`, `border-disabled`, `text-fg-disabled`, `text-fg-disabled_subtle`, `bg-toggle-button-fg_disabled`) удалены в v8.

---

## v8 Modal structure

В v8 wrapper `<div>` внутри `<Dialog>` УБРАН — стили перенесены в base `Modal`/`Dialog`. `max-w-*` теперь на `<Modal>`.

```tsx
// ✅ v8
<Modal className="sm:max-w-100">
  <Dialog>
    {/* content directly here */}
  </Dialog>
</Modal>

// ❌ v7 (legacy)
<Modal>
  <Dialog>
    <div className="relative w-full overflow-hidden rounded-2xl bg-primary shadow-xl sm:max-w-100">
      {/* content */}
    </div>
  </Dialog>
</Modal>
```

В v8 это исправило bug где клик по visible overlay не закрывал modal.

---

## Naming conventions

### Imports
- React Aria: всегда `Aria*` prefix
  ```tsx
  // ✅
  import { Button as AriaButton, TextField as AriaTextField } from "react-aria-components";
  // ❌
  import { Button, TextField } from "react-aria-components";
  ```
- UUI components: из `@/components/{base,application,foundations,marketing,shared-assets}/`

### Files
- Все файлы в **kebab-case**: `date-picker.tsx`, `user-profile.tsx`, `api-client.ts`
- Компоненты, hooks, utilities, tests, configs

### Compound components
```tsx
const Select = SelectComponent as typeof SelectComponent & {
  Item: typeof SelectItem;
  ComboBox: typeof ComboBox;
};
Select.Item = SelectItem;
Select.ComboBox = ComboBox;

// Использование:
<Select items={users}>
  {(item) => <Select.Item id={item.id}>{item.name}</Select.Item>}
</Select>
```

---

## Icons

### Packages
- `@untitledui/icons` (free) — 1,100+ line-style icons
- `@untitledui-pro/icons` (Pro) — 4,600+ icons в 4 стилях (line, duocolor, duotone, solid)
- `@untitledui/file-icons` — file type icons

### Imports (tree-shakeable)
```tsx
// ✅ Named imports
import { Home01, Settings01, ChevronDown } from "@untitledui/icons";

// Pro styles (импорт из подпапок):
import { Home01 } from "@untitledui-pro/icons";              // line (default)
import { Home01 } from "@untitledui-pro/icons/duocolor";
import { Home01 } from "@untitledui-pro/icons/duotone";
import { Home01 } from "@untitledui-pro/icons/solid";
```

### Usage в Button props
```tsx
// ✅ Component reference (preferred)
<Button iconLeading={ChevronDown}>Options</Button>

// ✅ JSX element (MUST include data-icon)
<Button iconLeading={<ChevronDown data-icon className="size-4" />}>Options</Button>

// ❌ JSX без data-icon — ломает styling
<Button iconLeading={<ChevronDown className="size-4" />}>Options</Button>
```

### Sizes
```tsx
<Home01 className="size-4" />  // 16px
<Home01 className="size-5" />  // 20px (default для inputs)
<Home01 className="size-6" />  // 24px

// Color (semantic tokens):
<Home01 className="size-5 text-fg-success-secondary" />

// Stroke width (line icons only):
<Home01 className="size-5" strokeWidth={2} />

// Decorative — нужен aria-hidden:
<Home01 className="size-5" aria-hidden="true" />
```

---

## v8 Component sizing changes

В v8 default sizes изменились:

- **Select default**: было `sm`, стало `md` — если полагался на default, добавь `size="sm"` явно
- **Input default**: было `sm`, стало `md` — то же
- **Button**: получил новый `xs` (32px) для compact UI
- **Social Buttons**: получил `md` (40px)
- **Avatar**: убрана `xxs` size — везде где было `xxs` нужно заменить на `xs`

---

## Money formatting (правило VEDA)

**ВСЕГДА** полная цифра через `formatCurrency()`:
```tsx
import { formatCurrency } from '@/app/components/admin/sales-control/shared/formatters';

formatCurrency(12014218)  // "12 014 218 ₽"
formatCurrency(293200)    // "293 200 ₽"
```

**ЗАПРЕЩЕНО**:
- `formatCompactAmount` (старая функция в codebase) — DELETE её
- Текст вида `293,2 К ₽` или `1 М ₽`
- Любые сокращения K/M/k/m

Это правило enforced **content-level hook v2**: при Edit/Write на .tsx с `formatCompactAmount` или ` К ₽`/` М ₽` в новом коде — hook блокирует.

---

## Animations

```tsx
// Default transitions для UI:
className="transition duration-100 ease-linear"
```

Это snappy 100ms linear transition для hover states, color changes, etc.

Для сложных анимаций — `motion` (Framer Motion). Для utility-based — `tailwindcss-animate`.

---

## Untitled UI v8 — what's new (что использовать вместо custom)

### Filter Bar (новый в v8) — для filter rows на list pages

**Используй когда**: список с поиском + dropdown фильтрами + active filter tags.

```bash
npx untitledui@latest add filter-bar --yes
```

Вместо ручной композиции `<Input> + <MultiSelect> + <Toggle> ×3`.

### Tree View — для иерархических списков
### Color/Gradient/Image Pickers — для редакторов
### 12 dropdown variants — для меню/avatar/breadcrumb/account
### Number counter, Tag input, OTP input — для форм
### 4 empty state variants — для пустых состояний
### Pagination с rows-per-page

---

## STEP 0 — обязательный preflight для UI задачи

```
1. Read AGENT.md в проекте — UUI conventions
2. Read /Users/alex/Projects/platform/docs/design/UUI-PAGE-MAP.md — какой template/блоки нужны
3. Read reference/negative-samples.md — какие кривые паттерны уже есть
4. npx untitledui@latest search "<описание задачи>" — найти подходящий
5. npx untitledui@latest example NAME --yes ИЛИ add NAME --yes
6. Data swap: mock → API, EN → RU, иконки
7. Build + verify
```

Hook v2 в `~/.claude/hooks/design-md-preflight.sh`:
- TTL 600s — требует свежий `mcp__untitledui__*` или CLI команду
- Content-level: блокирует `formatCompactAmount`, `<div rounded-xl ring-1>` без UUI Metrics
- Не пытайся обходить — это защита от 6-итерационных переделок

---

## When you actually need to deviate from UUI

UUI files are copy-paste — they live in your project as plain `.tsx` after CLI install. Anyone can edit them. **Don't.** Three legitimate paths instead:

### 1. You need different behavior (animation, hidden-on-hover, custom logic)
Wrap, don't patch. Make a thin wrapper in `app/components/<feature>/<name>.tsx` that imports the UUI component and adds your behavior on top. The UUI file stays canonical so future `npx ... add NAME --overwrite` keeps working.

### 2. You need a brand override (logo, brand color)
Declare it. For colors — only `styles/brand-tokens.css` with `--color-brand-25..950` ([UUI v8 theming spec](https://www.untitledui.com/react/docs/theming.md)). For logo — make `app/components/branding/veda-logo.tsx` and import it on your pages instead of `UntitledLogo`. Never patch `components/foundations/logo/untitledui-logo.tsx` directly.

### 3. You need a fresh copy (drift detected, accidental edits)
Run `npx untitledui@latest add <component> --yes --overwrite`. CLI will replace the file with current canonical version. Lost local edits = good, that's the point.

## How to detect drift in UUI files

Quarterly or before any `npm run build` for production:
```bash
# Read UUI canonical via MCP, diff against local file:
# 1. mcp__untitledui__get_component (type='application', name='metrics')
# 2. Compare with components/application/metrics/metrics.tsx
# Drift = manual edits leaked. Fix via add --overwrite.
```

Future: `~/.claude/hooks/uui-library-guard.sh` blocks Edit/Write to `components/{base,application,foundations}/` unless first line is `// BRAND OVERRIDE`. Files with this marker are allowed (declared re-exports).

## CRITICAL anti-pattern that broke us (2026-04-28)

❌ **Generated CSS files that override UUI scale tokens in raw pixels.**

A custom `product.tailwind.css` (generated from `product.design.md` via `scripts/design-md/`) emitted:
```css
--spacing-4: 4px;     /* WRONG: should be calc(var(--spacing) * 4) = 16px */
--radius-lg: 12px;    /* WRONG: overrides UUI canonical 8px */
--text-sm: 14px;      /* MISSING --text-sm--line-height */
```

Tailwind v4 + UUI expects `--spacing-N` to follow `calc(var(--spacing) * N)` formula. Pixel overrides break:
- `px-8` becomes 8px instead of 32px → all content sticks to edges
- `gap-4` becomes 4px instead of 16px → cards smash together
- `rounded-lg` becomes 12px instead of 8px → all cards visually fatter

**Lesson**: Never write a "design SSOT" that emits pixel values for `--spacing-*`, `--radius-*`, or `--text-*` without `--line-height`. Either trust UUI's `theme.css` entirely, or write narrow brand-only overrides (`--color-brand-*`) per UUI v8 official theming spec.

**If you see**: any imported `.css` defining `--spacing-N: <pixels>px` → that's a killer. Remove the import or fix the file.

## NEVER DO (anti-patterns from history)

❌ **Custom `<div className="rounded-xl ring-1 ring-secondary px-4 py-3">` карточки** вместо UUI Metrics/Card. Hook v2 блокирует.

❌ **`formatCompactAmount` или text вида `293,2 К ₽`**. Только `formatCurrency`. Hook v2 блокирует.

❌ **Arbitrary value `h-[280px]` / `w-[600px]` в admin zones**. Расширь theme.css через `@theme` блок (см. AGENT.md theme section). Hook v2 предупреждает.

❌ **Модификация UUI library файлов** (`components/application/metrics/metrics.tsx`). Copy-paste модель — НЕ «поправлю чтоб подошло». Если template требует изменений — дублируй компонент в проектную папку.

❌ **CSS-хаки `[&>div]:hidden` для скрытия слотов UUI компонента**. Не подходит → выбери другой компонент через search.

❌ **Использовать `mcp__untitledui__get_example` для копирования markup** (community sbilde MCP). Это deprecated workflow. Используй CLI `example`/`add` install.

❌ **Использовать `text-gray-*`, `bg-blue-*`, hex codes**. Только semantic tokens (text-primary, bg-brand-solid).

❌ **JSX icon без `data-icon`** в Button props. Иначе styling ломается.

❌ **v7 disabled patterns** (text-disabled, ring-disabled, bg-disabled_subtle). Только `disabled:opacity-50`.

❌ **lucide icons** в проектах где есть @untitledui/icons. Заменить на UUI icons (бывают разные имена — `npx untitledui@latest search "<name>" --type icons`).

---

## Reference files

| Файл | Что | Когда |
|------|-----|-------|
| `<project>/AGENT.md` | UUI v8 SSOT правил для AI агентов (37KB) | Перед ЛЮБОЙ UI задачей |
| `/Users/alex/Projects/platform/docs/design/UUI-PAGE-MAP.md` | Mapping наших страниц → UUI templates через CLI | STEP 0 lookup |
| `reference/negative-samples.md` | Реестр кривых паттернов в codebase + правильный UUI аналог | Search по target file |
| `<project>/styles/theme.css` | UUI canonical scale (spacing, text, radius, shadow) — единственный источник | Любая UI задача |
| `<project>/styles/brand-tokens.css` | Veda brand colors (`--color-brand-25..950`) — UUI v8 official override | Если нужен бренд цвет |
| `/tmp/uui-docs/*.md` | Скачанные .md официальной UUI доки (20 файлов) | Когда нужны точные правила |

## Verify Phase (БЛОКЕР перед deploy)

### Compliance Checklist

```
□ AGENT.md прочитан в начале сессии
□ formatCurrency() для денег (полная цифра «12 014 218 ₽»)
□ Все KPI блоки — UUI Metrics* (НЕ custom <div rounded-xl>)
□ Все таблицы — внутри UUI Card/TableCard
□ Filter row — внутри CardHeader или Filter Bar component
□ Action buttons — в PageHeader или CardHeader
□ Spacing 4/8/12/16/24/32/48 (нет произвольных px кроме UUI оригинальных)
□ Цвета — semantic tokens (text-primary, bg-brand-solid; нет hex, нет gray-*)
□ Иконки — @untitledui-pro/icons или @untitledui/icons (нет lucide)
□ Skeleton — копия структуры из UUI ref (не custom)
□ disabled:opacity-50 (v8) — нет v7 disabled tokens
□ Aria* prefix для react-aria imports
□ Файлы kebab-case (НЕ DatePicker.tsx, а date-picker.tsx)
□ Modal без wrapper div внутри Dialog (v8 структура)
□ Если использовался arbitrary h-[Npx] — расширь theme.css вместо
□ npm run build clean
□ preview_screenshot или preview_snapshot match UUI reference
```

Любой пункт «нет» — НЕ говори «готово». Возвращайся к шагам.

### Visual Verification
1. `preview_start <project>` → `preview_snapshot` для accessibility tree
2. `preview_screenshot` для визуальной проверки
3. Сравнить side-by-side с UUI reference (получить через `npx untitledui@latest search` или https://www.untitledui.com/react/examples/<name>)
4. Только после этого → deploy

---

## Что я выяснил из официальной доки (research 2026-04-27)

### Скачанные файлы в `/tmp/uui-docs/` (20 .md файлов):
- `react_AGENT.md` (37KB) — главный SSOT для AI
- `react_docs_installation.md` (76KB) — full setup
- `react_docs_cli.md` (22KB) — все CLI команды
- `react_docs_upgrade.md` (15KB) — v7→v8 migration
- `react_docs_typography.md` (37KB) — typography scale
- `react_docs_introduction.md`, `theming.md`, `dark-mode.md`, `icons.md`
- `react_integrations_*.md` — nextjs, vite, mcp, claude, v0, bolt, replit, gemini, monorepo, components-json

### Главные инсайты которые меняли мой workflow:

1. **MCP server возвращает CLI команды**, не код — это защита от drift
2. **Filter Bar новый в v8** — native компонент для filter rows
3. **`example` команда ставит full template + dependencies + components** автоматически (5 действий)
4. **Search semantic** на multimodal AI — описывай задачу естественным языком, не UUI termin'ом
5. **AGENT.md обязателен** в проекте — без него AI не знает conventions

---

## История версий скилла

- **v3 (2026-04-27)** — переписан полностью на основе AGENT.md и официальной доки UUI v8. CLI workflow вместо MCP get_example. Filter Bar component. v8 disabled/modal patterns.
- v2 (27.04 utro) — block manifest + composition workflow. Сохранена идея композиции но переехала в UUI-PAGE-MAP.md.
- v1 (до 26.04) — soft text rules без CLI integration. Привело к 6-итерационным переделкам.

## Memory references

- `~/.claude/projects/-Users-alex-Projects/memory/decisions/2026-04-27-uui-page-map-system.md` — архитектура системы защит
- `feedback_uui_source_verbatim.md` — запрет реверс-инжиниринга через MCP
- `feedback_uui_theme_extension_first.md` — расширять theme а не arbitrary value
- `feedback_untitledui_only.md` — никаких custom UI элементов

---

## Quick start для новой UI задачи

```bash
# 1. Read AGENT.md в проекте (5 sec)
cat /Users/alex/Projects/platform/<project>/AGENT.md | head -100

# 2. Read PageMap (5 sec)
cat /Users/alex/Projects/platform/docs/design/UUI-PAGE-MAP.md

# 3. Search подходящий template (10 sec)
cd platform/<project>
npx untitledui@latest search "<задача>" --limit 5

# 4. Install (30-60 sec)
npx untitledui@latest example dashboards-XX/YY --yes
# или
npx untitledui@latest add filter-bar button --yes

# 5. Data swap (15-30 мин)
# - mock data → authFetch hooks
# - EN texts → RU
# - иконки если нужно
# - НЕ менять layout/spacing/colors

# 6. Verify
npm run build
# preview_screenshot для visual check

# 7. Compliance checklist (5 sec)

# 8. Commit + Push + Deploy
git add . && git commit -m "feat(...): UUI v8 install <NAME> + data swap"
git push origin main
./deploy.sh
```

Это весь workflow. Никаких ручных композиций, никакого markup-копирования, никаких guess-work.
