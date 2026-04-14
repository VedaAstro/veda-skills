# 05. Варга (Varga)

> Источник: БПХШ, главы 6-8
> Назначение: верификация расчёта дробных карт (16 варг)
> Зависимости: -> 01-rashi, -> 02-graha, -> 04-nakshatra-dasha

---

## Данные

### 1. Шодаша-варга (Shodasha Varga) -- 16 дробных карт

| # | Варга | Санскрит | Деление | Размер части | Сфера | BPHS | Шад(6) | Сапт(7) | Даш(10) | Шод(16) |
|---|-------|----------|---------|--------------|-------|------|--------|---------|---------|---------|
| 1 | D-1 | Rashi | 1 | 30d00'00" | Общая жизнь | 4-5 | 6 | 5 | 3 | 3.5 |
| 2 | D-2 | Hora | 2 | 15d00'00" | Богатство | 6 | 2 | 2 | 1.5 | 1 |
| 3 | D-3 | Drekkana | 3 | 10d00'00" | Братья/сёстры | 6 | 4 | 3 | 1.5 | 1 |
| 4 | D-4 | Chaturthamsha | 4 | 7d30'00" | Имущество | 7 | -- | -- | -- | 0.5 |
| 5 | D-7 | Saptamsha | 7 | 4d17'08.57" | Дети | 7 | -- | 2.5 | 1.5 | 0.5 |
| 6 | D-9 | Navamsha | 9 | 3d20'00" | Брак, дхарма | 6 | 5 | 4.5 | 3 | 3 |
| 7 | D-10 | Dashamsha | 10 | 3d00'00" | Карьера | 7 | -- | -- | 1.5 | 0.5 |
| 8 | D-12 | Dvadashamsha | 12 | 2d30'00" | Родители | 7 | 2 | 2 | 1.5 | 0.5 |
| 9 | D-16 | Shodashamsha | 16 | 1d52'30" | Транспорт | 7 | -- | -- | 2 | 2 |
| 10 | D-20 | Vimshamsha | 20 | 1d30'00" | Духовность | 7 | -- | -- | -- | 0.5 |
| 11 | D-24 | Chaturvimshamsha | 24 | 1d15'00" | Образование | 7 | -- | -- | -- | 0.5 |
| 12 | D-27 | Saptavimshamsha | 27 | 1d06'40" | Сила/слабость | 7 | -- | -- | -- | 0.5 |
| 13 | D-30 | Trimshamsha | 30* | неравные | Несчастья | 7 | 1 | 1 | 1.5 | 1 |
| 14 | D-40 | Khavedamsha | 40 | 0d45'00" | Материнская карма | 8 | -- | -- | -- | 0.5 |
| 15 | D-45 | Akshavedamsha | 45 | 0d40'00" | Отцовская карма | 8 | -- | -- | -- | 0.5 |
| 16 | D-60 | Shashtiamsha | 60 | 0d30'00" | Прошлые жизни | 8 | -- | -- | 3 | 4 |

> -- = варга не входит в данную схему. Суммы весов: 20 для каждой группы.
> *D-30: неравные деления -- 5 частей (см. 2.13)

### 1.1 Иерархия точности

```
D-1 (30d) -> D-2 (15d) -> ... -> D-60 (0d30') = 2 мин реального времени
D-9: 3d20' = ~13 мин. D-60: 0d30' = ~2 мин.
КРИТИЧНО: для D-60 погрешность > 2 мин = невалидный результат.
```

### 1.2 Общая формула (равномерные деления)

```
ВХОД: sign (1-12), degree (0.0 - 29.999...)
1. part = floor(degree / (30 / N))           // 0-indexed
2. start = f(sign, element, oddity, varga)   // по правилам варги
3. varga_sign = ((start - 1) + part) % 12 + 1
```

---

## 2. Формулы расчёта каждой варги

### 2.1 D-1 Раши (Rashi)

```
varga_sign = sign
```

### 2.2 D-2 Хора (Hora)

```
half = floor(degree / 15)  // 0 или 1
IF sign нечётный: hora = (half == 0) ? 5 : 4   // Лев, Рак
ELSE:             hora = (half == 0) ? 4 : 5   // Рак, Лев

ASSERT: результат ТОЛЬКО 4 или 5
```

### 2.3 D-3 Дрекана (Drekkana)

```
part = floor(degree / 10)    // 0, 1, 2
offset = part * 4             // 0, 4, 8  (трины: 1-й, 5-й, 9-й)
drekkana_sign = ((sign - 1) + offset) % 12 + 1
```

### 2.4 D-4 Чатуртхамша (Chaturthamsha)

```
part = floor(degree / 7.5)   // 0, 1, 2, 3
offset = part * 3             // 0, 3, 6, 9  (кендры: 1-й, 4-й, 7-й, 10-й)
d4_sign = ((sign - 1) + offset) % 12 + 1
```

### 2.5 D-7 Саптамша (Saptamsha)

```
part = floor(degree / (30.0 / 7))    // 0-6
IF sign нечётный: start = sign
ELSE:             start = ((sign - 1) + 6) % 12 + 1   // 7-й от знака
d7_sign = ((start - 1) + part) % 12 + 1

Границы: 0d, 4d17'08.57", 8d34'17.14", 12d51'25.71", 17d08'34.29", 21d25'42.86", 25d42'51.43", 30d
```

### 2.6 D-9 Навамша (Navamsha) -- КЛЮЧЕВАЯ ВАРГА

```
part = floor(degree / (30.0 / 9))    // 0-8

// Начало по стихии:
//   Огонь (1,5,9) -> 1    Земля (2,6,10) -> 10
//   Воздух (3,7,11) -> 7  Вода (4,8,12) -> 4

// Упрощённая формула:
navamsha_sign = ((sign - 1) * 9 + part) % 12 + 1

СВЯЗЬ: каждая навамша = 1 пада накшатры = 3d20'
12 знаков x 9 навамш = 108 = 27 накшатр x 4 пады
```

**Полная таблица навамш:**

| Знак | Nav1 0d-3d20' | Nav2 3d20'-6d40' | Nav3 6d40'-10d | Nav4 10d-13d20' | Nav5 13d20'-16d40' | Nav6 16d40'-20d | Nav7 20d-23d20' | Nav8 23d20'-26d40' | Nav9 26d40'-30d |
|------|------|------|------|------|------|------|------|------|------|
| 1 Овен | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
| 2 Телец | 10 | 11 | 12 | 1 | 2 | 3 | 4 | 5 | 6 |
| 3 Близн. | 7 | 8 | 9 | 10 | 11 | 12 | 1 | 2 | 3 |
| 4 Рак | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
| 5 Лев | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
| 6 Дева | 10 | 11 | 12 | 1 | 2 | 3 | 4 | 5 | 6 |
| 7 Весы | 7 | 8 | 9 | 10 | 11 | 12 | 1 | 2 | 3 |
| 8 Скорп. | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
| 9 Стрел. | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
| 10 Козер. | 10 | 11 | 12 | 1 | 2 | 3 | 4 | 5 | 6 |
| 11 Водол. | 7 | 8 | 9 | 10 | 11 | 12 | 1 | 2 | 3 |
| 12 Рыбы | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |

### 2.7 D-10 Дашамша (Dashamsha)

```
part = floor(degree / 3.0)    // 0-9
IF sign нечётный: start = sign
ELSE:             start = ((sign - 1) + 8) % 12 + 1   // 9-й от знака
d10_sign = ((start - 1) + part) % 12 + 1
```

### 2.8 D-12 Двадашамша (Dvadashamsha)

```
part = floor(degree / 2.5)    // 0-11
d12_sign = ((sign - 1) + part) % 12 + 1
// Всегда от того же знака. Каждый знак проходит полный зодиак.
```

### 2.9 D-16 Шодашамша (Shodashamsha)

```
part = floor(degree / 1.875)   // 0-15
// Начало по модальности:
//   Chara (1,4,7,10) -> 1    Sthira (2,5,8,11) -> 5    Dwi (3,6,9,12) -> 9
start = [1, 5, 9][(sign - 1) % 3]
d16_sign = ((start - 1) + part) % 12 + 1
```

### 2.10 D-20 Вимшамша (Vimshamsha)

```
part = floor(degree / 1.5)    // 0-19
// По модальности (основная редакция BPHS):
//   Chara -> 1    Sthira -> 9    Dwi -> 5
start = [1, 9, 5][(sign - 1) % 3]
d20_sign = ((start - 1) + part) % 12 + 1

// Альтернатива по стихии: Fire->1, Earth->9, Air->5, Water->1
// Рекомендация: реализовать оба с флагом.
```

### 2.11 D-24 Чатурвимшамша (Chaturvimshamsha)

```
part = floor(degree / 1.25)    // 0-23
IF sign нечётный: start = 5    // Лев
ELSE:             start = 4    // Рак
d24_sign = ((start - 1) + part) % 12 + 1
```

### 2.12 D-27 Саптавимшамша (Saptavimshamsha)

```
part = floor(degree / (30.0 / 27))    // 0-26
// По стихии: Огонь->1, Земля->4, Воздух->7, Вода->10
start = [1, 4, 7, 10][(sign - 1) % 4]
d27_sign = ((start - 1) + part) % 12 + 1
```

### 2.13 D-30 Тримшамша (Trimshamsha) -- ОСОБАЯ ВАРГА

Неравные деления: 5 частей, управители Mars/Saturn/Jupiter/Mercury/Venus.

**Нечётные знаки (1,3,5,7,9,11):**

| Градусы | Размер | Управитель | D-30 знак |
|---------|--------|-----------|-----------|
| 0d-5d | 5d | Mars | 1 (Овен) |
| 5d-10d | 5d | Saturn | 11 (Водолей) |
| 10d-18d | 8d | Jupiter | 9 (Стрелец) |
| 18d-25d | 7d | Mercury | 3 (Близнецы) |
| 25d-30d | 5d | Venus | 7 (Весы) |

**Чётные знаки (2,4,6,8,10,12) -- ОБРАТНЫЙ порядок:**

| Градусы | Размер | Управитель | D-30 знак |
|---------|--------|-----------|-----------|
| 0d-5d | 5d | Venus | 2 (Телец) |
| 5d-12d | 7d | Mercury | 6 (Дева) |
| 12d-20d | 8d | Jupiter | 12 (Рыбы) |
| 20d-25d | 5d | Saturn | 10 (Козерог) |
| 25d-30d | 5d | Mars | 8 (Скорпион) |

```
odd_bounds  = [5, 10, 18, 25, 30]
even_bounds = [5, 12, 20, 25, 30]
odd_signs   = [1, 11, 9, 3, 7]
even_signs  = [2, 6, 12, 10, 8]

bounds = odd_bounds IF sign нечётный ELSE even_bounds
signs  = odd_signs  IF sign нечётный ELSE even_signs
FOR i IN 0..4:
  IF degree < bounds[i]: RETURN signs[i]
```

### 2.14 D-40 Кхаведамша (Khavedamsha)

```
part = floor(degree / 0.75)    // 0-39
IF sign нечётный: start = 1   // Овен
ELSE:             start = 7   // Весы
d40_sign = ((start - 1) + part) % 12 + 1
```

### 2.15 D-45 Акшаведамша (Akshavedamsha)

```
part = floor(degree / (30.0 / 45))   // 0-44
// По модальности: Chara->1, Sthira->5, Dwi->9
start = [1, 5, 9][(sign - 1) % 3]
d45_sign = ((start - 1) + part) % 12 + 1
```

### 2.16 D-60 Шаштиамша (Shashtiamsha)

```
part = floor(degree / 0.5)    // 0-59
d60_sign = ((sign - 1) + part) % 12 + 1
// Всегда от того же знака. 60/12 = 5 полных циклов.
```

**60 имён шаштиамш:**

| # | Имя | Природа | # | Имя | Природа |
|---|-----|---------|---|-----|---------|
| 1 | Ghora | неблаг. | 31 | Ghora | неблаг. |
| 2 | Rakshasa | неблаг. | 32 | Rakshasa | неблаг. |
| 3 | Deva | благ. | 33 | Deva | благ. |
| 4 | Kubera | благ. | 34 | Kubera | благ. |
| 5 | Yaksha | нейтр. | 35 | Yaksha | нейтр. |
| 6 | Kinnara | благ. | 36 | Kinnara | благ. |
| 7 | Bhrashta | неблаг. | 37 | Bhrashta | неблаг. |
| 8 | Kulaghna | неблаг. | 38 | Kulaghna | неблаг. |
| 9 | Garala | неблаг. | 39 | Garala | неблаг. |
| 10 | Agni | неблаг. | 40 | Agni | неблаг. |
| 11 | Maya | нейтр. | 41 | Maya | нейтр. |
| 12 | Purishaka | неблаг. | 42 | Purishaka | неблаг. |
| 13 | Apampati | благ. | 43 | Apampati | благ. |
| 14 | Marut | благ. | 44 | Marut | благ. |
| 15 | Kala | неблаг. | 45 | Kala | неблаг. |
| 16 | Sarpa | неблаг. | 46 | Sarpa | неблаг. |
| 17 | Amrita | благ. | 47 | Amrita | благ. |
| 18 | Indu | благ. | 48 | Indu | благ. |
| 19 | Mridu | благ. | 49 | Mridu | благ. |
| 20 | Komala | благ. | 50 | Komala | благ. |
| 21 | Heramba | нейтр. | 51 | Heramba | нейтр. |
| 22 | Brahma | благ. | 52 | Brahma | благ. |
| 23 | Vishnu | благ. | 53 | Vishnu | благ. |
| 24 | Maheshwara | благ. | 54 | Maheshwara | благ. |
| 25 | Deva | благ. | 55 | Deva | благ. |
| 26 | Ardra | неблаг. | 56 | Ardra | неблаг. |
| 27 | Kalinasha | благ. | 57 | Kalinasha | благ. |
| 28 | Kshitesha | благ. | 58 | Kshitesha | благ. |
| 29 | Kamalakara | благ. | 59 | Kamalakara | благ. |
| 30 | Gulika | неблаг. | 60 | Gulika | неблаг. |

```
Нечётные знаки: номер = part + 1 (1-30)
Чётные знаки: номер = part + 31 (31-60)
```

---

## 3. Варготтама (Vargottama)

```
ОПРЕДЕЛЕНИЕ: D-1 sign == D-9 sign
vargottama = (sign == ((sign - 1) * 9 + part) % 12 + 1)
```

| Модальность | Навамша # | Диапазон |
|-------------|----------|----------|
| Chara (1,4,7,10) | 1-я | 0d00' -- 3d20' |
| Sthira (2,5,8,11) | 5-я | 13d20' -- 16d40' |
| Dwi (3,6,9,12) | 9-я | 26d40' -- 30d |

---

## 4. Виншопак-бала (Vimshopaka Bala)

Сила планеты по положению в нескольких варгах. Максимум = 20 для каждой группы.

### 4.1 Веса варг по группам

| Варга | Шадварга(6) | Саптаварга(7) | Дашаварга(10) | Шодашаварга(16) |
|-------|-------------|---------------|---------------|-----------------|
| D-1 | 6 | 5 | 3 | 3.5 |
| D-2 | 2 | 2 | 1.5 | 1 |
| D-3 | 4 | 3 | 1.5 | 1 |
| D-4 | -- | -- | -- | 0.5 |
| D-7 | -- | 2.5 | 1.5 | 0.5 |
| D-9 | 5 | 4.5 | 3 | 3 |
| D-10 | -- | -- | 1.5 | 0.5 |
| D-12 | 2 | 2 | 1.5 | 0.5 |
| D-16 | -- | -- | 2 | 2 |
| D-20 | -- | -- | -- | 0.5 |
| D-24 | -- | -- | -- | 0.5 |
| D-27 | -- | -- | -- | 0.5 |
| D-30 | 1 | 1 | 1.5 | 1 |
| D-40 | -- | -- | -- | 0.5 |
| D-45 | -- | -- | -- | 0.5 |
| D-60 | -- | -- | 3 | 4 |
| **ИТОГО** | **20** | **20** | **20** | **20** |

### 4.2 Множители достоинства

| Достоинство | Санскрит | Множитель |
|-------------|----------|-----------|
| Экзальтация | Uchcha | 1.0 |
| Собственный знак | Svakshetra | 1.0 |
| Мулатрикона | Mulatrikona | 0.75 |
| Лучший друг | Adhimitra | 0.75 |
| Друг | Mitra | 0.5 |
| Нейтральный | Sama | 0.375 |
| Враг | Shatru | 0.25 |
| Лучший враг | Adhishatru | 0.1875 |
| Дебилитация | Nicha | 0.0 |

```
vimshopak = SUM(weight[varga] * get_dignity_multiplier(planet, varga_sign))
// Достоинство через Panchadha Maitri (5-уровневая дружба) -> 02-graha
```

---

## 5. Пушкара-навамша (Pushkara Navamsha) и Пушкара-бхага (Pushkara Bhaga)

### 5.1 Пушкара-навамша

| Знак D-1 | Навамша # | Градусы D-1 | D-9 знак |
|----------|----------|-------------|----------|
| Овен | 7-я | 20d00'-23d20' | Весы |
| Телец | 3-я | 6d40'-10d00' | Рыбы |
| Близнецы | 6-я | 16d40'-20d00' | Рыбы |
| Рак | 1-я | 0d00'-3d20' | Рак |
| Рак | 9-я | 26d40'-30d00' | Рыбы |
| Лев | 4-я | 10d00'-13d20' | Рак |
| Дева | 3-я | 6d40'-10d00' | Рыбы |
| Дева | 6-я | 16d40'-20d00' | Близнецы |
| Весы | 7-я | 20d00'-23d20' | Овен |
| Скорпион | 2-я | 3d20'-6d40' | Лев |
| Стрелец | 4-я | 10d00'-13d20' | Рак |
| Стрелец | 8-я | 23d20'-26d40' | Скорпион |
| Козерог | 6-я | 16d40'-20d00' | Близнецы |
| Водолей | 3-я | 6d40'-10d00' | Стрелец |
| Водолей | 7-я | 20d00'-23d20' | Овен |
| Рыбы | 5-я | 13d20'-16d40' | Скорпион |
| Рыбы | 9-я | 26d40'-30d00' | Рыбы |

### 5.2 Пушкара-бхага

| # | Знак | Бхага 1 | Бхага 2 |
|---|------|---------|---------|
| 1 | Овен | 21d | 24d |
| 2 | Телец | 14d | 19d |
| 3 | Близнецы | 18d | 24d |
| 4 | Рак | 8d | 21d |
| 5 | Лев | 14d | 19d |
| 6 | Дева | 9d | 24d |
| 7 | Весы | 21d | 24d |
| 8 | Скорпион | 14d | 19d |
| 9 | Стрелец | 18d | 24d |
| 10 | Козерог | 8d | 21d |
| 11 | Водолей | 14d | 19d |
| 12 | Рыбы | 9d | 24d |

```
# Знаки 1-6 зеркалируют 7-12
pushkara_bhaga = {
  1: [21,24], 2: [14,19], 3: [18,24], 4: [8,21], 5: [14,19], 6: [9,24],
  7: [21,24], 8: [14,19], 9: [18,24], 10:[8,21], 11:[14,19], 12:[9,24]
}
```

---

## 6. Накшатра x Пада -> Навамша (108 позиций)

| # | Накшатра | Диапазон | Пада 1 | Пада 2 | Пада 3 | Пада 4 |
|---|----------|----------|--------|--------|--------|--------|
| 1 | Ashwini | 0d-13d20' Ar | Ar | Ta | Ge | Cn |
| 2 | Bharani | 13d20'-26d40' Ar | Le | Vi | Li | Sc |
| 3 | Krittika | 26d40' Ar-10d Ta | Sg | Cp | Aq | Pi |
| 4 | Rohini | 10d-23d20' Ta | Ar | Ta | Ge | Cn |
| 5 | Mrigashira | 23d20' Ta-6d40' Ge | Le | Vi | Li | Sc |
| 6 | Ardra | 6d40'-20d Ge | Sg | Cp | Aq | Pi |
| 7 | Punarvasu | 20d Ge-3d20' Cn | Ar | Ta | Ge | Cn |
| 8 | Pushya | 3d20'-16d40' Cn | Le | Vi | Li | Sc |
| 9 | Ashlesha | 16d40'-30d Cn | Sg | Cp | Aq | Pi |
| 10 | Magha | 0d-13d20' Le | Ar | Ta | Ge | Cn |
| 11 | P.Phalguni | 13d20'-26d40' Le | Le | Vi | Li | Sc |
| 12 | U.Phalguni | 26d40' Le-10d Vi | Sg | Cp | Aq | Pi |
| 13 | Hasta | 10d-23d20' Vi | Ar | Ta | Ge | Cn |
| 14 | Chitra | 23d20' Vi-6d40' Li | Le | Vi | Li | Sc |
| 15 | Swati | 6d40'-20d Li | Sg | Cp | Aq | Pi |
| 16 | Vishakha | 20d Li-3d20' Sc | Ar | Ta | Ge | Cn |
| 17 | Anuradha | 3d20'-16d40' Sc | Le | Vi | Li | Sc |
| 18 | Jyeshtha | 16d40'-30d Sc | Sg | Cp | Aq | Pi |
| 19 | Mula | 0d-13d20' Sg | Ar | Ta | Ge | Cn |
| 20 | P.Ashadha | 13d20'-26d40' Sg | Le | Vi | Li | Sc |
| 21 | U.Ashadha | 26d40' Sg-10d Cp | Sg | Cp | Aq | Pi |
| 22 | Shravana | 10d-23d20' Cp | Ar | Ta | Ge | Cn |
| 23 | Dhanishtha | 23d20' Cp-6d40' Aq | Le | Vi | Li | Sc |
| 24 | Shatabhisha | 6d40'-20d Aq | Sg | Cp | Aq | Pi |
| 25 | P.Bhadrapada | 20d Aq-3d20' Pi | Ar | Ta | Ge | Cn |
| 26 | U.Bhadrapada | 3d20'-16d40' Pi | Le | Vi | Li | Sc |
| 27 | Revati | 16d40'-30d Pi | Sg | Cp | Aq | Pi |

```
# Паттерн: 3 группы x 4 знака (каждые 3 накшатры = 1 раши)
# A: Ar-Ta-Ge-Cn   B: Le-Vi-Li-Sc   C: Sg-Cp-Aq-Pi
# Глобальный индекс = (nakshatra-1)*4 + (pada-1), навамша = index % 12 + 1
```

---

## 7. Мастер-таблица начальных знаков

**По чётности:**

| Варга | Нечётные (1,3,5,7,9,11) | Чётные (2,4,6,8,10,12) |
|-------|--------------------------|------------------------|
| D-7 | sign | sign + 6 |
| D-10 | sign | sign + 8 |
| D-24 | 5 (Лев) | 4 (Рак) |
| D-40 | 1 (Овен) | 7 (Весы) |

**По стихии:**

| Варга | Огонь(1,5,9) | Земля(2,6,10) | Воздух(3,7,11) | Вода(4,8,12) |
|-------|-------------|---------------|----------------|-------------|
| D-9 | 1 | 10 | 7 | 4 |
| D-27 | 1 | 4 | 7 | 10 |

**По модальности:**

| Варга | Chara(1,4,7,10) | Sthira(2,5,8,11) | Dwi(3,6,9,12) |
|-------|-----------------|-------------------|----------------|
| D-16 | 1 | 5 | 9 |
| D-20 | 1 | 9 | 5 |
| D-45 | 1 | 5 | 9 |

**Без зависимости:** D-1, D-3, D-4 (от sign), D-12, D-60 (от sign), D-30 (особые правила)

---

## Правила

```
IF varga == 2:
  ASSERT result IN [4, 5]

IF varga == 12:
  FOR any sign: all 12 parts -> all 12 signs exactly once

IF varga == 60:
  FOR any sign: all 60 parts -> each sign exactly 5 times

IF varga == 30:
  SUM(odd_bounds) == 5+5+8+7+5 == 30
  SUM(even_bounds) == 5+7+8+5+5 == 30

IF group IN [shadvarga, saptavarga, dashavarga, shodashavarga]:
  SUM(weights) == 20

IF planet exalted/own in ALL vargas of group:
  vimshopak == 20

pushkara_bhaga[n] == pushkara_bhaga[n+6] FOR n=1..6

IF degree == 0.0: part == 0  (always)
IF degree == 29.999...: part == N-1  (last part)
IF degree == exact_boundary: floor() -> next part
```

---

## Верификация

```python
def calculate_varga(sign: int, degree: float, varga: int) -> int:
    assert 1 <= sign <= 12
    assert 0.0 <= degree < 30.0
    is_odd = (sign % 2 == 1)
    element = (sign - 1) % 4
    modality = (sign - 1) % 3

    if varga == 1:  return sign
    elif varga == 2:
        half = int(degree >= 15)
        return (5 if half == 0 else 4) if is_odd else (4 if half == 0 else 5)
    elif varga == 3:
        return (sign - 1 + int(degree / 10) * 4) % 12 + 1
    elif varga == 4:
        return (sign - 1 + int(degree / 7.5) * 3) % 12 + 1
    elif varga == 7:
        part = int(degree / (30.0 / 7))
        start = sign if is_odd else ((sign - 1 + 6) % 12 + 1)
        return (start - 1 + part) % 12 + 1
    elif varga == 9:
        return ((sign - 1) * 9 + int(degree / (30.0 / 9))) % 12 + 1
    elif varga == 10:
        part = int(degree / 3.0)
        start = sign if is_odd else ((sign - 1 + 8) % 12 + 1)
        return (start - 1 + part) % 12 + 1
    elif varga == 12:
        return (sign - 1 + int(degree / 2.5)) % 12 + 1
    elif varga == 16:
        return ([1, 5, 9][modality] - 1 + int(degree / 1.875)) % 12 + 1
    elif varga == 20:
        return ([1, 9, 5][modality] - 1 + int(degree / 1.5)) % 12 + 1
    elif varga == 24:
        start = 5 if is_odd else 4
        return (start - 1 + int(degree / 1.25)) % 12 + 1
    elif varga == 27:
        return ([1, 4, 7, 10][element] - 1 + int(degree / (30.0 / 27))) % 12 + 1
    elif varga == 30:
        if is_odd:
            for i, b in enumerate([5, 10, 18, 25, 30]):
                if degree < b: return [1, 11, 9, 3, 7][i]
        else:
            for i, b in enumerate([5, 12, 20, 25, 30]):
                if degree < b: return [2, 6, 12, 10, 8][i]
    elif varga == 40:
        return ((1 if is_odd else 7) - 1 + int(degree / 0.75)) % 12 + 1
    elif varga == 45:
        return ([1, 5, 9][modality] - 1 + int(degree / (30.0 / 45))) % 12 + 1
    elif varga == 60:
        return (sign - 1 + int(degree / 0.5)) % 12 + 1


def is_vargottama(sign: int, degree: float) -> bool:
    return sign == calculate_varga(sign, degree, 9)


def get_vimshopak_bala(sign, degree, planet, group="shodashavarga"):
    groups = {
        "shadvarga":     {1:6, 2:2, 3:4, 9:5, 12:2, 30:1},
        "saptavarga":    {1:5, 2:2, 3:3, 7:2.5, 9:4.5, 12:2, 30:1},
        "dashavarga":    {1:3, 2:1.5, 3:1.5, 7:1.5, 9:3, 10:1.5, 12:1.5, 16:2, 30:1.5, 60:3},
        "shodashavarga": {1:3.5, 2:1, 3:1, 4:0.5, 7:0.5, 9:3, 10:0.5, 12:0.5,
                          16:2, 20:0.5, 24:0.5, 27:0.5, 30:1, 40:0.5, 45:0.5, 60:4}
    }
    score = 0.0
    for varga, weight in groups[group].items():
        varga_sign = calculate_varga(sign, degree, varga)
        score += weight * get_dignity_multiplier(planet, varga_sign)
    return score
```

---
← [[04-nakshatra-dasha]] | [[06-shadbala]] →
