# ASSETS.md — Карта изображений для PDF

> Все доступные визуальные ассеты. Используй ТОЛЬКО эти пути.

---

## Планеты (9 файлов)

**Путь:** `platform/app-myveda/public/images/planets/`
**Формат:** WebP, ~20KB, 3D сферы

| Файл | Планета | Санскрит |
|------|---------|----------|
| `sun.webp` | Солнце | Surya / Su |
| `moon.webp` | Луна | Chandra / Mo |
| `mars.webp` | Марс | Mangala / Ma |
| `mercury.webp` | Меркурий | Budha / Me |
| `jupiter.webp` | Юпитер | Guru / Ju |
| `venus.webp` | Венера | Shukra / Ve |
| `saturn.webp` | Сатурн | Shani / Sa |
| `rahu.webp` | Раху | Rahu / Ra |
| `ketu.webp` | Кету | Ketu / Ke |

---

## Знаки зодиака (12 + 12 круглых)

**Путь обычные:** `platform/app-myveda/public/images/signs/`
**Путь круглые:** `platform/app-myveda/public/images/signs-round/`
**Формат:** WebP, 256px, 7-15KB

| Файл | Знак | Unicode |
|------|------|---------|
| `aries.webp` | Овен | ♈ |
| `taurus.webp` | Телец | ♉ |
| `gemini.webp` | Близнецы | ♊ |
| `cancer.webp` | Рак | ♋ |
| `leo.webp` | Лев | ♌ |
| `virgo.webp` | Дева | ♍ |
| `libra.webp` | Весы | ♎ |
| `scorpio.webp` | Скорпион | ♏ |
| `sagittarius.webp` | Стрелец | ♐ |
| `capricorn.webp` | Козерог | ♑ |
| `aquarius.webp` | Водолей | ♒ |
| `pisces.webp` | Рыбы | ♓ |

---

## Дома (12 + 12 круглых)

**Путь обычные:** `platform/app-myveda/public/images/houses/`
**Путь круглые:** `platform/app-myveda/public/images/houses-round/`
**Формат:** WebP, 128-256px, 3-10KB

| Файл | Дом | Сфера |
|------|-----|-------|
| `1.webp` | 1-й | Личность, предназначение |
| `2.webp` | 2-й | Деньги, семья, ценности |
| `3.webp` | 3-й | Смелость, навыки, медиа |
| `4.webp` | 4-й | Дом, мать, покой |
| `5.webp` | 5-й | Дети, творчество, романтика |
| `6.webp` | 6-й | Здоровье, служение |
| `7.webp` | 7-й | Партнёр, брак |
| `8.webp` | 8-й | Трансформация, тайное |
| `9.webp` | 9-й | Удача, учитель, путешествия |
| `10.webp` | 10-й | Карьера, статус |
| `11.webp` | 11-й | Мечты, сообщество |
| `12.webp` | 12-й | Духовность, заграница |

---

## Иконки программ (51 файл)

**Путь:** `platform/veda-presentation/public/images/program-icons/`
**Формат:** WebP, 128px, ~220KB (PNG с прозрачным фоном)

**Ключевые:**
- `AI___НЕЙРО.webp` — AI/нейрокуратор
- `Бонус.webp` — бонусные материалы
- `Гарантия_возврата.webp` — гарантия
- `Домашнее_задание.webp` — ДЗ
- `Закрытый_клуб.webp` — сообщество
- `Куратор.webp` — поддержка куратора
- `Магнит_клиентов.webp` — привлечение клиентов
- `Обучение.webp` — учебный процесс
- `Пдф.webp` — PDF-материалы
- `Прямой_эфир.webp` — эфиры
- `Сертификат.webp` — сертификат/ДПО
- `vip.webp` — VIP/эксперт

---

## Модули курсов (11 файлов)

**Путь:** `platform/veda-presentation/public/images/program-modules/`
**Формат:** WebP, 400px, ~376KB

- `Базовая_астрология.webp`
- `Карма.webp`, `Карма_2.webp`
- `Прогнозы.webp`, `Прогнозы_2.webp`
- `Энергия.webp`
- `деньги.webp`
- `любовь.webp`
- `предназначение.webp`
- `семья.webp`
- `Куратор2.webp`

---

## Бонусы (8 файлов)

**Путь:** `platform/veda-presentation/public/images/program-bonuses/`
**Формат:** WebP, 300px, ~188KB

- `Нейроастролог.webp`
- `НейроКуратор.webp`
- `Гарантия-1.webp`, `Гарантия-2.webp`
- `Магнит_клиентов.webp`
- `чат.webp`
- `эфиры.webp`

---

## Стикмены (213 записей)

**Каталог:** `Claude_Docs/Images/CATALOG_STICKMAN.tsv`
**Папка:** `Claude_Docs/Images/Из презы стикман/`
**Формат:** PNG/JPG/GIF, ч/б рисованные

Поиск по тегам в каталоге. Основные категории:
- Эмоции (грусть, радость, успех, страх)
- Ситуации (работа, семья, деньги)
- Действия (движение, рост, выбор)

---

## Конвертация для reportlab

```python
from PIL import Image
import os

ASSETS_BASE = '/Users/alex/Projects/platform/app-myveda/public/images'
PRES_BASE = '/Users/alex/Projects/platform/veda-presentation/public/images'
TMP = '/tmp/pdf_assets'
os.makedirs(TMP, exist_ok=True)

def asset(rel_path, base=ASSETS_BASE):
    """Конвертирует WebP → PNG для reportlab, кэширует в /tmp"""
    src = os.path.join(base, rel_path)
    name = os.path.splitext(os.path.basename(rel_path))[0]
    dst = os.path.join(TMP, f'{name}.png')
    if not os.path.exists(dst):
        Image.open(src).convert('RGBA').save(dst)
    return dst

# Использование:
# planet_moon = asset('planets/moon.webp')
# sign_taurus = asset('signs/taurus.webp')
# house_2 = asset('houses/2.webp')
# icon_cert = asset('program-icons/Сертификат.webp', PRES_BASE)
```

---

## Правила использования

1. **Всегда конвертировать** WebP → PNG через PIL перед drawImage()
2. **mask='auto'** для прозрачного фона
3. **Не растягивать** — сохранять пропорции
4. **Максимум 3 изображения на страницу** — не перегружать
5. **Размеры:** иконки 12-20mm, иллюстрации 30-50mm, планеты 15-25mm
