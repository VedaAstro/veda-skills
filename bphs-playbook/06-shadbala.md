# 06. Шадбала (Shadbala)

> Источник: БПХШ, главы 27-30
> Назначение: верификация расчётов планетарных сил (6 компонентов)
> Зависимости: -> 01-rashi, -> 02-graha, -> 04-nakshatra-dasha, -> 05-varga

---

## Данные

### 1. Структура Шадбалы

```
SHADBALA = sthana + dig + kala + cheshta + naisargika + drik

Единицы: 1 Rupa = 60 Virupas. Все промежуточные расчёты в Virupas.
```

| # | Бала | Санскрит | Измеряет | Подкомпоненты |
|---|------|----------|----------|---------------|
| 1 | Стхана (Sthana) | स्थानबल | Позиционная сила | 5 |
| 2 | Диг (Dig) | दिग्बल | Направленная сила | 1 |
| 3 | Кала (Kala) | कालबल | Временная сила | 9 |
| 4 | Чешта (Cheshta) | चेष्टाबल | Сила движения | 1 |
| 5 | Нейсаргика (Naisargika) | नैसर्गिकबल | Естественная сила | 1 |
| 6 | Дрик (Drik) | दृक्बल | Аспектная сила | 1 |

> Участники: 7 планет (SU-SA). Раху и Кету не участвуют.

### 2. Типичные диапазоны компонентов

| Компонент | Min (Vir) | Max (Vir) | Типично |
|-----------|-----------|-----------|---------|
| Стхана | ~30 | ~350 | 100-250 |
| Диг | 0 | 60 | 10-50 |
| Кала | ~30 | ~300 | 80-200 |
| Чешта | 0 | 60 | 10-50 |
| Нейсаргика | 8.57 | 60 | фикс. |
| Дрик | ~-60 | ~+60 | -20..+30 |
| **ИТОГО** | **~70** | **~800** | **250-550** |

---

## Правила

### 1. Стхана-бала (Sthana Bala)

```
sthana_bala = uchcha + saptavargaja + ojayugma + kendra + drekkana
```

#### 1.1 Учча-бала (Uchcha Bala)

Точки дебилитации (Parama Neecha):

| Планета | Знак | Абсолютная долгота |
|---------|------|--------------------|
| SU (Surya) | Tula | 190° |
| MO (Chandra) | Vrischika | 213° |
| MA (Mangala) | Karka | 118° |
| ME (Budha) | Meena | 345° |
| JU (Guru) | Makara | 275° |
| VE (Shukra) | Kanya | 177° |
| SA (Shani) | Mesha | 20° |

```
arc = abs(planet_longitude - debilitation_point)
if arc > 180: arc = 360 - arc
uchcha_bala = arc / 3

ДИАПАЗОН: 0-60 Vir (0 = точка дебил., 60 = точка экзальт.)

exaltation_point = (debilitation_point + 180) % 360
```

#### 1.2 Саптаваргаджа-бала (Saptavargaja Bala)

7 варг: D1, D2, D3, D7, D9, D12, D30

Баллы за достоинство в каждой варге:

| Достоинство | Санскрит | Virupas |
|-------------|----------|---------|
| Мулатрикона (Mooltrikona) | मूलत्रिकोण | 45 |
| Свакшетра (Swakshetra) | स्वक्षेत्र | 30 |
| Лучший друг (Adhi Mitra) | अधिमित्र | 22.5 |
| Друг (Mitra) | मित्र | 15 |
| Нейтрал (Sama) | सम | 7.5 |
| Враг (Shatru) | शत्रु | 3.75 |
| Злейший враг (Adhi Shatru) | अधिशत्रु | 1.875 |

```
for each varga in [D1, D2, D3, D7, D9, D12, D30]:
    sign = get_varga_sign(planet, varga)
    lord = get_sign_lord(sign)
    if lord == planet:
        if is_mooltrikona(planet, sign): points = 45
        else: points = 30  # swakshetra
    else:
        natural = get_naisargika_relation(planet, lord)
        temporal = get_tatkalika_relation(planet, lord)
        combined = combine_relations(natural, temporal)
        # Friend+Friend=Adhi Mitra | Friend+Enemy=Sama
        # Neutral+Friend=Mitra     | Neutral+Enemy=Shatru
        # Enemy+Friend=Sama        | Enemy+Enemy=Adhi Shatru
        points = DIGNITY_MAP[combined]
    total += points
saptavargaja_bala = total

ДИАПАЗОН: 13.125-315 Vir (типично 45-180)
```

Мулатрикона (Mooltrikona):

| Планета | Знак | Диапазон |
|---------|------|----------|
| SU | Simha (5) | 0°-20° |
| MO | Vrishabha (2) | 3°-30° |
| MA | Mesha (1) | 0°-12° |
| ME | Kanya (6) | 15°-20° |
| JU | Dhanu (9) | 0°-10° |
| VE | Tula (7) | 0°-15° |
| SA | Kumbha (11) | 0°-20° |

```
is_mooltrikona(planet, sign, degree):
  SU: sign==5 and 0<=deg<20
  MO: sign==2 and 3<=deg<=30
  MA: sign==1 and 0<=deg<12
  ME: sign==6 and 15<=deg<20
  JU: sign==9 and 0<=deg<10
  VE: sign==7 and 0<=deg<15
  SA: sign==11 and 0<=deg<20
```

#### 1.3 Оджа-Югма-бала (Ojayugma Bala)

```
# Расширённая версия (раздельная оценка раши + навамша):
ojayugma_rashi = 0; ojayugma_navamsha = 0

if planet in [MO, VE]:              # "женские"
    if sign_is_even: ojayugma_rashi = 7.5
    if navamsha_is_even: ojayugma_navamsha = 7.5
else:                                # SU, MA, ME, JU, SA
    if sign_is_odd: ojayugma_rashi = 7.5
    if navamsha_is_odd: ojayugma_navamsha = 7.5

ojayugma_bala = ojayugma_rashi + ojayugma_navamsha

ДИАПАЗОН: 0, 7.5 или 15 Vir
# odd = rashi_number % 2 == 1 (1,3,5,7,9,11)
# even = rashi_number % 2 == 0 (2,4,6,8,10,12)
```

#### 1.4 Кендра-бала (Kendra Bala)

```
Кендра (Kendra):    1, 4, 7, 10  -> 60 Vir
Панапара (Panapara): 2, 5, 8, 11  -> 30 Vir
Апоклима (Apoklima): 3, 6, 9, 12  -> 15 Vir

# Явная проверка: h in [1,4,7,10] -> Kendra, etc.
```

#### 1.5 Дрешкана-бала (Drekkana Bala)

| Категория | Планеты |
|-----------|---------|
| Мужские (male) | SU, MA, JU |
| Женские (female) | MO, VE |
| Нейтральные (neutral) | ME, SA |

| Деканат | Диапазон | Пол |
|---------|----------|-----|
| 1 | 0°-10° | male |
| 2 | 10°-20° | neutral |
| 3 | 20°-30° | female |

```
degree_in_sign = planet_longitude % 30
drekkana = 1 if deg<10 else (2 if deg<20 else 3)

if (gender=="male" and drekkana==1) or
   (gender=="neutral" and drekkana==2) or
   (gender=="female" and drekkana==3):
    drekkana_bala = 15
else:
    drekkana_bala = 0

ДИАПАЗОН: 0 или 15 Vir
```

#### 1.6 Итог Стхана-балы

```
sthana_bala = uchcha + saptavargaja + ojayugma + kendra + drekkana
ТИПИЧНЫЙ ДИАПАЗОН: 80-350 Vir (1.3-5.8 Rupa)
```

---

### 2. Диг-бала (Dig Bala)

| Планета | Сильный дом | Направление | Слабый дом |
|---------|-------------|-------------|------------|
| SU | 10 | Юг (Dakshina) | 4 |
| MO | 4 | Север (Uttara) | 10 |
| MA | 10 | Юг (Dakshina) | 4 |
| ME | 1 | Восток (Purva) | 7 |
| JU | 1 | Восток (Purva) | 7 |
| VE | 4 | Север (Uttara) | 10 |
| SA | 7 | Запад (Pashchima) | 1 |

```
# Точный метод (через долготы):
weak_point = bhava_madhya(DIG_WEAK_HOUSE[planet])
arc = abs(planet_longitude - weak_point)
if arc > 180: arc = 360 - arc
dig_bala = arc / 3

# Упрощённый (через номера домов):
house_distance = abs(planet_house - weak_house)
if house_distance > 6: house_distance = 12 - house_distance
dig_bala_simple = house_distance * 10  # 0,10,20,30,40,50,60

ДИАПАЗОН: 0-60 Vir (0 = слабый дом, 60 = сильный)
```

---

### 3. Кала-бала (Kala Bala)

```
kala_bala = nathonnatha + paksha + tribhaga + abda + masa + vara + hora + ayana + yuddha
```

#### 3.1 Натхоннатха-бала (Nathonnatha Bala)

| Группа | Планеты | Максимум |
|--------|---------|----------|
| Дневные | SU, JU, VE | 60 Vir в полдень |
| Ночные | MO, MA, SA | 60 Vir в полночь |
| Всегда | ME | 60 Vir всегда |

```
hours_from_noon = abs(time - local_noon)  # 0-12 ч
if hours_from_noon > 12: hours_from_noon = 24 - hours_from_noon

SU, JU, VE: nathonnatha = 60 - hours_from_noon * 5
MO, MA, SA: nathonnatha = hours_from_noon * 5
ME:         nathonnatha = 60

ДИАПАЗОН: 0-60 Vir
```

#### 3.2 Пакша-бала (Paksha Bala)

```
moon_sun_arc = (moon_longitude - sun_longitude) % 360
# Shukla Paksha: 0°-180° | Krishna Paksha: 180°-360°

if moon_sun_arc <= 180:
    benefic_paksha = moon_sun_arc / 3
else:
    benefic_paksha = (360 - moon_sun_arc) / 3
malefic_paksha = 60 - benefic_paksha

Благодетели (MO, ME, JU, VE): paksha = benefic_paksha
Вредители (SU, MA, SA):       paksha = malefic_paksha

ДИАПАЗОН: 0-60 Vir
# Некоторые авторы удваивают (max=120), деля arc на 1.5
```

#### 3.3 Трибхага-бала (Tribhaga Bala)

```
ДНЕВНЫЕ ТРЕТИ (sunrise -> sunset / 3):
  1-я: JU = 60 | 2-я: SU = 60 | 3-я: SA = 60

НОЧНЫЕ ТРЕТИ (sunset -> sunrise / 3):
  1-я: MO = 60 | 2-я: VE = 60 | 3-я: MA = 60

ME: 60 ВСЕГДА

if daytime:
    elapsed = (birth_time - sunrise) / day_length
    ruler = JU if elapsed<1/3 else (SU if elapsed<2/3 else SA)
else:
    elapsed = time_since_sunset / night_length
    ruler = MO if elapsed<1/3 else (VE if elapsed<2/3 else MA)

planet: 60 if planet==ME or planet==ruler else 0

ДИАПАЗОН: 0 или 60 Vir
```

#### 3.4 Абда-бала (Abda Bala)

```
# Повелитель года = день недели Меша Санкранти (вход Солнца в Овен)
year_lord = weekday_lords[weekday_of_mesha_sankranti]
abda_bala = 15 if planet == year_lord else 0

ДИАПАЗОН: 0 или 15 Vir
```

#### 3.5 Маса-бала (Masa Bala)

```
# Повелитель месяца = день недели Шукла Пратипада (1-й день после новолуния)
month_lord = weekday_lords[weekday_of_shukla_pratipada]
masa_bala = 30 if planet == month_lord else 0

ДИАПАЗОН: 0 или 30 Vir
```

#### 3.6 Вара-бала (Vara Bala)

```
# Ведический день начинается с восхода (НЕ с полуночи)
weekday = get_weekday(birth_date)
if birth_time < sunrise: weekday = (weekday - 1) % 7
vara_lord = DAY_LORDS[weekday]
vara_bala = 45 if planet == vara_lord else 0

ДИАПАЗОН: 0 или 45 Vir
```

#### 3.7 Хора-бала (Hora Bala)

```
# Халдейский порядок: SU -> VE -> ME -> MO -> SA -> JU -> MA -> ...
# Первая хора дня = vara_lord. Дневные/ночные часы неравные.

start_index = HORA_SEQUENCE.index(vara_lord)

if daytime:
    hora_length = (sunset - sunrise) / 12
    hora_number = floor((birth_time - sunrise) / hora_length)
else:
    hora_length = (next_sunrise - sunset) / 12
    hours_since_sunset = ... # учёт перехода через полночь
    hora_number = 12 + floor(hours_since_sunset / hora_length)

hora_lord = HORA_SEQUENCE[(start_index + hora_number) % 7]
hora_bala = 60 if planet == hora_lord else 0

ДИАПАЗОН: 0 или 60 Vir
```

#### 3.8 Аяна-бала (Ayana Bala)

```
# Основана на деклинации (склонении) планеты
sayana_longitude = sidereal_longitude + ayanamsha
max_decl = 23.4389°  # наклон эклиптики J2000

declination = arcsin(sin(sayana_longitude) * sin(max_decl))

Северные (SU, MA, JU, ME, VE):
  ayana_bala = (declination + max_decl) / (2 * max_decl) * 60

Южные (MO, SA):
  ayana_bala = (max_decl - declination) / (2 * max_decl) * 60

ДИАПАЗОН: 0-60 Vir
```

#### 3.9 Юддха-бала (Yuddha Bala)

```
УСЛОВИЕ: две планеты в пределах 1° по долготе
УЧАСТНИКИ: только MA, ME, JU, VE, SA (SU и MO НЕ участвуют)
ПОБЕДИТЕЛЬ: планета с более северной широтой (по BPHS)

yuddha_bala[winner] = diff / 2
yuddha_bala[loser] = -diff / 2

ДИАПАЗОН: -60..+60 Vir (обычно 0 — редкое событие)
```

#### 3.10 Итог Кала-балы

```
kala_bala = nathonnatha + paksha + tribhaga + abda + masa + vara + hora + ayana + yuddha

ТИПИЧНЫЙ ДИАПАЗОН: 60-390 Vir (1.0-6.5 Rupa)
# ME всегда: nathonnatha(60) + tribhaga(60) = 120 базовых
# Абда+Маса+Вара+Хора: одна планета max 150 (15+30+45+60)
```

---

### 4. Чешта-бала (Cheshta Bala)

#### 4.1 Для 5 планет (MA-SA)

8 состояний движения:

| # | Состояние | Санскрит | Virupas |
|---|-----------|----------|---------|
| 1 | Вакра (Vakra) | वक्र — ретроград | 60 |
| 2 | Анувакра (Anuvakra) | अनुवक्र — вход в ретро | 30 |
| 3 | Викала (Vikala) | विकल — стационарность | 15 |
| 4 | Манда (Manda) | मन्द — медленное | 15 |
| 5 | Мандатара (Mandatara) | मन्दतर — ещё медленнее | 30 |
| 6 | Сама (Sama) | सम — средняя скорость | 7.5 |
| 7 | Чара (Chara) | चर — быстрое | 45 |
| 8 | Атичара (Atichara) | अतिचर — очень быстрое | 30 |

```
# Точная формула (через Чешта-канду):
cheshta_kanda = abs(true_longitude - mean_longitude)
if cheshta_kanda > 180: cheshta_kanda = 360 - cheshta_kanda
cheshta_bala = cheshta_kanda / 3

ДИАПАЗОН: 0-60 Vir (0 = прямое среднее, 60 = глубокая ретро)
```

Средние суточные скорости:

| Планета | °/день |
|---------|--------|
| MA | 0.524 |
| ME | 1.383 |
| JU | 0.083 |
| VE | 1.200 |
| SA | 0.034 |

#### 4.2 Чешта-бала Солнца

```
# SU не имеет ретроградности -> Чешта = Аяна-бала
sayana = sidereal_longitude + ayanamsha
decl = arcsin(sin(23.4389°) * sin(sayana))
cheshta_bala_sun = (decl + 23.4389) * 60 / (2 * 23.4389)

ДИАПАЗОН: 0-60 Vir
```

#### 4.3 Чешта-бала Луны

```
cheshta_bala_moon = paksha_bala_moon  # уже вычислена в Кала-бале
ДИАПАЗОН: 0-60 Vir
```

---

### 5. Нейсаргика-бала (Naisargika Bala)

Фиксированные значения, одинаковы для всех карт. Шаг: 60/7 = 8.571... Vir.

| # | Планета | Virupas | Дробь |
|---|---------|---------|-------|
| 1 | SU (Surya) | 60.000 | 60/1 |
| 2 | MO (Chandra) | 51.429 | 360/7 |
| 3 | VE (Shukra) | 42.857 | 300/7 |
| 4 | JU (Guru) | 34.286 | 240/7 |
| 5 | ME (Budha) | 25.714 | 180/7 |
| 6 | MA (Mangala) | 17.143 | 120/7 |
| 7 | SA (Shani) | 8.571 | 60/7 |

```
naisargika_bala = (7 - rank) * 60 / 7  # rank: SU=0..SA=6
sum(all) = 240.0 Vir, все интервалы = 60/7
```

---

### 6. Дрик-бала (Drik Bala)

```
# Аспект благодетеля -> +, вредителя -> -. Может быть ОТРИЦАТЕЛЬНОЙ.

drik_bala[planet] = (sum_benefic_aspects - sum_malefic_aspects) / 4

Сила аспекта по расстоянию (домов):
  3 или 10 -> 15 Vir (25%)
  4 или 9  -> 45 Vir (75%)
  5 или 8  -> 30 Vir (50%)
  7        -> 60 Vir (100%)
  прочие   -> 0

Особые аспекты (Vishesha Drishti) -- 100%:
  MA: полный на 4-й и 8-й (в доп. к 7-му)
  JU: полный на 5-й и 9-й (в доп. к 7-му)
  SA: полный на 3-й и 10-й (в доп. к 7-му)

Благодетели (factor=+1): JU, VE, яркая MO, ME (без вредителей)
Вредители (factor=-1):   SU, MA, SA, тёмная MO, ME (с вредителями)

ДИАПАЗОН: ~-60..+60 Vir
```

---

### 7. Итоговая Шадбала и минимумы

```
TOTAL = sthana + dig + kala + cheshta + naisargika + drik  # Virupas
TOTAL_RUPAS = TOTAL / 60
```

Минимальные требования (Avasya Shadbala):

| Планета | Min (Rupas) | Min (Virupas) |
|---------|-------------|---------------|
| SU | 6.5 | 390 |
| MO | 6.0 | 360 |
| MA | 5.0 | 300 |
| ME | 7.0 | 420 |
| JU | 6.5 | 390 |
| VE | 5.5 | 330 |
| SA | 5.0 | 300 |

```
is_strong(planet) = TOTAL_RUPAS >= MINIMUM_REQUIRED[planet]
ratio = TOTAL_RUPAS / MINIMUM_REQUIRED[planet]
# ratio > 1.0 -> сильная | < 1.0 -> слабая | > 2.0 -> очень сильная
```

---

### 8. Иштабала и Каштабала (Ishta/Kashta Phala)

```
ishta_bala = sqrt(uchcha_bala * cheshta_bala)     # 0-60 Vir
kashta_bala = sqrt((60 - uchcha_bala) * (60 - cheshta_bala))  # 0-60 Vir

# С учётом аспектов:
ishta_phala = ishta_bala + subha_drishti_pinda
kashta_phala = kashta_bala + ashubha_drishti_pinda

# ishta > kashta -> преимущественно благоприятна
# kashta > ishta -> преимущественно неблагоприятна

# Граничные случаи:
# uchcha=60, cheshta=60: ishta=60, kashta=0
# uchcha=0,  cheshta=0:  ishta=0,  kashta=60
# uchcha=30, cheshta=30: ishta=30, kashta=30
```

---

### 9. Бхава-бала (Bhava Bala)

```
bhava_bala[house] = bhavadhipati_bala + bhava_dig_bala + bhava_drishti_bala
```

#### 9.1 Бхавадхипати-бала

```
bhavadhipati_bala[house] = TOTAL_SHADBALA[lord_of_house]
```

#### 9.2 Бхава-дигбала

```
# Направленная сила дома (аналог Dig Bala, но для куспида дома)
# Дома 1,2,3,4 -> сильны Восток (10-й от Лагны)
# Дома 10,11,12 -> сильны Запад (4-й от Лагны)
# Дома 7,8,9 -> сильны Юг (7-й от Лагны)
# Дома 4,5,6 -> сильны Север (Лагна)
ДИАПАЗОН: 0-60 Vir
```

#### 9.3 Бхава-дришти-бала

```
bhava_drishti_bala[house] = sum(benefic_aspects_on_cusp) - sum(malefic_aspects_on_cusp)
ДИАПАЗОН: может быть отрицательной
```

---

### 10. Полный алгоритм

```python
def compute_shadbala(planet, chart):
    """
    ВХОД:
      planet: одна из [SU, MO, MA, ME, JU, VE, SA]
      chart: {
          planet_longitudes: dict,     # абсолютные долготы 0-360
          house_positions: dict,       # в каком доме каждая планета
          birth_time: datetime,
          sunrise: time, sunset: time,
          ayanamsha: float,
          varga_positions: dict,       # позиции в D1-D30
          daily_motions: dict,
          mean_longitudes: dict,       # средние долготы (для Чешта)
      }
    ВЫХОД: dict с компонентами и итогом в Virupas
    """
    results = {}

    # 1. СТХАНА-БАЛА
    # 1.1 Учча-бала
    debil_point = DEBILITATION_POINTS[planet]
    arc = abs(chart.planet_longitudes[planet] - debil_point)
    if arc > 180: arc = 360 - arc
    uchcha_bala = arc / 3

    # 1.2 Саптаваргаджа-бала
    saptavargaja = 0
    for varga in [D1, D2, D3, D7, D9, D12, D30]:
        sign = chart.varga_positions[planet][varga]
        dignity = get_dignity(planet, sign, varga)
        saptavargaja += DIGNITY_POINTS[dignity]

    # 1.3 Оджа-Югма-бала
    rashi_sign = chart.varga_positions[planet][D1]
    navamsha_sign = chart.varga_positions[planet][D9]
    if planet in [MO, VE]:
        oja = 15 if (rashi_sign % 2 == 0 and navamsha_sign % 2 == 0) else 0
    else:
        oja = 15 if (rashi_sign % 2 == 1 and navamsha_sign % 2 == 1) else 0

    # 1.4 Кендра-бала
    house = chart.house_positions[planet]
    if house in [1,4,7,10]: kendra = 60
    elif house in [2,5,8,11]: kendra = 30
    else: kendra = 15

    # 1.5 Дрешкана-бала
    degree_in_sign = chart.planet_longitudes[planet] % 30
    if degree_in_sign < 10: drekkana_num = 1
    elif degree_in_sign < 20: drekkana_num = 2
    else: drekkana_num = 3
    gender = PLANET_GENDER[planet]
    if (gender == 'male' and drekkana_num == 1) or \
       (gender == 'neutral' and drekkana_num == 2) or \
       (gender == 'female' and drekkana_num == 3):
        drekkana = 15
    else:
        drekkana = 0

    sthana_bala = uchcha_bala + saptavargaja + oja + kendra + drekkana
    results['sthana_bala'] = sthana_bala

    # 2. ДИГ-БАЛА
    weak_house = DIG_WEAK_HOUSE[planet]
    weak_point = chart.bhava_madhya[weak_house]
    arc = abs(chart.planet_longitudes[planet] - weak_point)
    if arc > 180: arc = 360 - arc
    dig_bala = arc / 3
    results['dig_bala'] = dig_bala

    # 3. КАЛА-БАЛА
    # 3.1 Натхоннатха
    hours_from_noon = abs(chart.birth_time - chart.local_noon)
    if planet in [SU, JU, VE]:
        nathonnatha = max(0, 60 - hours_from_noon * 5)
    elif planet in [MO, MA, SA]:
        nathonnatha = min(60, hours_from_noon * 5)
    else:  # ME
        nathonnatha = 60

    # 3.2 Пакша
    moon_sun_arc = (chart.planet_longitudes[MO] - chart.planet_longitudes[SU]) % 360
    if moon_sun_arc <= 180:
        benefic_paksha = moon_sun_arc / 3
    else:
        benefic_paksha = (360 - moon_sun_arc) / 3
    malefic_paksha = 60 - benefic_paksha
    if planet in [MO, ME, JU, VE]:
        paksha = benefic_paksha
    else:
        paksha = malefic_paksha

    # 3.3 Трибхага
    ruler = get_tribhaga_ruler(chart.birth_time, chart.sunrise, chart.sunset)
    tribhaga = 60 if (planet == ME or planet == ruler) else 0

    # 3.4-3.7: Абда, Маса, Вара, Хора
    abda = 15 if planet == get_year_lord(chart) else 0
    masa = 30 if planet == get_month_lord(chart) else 0
    vara = 45 if planet == get_day_lord(chart) else 0
    hora = 60 if planet == get_hora_lord(chart) else 0

    # 3.8 Аяна
    sayana_long = chart.planet_longitudes[planet] + chart.ayanamsha
    decl = math.degrees(math.asin(
        math.sin(math.radians(23.4389)) * math.sin(math.radians(sayana_long))
    ))
    if planet in [SU, MA, JU, ME, VE]:
        ayana = (decl + 23.4389) * 60 / (2 * 23.4389)
    else:
        ayana = (23.4389 - decl) * 60 / (2 * 23.4389)

    # 3.9 Юддха (обычно 0)
    yuddha = compute_yuddha_bala(planet, chart) if has_yuddha(planet, chart) else 0

    kala_bala = nathonnatha + paksha + tribhaga + abda + masa + vara + hora + ayana + yuddha
    results['kala_bala'] = kala_bala

    # 4. ЧЕШТА-БАЛА
    if planet == SU:
        sayana = chart.planet_longitudes[SU] + chart.ayanamsha
        decl = math.asin(math.sin(math.radians(23.4389)) * math.sin(math.radians(sayana)))
        decl_deg = math.degrees(decl)
        cheshta_bala = (decl_deg + 23.4389) * 60 / (2 * 23.4389)
    elif planet == MO:
        cheshta_bala = paksha
    else:
        ck = abs(chart.planet_longitudes[planet] - chart.mean_longitudes[planet])
        if ck > 180: ck = 360 - ck
        cheshta_bala = ck / 3
    results['cheshta_bala'] = cheshta_bala

    # 5. НЕЙСАРГИКА-БАЛА
    NAISARGIKA = {SU: 60, MO: 51.43, VE: 42.86, JU: 34.29, ME: 25.71, MA: 17.14, SA: 8.57}
    naisargika_bala = NAISARGIKA[planet]
    results['naisargika_bala'] = naisargika_bala

    # 6. ДРИК-БАЛА
    drik_total = 0
    for other in [SU, MO, MA, ME, JU, VE, SA]:
        if other == planet: continue
        arc = abs(chart.planet_longitudes[planet] - chart.planet_longitudes[other])
        if arc > 180: arc = 360 - arc
        drishti_strength = compute_drishti_strength(other, arc)
        if is_benefic(other, chart):
            drik_total += drishti_strength
        else:
            drik_total -= drishti_strength
    drik_bala = drik_total / 4
    results['drik_bala'] = drik_bala

    # ИТОГО
    total = sthana_bala + dig_bala + kala_bala + cheshta_bala + naisargika_bala + drik_bala
    results['total_virupas'] = total
    results['total_rupas'] = total / 60
    results['minimum_required'] = MINIMUM_SHADBALA[planet]
    results['is_strong'] = (total / 60) >= MINIMUM_SHADBALA[planet]
    results['ratio'] = (total / 60) / MINIMUM_SHADBALA[planet]

    # Ishta / Kashta
    results['ishta_bala'] = math.sqrt(uchcha_bala * cheshta_bala)
    results['kashta_bala'] = math.sqrt((60 - uchcha_bala) * (60 - cheshta_bala))

    return results
```

---

## Константы

```python
DEBILITATION_POINTS = {
    'SU': 190,   # 10° Весов
    'MO': 213,   # 3° Скорпиона
    'MA': 118,   # 28° Рака
    'ME': 345,   # 15° Рыб
    'JU': 275,   # 5° Козерога
    'VE': 177,   # 27° Девы
    'SA': 20     # 20° Овна
}

EXALTATION_POINTS = {k: (v + 180) % 360 for k, v in DEBILITATION_POINTS.items()}
# SU: 10, MO: 33, MA: 298, ME: 165, JU: 95, VE: 357, SA: 200

DIG_WEAK_HOUSE = {
    'SU': 4, 'MO': 10, 'MA': 4, 'ME': 7, 'JU': 7, 'VE': 10, 'SA': 1
}

MINIMUM_SHADBALA = {
    'SU': 6.5, 'MO': 6.0, 'MA': 5.0, 'ME': 7.0, 'JU': 6.5, 'VE': 5.5, 'SA': 5.0
}

NAISARGIKA_BALA = {
    'SU': 60.000, 'MO': 51.429, 'VE': 42.857, 'JU': 34.286,
    'ME': 25.714, 'MA': 17.143, 'SA': 8.571
}

DIGNITY_POINTS = {
    'mooltrikona': 45.0, 'swakshetra': 30.0, 'adhi_mitra': 22.5,
    'mitra': 15.0, 'sama': 7.5, 'shatru': 3.75, 'adhi_shatru': 1.875
}

PLANET_GENDER = {
    'SU': 'male', 'MO': 'female', 'MA': 'male', 'ME': 'neutral',
    'JU': 'male', 'VE': 'female', 'SA': 'neutral'
}

HORA_SEQUENCE = ['SU', 'VE', 'ME', 'MO', 'SA', 'JU', 'MA']

DAY_LORDS = {0: 'SU', 1: 'MO', 2: 'MA', 3: 'ME', 4: 'JU', 5: 'VE', 6: 'SA'}
```

---

## Верификация

```
# 1. Диапазоны компонентов
assert 0 <= uchcha_bala <= 60
assert 0 <= ojayugma_bala <= 15
assert kendra_bala in [15, 30, 60]
assert drekkana_bala in [0, 15]
assert 0 <= dig_bala <= 60
assert 0 <= nathonnatha_bala <= 60
assert 0 <= paksha_bala <= 60
assert tribhaga_bala in [0, 60]
assert abda_bala in [0, 15]
assert masa_bala in [0, 30]
assert vara_bala in [0, 45]
assert hora_bala in [0, 60]
assert 0 <= cheshta_bala <= 60
assert 8.57 <= naisargika_bala <= 60
assert 0 <= ishta_bala <= 60
assert 0 <= kashta_bala <= 60

# 2. Нейсаргика-бала: сумма = 240
assert abs(sum(NAISARGIKA_BALA.values()) - 240.0) < 0.01

# 3. Нейсаргика-бала: равные интервалы
vals = sorted(NAISARGIKA_BALA.values())
for i in range(1, len(vals)):
    assert abs(vals[i] - vals[i-1] - 8.571) < 0.01

# 4. Учча-бала: экзальтация=60, дебилитация=0
for planet in PLANETS:
    assert compute_uchcha(planet, EXALTATION_POINTS[planet]) == 60.0
    assert compute_uchcha(planet, DEBILITATION_POINTS[planet]) == 0.0

# 5. Симметрия: exaltation + 180 == debilitation
for planet in PLANETS:
    assert (EXALTATION_POINTS[planet] + 180) % 360 == DEBILITATION_POINTS[planet]

# 6. Dig Bala: сильный=60, слабый=0
for planet in PLANETS:
    strong = (DIG_WEAK_HOUSE[planet] + 6 - 1) % 12 + 1
    assert compute_dig_bala_simple(planet, strong) == 60
    assert compute_dig_bala_simple(planet, DIG_WEAK_HOUSE[planet]) == 0

# 7. ME: Натхоннатха=60 всегда, Трибхага=60 всегда
assert nathonnatha_bala[ME] == 60
assert tribhaga_bala[ME] == 60

# 8. Ровно 1 планета получает каждую бинарную балу
assert sum(1 for p in PLANETS if abda_bala[p] > 0) == 1
assert sum(1 for p in PLANETS if masa_bala[p] > 0) == 1
assert sum(1 for p in PLANETS if vara_bala[p] > 0) == 1
assert sum(1 for p in PLANETS if hora_bala[p] > 0) == 1

# 9. Кендра-бала: фиксированные значения по типу дома
for h in range(1, 13):
    if h in [1,4,7,10]: assert get_kendra_bala(h) == 60
    elif h in [2,5,8,11]: assert get_kendra_bala(h) == 30
    else: assert get_kendra_bala(h) == 15

# 10. Ishta/Kashta: граничные случаи
assert ishta(60, 60) == 60
assert kashta(60, 60) == 0
assert ishta(0, 0) == 0
assert kashta(0, 0) == 60
```

---

### Зависимости компонентов

```
Стхана-бала:
  Учча          <- долгота планеты
  Саптаваргаджа <- позиции в 7 варгах
  Оджа-Югма     <- знак D1 и D9
  Кендра        <- дом планеты
  Дрешкана      <- градус в знаке + пол планеты

Диг-бала:       <- дом планеты

Кала-бала:
  Натхоннатха   <- время рождения отн. полудня
  Пакша         <- фаза Луны (Moon-Sun arc)
  Трибхага      <- время рождения (часть суток)
  Абда/Маса/Вара/Хора <- год/месяц/день/час рождения

Чешта-бала:
  SU            <- деклинация Солнца
  MO            <- Пакша-бала
  MA-SA         <- разница true и mean долготы

Нейсаргика:     <- КОНСТАНТЫ

Дрик-бала:      <- аспекты других планет
```

---

← [[05-varga]] | [[07-yoga]] →
