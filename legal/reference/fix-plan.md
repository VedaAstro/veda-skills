# План юридических фиксов — АНО ДПО «Ведантика»

> Составлен: 2026-03-31 по итогам аудита организации + 39 продуктов
> Горизонт: неделя 1 (до 15.04) + квартал Q2 2026

---

## БЛОК 0 — РУЧНЫЕ ДЕЙСТВИЯ АЛЕКСА (Claude не может)

### 0.1 Отчёт в Минюст — до 15 апреля 2026

1. Войти: **https://nco.minjust.gov.ru/** (потребуется ЕСИА/Госуслуги)
2. Выбрать организацию: АНО ДПО «Ведантика», ИНН 7838118476
3. Заполнить отчёт за 2025 год по новой форме (Приказ Минюста № 336 от 09.12.2025)
4. Подать до 23:59 15 апреля 2026

Штраф за пропуск: предупреждение → при повторе принудительная ликвидация

### 0.2 РКН — реестр операторов ПД — немедленно

1. Открыть: **https://pd.rkn.gov.ru/operators-registry/operators-list/**
2. Ввести ИНН: **7838118476**
3. Если организации НЕТ в реестре → подать уведомление там же (форма бесплатная, 15 мин)

Штраф за работу без уведомления: 100 000 — 500 000 руб. (ст. 13.11 КоАП, с 30.05.2025)

### 0.3 Уточнить у бухгалтера

- Нулевая выручка за 2024 в ФНС при реальных оборотах — либо ошибка учёта, либо не сданы отчёты
- АНО учитывает доходы как «целевые поступления» — ФНС должна видеть это в форме ОН0001

---

## БЛОК 1 — ОФЕРТЫ: убрать незаконную оговорку (Сессия 5)

### Проблема
В `oferta_1022` и производных:
> «...договор не является публичной офертой, исключающей применение закона о защите прав потребителей»

**Это незаконно.** ВС РФ N72-КГ23-1-К8 (2023): потребитель не может отказаться от ЗоЗПП. Суд признаёт пункт ничтожным и может расценить как признак недобросовестности → увеличение штрафа.

### Затронутые продукты (7 штук — одна оферта)
- vedantica.pro/oferta_1022:
  - Ректификация
  - НейроАстролог 1 ступень
  - НейроАстролог 2 ступень
  - Активация Денежного Магнита
  - Тест-драйв «Профессия ВА»
  - Профессия НейроАстролог (лендинг)

### Фикс
Заменить оговорку на:
> «Настоящий договор является договором возмездного оказания образовательных услуг. К отношениям между Исполнителем и Заказчиком — физическим лицом, приобретающим услуги для личных нужд, применяется Закон РФ "О защите прав потребителей" в части, не противоречащей настоящему договору.»

---

## БЛОК 2 — СОГЛАСИЕ НА РАССЫЛКИ: 25 продуктов без согласия

### Штраф
38-ФЗ, ст. 14.3 КоАП: до 1 000 000 руб. за каждую рекламную рассылку без согласия

### Продукты без согласия (25 штук)

| # | Продукт | Страница продажи |
|---|---------|-----------------|
| 1 | Ведический астролог 1.4 | vedantica.pro/tariff |
| 2 | Профессия НейроАстролог | vedantica.pro/neyroastrology |
| 3 | Ректификация | vedantica.pro/recti_tariff |
| 4 | Мини-курсы | vedantica.pro/generous_offers |
| 5 | Накшатры | vedantica.pro/tariff3 |
| 6 | Астрология рода | vedantica.pro/tariff4 |
| 7 | Панчанга | vedantica.pro/panchanga |
| 8 | НейроАстролог 30 мая (веб) | vedantica.pro/neyroastrology30 |
| 9 | Тренинг Быстрый старт | vedantica.pro/reality_number |
| 10 | НейроАстролог 1 ступень | vedantica.pro/neyroastrology |
| 11 | НейроАстролог 2 ступень | vedantica.pro/neyro2step |
| 12 | НейроНумеролог 2 ступень | vedantica.pro/tarifneronume |
| 13 | Погружение в накшатры | vedantica.pro/tariff3 |
| 14 | Дробные карты | vedantica.pro/vargi |
| 15 | Мухурта | vedantica.pro/muhurta |
| 16 | Активация Денежного Магнита | vedantica.pro/money_magnet |
| 17 | Активируй потенциал ребенка | course.vedantica.ru/rodperezagruzka |
| 18 | Освобождение | vedantica.pro/osvobozhdeniye |
| 19 | Карма (распродажа) | vedantica.pro/generous_offers |
| 20 | Деньги (распродажа) | vedantica.pro/generous_offers |
| 21 | Расчёт времени (распродажа) | vedantica.pro/generous_offers |
| 22 | ЛОТЫ | course.vedantica.ru/birthday25 |
| 23 | Ведическое таро | course.vedantica.ru/vedicheskoetaro |
| 24 | Питру Пакша | course.vedantica.ru/rodperezagruzka |
| 25 | Карта без времени | course.vedantica.ru/rodperezagruzka |
| 26 | 7 направлений — одна система | vedantica.pro/bf |

### Готовый шаблон согласия уже есть
- vedantica.pro/soglasie — для vedantica.pro продуктов
- course.vedantica.ru/soglasie_042025 — для course.vedantica.ru продуктов
- vedantica.getcourse.ru/soglasie_042025 — для getcourse продуктов

### Фикс
В каждую форму оплаты (GetCourse / Tilda) добавить чекбокс:
```
☐ Я согласен получать информационные и рекламные рассылки от АНО ДПО «Ведантика»
  [ссылка на согласие]
```
**Чекбокс необязательный** (нельзя блокировать покупку), но должен быть.

---

## БЛОК 3 — ОФЕРТЫ НА GOOGLE DOCS: перенести на сайт (2 продукта)

### Проблема
Google Docs не является надёжным местом публикации оферты: документ может стать недоступным, Google может заблокировать. Суды принимают, но с оговорками.

### Продукты
- **ЛОТЫ в честь дня рождения** (course.vedantica.ru/birthday25)
  → Оферта: docs.google.com/document/d/1PdFfAyDlY1514_H4-1G0VrUdDlck6SpJy9zhJUUptvk/
- **Ведический астролог (юбилей)** (vedantica.pro/vedastroyoubiley)
  → Оферта ДО: docs.google.com/document/d/12EO1rTHxFcxmOWqyyOZl_etZzH71mJ2f5B-09BeQWL4/
  → Оферта ДПО: docs.google.com/document/d/1fQj7t6aw4xVNxAUBh-ELPi0zNuMWrt83yOuoJvzAv7s/

### Фикс
Создать страницы на Tilda/course.vedantica.ru и переложить туда тексты.

---

## БЛОК 4 — «ОСВОБОЖДЕНИЕ»: неверная оферта (1 продукт)

Продукт «Освобождение» (vedantica.pro/osvobozhdeniye) ссылается на `offerta_panchanga` — оферту другого курса. Предмет договора не совпадает.

**Фикс:** Создать отдельную оферту для «Освобождения» или убедиться, что offerta_panchanga охватывает этот продукт (маловероятно).

---

## БЛОК 5 — САЙТ vedantica.pro/documents: актуализировать (Сессия 4)

### Изменения

| Поле | Сейчас | Нужно |
|------|--------|-------|
| Директор | Левина Анастасия Валерьевна | Максимов Роман Андреевич |
| Ссылка на лицензию | Только номер | + ссылка на islod.obrnadzor.gov.ru |
| Устав | Яндекс Диск | Перенести на сервер или Tilda |
| Политика ПД | Нет ссылки в documents | Добавить vedantica.pro/policy |
| Свидетельство о регистрации | Нет | Добавить скан |

---

## БЛОК 6 — ВЕБ-СЕРВИСЫ: создать недостающие документы (Сессия 5)

### new.astroguru.ru

Нет ни одного юридического документа:

| Документ | URL (создать) | Приоритет |
|---------|--------------|-----------|
| Пользовательское соглашение | new.astroguru.ru/terms | 🔴 |
| Политика ПД | new.astroguru.ru/policy | 🔴 |
| Cookie Policy | new.astroguru.ru/cookies | 🟠 |
| AI Disclaimer | new.astroguru.ru/ai-disclaimer | 🟠 |

### app.myveda.ru

| Документ | URL (создать) | Приоритет |
|---------|--------------|-----------|
| Пользовательское соглашение | app.myveda.ru/terms | 🟠 |
| Политика ПД | app.myveda.ru/policy | 🟠 |

---

## РЕЕСТР ВСЕХ ПУБЛИЧНЫХ URL (проверено 2026-03-31)

### Реестры (ручная проверка)
```
https://pd.rkn.gov.ru/operators-registry/operators-list/          # РКН операторы ПД
https://nco.minjust.gov.ru/                                        # Минюст отчётность НКО
https://islod.obrnadzor.gov.ru/rlic/                               # Лицензии Рособрнадзор (номер Л035-01271-78/01136147)
https://www.rusprofile.ru/id/1237800139345                         # Rusprofile карточка
https://zachestnyibiznes.ru/company/ul/1237800139345_7838118476    # Zachestnyibiznes
```

### vedantica.pro — документы (все ✅ 200)
```
https://vedantica.pro/documents                   # Сведения об образ. организации
https://vedantica.pro/oferta22                    # Оферта основная (эталон)
https://vedantica.pro/policy                      # Политика ПД основная
https://vedantica.pro/soglasie                    # Согласие на рассылки (эталон)
https://vedantica.pro/oferta_1022                 # Оферта (НЕЗАКОННАЯ оговорка ЗоЗПП!)
https://vedantica.pro/neyro_number_oferta         # Оферта НейроНумеролог
https://vedantica.pro/neyro_number_policy         # Политика ПД НейроНумеролог
https://vedantica.pro/neyro_number_soglasie       # Согласие рассылки НейроНумеролог
https://vedantica.pro/neyro_number_rewie          # Согласие отзывы НейроНумеролог
https://vedantica.pro/neyro_astrology_oferta      # Оферта НейроАстролог
https://vedantica.pro/neyro_number_new_policy     # Политика ПД НейроНумеролог новый
https://vedantica.pro/neyro2step2_oferta          # Оферта НейроАстролог 2.2
https://vedantica.pro/neyro2step2_p               # Политика ПД НейроАстролог 2.2
https://vedantica.pro/neyro2step2_s               # Согласие рассылки НейроАстролог 2.2
https://vedantica.pro/tariff_1033_oferta          # Оферта ВА 1.1
https://vedantica.pro/tariff_1033_policy          # Политика ПД ВА 1.1
https://vedantica.pro/tariff_1033_s               # Согласие рассылки ВА 1.1 / ВА юбилей
https://vedantica.pro/psychology_cons_soglasie    # Согласие рассылки Психология
```

### course.vedantica.ru — оферты (все ✅ 200)
```
https://course.vedantica.ru/offerta_kurs                    # Мини-курсы (3 продукта)
https://course.vedantica.ru/offerta_karma_roda              # Астрология рода
https://course.vedantica.ru/offerta_panchanga               # Панчанга + Освобождение (ошибка)
https://course.vedantica.ru/ofertadg_0525                   # НейроАстролог 30 мая
https://course.vedantica.ru/offerta_nnv                     # НейроНумеролог нового времени
https://course.vedantica.ru/offerta_nnv_reality             # Быстрый старт
https://course.vedantica.ru/tarifneronume2                  # НейроНумеролог 2 ступень
https://course.vedantica.ru/offerta_vargi                   # Дробные карты
https://course.vedantica.ru/offerta_muhurta                 # Мухурта
https://course.vedantica.ru/offerta_ayurveda                # Астрология здоровья
https://course.vedantica.ru/offerta_ved_taro                # Ведическое таро
https://course.vedantica.ru/offerta_kniga                   # Книга силы
https://course.vedantica.ru/ps_karma_rod                    # Питру Пакша
https://course.vedantica.ru/offerta_card_without_time       # Карта без времени
https://course.vedantica.ru/oferta_26022026                 # АстроКоучинг
https://course.vedantica.ru/offerta_va_direction            # 7 направлений (ДО)
https://course.vedantica.ru/offerta_va_7                    # 7 направлений (ДПО)
https://course.vedantica.ru/offerta_7napravleniy_ob         # Ведическая Астрология 7 направлений
https://course.vedantica.ru/offerta_child's_potential       # Активируй потенциал ребенка
```

### course.vedantica.ru — политики и согласия (все ✅ 200)
```
https://course.vedantica.ru/politika_042025                 # Политика ПД (course)
https://course.vedantica.ru/soglasie_042025                 # Согласие рассылки (course)
https://course.vedantica.ru/consent_to_mailing_lists        # Согласие рассылки АстроКоучинг
https://course.vedantica.ru/soglasie_otziv                  # Согласие отзывы
```

### vedantica.getcourse.ru (все ✅ 200)
```
https://vedantica.getcourse.ru/offerta_042025               # Оферта Психология
https://vedantica.getcourse.ru/offerta_nakshatras           # Оферта Накшатры
https://vedantica.getcourse.ru/offerta_vn_ob                # Оферта Ведическая нумерология
https://vedantica.getcourse.ru/politika_042025              # Политика ПД (getcourse)
https://vedantica.getcourse.ru/soglasie_042025              # Согласие рассылки (getcourse)
```

### Программы ДПО/ДО (не проверялись, вероятно ✅)
```
https://course.vedantica.ru/programma_PNN_1
https://course.vedantica.ru/programma_PNN_2
https://course.vedantica.ru/programma_PNA_1
https://course.vedantica.ru/programma_PNA_2
https://course.vedantica.ru/programma_PNA_2.2
https://course.vedantica.ru/programma_rectification
https://course.vedantica.ru/programma_psychologist_consultant
https://course.vedantica.ru/programma_panchanga
https://course.vedantica.ru/programma_NNV
https://course.vedantica.ru/programma_drobnyye_karty
https://course.vedantica.ru/programma_muhurta
https://course.vedantica.ru/programma_potentsial_rebenka
https://course.vedantica.ru/programma_taro
```

### Google Docs (⚠️ требуют переноса)
```
https://docs.google.com/document/d/1PdFfAyDlY1514_H4-1G0VrUdDlck6SpJy9zhJUUptvk/  # ЛОТЫ оферта
https://docs.google.com/document/d/12EO1rTHxFcxmOWqyyOZl_etZzH71mJ2f5B-09BeQWL4/  # ВА юбилей оферта ДО
https://docs.google.com/document/d/1fQj7t6aw4xVNxAUBh-ELPi0zNuMWrt83yOuoJvzAv7s/  # ВА юбилей оферта ДПО
```

### Яндекс Диск (⚠️ риск недоступности — перенести)
```
https://disk.yandex.ru/i/HZ61n-psp580rg   # Устав АНО ДПО «Ведантика»
https://disk.yandex.ru/i/VDFBGxLoONA45A   # Правила внутреннего распорядка обучающихся
https://disk.yandex.ru/i/zzcLqM5AEmcFxg   # Правила внутреннего трудового распорядка
https://disk.yandex.ru/i/XG5pNFd2qjqAkg   # Правила приема на дополнительные программы
https://disk.yandex.ru/i/CwB4KnjWlDGJ2Q   # Правила оказания платных образовательных услуг
https://disk.yandex.ru/i/8_l7URBJma-odA   # Образец договора об образовании
```

---

## ДОРОЖНАЯ КАРТА ФИКСОВ

### Неделя 1 (до 15.04.2026) — СРОЧНО

| День | Действие | Ответственный | Инструмент |
|------|---------|--------------|-----------|
| 31.03 | Проверить РКН реестр, подать если нет | Алекс | Браузер, pd.rkn.gov.ru |
| 01.04 | Открыть nco.minjust.gov.ru, начать заполнение отчёта | Алекс | ЕСИА + Минюст |
| 02.04 | Исправить oferta_1022 (убрать оговорку ЗоЗПП) | Claude + Алекс | Tilda editor |
| 03.04 | Добавить согласие рассылки в ТОП-10 продуктов (GetCourse чекбокс) | Claude + команда | GetCourse |
| 07.04 | Обновить директора на vedantica.pro/documents | Claude | Tilda |
| 10.04 | Добавить согласие рассылки в оставшиеся 15 продуктов | Команда | GetCourse / Tilda |
| 15.04 | Подать отчёт в Минюст | Алекс | Минюст |

### Неделя 2-3 (апрель)

- Перенести оферты ЛОТЫ и ВА юбилей с Google Docs на сайт
- Создать отдельную оферту для «Освобождения»
- Создать Cookie Policy, AI Disclaimer, User Agreement для new.astroguru.ru
- Перенести Яндекс Диск документы на сервер

### Q2 2026

- Редизайн vedantica.pro (Сессия 4 roadmap)
- Проверить ФИС ФРДО — внесение дипломов ДПО
- Аудит форм GetCourse на наличие чекбоксов согласия (полная проверка)
