# Pricing Hierarchy — best practices

Как формировать цены на лендингах, офферах, презентациях. Research-backed, не мнение.

## Правило иерархии (3 уровня)

Для high-ticket продуктов (от 100K ₽) три ценовых элемента формируют блок. Их визуальный вес задаёт конверсию.

| Элемент | Роль | Размер vs финальная | Цвет |
|---------|------|---------------------|------|
| Финальная цена (что платит клиент) | Primary focus | 100% (самый крупный, bold) | основной текстовый |
| Зачёркнутая исходная (anchor) | Secondary — якорь скидки | ~40-45% от финальной | muted (gray-400) |
| Рассрочка/мес (accessibility) | Secondary — снижает sticker shock | ~45-50% от финальной | **accent** (амбер/бренд) |

**Анти-паттерн:** зачёркнутая равна или крупнее финальной — размывает фокус, клиент не понимает что он реально платит.
**Анти-паттерн:** рассрочка в 11-13px серым — невидима, high-ticket конверсия падает.

## Рассрочка — критичный элемент high-ticket

ConversionXL / Monetizely исследования:
- Monthly framing на high-ticket даёт **+20-40% к конверсии**
- Для продуктов от 100K ₽ рассрочка должна быть **визуально заметна** (своя строка, accent-цвет, минимум 45% от размера финальной цены)
- Формула presentation: **total first → installment as lower anchor** ("249 900 ₽ или 10 413 ₽/мес × 24 мес 0%"). Именно в таком порядке.
- Beсзл% / 0% подписывать явно — снимает недоверие к "скрытым комиссиям"

## Зачёркнутая цена (strikethrough)

- Должна быть **clearly visible** на мобиле (>60% трафика). Минимум 14-16px на десктопе, не меньше 12px на мобиле
- Соотношение strikethrough:final = ~1:2.4 хороший дефолт (15/36, 16/38, 18/42)
- EU Omnibus Directive: зачёркнутая = минимальная цена за 30 дней до промо. Для РФ не обязательно, но честность полезна для доверия
- Strikethrough без reference price (когда скидки реально нет) — снижает доверие, часто триггерит "fake discount" ощущение

## Sale badge — дизайн

- Классический sunburst (звезда-солнце с лучами) ассоциируется со скидкой лучше, чем обычный pill `-XX%`
- Цвет: амбер/жёлтый (#F59E0B) или красный на тёмном. На светлом — красный/амбер с тёмным текстом
- Размер badge: примерно = высоте финальной цены
- SVG polygon с 16 точками (8 острых лучей) — минимальный код, нет растра

Пример реализации sunburst: см. `platform/veda-presentation/app/components/visuals/library/SlideDirectionOffer.tsx` — footer BundleOffer.

## Layout pricing block

Порядок сверху вниз (right-aligned в горизонтальном блоке):

```
1 545 000 ₽         ← strikethrough, 16px, gray-400
249 900 ₽           ← FINAL, 38px, bold
или 10 413 ₽/мес ×  ← installment, 17px, amber accent
24 мес 0%
                    [sunburst -84%]
```

## Research sources

- ConversionXL: visual hierarchy на pricing → +35% конверсии
- SiteTuners (high-ticket): zero-interest installments → +20-40% lift на high-ticket funnel
- Monetizely: "total investment, then installments" как proven psychological frame для премиум продуктов
- Growth Suite / Voucherify: strikethrough-to-final ratio, readability thresholds
- Research на strikethrough reference pricing: +20-30% purchase intent vs sale-only

## Чеклист перед деплоем цены

- [ ] Финальная цена — самый крупный bold элемент в блоке
- [ ] Зачёркнутая читаема на 320px-ширине viewport (симуляция iPhone SE)
- [ ] Рассрочка видна, в accent-цвете, своя строка
- [ ] "0%" / "без %" явно прописано если рассрочка беспроцентная
- [ ] Badge скидки: sunburst или минимум pill с контрастом ≥ 4.5:1
- [ ] Нет "слипшихся" элементов — между price и badge минимум 16-20px
