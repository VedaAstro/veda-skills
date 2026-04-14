# Slide Layouts — Шаблоны вёрстки слайдов

> Canvas: **1280×720px** (16:9). CSS `transform: scale()` масштабирует под экран.
> Каждый слайд = `w-full h-full flex flex-col` внутри 1280×720.
> Минимальный шрифт: `text-[10px]` для подписей, `text-[11px]` для контента.

---

## КРИТИЧНЫЕ ПРАВИЛА ДЛЯ СЛАЙДОВ

```
1. НИКОГДА не используй grid-cols-N если количество элементов не делится на N.
   5 элементов → grid-cols-5 (НЕ grid-cols-2, grid-cols-3!)
   4 элемента → grid-cols-4 или grid-cols-2
   3 элемента → grid-cols-3
   6 элементов → grid-cols-3 (2 ряда) или grid-cols-6
   7 элементов → НЕ grid! Используй другой layout (flex-wrap, 4+3 или 3+4)

2. ВСЕ карточки одного типа = ОДИНАКОВЫЙ визуальный стиль.
   ПЛОХО: модули — горизонтальные с border-left, бонусы — вертикальные с border-top
   ХОРОШО: единый компонент ItemCard, разница только в subtle bg/border

3. ПРОПОРЦИИ СЕКЦИЙ на слайде 1280×720:
   Header: 80-100px (pt-8, text-[24px] title + text-[13px] subtitle)
   Content: ~500-550px (flex-1)
   Footer: 50-60px (py-3, flex-shrink-0)

4. PADDING на слайде:
   Горизонтальный: px-10 (40px) или px-12 (48px)
   Вертикальный: pt-8 pb-2 для content area

5. GAP между секциями: gap-4 (16px)
   GAP внутри grid: gap-3 (12px) для карточек, gap-2 (8px) для плотных
```

---

## ШАБЛОН 1: N элементов в ряд (grid-cols-N)

> Используй: 3-6 одинаковых элементов (модули, бонусы, этапы, преимущества)

### Когда подходит
- Все элементы одного типа и равной важности
- Количество = 3, 4, 5 или 6
- Каждый элемент: иконка + заголовок + описание + (опционально) значение

### Layout
```
┌──────────────────────────────────────────────────────┐
│                    ЗАГОЛОВОК                          │
│                    подзаголовок                        │
├──────────────────────────────────────────────────────┤
│  ┌────┐  ┌────┐  ┌────┐  ┌────┐  ┌────┐            │
│  │icon│  │icon│  │icon│  │icon│  │icon│             │
│  │name│  │name│  │name│  │name│  │name│             │
│  │desc│  │desc│  │desc│  │desc│  │desc│             │
│  │val │  │val │  │val │  │val │  │val │             │
│  └────┘  └────┘  └────┘  └────┘  └────┘            │
├──────────────────────────────────────────────────────┤
│  FOOTER: итог / CTA                                  │
└──────────────────────────────────────────────────────┘
```

### Код (5 элементов)
```tsx
// Карточка — единый компонент
function ItemCard({ item, index }: { item: Item; index: number }) {
  const Icon = item.icon;
  return (
    <motion.div
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.06, type: 'spring', stiffness: 220, damping: 22 }}
      className="flex flex-col items-center text-center rounded-xl px-3 py-4"
      style={{
        backgroundColor: '#FFFFFF',
        boxShadow: '0 1px 3px rgba(0,0,0,0.06)',
        border: '1px solid #F3F4F6',
      }}
    >
      <div
        className="w-11 h-11 rounded-full flex items-center justify-center mb-2.5"
        style={{ backgroundColor: item.accent.iconBg }}
      >
        <Icon size={20} style={{ color: item.accent.text }} />
      </div>
      <p className="text-[13px] font-semibold leading-tight" style={{ color: item.accent.text }}>
        {item.title}
      </p>
      <p className="text-[11px] leading-snug mt-1 flex-1" style={{ color: '#6B7280' }}>
        {item.tagline}
      </p>
      <span className="text-[13px] font-bold tabular-nums mt-2.5" style={{ color: '#374151' }}>
        {formatPrice(item.value)} ₽
      </span>
    </motion.div>
  );
}

// Секция
<div className="grid grid-cols-5 gap-3">
  {items.map((item, i) => (
    <ItemCard key={item.id} item={item} index={i} />
  ))}
</div>
```

### Чеклист
- [ ] Количество элементов = grid-cols-N (нет дыр)
- [ ] Все карточки одной высоты (grid + stretch по умолчанию)
- [ ] Иконка обёрнута в circle/rounded bg (не голая)
- [ ] Текст по центру (text-center для вертикальных карточек)
- [ ] Цена/значение прижато к низу (mt-auto или flex-1 на описании)

---

## ШАБЛОН 2: Две секции по N элементов (stacked grids)

> Используй: когда есть два типа элементов (модули + бонусы, этапы + результаты)

### Когда подходит
- Два набора по 3-5 элементов
- Верхняя секция = основное, нижняя = дополнительное
- Слайд должен вместить 6-10 элементов

### Layout
```
┌──────────────────────────────────────────────────────┐
│                    ЗАГОЛОВОК                          │
├──────────────────────────────────────────────────────┤
│  Секция A: заголовок                        сумма    │
│  ┌────┐  ┌────┐  ┌────┐  ┌────┐  ┌────┐            │
│  └────┘  └────┘  └────┘  └────┘  └────┘            │
│                                                      │
│  Секция B: заголовок                        сумма    │
│  ┌────┐  ┌────┐  ┌────┐  ┌────┐  ┌────┐            │
│  └────┘  └────┘  └────┘  └────┘  └────┘            │
├──────────────────────────────────────────────────────┤
│  FOOTER: общая ценность                              │
└──────────────────────────────────────────────────────┘
```

### Код
```tsx
// Main layout
<div className="w-full h-full flex flex-col" style={{ backgroundColor: '#FAFAFA' }}>
  {/* Header */}
  <div className="text-center pt-8 pb-2 px-12 flex-shrink-0">
    <h2 className="text-[24px] font-bold tracking-tight" style={{ color: '#111827' }}>
      Заголовок
    </h2>
    <p className="text-[13px] mt-1" style={{ color: '#9CA3AF' }}>Подзаголовок</p>
  </div>

  {/* Content: две секции */}
  <div className="flex-1 min-h-0 px-10 pt-3 pb-2 flex flex-col gap-4">
    {/* Секция A */}
    <div>
      <SectionHeader title="Секция A" total={total_a} totalColor="#374151" />
      <div className="grid grid-cols-5 gap-3">
        {itemsA.map((item, i) => <ItemCard key={item.id} item={item} index={i} variant="primary" />)}
      </div>
    </div>

    {/* Секция B */}
    <div>
      <SectionHeader title="Секция B" total={total_b} totalColor="#4338CA" />
      <div className="grid grid-cols-5 gap-3">
        {itemsB.map((item, i) => <ItemCard key={item.id} item={item} index={i} variant="secondary" />)}
      </div>
    </div>
  </div>

  {/* Footer */}
  <div className="px-10 py-3 flex-shrink-0" style={{ borderTop: '1px solid #E5E7EB' }}>
    <div className="flex items-center justify-between">
      <span className="text-[14px] font-semibold" style={{ color: '#111827' }}>Итого</span>
      <span className="text-[22px] font-bold tabular-nums" style={{ color: '#111827' }}>
        {formatPrice(total)} ₽
      </span>
    </div>
  </div>
</div>
```

### Различие variant="primary" vs "secondary"
```tsx
// Primary: белый фон, мягкая тень
backgroundColor: '#FFFFFF',
boxShadow: '0 1px 3px rgba(0,0,0,0.06)',
border: '1px solid #F3F4F6',

// Secondary: лёгкий цветной фон (25% opacity от accent), без тени
backgroundColor: item.accent.iconBg + '40',  // hex + alpha
boxShadow: 'none',
border: `1px solid ${item.accent.iconBg}`,
```

---

## ШАБЛОН 3: Две колонки (split layout)

> Используй: сравнение тарифов, "до/после", основное + детали

### Когда подходит
- 2 сущности для сравнения (тарифы, варианты)
- Или: текст слева + визуал справа
- Карточки ОДИНАКОВОЙ высоты (items-stretch)

### Layout
```
┌──────────────────────────────────────────────────────┐
│                    ЗАГОЛОВОК                          │
├──────────────────────────────────────────────────────┤
│  ┌─────────────────────┐  ┌─────────────────────┐   │
│  │                     │  │     recommended       │   │
│  │   Тариф A           │  │   Тариф B            │   │
│  │   feature 1          │  │   feature 1          │   │
│  │   feature 2          │  │   feature 2          │   │
│  │   feature 3          │  │   feature 3          │   │
│  │                     │  │   feature 4          │   │
│  │   ──────────        │  │   ──────────         │   │
│  │   ЦЕНА              │  │   ЦЕНА               │   │
│  └─────────────────────┘  └─────────────────────┘   │
├──────────────────────────────────────────────────────┤
│  FOOTER: подсказка                                   │
└──────────────────────────────────────────────────────┘
```

### Код
```tsx
<div className="w-full h-full flex flex-col bg-white px-12 py-8">
  {/* Header */}
  <div className="text-center mb-6">
    <h2 className="text-[24px] font-bold tracking-tight" style={{ color: '#111827' }}>
      Заголовок
    </h2>
    <p className="text-[13px] mt-1" style={{ color: '#9CA3AF' }}>Подзаголовок</p>
  </div>

  {/* Two cards — equal height */}
  <div className="flex-1 flex gap-5 items-stretch">
    <TierCard title="Тариф A" features={features_a} price={price_a} />
    <TierCard
      title="Тариф B"
      features={features_b}
      price={price_b}
      recommended
    />
  </div>

  {/* Footer */}
  <div className="mt-4 text-center">
    <p className="text-sm text-gray-500">Подсказка</p>
  </div>
</div>
```

### Ключевые правила split-layout
```
- flex-1 на каждой карточке → одинаковая ширина
- items-stretch → одинаковая высота
- flex-1 spacer внутри карточки → цена прижата к низу
- gap-5 (20px) между карточками
- Рекомендуемая карточка: border-2 + gradient bg + badge сверху
```

---

## ШАБЛОН 4: 2×2 Grid (четыре крупных карточки)

> Используй: доверие, преимущества, 4 ключевые метрики

### Layout
```
┌──────────────────────────────────────────────────────┐
│                    ЗАГОЛОВОК                          │
├──────────────────────────────────────────────────────┤
│  ┌───────────────┐  ┌───────────────┐               │
│  │   Карточка 1   │  │   Карточка 2   │               │
│  │               │  │               │               │
│  └───────────────┘  └───────────────┘               │
│  ┌───────────────┐  ┌───────────────┐               │
│  │   Карточка 3   │  │   Карточка 4   │               │
│  │               │  │               │               │
│  └───────────────┘  └───────────────┘               │
└──────────────────────────────────────────────────────┘
```

### Код
```tsx
<div className="w-full h-full flex flex-col bg-white px-10 py-8">
  <h2 className="text-[24px] font-bold tracking-tight text-center mb-6"
    style={{ color: '#111827' }}>
    Заголовок
  </h2>

  <div className="flex-1 grid grid-cols-2 gap-4">
    {items.map((item, i) => (
      <div
        key={i}
        className="rounded-xl p-5 flex flex-col"
        style={{
          backgroundColor: '#FFFFFF',
          boxShadow: '0 1px 4px rgba(0,0,0,0.06)',
          border: '1px solid #F3F4F6',
        }}
      >
        {/* Icon */}
        <div className="w-10 h-10 rounded-lg flex items-center justify-center mb-3"
          style={{ backgroundColor: item.iconBg }}>
          <item.icon size={20} style={{ color: item.iconColor }} />
        </div>
        {/* Title */}
        <h3 className="text-[15px] font-semibold mb-1" style={{ color: '#111827' }}>
          {item.title}
        </h3>
        {/* Content */}
        <p className="text-[12px] leading-relaxed flex-1" style={{ color: '#6B7280' }}>
          {item.description}
        </p>
      </div>
    ))}
  </div>
</div>
```

### Чеклист 2×2
- [ ] Ровно 4 элемента (НЕ 3, НЕ 5)
- [ ] grid-cols-2 gap-4
- [ ] Все 4 карточки одинакового стиля
- [ ] Контент заполняет 80%+ площади каждой
- [ ] Текст выровнен по левому краю (НЕ center)

---

## ШАБЛОН 5: Полноэкранный с одним акцентом

> Используй: титульный, итоговый, CTA, цитата

### Layout
```
┌──────────────────────────────────────────────────────┐
│                                                      │
│                                                      │
│                  БОЛЬШОЙ ЗАГОЛОВОК                    │
│                  подтекст/пояснение                   │
│                                                      │
│                  [ CTA КНОПКА ]                       │
│                                                      │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### Код
```tsx
<div className="w-full h-full flex items-center justify-center bg-white p-12">
  <div className="text-center max-w-2xl">
    <h2 className="text-[28px] font-bold tracking-tight" style={{ color: '#111827' }}>
      Заголовок
    </h2>
    <p className="text-[16px] mt-3 leading-relaxed" style={{ color: '#6B7280' }}>
      Описание
    </p>
  </div>
</div>
```

---

## АНТИ-ПАТТЕРНЫ (чего НИКОГДА не делать на слайдах)

```
1. grid-cols-2 для 5 элементов → дыра внизу (одинокая карточка)
2. flex-[55] / flex-[45] → кривая пропорция, не из шкалы
3. Разные стили карточек одного уровня → хаос
   (одни с border-left, другие с border-top)
4. Горизонтальные + вертикальные карточки на одном слайде → стилистический конфликт
5. padding px-3 py-8 → "колодец", нарушает симметрию
6. Текст text-[9px] → нечитаемый даже на слайде
7. Карточка с 20% контента и 80% пустоты → "дыра"
8. auto-rows-auto в grid → разная высота карточек → "лесенка"

9. ЦВЕТНОЙ ЗАГОЛОВОК СЕКЦИИ ВНУТРИ КАРТОЧКИ — критичный анти-паттерн:
   ПЛОХО:  <div className="text-red-500 font-semibold">С чем пришла</div>
   ПЛОХО:  <div className="text-blue-500 font-semibold">Что сделала</div>
   ПЛОХО:  Карточка с цветной полосой-заголовком сверху (colored header bar)
   ХОРОШО: <div className="text-[11px] font-medium text-gray-400">С чем пришла</div>
   ПРАВИЛО: Лейблы-категории ВСЕГДА серые (#9CA3AF), крупные цвета — только в dot-индикаторах

10. ОБРЕЗКА ТЕКСТА в кейсе клиента без проверки переполнения:
    ПЛОХО:  overflow-hidden на карточке когда текст может быть длинным
    ХОРОШО: Карточка растягивается по контенту (grid items-start НЕ items-stretch для кейсов)
            ИЛИ проверить что текст точно влезает в фиксированную высоту
```

---

## MENTAL RENDERING: как проверить layout БЕЗ рендера

Перед тем как писать код, посчитай пиксели:

```
Canvas: 1280×720
- px-10 (40px × 2) = 80px → доступная ширина: 1200px
- pt-8 = 32px header top
- Header text (24px + 13px + margins) ≈ 70px
- Footer (py-3 + text) ≈ 50px
- Content area = 720 - 32 - 70 - 50 = ~568px высота

Для grid-cols-5 с gap-3 (12px):
  Ширина карточки = (1200 - 4×12) / 5 = (1200 - 48) / 5 = 230px
  → Достаточно для иконка + 2 строки текста + цена

Для двух секций (gap-4 = 16px):
  Высота на секцию = (568 - 16) / 2 = ~276px
  Header секции ≈ 40px
  Карточка ≈ 236px высоты
  → Достаточно для иконку (44px) + заголовок (18px) + описание (30px) + цена (18px) + padding (32px) = ~142px
  → 236 - 142 = 94px запас → нормально
```

Если "запас" < 20px → слайд будет тесным. Пересмотри layout.
Если "запас" > 150px → контент НЕ заполняет 80%. Добавь элементы или уменьши grid.
