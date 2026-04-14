---
name: webinar-library-visuals
description: Библиотека визуалов для сценариев Ирины Чайки — разрешённые img_tag для TSV, правила использования, примеры по задачам. Перенос из HANDOFF-NEXT-SESSION.md + webinar-production.
---

# Визуалы для сценариев

## Расположение библиотеки

```
Google Drive (синхронизирован локально):
/Users/alex/Library/CloudStorage/GoogleDrive-a.schekotov@astroacademy1.ru/Мой диск/Webinar_Images/

Google Drive Folder ID: 1UwlBZVTPJ46wXqhUrXnlvb4dTxfGyXnM
```

**ВАЖНО:** НЕ использовать `/Users/alex/Projects/Claude_Docs/Images/` — это устаревшая копия.

## Каталог файлов

Файл `CATALOG_STICKMAN.tsv` лежит в этой же папке `library/`. Формат: `filename\ttags\tdescription`. 405 записей. **Читай TSV напрямую, не скачивай картинки.**

---

## Категории (408 файлов)

| Префикс | Кол-во | Стиль | Описание |
|---|---|---|---|
| `icon_` | 32 | 3D цветные иконки, золото/стекло | Абстрактные концепции: AI, бонус, финансы, рост, куратор, сертификат |
| `sfera_` | 18 | 3D сферы на мраморном пьедестале | Сферы жизни: деньги, карьера, любовь, семья, энергия, предназначение |
| `bonus_` | 8 | 3D цветные | Бонусы тарифов: гарантия, магнит клиентов, нейроастролог |
| `module_` | 11 | 3D цветные | Модули курса: базовая астро, карма, прогнозы, энергия, деньги, любовь |
| `planet_` | 9 | 3D планеты | 9 грах: Su, Mo, Ma, Me, Ju, Ve, Sa, Ra, Ke |
| `sign_` | 24 | 3D знаки зодиака | 12 знаков × 2 варианта (обычные + `_r_` круглые) |
| `house_` | 24 | 3D дома | 12 домов × 2 варианта (обычные + `_r_` круглые) |
| `image` | 280 | Ч/Б стикмены, рисованные | Эмоции, ситуации, боли аудитории. Номерные (image1–image279) |

---

## Разрешённые img_tag (только эти — из HANDOFF-NEXT-SESSION.md)

### Иконки
```
icon_AI-Нейро.png, icon_Финансы.png, icon_Сертификат.png, icon_Время.png,
icon_Вопрос.png, icon_Вопрос ответ.png, icon_Бонус.png, icon_Рост.png,
icon_Поддержка.png, icon_Куратор.png, icon_Чат.png, icon_VIP.png,
icon_Активация.png, icon_Книга.png, icon_Лунные фазы.png,
icon_Гарантия возврата.png, icon_Доступ_Премиум.png, icon_Блокировка.png,
icon_Прямой эфир.png, icon_Домашнее задание.png, icon_Кармический узел.png,
icon_Магнит клиентов.png, icon_Методичка.png, icon_Доп.модуль.png,
icon_Снижение.png, icon_Сообщение.png, icon_Пдф.png, icon_Настройки.png,
icon_Планеты.png, icon_Закрытый клуб.png, icon_Доступ к записям.png,
icon_Проверка домашнего задания.png
```

### Сферы жизни
```
sfera_Деньги.png, sfera_Астрология.png, sfera_Рост дохода.png,
sfera_Прогнозы.png, sfera_Любовь.png, sfera_Карма.png, sfera_Куратор.png,
sfera_Предназначение.png, sfera_Энергия.png, sfera_Обучение.png,
sfera_Семья.png, sfera_Цель.png, sfera_Карьера.png, sfera_Ключ.png,
sfera_Дом.png, sfera_Защита.png, sfera_Путешествие.png,
sfera_Саморазвитие.png
```

### Модули
```
module_Деньги.png, module_Энергия.png, module_Карма.png, module_Любовь.png,
module_Предназначение.png, module_Базовая астрология.png,
module_Прогнозы-1.png, module_Прогнозы-2.png, module_Семья.png,
module_Куратор2.png, module_Карма 2.png
```

### Планеты (только такой формат!)
```
planet_Su.png, planet_Mo.png, planet_Ve.png, planet_Ma.png,
planet_Ju.png, planet_Sa.png, planet_Ra.png, planet_Ke.png, planet_Me.png
```

### Стикмены (только эти номера!)
```
image2.png, image5.png, image14.png, image15.png, image20.png,
image21.png, image22.png, image26.png, image28.png, image29.png,
image30.png, image32.png, image33.png, image35.png, image36.png,
image37.png, image38.png, image39.png, image41.png, image42.png,
image45.png, image46.png, image47.png, image49.png, image50.png,
image51.png, image54.png, image56.png, image57.png, image59.png,
image60.png, image61.png, image62.png, image63.png, image70.png,
image72.png, image75.png, image80.png, image81.png, image83.png,
image87.png, image90.png, image97.png, image109.png, image117.png,
image137.png
```

---

## ❌ НЕ СУЩЕСТВУЮТ (запрещено использовать)

```
planet_Сатурн.png, planet_Солнце.png, planet_Луна.png, planet_Венера.png
sfera_Духовность.png, sfera_Здоровье.png, sfera_Самореализация.png, sfera_Отношения.png
icon_Традиция.png, icon_Мухурта.png, icon_Изобилие.png, icon_Накшатры.png
module_Мухурта.png, module_Накшатры.png, module_Карты.png, module_Транзиты.png
Любые image с номерами НЕ из списка выше (image71, image84, image92 и т.д.)
```

**Правило:** если хочется визуал, которого нет в списке — взять ближайший подходящий. Лучше повторить разрешённый, чем поставить несуществующий.

---

## Правило разнообразия

**Один img_tag не должен повторяться больше 3 раз во всей презентации.**

Если 85 слайдов и повторяется — пересмотреть: можно взять аналогичный из той же категории.

---

## Примеры использования по задаче

| Задача | Что искать | Пример файла |
|---|---|---|
| Бейдж «клиенты» | icon_Магнит клиентов.png | Магнит притягивает золотых человечков |
| Бейдж «AI / инструмент» | icon_AI-Нейро.png | Ноутбук с астро-колесом |
| Бейдж «наставник» | icon_Куратор.png / sfera_Куратор.png | Женщина с книгой на пьедестале |
| Бейдж «доход» | sfera_Рост дохода.png | Золотая диаграмма роста на пьедестале |
| Бейдж «гарантия» | icon_Гарантия возврата.png | Щит с галочкой |
| Модуль курса | module_*.png | Тематические 3D иконки модулей |
| Планета в трактовке | planet_Ju.png | 3D Юпитер |
| Знак зодиака | sign_Leo.png / sign_r_Leo.png | 3D Лев (обычный / круглый) |
| Дом в карте | house_r_10.png | 3D 10-й дом круглый |
| Эмоция «грусть» | image15.png, image20.png, image21.png | Стикмен грустит |
| Эмоция «я смогла!» | image28.png, image33.png, image30.png | Руки вверх, радость |
| Эмоция «задумалась» | image5.png, image14.png | Стикмен думает |
| Эмоция «узнавание» | image37.png, image42.png | Стикмен «а-ха» |
| Приветствие | image29.png, image45.png | Стикмен здоровается |
| Медитация / намерение | image47.png, image49.png | Стикмен в покое |
| Финал / благодарность | image33.png, image50.png | Стикмен улыбается |

---

## Как использовать визуалы в сценарии

### По блокам веба

**Блок 1 (программа, захват):**
- Приветствие: image29 / image45
- Программа: icon_Книга / icon_Планеты / icon_Лунные фазы
- Бонусы: icon_Бонус / icon_Подарок *(если есть)*
- Регалии: icon_Сертификат / icon_Куратор

**Блок 2 (боль, узнавание):**
- Узнавание «устала»: image15, image20, image21
- Цикл застревания: image14 (задумался)
- Снятие вины: image37 (а-ха)
- Разрешение: image30 (расслабленный)

**Блок 3 (фрейм, астро):**
- Метафора «щит»: icon_Настройки
- 12 домов: house_r_X.png (по номерам)
- Планеты: planet_*.png
- Дверь / ключ: sfera_Ключ
- Пруф «5000 лет»: icon_Книга / icon_Активация

**Блок 4 (практика):**
- Таблица лагн: sign_r_*.png (12 знаков)
- Калибровка: image26 / image38
- «Вы сделали!»: image28 / image33
- Тизер глубины: icon_Доступ_Премиум

**Блок 5 (WOW-демо) — только Веб-1:**
- Инструмент: icon_AI-Нейро
- Скриншоты PDF — реальные
- Кейс участницы: image41, image42

**Блок 6 (астрособытие):**
- Солнце: planet_Su
- Луна: planet_Mo
- 3 фазы окна: icon_Время / icon_Лунные фазы / icon_Активация

**Блок 7 (финал, миссия):**
- Лид-магнит: icon_Пдф
- Медитация: image47 / image49
- Финал: image33 / image50

---

## Где проверить актуальность списка

Перед написанием TSV — быстро проверить:

```bash
ls "/Users/alex/Library/CloudStorage/GoogleDrive-a.schekotov@astroacademy1.ru/Мой диск/Webinar_Images/" | head -50
```

Если нашёлся новый файл, которого нет в списке — добавить в этот файл и в `HANDOFF-NEXT-SESSION.md`.

---

## Связанные

- `../types/_index.md` — правила TSV формата
- `../types/warm-up.md` — какие визуалы в каком блоке Веб-1

---

## История

- **2026-04-10** (v1) — перенос из `HANDOFF-NEXT-SESSION.md` + `webinar-production/SKILL.md §«Библиотека визуалов»`. Добавлены примеры использования по блокам веба.
