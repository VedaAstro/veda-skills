# Layout Rules — Spacing, Typography, Shadows

> Actionable правила. Нарушение = "колхоз". Основа: Refactoring UI + Veda standards.

---

## Spacing (ТОЛЬКО из шкалы)

```
4px  gap-1 / p-1    → внутри tight-группы (лейбл→значение)
8px  gap-2 / p-2    → между элементами одного уровня
12px gap-3 / p-3    → между мелкими блоками
16px gap-4 / p-4    → стандартный padding контейнера
24px gap-6 / p-6    → между секциями
32px gap-8 / p-8    → между крупными разделами
48px gap-12         → top-level spacing
```

**Правило 1:3** — spacing между группами ≥ 3× spacing внутри группы.

```
gap-2 внутри карточки → gap-6 между карточками ✓
gap-3 везде → нет иерархии ✗
```

**Padding по контейнеру:**

| Контейнер | Padding |
|-----------|---------|
| Compact карточки | p-4 (16px) |
| Стандартные карточки | p-6 (24px) |
| Слайды 1280×720 | px-20 py-10 (80/40px) |
| Страницы desktop | px-6 + max-w-7xl |
| Кнопки | px ≈ 2× py |

---

## Typography

| Размер | Класс | Где |
|--------|-------|-----|
| 11px | `text-[11px]` | Мета, timestamps, лейблы кейс-карты |
| 12px | `text-xs` | Вспомогательный текст, подписи |
| 13px | `text-[13px]` | Основной UI-текст CRM |
| 14px | `text-sm` | Body standard |
| 16px | `text-base` | Body крупный, подзаголовки |
| 18px | `text-lg` | Заголовки секций |
| 20px | `text-xl` | Заголовки страниц |
| 24px | `text-2xl` | Hero-заголовки |

**Правила:**
- Минимум `text-[11px]` в UI. Слайды — допустим `text-[10px]` для подписей.
- Line-height: `leading-relaxed` (12–14px), `leading-tight` (18px+), `leading-none` (заголовки 24px+)
- Числа в таблицах: `tabular-nums text-right`
- Длинный текст: `text-left`, max-width = `max-w-prose` (65ch)
- UPPERCASE + `tracking-wider`. Заголовки + `tracking-tight`.
- Никогда `font-thin`, `font-light` в UI. Де-эмфаз = цвет, не вес.

**Иерархия (3 уровня):**

| Уровень | Класс |
|---------|-------|
| Главное (заголовок, метрика) | `text-primary font-bold` |
| Важное (текст, подзаголовки) | `text-secondary font-medium` |
| Вспомогательное (мета, хинты) | `text-tertiary font-normal` |

---

## Shadows (Elevation)

```
shadow-xs  → buttons, inputs
shadow-sm  → cards, dropdowns
shadow-md  → popovers, tooltips
shadow-lg  → modals, slideouts
shadow-xl  → notification toasts (только)
```

Предпочти разный bg вместо бордеров: `bg-secondary` карточки на `bg-primary` фоне.

---

## Alignment

- **Left-align** — дефолт: текст, формы, дашборды, карточки
- **Center-align** — только: hero-заголовки, модалки, empty states, короткие слайд-заголовки
- Таблицы: текст `text-left`, числа `text-right tabular-nums`, статус `text-center`, действия `text-right`
- Шапка таблицы: `bg-secondary text-xs font-medium text-tertiary uppercase tracking-wider sticky top-0`

---

## Информационная плотность

| Тип интерфейса | Gap | Font | Padding |
|----------------|-----|------|---------|
| CRM / дашборд | 6–10px | 12–14px | 8–12px |
| Landing / marketing | 16–24px | 14–18px | 16–32px |
| Презентации / слайды | 16–32px | 16–24px | 24–40px |

---

## Карточки в ряду

```tsx
{/* Одинаковая высота — ОБЯЗАТЕЛЬНО */}
<div className="grid grid-cols-3 gap-4 items-stretch">
  {items.map(item => (
    <div className="flex flex-col p-6 rounded-xl bg-primary border border-primary">
      <div className="flex-1">{item.content}</div>
      <div className="mt-auto pt-4">{item.action}</div>
    </div>
  ))}
</div>
```

---

## Self-check

```
SPACING:
  □ Все значения из шкалы 4/8/12/16/24/32/48?
  □ Spacing между группами > внутри групп?
  □ Padding симметричный (px ≈ py)?

TYPOGRAPHY:
  □ Нигде < 11px?
  □ 3 уровня иерархии видны?
  □ Числа в таблицах text-right tabular-nums?

LAYOUT:
  □ Формы max-w-md?
  □ Карточки в ряду — одной высоты?
  □ Длинный текст text-left, ≤ 75 символов?

ВИЗУАЛ:
  □ Разделение через shadow/bg, не бордеры?
  □ Модалки/dropdown с тенью (Figure-Ground)?
  □ Скриншоты → нативная вёрстка?
```
