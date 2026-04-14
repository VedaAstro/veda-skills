# 07. Йоги (Yoga)

> Источник: БПХШ, главы 36-45; Брихат Джатака, Пхала Дипика
> Назначение: верификация планетарных комбинаций в натальной карте
> Зависимости: → 01-rashi, → 02-graha, → 03-bhava, → 06-shadbala

---

## 1. Базовые определения

```
КЕНДРЫ (Kendra):  1, 4, 7, 10
ТРИКОНЫ (Trikona): 1, 5, 9
ДУСТХАНЫ (Dusthana): 6, 8, 12
УПАЧАЯ (Upachaya): 3, 6, 10, 11
ПАНАПХАРА (Panapara): 2, 5, 8, 11
АПОКЛИМА (Apoklima): 3, 6, 9, 12
МАРАКА (Maraka): 2, 7

ПОДВИЖНЫЕ (Chara):   1, 4, 7, 10
ФИКСИРОВАННЫЕ (Sthira):    2, 5, 8, 11
ДВОЙСТВЕННЫЕ (Dwiswabhava): 3, 6, 9, 12

БЕНЕФИКИ (Shubha): JU, VE, яркая MO, непоражённый ME
МАЛЕФИКИ (Krura): SU, MA, SA, RA, KE, тёмная MO

СВЯЗЬ (Sambandha): 1) Yuti (один знак) 2) Drishti (полный аспект) 3) Parivartana (обмен)

7 ГРАХ для Набхаша-йог: SU, MO, MA, ME, JU, VE, SA (без RA/KE)
```

---

## 2. Набхаша-йоги (Nabhasa Yoga) — 32 йоги

```
ПРИОРИТЕТ: Ашрая > Санкхья. Акрити — параллельно с другими.
Луна НЕ учитывается в Даль-йогах. Санкхья — только при отсутствии других.
```

### 2.1 Ашрая-йоги (Ashraya) — 3

| # | Йога | Условие | Результат |
|---|------|---------|-----------|
| 1 | Раджу (Rajju) | ВСЕ 7 грах в подвижных (1,4,7,10) | Путешествия, непостоянство |
| 2 | Мусала (Musala) | ВСЕ 7 грах в фиксированных (2,5,8,11) | Стабильность, богатство |
| 3 | Нала (Nala) | ВСЕ 7 грах в двойственных (3,6,9,12) | Ловкость, образованность |

```
signs = [sign_of(p) for p in ALL_7]
mods = [get_modality(s) for s in signs]
IF all(CHARA):       → Rajju
IF all(STHIRA):      → Musala
IF all(DWISWABHAVA): → Nala
```

### 2.2 Даль-йоги (Dala) — 2

| # | Йога | Условие | Результат |
|---|------|---------|-----------|
| 4 | Мала (Mala) | ME, JU, VE в трёх триконах (1,5,9) | Счастье, процветание |
| 5 | Сарпа (Sarpa) | SU, MA, SA в трёх триконах (1,5,9) | Несчастья, бедность |

```
IF planets_in_houses([ME,JU,VE], [1,5,9]) покрывают все 3: → Mala
IF planets_in_houses([SU,MA,SA], [1,5,9]) покрывают все 3: → Sarpa
MO, RA, KE не учитываются.
```

### 2.3 Акрити-йоги (Akriti) — 20

#### Группа A: Парные кендры

| # | Йога | Условие | Результат |
|---|------|---------|-----------|
| 6 | Гада (Gada) | В 2 смежных кендрах: {1,4}/{4,7}/{7,10}/{10,1} | Богатство через знания |
| 7 | Шаката (Shakata) | ТОЛЬКО в {1,7} | Болезни, бедность |
| 8 | Вихага (Vihaga) | ТОЛЬКО в {4,10} | Путешественник |
| 9 | Шрингатака (Shringataka) | В триконах {1,5,9} | Благополучие |

```
occupied = set(house_of(p) for p in ALL_7)
Gada:        occupied ⊆ {1,4} OR {4,7} OR {7,10} OR {10,1}
Shakata:     occupied ⊆ {1,7} AND |occupied| == 2
Vihaga:      occupied ⊆ {4,10} AND |occupied| == 2
Shringataka: occupied ⊆ {1,5,9}
```

#### Группа B: Тригональные паттерны

| # | Йога | Условие | Результат |
|---|------|---------|-----------|
| 10 | Хала (Hala) | В {2,6,10} или {3,7,11} или {4,8,12} | Труженик, бедность |

```
Hala: occupied ⊆ {2,6,10} OR {3,7,11} OR {4,8,12}
```

#### Группа C: Бенефики vs Малефики в кендрах

| # | Йога | Условие | Результат |
|---|------|---------|-----------|
| 11 | Ваджра (Vajra) | Бенефики в {1,7}, малефики в {4,10} | Счастье в начале/конце жизни |
| 12 | Йава (Yava) | Малефики в {1,7}, бенефики в {4,10} | Благополучие в середине |

```
Vajra: all_benefics_in({1,7}) AND all_malefics_in({4,10})
Yava:  all_malefics_in({1,7}) AND all_benefics_in({4,10})
```

#### Группа D: Все в определённых типах домов

| # | Йога | Условие | Результат |
|---|------|---------|-----------|
| 13 | Камала (Kamala) | В кендрах {1,4,7,10} | Подобен царю |
| 14 | Вапи (Vapi) | В панапхарах {2,5,8,11} ИЛИ апоклимах {3,6,9,12} | Богатство, дети |

```
Kamala: occupied ⊆ {1,4,7,10}
Vapi:   occupied ⊆ {2,5,8,11} OR occupied ⊆ {3,6,9,12}
```

#### Группа E: 4 последовательных от кендры

| # | Йога | Условие | Результат |
|---|------|---------|-----------|
| 15 | Юпа (Yupa) | {1,2,3,4} | Щедрый, религиозный |
| 16 | Шара (Shara) | {4,5,6,7} | Жестокий, оружие |
| 17 | Шакти (Shakti) | {7,8,9,10} | Ленивый, долгоживущий |
| 18 | Данда (Danda) | {10,11,12,1} | Одинокий, отшельник |

#### Группа F: 7 последовательных от кендры

| # | Йога | Условие | Результат |
|---|------|---------|-----------|
| 19 | Наука (Nauka) | {1-7} | Богатство через воду |
| 20 | Кута (Kuta) | {4-10} | Лжец, крепость |
| 21 | Чхатра (Chhatra) | {7-1} | Добрый, долгоживущий |
| 22 | Чапа (Chapa) | {10-4} | Храбрый, воин |

#### Группа G: Особые паттерны

| # | Йога | Условие | Результат |
|---|------|---------|-----------|
| 23 | Ардха-Чандра (Ardha-Chandra) | 7 последовательных, НЕ от кендры | Лидер, богатый |
| 24 | Чакра (Chakra) | В нечётных {1,3,5,7,9,11} | Император |
| 25 | Самудра (Samudra) | В чётных {2,4,6,8,10,12} | Равный царю |

```
Ardha-Chandra: is_7_consecutive(occupied) AND start NOT IN {1,4,7,10}
Chakra:  occupied ⊆ {1,3,5,7,9,11}
Samudra: occupied ⊆ {2,4,6,8,10,12}
```

### 2.4 Санкхья-йоги (Sankhya) — 7

| # | Йога | Число домов | Результат |
|---|------|-------------|-----------|
| 26 | Валлаки (Vallaki) | 7 | Любит музыку, лидер |
| 27 | Дама (Dama) | 6 | Щедрый |
| 28 | Паша (Pasha) | 5 | Умелый |
| 29 | Кедара (Kedara) | 4 | Земледелец |
| 30 | Шула (Shoola) | 3 | Храбрый воин |
| 31 | Юга (Yuga) | 2 | Бедный |
| 32 | Гола (Gola) | 1 | Слабый, бродяга |

```
count = len(set(house_of(p) for p in ALL_7))
IF count == 7: Vallaki ... IF count == 1: Gola
Каждая карта имеет ровно 1 Санкхья-йогу.
IF есть Ашрая/Акрити → Санкхья подавляется.
```

---

## 3. Панча-Махапуруша (Pancha Mahapurusha) — 5 йог

| Йога | Планета | Собственные знаки | Экзальтация | Результат |
|------|---------|-------------------|-------------|-----------|
| Ручака (Ruchaka) | MA | Ar(1), Sc(8) | Cp(10) | Храбрый, командир |
| Бхадра (Bhadra) | ME | Ge(3), Vi(6) | Vi(6) | Умный, учёный |
| Хамса (Hamsa) | JU | Sg(9), Pi(12) | Cn(4) | Мудрый, праведный |
| Малавья (Malavya) | VE | Ta(2), Li(7) | Pi(12) | Красивый, богатый |
| Шаша (Shasha) | SA | Cp(10), Aq(11) | Li(7) | Властный, дисциплинированный |

```
FOR planet IN [MA, ME, JU, VE, SA]:
  IF (sign IN OWN_SIGNS[planet] OR sign == EXALT[planet]) AND house IN {1,4,7,10}:
    → Mahapurusha Yoga

СИЛА:
  STRONG: экзальтация + кендра + нет аспекта малефиков
  MEDIUM: свой знак + кендра
  WEAK/CANCEL: combust, graha yuddha, RA/KE в соединении
SU и MO НЕ образуют Махапуруша-йоги.
```

---

## 4. Чандра-йоги (Chandra Yoga)

### 4.1 Сунапха, Анапха, Дурдхура, Кемадрума

| Йога | Условие (от MO) | Результат |
|------|-----------------|-----------|
| Сунапха (Sunapha) | Планеты во 2-м (без SU,RA,KE) | Самостоятельное богатство |
| Анапха (Anapha) | Планеты в 12-м | Добродетель, красноречие |
| Дурдхура (Durdhura) | Во 2-м И 12-м | Великое богатство, слава |
| Кемадрума (Kemadruma) | Нет планет во 2/12/кендрах от MO | Бедность, страдания |

```
valid = [MA, ME, JU, VE, SA]
h2 = planets_in(valid, 2nd_from_MO)
h12 = planets_in(valid, 12th_from_MO)
IF h2 AND NOT h12: Sunapha
IF h12 AND NOT h2: Anapha
IF h2 AND h12:     Durdhura
IF NOT h2 AND NOT h12 AND no_valid_in_kendras_from_MO: Kemadruma
```

### 4.2 Отмена Кемадрумы (Kemadruma Bhanga)

```
ОТМЕНЯЕТСЯ если (>= 2 условий = полная отмена, 1 = частичная):
  1. JU/VE/сильный ME аспектирует MO
  2. MO в кендре от лагны
  3. MO в триконе (5,9) от лагны
  4. MO в Ta или Cn
  5. Бенефики в кендрах от лагны
  6. Полная/яркая MO (Shukla Paksha)
  7. Навамша-диспозитор MO силён и в кендре
```

### 4.3 Чандрадхи-йога (Chandradhi)

```
Бенефики в 6/7/8 от MO:
  3 дома = полная (царь)
  2 дома = частичная (министр)
  1 дом  = минимальная
```

### 4.4 Гаджакешари-йога (Gajakesari)

```
IF JU в кендре (1,4,7,10) от MO: → Gajakesari

СИЛА:
  MAX: JU+MO в Cn (экзальтация обоих) без малефик-аспекта
  STRONG: JU экзальтирован/свой + MO яркая
  MEDIUM: нейтральные позиции
  WEAK: JU combust/debilitated, аспект SA/RA, MO тёмная
```

---

## 5. Суриа-йоги (Surya Yoga)

| Йога | Условие (от SU, без MO/RA/KE) | Результат |
|------|-------------------------------|-----------|
| Ваши (Vashi) | Планеты во 2-м | Красноречие, богатство |
| Вошти (Voshi) | Планеты в 12-м | Учёность, щедрость |
| Убхайачари (Ubhayachari) | Во 2-м И 12-м | Равен царю |

```
Бенефик → Shubha вариант. Малефик → Papa вариант. Нет планет → нет йоги.
```

---

## 6. Раджа-йоги (Raja Yoga)

### 6.1 Основное правило

```
Владелец КЕНДРЫ (1,4,7,10) СВЯЗАН с владельцем ТРИКОНЫ (1,5,9)
через Yuti/Drishti/Parivartana → Раджа-йога.

СИЛЬНЕЙШИЕ ПАРЫ: 9L+10L (Дхарма-Карма-Адхипати), 1L+5L, 1L+9L, 5L+10L

1-й дом = и кендра и трикона → лагнеша + любой кендра/трикона-владелец.

ЙОГА-КАРАКА (владеет И кендрой И триконой) = самодостаточная Раджа-йога.

КЕНДРАДХИПАТИ-ДОША:
  Бенефик, владеющий ТОЛЬКО кендрой → теряет благость
  Малефик, владеющий ТОЛЬКО кендрой → приобретает благость
```

### 6.2 Йога-караки и пары по лагнам

| Лагна | Йога-карака | Сильнейшие пары |
|-------|------------|-----------------|
| Овен (Mesha) | — | JU(5,9L)+MA(1L), JU+SU(5L) |
| Телец (Vrishabha) | **SA(9,10L)** | SA+VE(1L), SA+ME(5L) |
| Близнецы (Mithuna) | — | VE(5L)+SA(9L), VE+ME(1L) |
| Рак (Karka) | **MA(5,10L)** | MA+JU(9L), MA+MO(1L) |
| Лев (Simha) | **MA(4,9L)** | MA+SU(1L), MA+JU(5L) |
| Дева (Kanya) | — | VE(9L)+ME(1L), VE+SA(5L) |
| Весы (Tula) | **SA(4,5L)** | SA+VE(1L), SA+ME(9L) |
| Скорпион (Vrischika) | — | JU(5L)+MO(9L), JU+MA(1L) |
| Стрелец (Dhanu) | — | MA(5L)+SU(9L), MA+JU(1L) |
| Козерог (Makara) | **VE(5,10L)** | VE+SA(1L), VE+ME(9L) |
| Водолей (Kumbha) | **VE(4,9L)** | VE+SA(1L), VE+MA(10L) |
| Рыбы (Meena) | — | MA(9L)+MO(5L), MA+JU(1L) |

---

## 7. Дхана-йоги (Dhana Yoga)

```
Связь владык 2/11 с триконами (5,9) и кендрами → богатство.

ПАРЫ:
  (2L, 11L), (2L, 5L), (2L, 9L), (11L, 5L), (11L, 9L), (1L, 2L)
  IF conjunction/aspect/exchange(a, b): → Dhana Yoga
```

| Йога | Условие | Результат |
|------|---------|-----------|
| Дхана от трикон | 5L и 9L сильны в своих домах | Унаследованное и заработанное |
| Обмен 2-11 | 2L в 11-м, 11L во 2-м | Растущий доход |
| Лакшми (Lakshmi) | 9L в кендре, в своём/экзальтации, 1L силён | Великое богатство |
| Чандра-Мангала | MO+MA в соединении | Предприимчивость |
| Шубхамала | 3 бенефика подряд | Комфорт, слава |

---

## 8. Даридра-йоги (Daridra Yoga)

| # | Условие | Эффект |
|---|---------|--------|
| 1 | 2L в дустхане (6,8,12) | Потеря накоплений |
| 2 | 11L в дустхане | Блокированный доход |
| 3 | 2L И 11L в дустханах | Серьёзная бедность |
| 4 | 5L и 9L слабы/в дустханах | Нет удачи |
| 5 | Малефики во 2-м и 12-м без бенефик-аспекта | Расходы > доход |
| 6 | 2L в 12-м (или наоборот) | Утекающее богатство |
| 7 | JU поражён и слаб | Общий индикатор бедности |

```
severity = count(conditions_met)
Раджа/Дхана-йога может перекрыть Даридра-йогу.
```

---

## 9. Випарита-Раджа-йоги (Viparita Raja Yoga)

| Йога | Условие | Результат |
|------|---------|-----------|
| Харша (Harsha) | 6L в 8-м или 12-м | Здоровье, победа над врагами |
| Сарала (Sarala) | 8L в 6-м или 12-м | Долголетие, бесстрашие |
| Вимала (Vimala) | 12L в 6-м или 8-м | Экономность, независимость |

```
STRONG: владелец дустханы в другой дустхане БЕЗ связи с кендра/трикона-владельцами
WEAK: связан с кендрадхипати → смешанные результаты
CANCEL: также владеет кендрой/триконой → обычная Раджа-йога перекрывает
Все 3 в дустханах друг друга → тройная Випарита = исключительная удача.
```

---

## 10. Прочие важные йоги

### 10.1 Будхадитья (Budhaditya)

```
IF sign_of(SU) == sign_of(ME): → Budhaditya (самая распространённая, ~50% карт)
STRONG: ME > 14° от SU, в кендре/триконе, ME в Ge/Vi
WEAK: ME < 3° от SU (полное сожжение), в дустхане
```

### 10.2 Картари (Kartari)

```
FOR house H:
  prev = ((H-2)%12)+1; next = (H%12)+1
  IF benefic(prev) AND benefic(next): → Shubha Kartari (защита)
  IF malefic(prev) AND malefic(next): → Papa Kartari (блокировка)
Особенно значимо для лагны и MO.
```

### 10.3 Грахана (Grahana)

```
IF sign(SU) == sign(RA): → Surya Grahana (проблемы: отец, власть, глаза)
IF sign(MO) == sign(RA/KE): → Chandra Grahana (проблемы: мать, ум)
Diff < 5° → рождение вблизи затмения → сильнее. Аспект JU ослабляет.
```

### 10.4 Куджа-доша (Kuja Dosha)

```
MA в домах {1,2,4,7,8,12} от Лагны/MO/VE → Kuja Dosha
count = sum(from_lagna, from_moon, from_venus)  # сила = count/3

Дом 7 = сильнейшее поражение. Дом 8 = серьёзно. Дом 1 = темперамент.

ОТМЕНА (любое условие):
  MA в Ar/Sc/Cp (свой/экзальтация)
  MA в Cn/Le
  MA+JU соединение или аспект JU
  MA combust/debilitated (сам слаб)
  Лагна в Ar/Le/Aq + MA в 1-м
  MA в Ge/Vi во 2-м; в Ta/Li в 4-м; в Vi/Cp в 8-м; в Ta/Ge/Vi/Li в 12-м
  MA в накшатрах Ashwini/Magha/Mula
  Бенефик аспектирует MA
  Оба партнёра Mangalik
```

---

## 11. Аришта-йоги (Arishta Yoga)

### 11.1 Бала-Аришта (Bala Arishta)

```
arishta_score = 0
IF house_of(MO) IN {6,8,12}: +2. IF no_benefic_aspect(MO): +3
IF papa_kartari(MO): +3
IF conjunction(MO, malefic) AND no_conjunction(MO, benefic): +2
IF malefics_in_kendras > 0 AND benefics_in_kendras == 0: +2

score >= 5: СЕРЬЁЗНАЯ. >= 3: УМЕРЕННАЯ. < 3: нет.
```

### 11.2 Аришта-Бханга

```
ОТМЕНЯЕТСЯ если:
  JU аспектирует MO | JU в кендре от лагны | сильный бенефик в 1-м
  1L силён | MO яркая (> 72° от SU) | MO в Ta/Cn/Pi | VE в кендре без поражения
```

---

## 12. Неечабханга Раджа-йога (Neechabhanga Raja Yoga)

### Таблица дебилитации

| Планета | Знак деб. | Градус деб. | Правитель деб. | Знак экз. | Правитель экз. |
|---------|-----------|-------------|----------------|-----------|----------------|
| SU | Li | 10° | VE | Ar | MA |
| MO | Sc | 3° | MA | Ta | VE |
| MA | Cn | 28° | MO | Cp | SA |
| ME | Pi | 15° | JU | Vi | ME |
| JU | Cp | 5° | SA | Cn | MO |
| VE | Vi | 27° | ME | Pi | JU |
| SA | Ar | 20° | MA | Li | VE |

### 6 условий отмены (любое одно достаточно)

```
P = дебилитированная планета. R = правитель знака дебилитации. E = правитель знака экзальтации P.

1. R в кендре от лагны ИЛИ от MO
2. E в кендре от лагны ИЛИ от MO
3. P аспектирована R
4. Правитель навамши P в кендре/триконе от лагны
5. P экзальтирована в навамше (D9)
6. Две дебилитированные планеты во взаимном аспекте
```

```python
PLANET_DEBIL_SIGN = {"SU":"Li","MO":"Sc","MA":"Cn","ME":"Pi","JU":"Cp","VE":"Vi","SA":"Ar"}
DEBIL_SIGN_LORD = {"SU":"VE","MO":"MA","MA":"MO","ME":"JU","JU":"SA","VE":"ME","SA":"MA"}
EXALT_SIGN_LORD = {"SU":"MA","MO":"VE","MA":"SA","ME":"ME","JU":"MO","VE":"JU","SA":"VE"}
PLANET_EXALT_SIGN = {"SU":"Ar","MO":"Ta","MA":"Cp","ME":"Vi","JU":"Cn","VE":"Pi","SA":"Li"}

def check_neechabhanga(planet, chart, lagna_house=1, moon_house=None):
    p_data = chart[planet]
    if p_data["sign"] != PLANET_DEBIL_SIGN.get(planet):
        return {"is_debilitated": False, "is_cancelled": False, "conditions_met": []}

    conditions = []
    R = DEBIL_SIGN_LORD[planet]
    E = EXALT_SIGN_LORD[planet]
    kendra_l = get_kendras_from(lagna_house)
    kendra_m = get_kendras_from(moon_house) if moon_house else set()
    trikona_l = get_trikonas_from(lagna_house)

    if chart[R]["house"] in (kendra_l | kendra_m): conditions.append(f"1: {R} в Кендре")
    if chart[E]["house"] in (kendra_l | kendra_m): conditions.append(f"2: {E} в Кендре")
    if full_aspect(chart[R]["house"], p_data["house"]): conditions.append(f"3: {R} аспектирует {planet}")
    if p_data.get("navamsha_sign"):
        nav_lord = SIGN_RULER[p_data["navamsha_sign"]]
        if chart[nav_lord]["house"] in (kendra_l | trikona_l):
            conditions.append(f"4: навамша-правитель {nav_lord} в Кендре/Триконе")
    if p_data.get("navamsha_sign") == PLANET_EXALT_SIGN.get(planet):
        conditions.append(f"5: {planet} экзальтирован в навамше")
    for other, debil in PLANET_DEBIL_SIGN.items():
        if other != planet and chart[other]["sign"] == debil:
            if mutual_7th_aspect(chart[other]["house"], p_data["house"]):
                conditions.append(f"6: взаимный аспект с дебилитированным {other}")

    strength = "strong" if len(conditions) >= 3 else "moderate" if len(conditions) >= 1 else "none"
    return {"is_debilitated": True, "is_cancelled": len(conditions) > 0,
            "conditions_met": conditions, "strength": strength}
```

---

## 13. Программная верификация

### 13.1 Порядок детекции

```python
def detect_all_yogas(chart):
    yogas = []
    yogas += detect_ashraya_yogas(chart)
    yogas += detect_dala_yogas(chart)
    yogas += detect_akriti_yogas(chart)
    yogas += detect_sankhya_yogas(chart)
    yogas += detect_mahapurusha_yogas(chart)
    yogas += detect_chandra_yogas(chart)
    yogas += detect_chandradhi_yoga(chart)
    yogas += detect_gajakesari_yoga(chart)
    yogas += detect_surya_yogas(chart)
    yogas += detect_raja_yogas(chart)
    yogas += detect_dharma_karma_yoga(chart)
    yogas += detect_yoga_karaka(chart)
    yogas += detect_dhana_yogas(chart)
    yogas += detect_daridra_yogas(chart)
    yogas += detect_viparita_raja_yogas(chart)
    yogas += detect_budhaditya_yoga(chart)
    yogas += detect_kartari_yogas(chart)
    yogas += detect_grahana_yoga(chart)
    yogas += detect_kuja_dosha(chart)
    yogas += detect_arishta_yogas(chart)
    yogas = apply_cancellations(yogas, chart)
    return yogas
```

### 13.2 Структура YogaResult

```python
@dataclass
class YogaResult:
    name: str              # "Gajakesari Yoga"
    name_ru: str           # "Гаджакешари-йога"
    category: str          # "chandra"|"nabhasa"|"raja"|"dhana"
    subcategory: str       # "akriti"|"sankhya"
    strength: str          # "strong"|"moderate"|"weak"
    planets: list[str]     # ["JU", "MO"]
    houses: list[int]      # [1, 4]
    formation_rule: str
    result_positive: str
    result_negative: str
    is_cancelled: bool
    cancellation_reason: str
    activation_dasha: str
```

### 13.3 Оценка силы йоги

```
УСИЛЕНИЕ: +2 экзальтация, +2 свой знак, +1 друг, +1 кендра, +1 JU-аспект, +1 варготтама, +1 Shukla(MO)
ОСЛАБЛЕНИЕ: -2 дебилитация, -2 combust, -1 дустхана, -1 враг, -1 SA/RA-аспект, -1 Krishna(MO)

>= +3: STRONG | 0..+2: MODERATE | < 0: WEAK
```

### 13.4 Активация через Даши

```
Йога проявляется в Дашу/Антардашу планет-участников.
Двойная Даша (оба участника = Даша+Антардаша) → МАКСИМАЛЬНАЯ активация.
```

---

## 14. Справочные таблицы

### 14.1 Владельцы домов по лагнам

| Лагна | 1L | 2L | 3L | 4L | 5L | 6L | 7L | 8L | 9L | 10L | 11L | 12L |
|-------|----|----|----|----|----|----|----|----|----|----|-----|-----|
| Овен | MA | VE | ME | MO | SU | ME | VE | MA | JU | SA | SA | JU |
| Телец | VE | ME | MO | SU | ME | VE | MA | JU | SA | SA | JU | MA |
| Близнецы | ME | MO | SU | ME | VE | MA | JU | SA | SA | JU | MA | VE |
| Рак | MO | SU | ME | VE | MA | JU | SA | SA | JU | MA | VE | ME |
| Лев | SU | ME | VE | MA | JU | SA | SA | JU | MA | VE | ME | MO |
| Дева | ME | VE | MA | JU | SA | SA | JU | MA | VE | ME | MO | SU |
| Весы | VE | MA | JU | SA | SA | JU | MA | VE | ME | MO | SU | ME |
| Скорпион | MA | JU | SA | SA | JU | MA | VE | ME | MO | SU | ME | VE |
| Стрелец | JU | SA | SA | JU | MA | VE | ME | MO | SU | ME | VE | MA |
| Козерог | SA | SA | JU | MA | VE | ME | MO | SU | ME | VE | MA | JU |
| Водолей | SA | JU | MA | VE | ME | MO | SU | ME | VE | MA | JU | SA |
| Рыбы | JU | MA | VE | ME | MO | SU | ME | VE | MA | JU | SA | SA |

### 14.2 Сводка по типам йог

| Категория | Кол-во | БПХШ | Частота |
|-----------|--------|------|---------|
| Набхаша (Ашрая) | 3 | 37 | Крайне редко |
| Набхаша (Даль) | 2 | 37 | Редко |
| Набхаша (Акрити) | 20 | 37 | Редко-средне |
| Набхаша (Санкхья) | 7 | 37 | Всегда (1 на карту) |
| Панча-Махапуруша | 5 | 75-77 | ~20% карт |
| Чандра-йоги | 5+ | 39 | Часто |
| Суриа-йоги | 3 | 40 | Часто |
| Раджа-йоги | множество | 41 | Часто |
| Дхана-йоги | множество | 43 | Часто |
| Даридра-йоги | множество | 44 | Средне |
| Випарита-Раджа | 3 | 41 | Средне |
| Будхадитья | 1 | 38 | ~50% карт |
| Куджа-доша | 1 | — | ~40% карт |
| Аришта | множество | 10-12 | Часто |

## Правила

```
1. ОДНА КАРТА — МНОЖЕСТВО ЙОГ. Результат = суперпозиция, взвешенная по силе.
2. ИЕРАРХИЯ: Raja > Dhana > Daridra. Но Даридра в дашу без Раджа = бедность.
3. НАВАМША: участники сильны в D9 → йога проявится. Слабы → ослаблена.
4. ТРАНЗИТЫ: активация при транзите участника по натальной позиции другого.
5. НЕ МЕХАНИЧЕСКАЯ ДЕТЕКЦИЯ: формальное наличие != гарантия результата.
6. КОНФЛИКТЫ: Raja+Daridra = богатство приходит/уходит. Mahapurusha+Nicha = невозможно.
```

## Верификация

```
ЧЕКЛИСТ:
□ Набхаша: все 7 грах без RA/KE. Санкхья: ровно 1 на карту.
□ Махапуруша: только MA/ME/JU/VE/SA. Свой/экзальтация + кендра.
□ Кемадрума: проверить отмену (>= 2 условий = полная).
□ Раджа: кендра-владелец + трикона-владелец. 1-й = и то и другое.
□ Випарита: владелец дустханы в другой дустхане. Не должен владеть кендрой.
□ Неечабханга: 6 условий, любое 1 достаточно. >= 3 = strong.
```

---
← [[06-shadbala]] | [[08-special]] →
