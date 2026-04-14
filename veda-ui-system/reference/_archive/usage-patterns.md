# Usage Patterns — Паттерны комбинирования компонентов

> Проверенные комбинации компонентов для VEDA. Используй как основу — не изобретай.

---

## 1. Карточка клиента (CRM)

Avatar + Badge + AvatarLabelGroup. Для списков/сайдбаров.

```tsx
import { Avatar } from "@/components/base/avatar/avatar";
import { Badge } from "@/components/base/badges/badges";

<div className="flex items-center gap-3 p-4 rounded-xl bg-primary border border-primary">
  <Avatar size="md" src={avatarUrl} initials={initials} status="online" />
  <div className="flex-1 min-w-0">
    <div className="flex items-center gap-2">
      <span className="text-sm font-semibold text-primary truncate">{name}</span>
      <Badge color="success" type="pill-color" size="sm">Активный</Badge>
    </div>
    <p className="text-xs text-tertiary truncate">{email}</p>
  </div>
  <Button color="secondary" size="sm">Открыть</Button>
</div>
```

---

## 2. KPI-карточка (дашборд)

```tsx
import { Metrics } from "@/components/application/metrics/metrics";

{/* Готовый компонент */}
<Metrics />

{/* Если нужна кастомная */}
<div className="p-6 rounded-xl bg-primary border border-primary">
  <p className="text-sm text-tertiary">Выручка за месяц</p>
  <div className="mt-2 flex items-baseline gap-2">
    <span className="text-3xl font-bold tabular-nums text-primary">84 500 ₽</span>
    <Badge color="success" type="pill-color" size="sm">+12%</Badge>
  </div>
  <p className="mt-1 text-xs text-tertiary">vs предыдущий месяц</p>
</div>
```

---

## 3. Форма (стандарт)

```tsx
import { Input } from "@/components/base/input/input";
import { Select } from "@/components/base/select/select";
import { Button } from "@/components/base/buttons/button";

<div className="space-y-4 max-w-md">
  <Input
    label="Имя клиента"
    placeholder="Введите имя"
    isRequired
  />
  <Input
    label="Телефон"
    placeholder="+7 (___) ___-__-__"
    hint="Без пробелов и скобок"
  />
  <Select
    label="Статус"
    placeholder="Выберите статус"
    items={statusItems}
  />
  <div className="flex gap-3 justify-end pt-2">
    <Button color="secondary" size="md">Отмена</Button>
    <Button color="primary" size="md">Сохранить</Button>
  </div>
</div>
```

---

## 4. Кейс клиента (sales-слайд) {#case-card}

> VEDA-специфичный компонент. Используется в презентациях.
> **Правило #1:** категориальные лейблы ВСЕГДА `text-[11px] font-medium` с серым цветом. НИКОГДА colored text.

### Анатомия

```
┌────────────────────────────────────────────────────────┐
│  [Аватар]  Имя Фамилия, возраст                        │
│            Статус/профессия                            │
├──────────────────────┬─────────────────────────────────┤
│  с чем пришла        │  что сделала                    │
│  (gray label 11px)   │  (gray label 11px)              │
│  Текст проблемы...   │  Текст результата...            │
├──────────────────────┴─────────────────────────────────┤
│               84 500 ₽   ← BIG METRIC (36px bold)      │
│               за 14 дней (gray 12px)                   │
├──────────────────────┬─────────────────────────────────┤
│  ● Было              │  ● Стало                        │
│  (red dot + gray lbl)│  (green dot + gray lbl)         │
│  Описание...         │  Описание...                    │
└──────────────────────┴─────────────────────────────────┘
│  Кто узнаёт себя? ...  (center-aligned footnote)       │
└────────────────────────────────────────────────────────┘
```

### Код

```tsx
<div className="bg-white rounded-2xl overflow-hidden max-w-2xl mx-auto">

  {/* Профиль */}
  <div className="flex items-center gap-4 p-6 pb-4">
    <img src={avatarUrl} className="w-14 h-14 rounded-full object-cover flex-shrink-0" />
    <div>
      <div className="text-[20px] font-semibold text-primary">{name}, {age}</div>
      <div className="text-[13px] font-medium mt-0.5 text-tertiary">{role}</div>
    </div>
  </div>

  {/* С чем пришла / Что сделала */}
  <div className="grid grid-cols-2 gap-3 px-6 pb-4">
    {[
      { label: 'С чем пришла', text: problemText, bg: '#F9FAFB', border: '#E5E7EB' },
      { label: 'Что сделала',  text: actionText,  bg: '#F0F7FF', border: '#DBEAFE' },
    ].map(({ label, text, bg, border }) => (
      <div key={label} className="rounded-xl p-4" style={{ background: bg, border: `1px solid ${border}` }}>
        {/* КРИТИЧНО: лейбл = серый мелкий, НЕ colored */}
        <div className="text-[11px] font-medium mb-2 text-quaternary">{label}</div>
        <p className="text-[13px] leading-relaxed text-secondary">{text}</p>
      </div>
    ))}
  </div>

  {/* Метрика */}
  <div className="mx-6 rounded-xl px-6 py-5 text-center mb-4 bg-secondary border border-primary">
    <div className="text-[36px] font-bold tabular-nums leading-none text-primary">
      {formatNumber(amount)} ₽
    </div>
    <div className="text-[12px] font-medium mt-1 text-quaternary">{period}</div>
    {caption && <div className="text-[12px] mt-1 text-tertiary">{caption}</div>}
  </div>

  {/* Было / Стало */}
  <div className="grid grid-cols-2 gap-3 px-6 pb-5">
    {[
      { label: 'Было',  text: beforeText, dot: '#EF4444', bg: '#FFF7F7', border: '#FFE4E1' },
      { label: 'Стало', text: afterText,  dot: '#22C55E', bg: '#F0FDF4', border: '#BBF7D0' },
    ].map(({ label, text, dot, bg, border }) => (
      <div key={label} className="rounded-xl p-4" style={{ background: bg, border: `1px solid ${border}` }}>
        <div className="flex items-center gap-1.5 mb-2">
          <span className="w-2 h-2 rounded-full flex-shrink-0" style={{ background: dot }} />
          {/* КРИТИЧНО: лейбл = серый мелкий, НЕ colored */}
          <span className="text-[11px] font-medium text-tertiary">{label}</span>
        </div>
        <p className="text-[12px] leading-relaxed text-secondary">{text}</p>
      </div>
    ))}
  </div>

  {cta && (
    <div className="pb-5 text-center">
      <p className="text-[13px] text-quaternary">{cta}</p>
    </div>
  )}
</div>
```

### Правила кейс-карты

```
ОБЯЗАТЕЛЬНО:
  □ Лейблы ("С чем пришла", "Было", "Стало") = text-[11px] серый мелкий, НЕ цветной
  □ "С чем пришла" / "Что сделала" — нейтральный bg, НЕ яркий
  □ Метрика = text-[36px] font-bold tabular-nums
  □ "Было" = красная точка + red-50 bg; "Стало" = зелёная точка + green-50 bg

ЗАПРЕЩЕНО:
  □ НЕ делать цветной текст лейбла ("С чем пришла" красным/оранжевым)
  □ НЕ делать цветной фон секции-заголовка внутри карточки
  □ НЕ делать colored header-бар сверху карточки
  □ НЕ обрезать текст truncate если карточка должна вместить весь текст
```

---

## 5. Anti-patterns

| Запрещено | Правильно |
|-----------|-----------|
| `lucide-react` иконки | `@untitledui-pro/icons` |
| `text-gray-900`, `text-gray-500` | `text-primary`, `text-tertiary` |
| `bg-blue-600` | `bg-brand-solid` |
| `#hex` в inline styles | Semantic token классы |
| `<Button>` без size | Всегда указывай `size="md"` |
| Avatar без fallback | Добавляй `initials` |
| Форма без `max-w-*` | `max-w-md` для стандарт |
| Скриншоты в UI | Нативная вёрстка |
| Лейблы кейс-карты цветными | `text-quaternary` (серый) |
