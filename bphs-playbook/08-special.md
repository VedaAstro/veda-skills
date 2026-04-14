# 08. Специальные темы (Viśeṣa)

> Источник: БПХШ, гл. 31-33, 44-47, 68-74, 90-99
> Назначение: авастхи, аштакаварга, спецлагны, аргала, сожжение, мараки, прашна
> Зависимости: [[01-rashi]], [[02-graha]], [[03-bhava]], [[06-shadbala]]

---

## 8.1 Авастхи (Avastha) — 4 системы

### 8.1.1 Балаади — 5 состояний по градусу

| Слот | Градусы | Нечётный знак | Чётный знак | Сила (нечёт/чёт) |
|------|---------|---------------|-------------|-------------------|
| 0 | 0-5°59' | Бала (Bala) | Мрита (Mrita) | 25% / 0% |
| 1 | 6-11°59' | Кумара (Kumara) | Вриддха (Vriddha) | 50% / 50% |
| 2 | 12-17°59' | Юва (Yuva) | Юва (Yuva) | 100% / 100% |
| 3 | 18-23°59' | Вриддха (Vriddha) | Кумара (Kumara) | 50% / 50% |
| 4 | 24-29°59' | Мрита (Mrita) | Бала (Bala) | 0% / 25% |

```
slot = min(floor(degree / 6), 4)
IF odd_sign: [BALA, KUMARA, YUVA, VRIDDHA, MRITA][slot]
ELSE:        [MRITA, VRIDDHA, YUVA, KUMARA, BALA][slot]
Нечёт: Овен(1), Близнецы(3), Лев(5), Весы(7), Стрелец(9), Водолей(11)
```

### 8.1.2 Джаграт/Свапна/Сушупти — 3 состояния

| Авастха | Условие | Множитель |
|---------|---------|-----------|
| Джаграт (Jagrat) | Экзальтация / свой / мулатрикона | 100% |
| Свапна (Svapna) | Друг / нейтральный | 50% |
| Сушупти (Sushupti) | Враг / дебилитация | Минимум |

```
IF exaltation OR own_sign OR moolatrikona → JAGRAT
IF relationship IN [MITRA, ADHI_MITRA, SAMA] → SVAPNA
IF relationship IN [SHATRU, ADHI_SHATRU] OR debilitation → SUSHUPTI
```

### 8.1.3 Дипта-ади — 9 состояний

| # | Авастха | Условие | Сила |
|---|---------|---------|------|
| 1 | Дипта (Deepta) | Экзальтация | Макс |
| 2 | Свастха (Swastha) | Свакшетра | Очень высокая |
| 3 | Мудита (Mudita) | Знак большого друга | Высокая |
| 4 | Шанта (Shanta) | Знак друга | Хорошая |
| 5 | Дина (Dina) | Нейтральный знак | Средняя |
| 6 | Дукхита (Dukhita) | Знак врага | Слабая |
| 7 | Викала (Vikala) | Сожжён | Очень слабая |
| 8 | Кхала (Khala) | Дебилитация | Мин |
| 9 | Бхита (Bhita) | Graha Yuddha (проиг.) | Мин |

```
ПРИОРИТЕТ: Vikala (сожжение) > Bhita (война) > позиционные (1→8)
GRAHA YUDDHA: 2 планеты < 1°. ТОЛЬКО Ma, Me, Ju, Ve, Sa. Победитель = большая сев. широта.
```

### 8.1.4 Шаяна-ади — 12 состояний

| 1-Шаяна | 2-Упавеша | 3-Нетрапани | 4-Пракаша | 5-Гамана | 6-Агама |
|---------|-----------|-------------|-----------|----------|---------|
| 7-Сабха | 8-Агама | 9-Бходжана | 10-Нритьялипса | 11-Каутука | 12-Нидра |

```
Расчёт: (planet_value + nakshatra_value + navamsha_value) * коэфф → mod 12
planet_value: Su=0, Mo=1, Ma=2, Me=3, Ju=4, Ve=5, Sa=6
Практическое применение ограничено. Приоритет: Balaadi → Jagrat/Swapna → Deeptaadi.
```

---

## 8.2 Аштакаварга (Ashtakavarga)

8 источников (7 планет + Лагна) × 12 домов. Бинду (1) / шунья (0). Ra/Ke НЕ участвуют.

### 8.2.1 BAV — Surya (checksum = 48)

| Источник | Дома с бинду | # |
|----------|-------------|---|
| Sun | 1,2,4,7,8,9,10,11 | 8 |
| Moon | 3,6,10,11 | 4 |
| Mars | 1,2,4,7,8,9,10,11 | 8 |
| Mercury | 3,5,6,9,10,11,12 | 7 |
| Jupiter | 5,6,9,11 | 4 |
| Venus | 6,7,12 | 3 |
| Saturn | 1,2,4,7,8,9,10,11 | 8 |
| Lagna | 3,4,6,10,11,12 | 6 |

### 8.2.2 BAV — Chandra (checksum = 49)

| Источник | Дома с бинду | # |
|----------|-------------|---|
| Sun | 3,6,7,8,10,11 | 6 |
| Moon | 1,3,6,7,10,11 | 6 |
| Mars | 2,3,5,6,9,10,11 | 7 |
| Mercury | 1,3,4,5,7,8,10,11 | 8 |
| Jupiter | 1,4,7,8,10,11,12 | 7 |
| Venus | 3,4,5,7,9,10,11 | 7 |
| Saturn | 3,5,6,11 | 4 |
| Lagna | 3,6,10,11 | 4 |

### 8.2.3 BAV — Mangala (checksum = 39)

| Источник | Дома с бинду | # |
|----------|-------------|---|
| Sun | 3,5,6,10,11 | 5 |
| Moon | 3,6,11 | 3 |
| Mars | 1,2,4,7,8,10,11 | 7 |
| Mercury | 3,5,6,11 | 4 |
| Jupiter | 6,10,11,12 | 4 |
| Venus | 6,8,11,12 | 4 |
| Saturn | 1,4,7,8,9,10,11 | 7 |
| Lagna | 1,3,6,10,11 | 5 |

### 8.2.4 BAV — Budha (checksum = 54)

| Источник | Дома с бинду | # |
|----------|-------------|---|
| Sun | 5,6,9,11,12 | 5 |
| Moon | 2,4,6,8,10,11 | 6 |
| Mars | 1,2,4,7,8,9,10,11 | 8 |
| Mercury | 1,3,5,6,9,10,11,12 | 8 |
| Jupiter | 6,8,11,12 | 4 |
| Venus | 1,2,3,4,5,8,9,11 | 8 |
| Saturn | 1,2,4,7,8,9,10,11 | 8 |
| Lagna | 1,2,4,6,8,10,11 | 7 |

### 8.2.5 BAV — Guru (checksum = 56)

| Источник | Дома с бинду | # |
|----------|-------------|---|
| Sun | 1,2,3,4,7,8,9,10,11 | 9 |
| Moon | 2,5,7,9,11 | 5 |
| Mars | 1,2,4,7,8,10,11 | 7 |
| Mercury | 1,2,4,5,6,9,10,11 | 8 |
| Jupiter | 1,2,3,4,7,8,10,11 | 8 |
| Venus | 2,5,6,9,10,11 | 6 |
| Saturn | 3,5,6,12 | 4 |
| Lagna | 1,2,4,5,6,7,9,10,11 | 9 |

### 8.2.6 BAV — Shukra (checksum = 52)

| Источник | Дома с бинду | # |
|----------|-------------|---|
| Sun | 8,11,12 | 3 |
| Moon | 1,2,3,4,5,8,9,11,12 | 9 |
| Mars | 3,5,6,9,11,12 | 6 |
| Mercury | 3,5,6,9,11 | 5 |
| Jupiter | 5,8,9,10,11 | 5 |
| Venus | 1,2,3,4,5,8,9,10,11 | 9 |
| Saturn | 3,4,5,8,9,10,11 | 7 |
| Lagna | 1,2,3,4,5,8,9,11 | 8 |

### 8.2.7 BAV — Shani (checksum = 39)

| Источник | Дома с бинду | # |
|----------|-------------|---|
| Sun | 1,2,4,7,8,10,11 | 7 |
| Moon | 3,6,11 | 3 |
| Mars | 3,5,6,10,11,12 | 6 |
| Mercury | 6,8,9,10,11,12 | 6 |
| Jupiter | 5,6,11,12 | 4 |
| Venus | 6,11,12 | 3 |
| Saturn | 3,5,6,11 | 4 |
| Lagna | 1,3,4,6,10,11 | 6 |

### 8.2.8 Сводка BAV + SAV

| Планета | Бинду | Среднее/знак |
|---------|-------|-------------|
| Sun | 48 | 4.00 |
| Moon | 49 | 4.08 |
| Mars | 39 | 3.25 |
| Mercury | 54 | 4.50 |
| Jupiter | 56 | 4.67 |
| Venus | 52 | 4.33 |
| Saturn | 39 | 3.25 |
| **SAV** | **337** | **28.08** |

```
ИНВАРИАНТ: SAV_total = 337 (любая карта)
SAV > 28 → силён; 25-28 → средний; < 25 → слаб
Транзитный порог: BAV > 4 (из 8) → благоприятный
```

### 8.2.9 Трикона Шодхана

```
ЭТАП 1 — Трикона-редукция:
  Группы: A=[1,5,9] B=[2,6,10] C=[3,7,11] D=[4,8,12]
  Для каждой: min = MIN(3 знака); каждый -= min

ЭТАП 2 — Экадхипатья:
  Пары: Ma=1/8, Ve=2/7, Me=3/6, Ju=9/12, Sa=10/11
  IF управитель В sign_a → reduced[sign_b] = 0
  IF управитель В sign_b → reduced[sign_a] = 0
  IF НЕ в обоих → обнулить меньший
  Su(Leo), Mo(Cancer) — один знак → пропуск

ЭТАП 3 — Пинда:
  РАШИ-ГУНА: Ar=7,Ta=10,Ge=8,Ca=4,Le=10,Vi=8,Li=7,Sc=4,Sg=10,Cp=8,Aq=7,Pi=4
  ГРАХА-ГУНА: Su=5,Mo=5,Ma=8,Me=5,Ju=10,Ve=7,Sa=5
  Pinda(P) = SUM(reduced_BAV[P][sign] * rashi_guna[sign]) для sign 1..12
```

---

## 8.3 Специальные Лагны

| Лагна | Сфера | Формула | Скорость |
|-------|-------|---------|----------|
| Hora (HL) | Богатство | (sun_sign + floor(elapsed/150)) % 12 | 1 знак/150 мин |
| Ghati (GL) | Власть | (sun_sign + floor(elapsed/24)) % 12 | 1 знак/24 мин |
| Bhava (BL) | Бхавы | (sun_sign + floor(elapsed/120)) % 12 | 1 знак/120 мин |
| Varnada (VL) | Статус | см. алгоритм ниже | Расчётная |
| Indu (IL) | Финансы | см. алгоритм ниже | Расчётная |

```
elapsed = birth_time - sunrise_time (минуты); if < 0: += 1440
degree = (elapsed % period) / period * 30

VARNADA LAGNA:
  IF lagna_odd:  lagna_count = lagna_sign + 1 (от Овна)
  ELSE:          lagna_count = 12 - lagna_sign (от Рыб)
  IF hora_odd:   hora_count = hora_sign + 1
  ELSE:          hora_count = 12 - hora_sign
  IF same_parity: total = lagna_count + hora_count
  ELSE:           total = abs(lagna_count - hora_count)
  IF lagna_odd:   varnada = (total - 1) % 12
  ELSE:           varnada = (12 - (total % 12)) % 12

INDU LAGNA:
  Какшья: Su=30, Mo=16, Ma=6, Me=8, Ju=10, Ve=12, Sa=1
  V1 = kakshya[lord_9_from_lagna]
  V2 = kakshya[lord_9_from_moon]
  remainder = (V1 + V2) % 12; if 0 → 12
  Indu Lagna = remainder домов от Луны
```

---

## 8.4 Аргала (Argala)

| Тип | Аргала (от X) | Виродха (от X) |
|-----|--------------|----------------|
| Дхана | 2-й | 12-й |
| Сукха | 4-й | 10-й |
| Лабха | 11-й | 3-й |
| Путра | 5-й | 9-й |

```
ДЕЙСТВИЕ: count(argala_house) > count(virodha_house) → действует
ОТМЕНА: count(virodha) >= count(argala) → отменена
ИСКЛЮЧЕНИЕ: малефики (Su,Ma,Sa,Ra,Ke) в 3-м → аргала, НЕ виродха
ПРИРОДА: бенефики → шубха; малефики → папа
ПОРЯДОК СИЛЫ: 11-я > 2-я > 4-я > 5-я
```

---

## 8.5 Сожжение (Combustion)

| Планета | Asta | Moudhya | Ретро Asta |
|---------|------|---------|------------|
| Moon | 12° | 8° | 12° |
| Mars | 17° | 8° | 17° |
| Mercury | 14° | 7° | 12° |
| Jupiter | 11° | 7° | 11° |
| Venus | 10° | 5° | 8° |
| Saturn | 15° | 8° | 15° |

```
diff = |planet_long - sun_long|; if > 180: diff = 360 - diff
diff <= moudhya → ГЛУБОКОЕ СОЖЖЕНИЕ (Moudhya)
moudhya < diff <= asta → ОБЫЧНОЕ СОЖЖЕНИЕ (Asta)
Ретро: Me 14→12°, Ve 10→8°. Остальные без изменений.
НЕ подвержены: Su, Ra, Ke. Deeptaadi → Vikala.
```

---

## 8.6 Мараки (Maraka)

```
ПРИОРИТЕТ:
1. Бадхакастхана управитель
2. Управитель 2-го
3. Управитель 7-го
4. Планеты в соединении/аспекте с упр. 2/7
5. Планеты В 2/7 домах
6. Малефики, аспектирующие 2/7

БАДХАКА: Chara→11, Sthira→9, Dvisva→7
ПАРАДОКС: слабая марака опаснее — не даёт позитив 2/7 домов
```

| Лагна | Тип | Упр. 2 | Упр. 7 | Бадхака | Упр. Бадх. |
|-------|-----|--------|--------|---------|------------|
| Овен | Chara | Ve | Ve | 11 (Водолей) | Sa |
| Телец | Sthira | Me | Ma | 9 (Козерог) | Sa |
| Близнецы | Dvisva | Mo | Ju | 7 (Стрелец) | Ju |
| Рак | Chara | Su | Sa | 11 (Телец) | Ve |
| Лев | Sthira | Me | Sa | 9 (Овен) | Ma |
| Дева | Dvisva | Ve | Ju | 7 (Рыбы) | Ju |
| Весы | Chara | Ma | Ma | 11 (Лев) | Su |
| Скорпион | Sthira | Ju | Ve | 9 (Рак) | Mo |
| Стрелец | Dvisva | Sa | Me | 7 (Близнецы) | Me |
| Козерог | Chara | Sa | Mo | 11 (Скорпион) | Ma |
| Водолей | Sthira | Ju | Su | 9 (Весы) | Ve |
| Рыбы | Dvisva | Ma | Me | 7 (Дева) | Me |

```
ДВОЙНАЯ МАРАКА (упр. 2 = упр. 7): Овен→Ve, Весы→Ma
ТРОЙНАЯ (7-й lord = badhaka lord): Близнецы→Ju, Дева→Ju, Стрелец→Me

АКТИВАЦИЯ: аюрдая исчерпана + даша мараки + транзит
БЕЗ исчерпания → болезни/кризисы
АЮРДАЯ: Alpa 0-32, Madhya 32-64, Purna 64-100+

БОЛЕЗНИ: Su→сердце,кости Mo→психика,кровь Ma→травмы,хирургия
         Me→нервы,кожа Ju→печень,диабет Ve→почки,репро Sa→хронич.,суставы
```

---

## 8.7 Прашна (Prashna)

```
Время = момент вопроса; Место = астролог
Лагна = спрашивающий; 7-й = предмет; Луна = ум
```

| Вопрос | Дом | Карака |
|--------|-----|--------|
| Здоровье | 1 | Su |
| Деньги, семья | 2 | Ju |
| Братья | 3 | Ma |
| Недвижимость | 4 | Mo |
| Дети, образование | 5 | Ju |
| Враги, суды, болезни | 6 | Ma, Sa |
| Брак, партнёрство | 7 | Ve |
| Наследство, оккультное | 8 | Sa |
| Путешествия, удача | 9 | Ju |
| Карьера, статус | 10 | Su, Sa |
| Прибыль, друзья | 11 | Ju |
| Потери, изоляция | 12 | Sa |

```
ДА: упр. лагны и упр. дома в кендрах + бенефики → лагне
    + Луна растущая в 1,2,4,5,7,9,10,11 + упр. дома силён
НЕТ: малефики в лагне + упр. лагны дебилитирован/сожжён
     + Луна убывающая в 6/8/12 + упр. дома слаб
ТАЙМИНГ: Подвижный→дни-недели; Фиксированный→месяцы-годы; Двойственный→недели-месяцы
         Кендра→скоро; Панапхара→среднее; Апоклима→нескоро
```

### 8.7.1 Таджака-аспекты

| Аспект | ° | Характер |
|--------|---|----------|
| Соединение | 0 | Сильнейший |
| Секстиль | 60 | Дружественный |
| Квадратура | 90 | Напряжённый |
| Тригон | 120 | Гармоничный |
| Оппозиция | 180 | Конфликтный |

Орбы: Su:15° Mo:12° Ma:8° Me:7° Ju:9° Ve:7° Sa:9°

```
ЙОГИ: Иттхашала(сближение)→ДА; Ишрафа(расхождение)→НЕТ
      Накта(передача света)→через посредника; Ямайа(оба в своих)→решится само
УСЛОВИЕ: diff < (orb_P1 + orb_P2) / 2
ЛУНА: применяющий→будет; разделяющий→нет; transfer→через посредника
```

---

## 8.8 Верификационный код

```python
"""Модуль 08 — Верификация специальных тем BPHS."""
from math import floor

# --- АВАСТХИ ---

def calculate_balaadi_avastha(degree, sign_number):
    """sign_number: 1-12. Возвращает: (name, strength%)"""
    ODD = ['Bala','Kumara','Yuva','Vriddha','Mrita']
    EVEN = ['Mrita','Vriddha','Yuva','Kumara','Bala']
    STR = {'Bala':25,'Kumara':50,'Yuva':100,'Vriddha':50,'Mrita':0}
    slot = min(int(degree / 6), 4)
    a = (ODD if sign_number % 2 == 1 else EVEN)[slot]
    return (a, STR[a])

def calculate_jagrat_avastha(is_exalted, is_own, relationship):
    if is_exalted or is_own: return ('Jagrat', 100)
    if relationship in ('great_friend','friend','neutral'): return ('Swapna', 50)
    return ('Sushupti', 10)

def calculate_deeptaadi_avastha(is_exalted, is_own, relationship,
                                 is_combust, is_debilitated, in_graha_yuddha):
    if is_combust: return 'Vikala'
    if in_graha_yuddha: return 'Bhita'
    if is_exalted: return 'Deepta'
    if is_debilitated: return 'Khala'
    if is_own: return 'Swastha'
    return {'great_friend':'Mudita','friend':'Shanta','neutral':'Dina',
            'enemy':'Dukhita','great_enemy':'Dukhita'}.get(relationship, 'Dina')

# --- АШТАКАВАРГА ---

ASHTAKAVARGA_TABLES = {
    'Sun': {
        'Sun':[1,2,4,7,8,9,10,11], 'Moon':[3,6,10,11],
        'Mars':[1,2,4,7,8,9,10,11], 'Mercury':[3,5,6,9,10,11,12],
        'Jupiter':[5,6,9,11], 'Venus':[6,7,12],
        'Saturn':[1,2,4,7,8,9,10,11], 'Lagna':[3,4,6,10,11,12],
    },
    'Moon': {
        'Sun':[3,6,7,8,10,11], 'Moon':[1,3,6,7,10,11],
        'Mars':[2,3,5,6,9,10,11], 'Mercury':[1,3,4,5,7,8,10,11],
        'Jupiter':[1,4,7,8,10,11,12], 'Venus':[3,4,5,7,9,10,11],
        'Saturn':[3,5,6,11], 'Lagna':[3,6,10,11],
    },
    'Mars': {
        'Sun':[3,5,6,10,11], 'Moon':[3,6,11],
        'Mars':[1,2,4,7,8,10,11], 'Mercury':[3,5,6,11],
        'Jupiter':[6,10,11,12], 'Venus':[6,8,11,12],
        'Saturn':[1,4,7,8,9,10,11], 'Lagna':[1,3,6,10,11],
    },
    'Mercury': {
        'Sun':[5,6,9,11,12], 'Moon':[2,4,6,8,10,11],
        'Mars':[1,2,4,7,8,9,10,11], 'Mercury':[1,3,5,6,9,10,11,12],
        'Jupiter':[6,8,11,12], 'Venus':[1,2,3,4,5,8,9,11],
        'Saturn':[1,2,4,7,8,9,10,11], 'Lagna':[1,2,4,6,8,10,11],
    },
    'Jupiter': {
        'Sun':[1,2,3,4,7,8,9,10,11], 'Moon':[2,5,7,9,11],
        'Mars':[1,2,4,7,8,10,11], 'Mercury':[1,2,4,5,6,9,10,11],
        'Jupiter':[1,2,3,4,7,8,10,11], 'Venus':[2,5,6,9,10,11],
        'Saturn':[3,5,6,12], 'Lagna':[1,2,4,5,6,7,9,10,11],
    },
    'Venus': {
        'Sun':[8,11,12], 'Moon':[1,2,3,4,5,8,9,11,12],
        'Mars':[3,5,6,9,11,12], 'Mercury':[3,5,6,9,11],
        'Jupiter':[5,8,9,10,11], 'Venus':[1,2,3,4,5,8,9,10,11],
        'Saturn':[3,4,5,8,9,10,11], 'Lagna':[1,2,3,4,5,8,9,11],
    },
    'Saturn': {
        'Sun':[1,2,4,7,8,10,11], 'Moon':[3,6,11],
        'Mars':[3,5,6,10,11,12], 'Mercury':[6,8,9,10,11,12],
        'Jupiter':[5,6,11,12], 'Venus':[6,11,12],
        'Saturn':[3,5,6,11], 'Lagna':[1,3,4,6,10,11],
    },
}

BAV_TOTALS = {'Sun':48,'Moon':49,'Mars':39,'Mercury':54,'Jupiter':56,'Venus':52,'Saturn':39}
SAV_TOTAL = 337
SIGN_LORDS = {0:'Mars',1:'Venus',2:'Mercury',3:'Moon',4:'Sun',5:'Mercury',
              6:'Venus',7:'Mars',8:'Jupiter',9:'Saturn',10:'Saturn',11:'Jupiter'}

def verify_bav_totals():
    for p, table in ASHTAKAVARGA_TABLES.items():
        total = sum(len(h) for h in table.values())
        assert total == BAV_TOTALS[p], f"{p}: {total} != {BAV_TOTALS[p]}"
    assert sum(BAV_TOTALS.values()) == SAV_TOTAL
    return True

def calculate_bav(planet, positions, lagna_sign):
    """positions: {'Sun':0-11,...}. Возвращает: [12 ints]"""
    bav = [0]*12
    table = ASHTAKAVARGA_TABLES[planet]
    contrib = {**positions, 'Lagna': lagna_sign}
    for src, base in contrib.items():
        for off in table[src]:
            bav[(base + off - 1) % 12] += 1
    return bav

def calculate_sav(all_bavs):
    sav = [0]*12
    for bav in all_bavs.values():
        for i in range(12): sav[i] += bav[i]
    assert sum(sav) == SAV_TOTAL
    return sav

def trikona_shodhana(bav):
    result = list(bav)
    for grp in [[0,4,8],[1,5,9],[2,6,10],[3,7,11]]:
        m = min(result[i] for i in grp)
        for i in grp: result[i] -= m
    return result

# --- СПЕЦИАЛЬНЫЕ ЛАГНЫ ---

def calculate_hora_lagna(sunrise_min, birth_min, sun_sign):
    elapsed = birth_min - sunrise_min
    if elapsed < 0: elapsed += 1440
    return ((sun_sign + int(elapsed / 150)) % 12, round((elapsed % 150) / 150 * 30, 2))

def calculate_ghati_lagna(sunrise_min, birth_min, sun_sign):
    elapsed = birth_min - sunrise_min
    if elapsed < 0: elapsed += 1440
    ghatis = elapsed / 24
    return ((sun_sign + int(ghatis)) % 12, round((ghatis % 1) * 30, 2))

INDU_VALUES = {'Sun':30,'Moon':16,'Mars':6,'Mercury':8,'Jupiter':10,'Venus':12,'Saturn':1}

def calculate_indu_lagna(lagna_sign, moon_sign):
    """lagna_sign, moon_sign: 0-11. Возвращает: sign 0-11"""
    v1 = INDU_VALUES[SIGN_LORDS[(lagna_sign + 8) % 12]]
    v2 = INDU_VALUES[SIGN_LORDS[(moon_sign + 8) % 12]]
    r = (v1 + v2) % 12
    if r == 0: r = 12
    return (moon_sign + r) % 12

# --- СОЖЖЕНИЕ ---

COMBUSTION_ORBS = {
    'Moon':{'asta':12,'moudhya':8,'retro_asta':12},
    'Mars':{'asta':17,'moudhya':8,'retro_asta':17},
    'Mercury':{'asta':14,'moudhya':7,'retro_asta':12},
    'Jupiter':{'asta':11,'moudhya':7,'retro_asta':11},
    'Venus':{'asta':10,'moudhya':5,'retro_asta':8},
    'Saturn':{'asta':15,'moudhya':8,'retro_asta':15},
}

def is_combust(planet, p_long, s_long, is_retro=False):
    if planet in ('Sun','Rahu','Ketu'): return ('none', 0)
    diff = abs(p_long - s_long)
    if diff > 180: diff = 360 - diff
    orbs = COMBUSTION_ORBS.get(planet)
    if not orbs: return ('none', diff)
    asta = orbs['retro_asta'] if is_retro else orbs['asta']
    if diff <= orbs['moudhya']: return ('moudhya', round(diff, 2))
    if diff <= asta: return ('asta', round(diff, 2))
    return ('none', round(diff, 2))

# --- МАРАКИ ---

LAGNA_TYPES = {0:'chara',1:'sthira',2:'dvisva',3:'chara',4:'sthira',5:'dvisva',
               6:'chara',7:'sthira',8:'dvisva',9:'chara',10:'sthira',11:'dvisva'}
BADHAKA_OFFSETS = {'chara':11,'sthira':9,'dvisva':7}

def find_marakas(lagna_sign):
    s2 = (lagna_sign+1)%12; s7 = (lagna_sign+6)%12
    l2 = SIGN_LORDS[s2]; l7 = SIGN_LORDS[s7]
    bh = (lagna_sign + BADHAKA_OFFSETS[LAGNA_TYPES[lagna_sign]] - 1) % 12
    lb = SIGN_LORDS[bh]; dm = (l2 == l7)
    return {'second_lord':l2,'seventh_lord':l7,'badhaka_lord':lb,
            'badhaka_house':bh,'double_maraka':dm,'primary_maraka':l2 if dm else None}

# --- АРГАЛА ---

def check_argala(target, chart):
    """target: 1-12. chart: {house:[planets]}. Возвращает: [argala dicts]"""
    MALEFICS = {'Sun','Mars','Saturn','Rahu','Ketu'}
    results = []
    for a_off, v_off, a_type in [(2,12,'primary'),(4,10,'primary'),(11,3,'primary'),(5,9,'secondary')]:
        ah = ((target-1+a_off)%12)+1; vh = ((target-1+v_off)%12)+1
        ap = chart.get(ah,[]); vp = chart.get(vh,[])
        if not ap: continue
        ev = [p for p in vp if p not in MALEFICS] if a_off == 11 else vp
        results.append({'argala_from':ah,'virodha_from':vh,'type':a_type,
                       'argala_planets':ap,'virodha_planets':ev,'obstructed':len(ev)>=len(ap)})
    return results

# --- ТЕСТЫ ---

def run_all_verifications():
    # Balaadi
    assert calculate_balaadi_avastha(3, 1) == ('Bala', 25)
    assert calculate_balaadi_avastha(15, 1) == ('Yuva', 100)
    assert calculate_balaadi_avastha(27, 1) == ('Mrita', 0)
    assert calculate_balaadi_avastha(3, 2) == ('Mrita', 0)
    assert calculate_balaadi_avastha(15, 2) == ('Yuva', 100)
    assert calculate_balaadi_avastha(27, 2) == ('Bala', 25)
    # BAV totals
    assert verify_bav_totals() == True
    # Combustion
    assert is_combust('Mercury',100,95)[0] == 'moudhya'
    assert is_combust('Mercury',100,88)[0] == 'asta'
    assert is_combust('Mercury',100,80)[0] == 'none'
    assert is_combust('Sun',100,100)[0] == 'none'
    assert is_combust('Venus',100,95,False)[0] == 'moudhya'
    assert is_combust('Venus',100,93,True)[0] == 'asta'
    assert is_combust('Venus',100,91,True)[0] == 'none'
    # Marakas
    m = find_marakas(0)
    assert m['second_lord']=='Venus' and m['seventh_lord']=='Venus'
    assert m['badhaka_lord']=='Saturn' and m['double_maraka']==True
    m = find_marakas(4)
    assert m['second_lord']=='Mercury' and m['seventh_lord']=='Saturn'
    assert m['badhaka_lord']=='Mars'
    m = find_marakas(2)
    assert m['seventh_lord']=='Jupiter' and m['badhaka_lord']=='Jupiter'
    # Indu Lagna
    assert calculate_indu_lagna(0, 1) == 0
    # Deeptaadi
    assert calculate_deeptaadi_avastha(True,False,'neutral',True,False,False) == 'Vikala'
    assert calculate_deeptaadi_avastha(True,False,'neutral',False,False,False) == 'Deepta'
    assert calculate_deeptaadi_avastha(False,True,'neutral',False,False,False) == 'Swastha'
    assert calculate_deeptaadi_avastha(False,False,'enemy',False,True,False) == 'Khala'
    # Argala
    assert check_argala(5, {6:['Mars']})[0]['obstructed'] == False
    print("Все проверки пройдены.")
    return True

if __name__ == '__main__':
    run_all_verifications()
```

---

## 8.9 Верификация

| Тема | Ключевое число | Назначение |
|------|---------------|------------|
| Balaadi | 5 состояний, 6° слоты | Сила по градусу |
| Jagrat/Swapna/Sushupti | 3 состояния | Сила по знаку |
| Deeptaadi | 9 состояний | Сила по положению |
| BAV | 8×12 матрица | Транзиты |
| SAV total | 337 | Инвариант |
| Hora/Ghati/Bhava | 150/24/120 мин | Спецлагны |
| Indu Lagna | 7 значений | Финансы |
| Combustion | 6 планет, 2 орба | Потеря силы |
| Marakas | 2+7+badhaka | Кризисы |
| Argala | 4 пары | Влияние |

```
ЧЕКЛИСТ:
□ АВАСТХИ: odd/even reverse; Юва 12-18° одинакова; Vikala/Bhita > позиционные
□ BAV: Su=48, Mo=49, Ma=39, Me=54, Ju=56, Ve=52, Sa=39 → SAV=337
□ ШОДХАНА: трикона → экадхипатья → пинда
□ СПЕЦЛАГНЫ: Hora +1/150мин, Ghati +1/24мин, Indu: Su=30,Mo=16,Ma=6,Me=8,Ju=10,Ve=12,Sa=1
□ АРГАЛА: 2↔12, 4↔10, 11↔3, 5↔9; малефики в 3-м = аргала
□ СОЖЖЕНИЕ: Me/Ve ретро → уменьшенный орб; Su/Ra/Ke неуязвимы
□ МАРАКИ: Chara→11, Sthira→9, Dvisva→7; слабая > сильной
```

---

← [[07-yoga]] | Конец серии
