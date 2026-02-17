# Architecture Reference — Diagnostic Workstation

## Цепочка данных (полная)

```
1. Клиент проходит квиз
   -> QuizSubmission в БД (7 полей: triedBefore, costLost, costFuture,
      incomeNow, incomeGoal, dreamChange, timeReady, familyAttitude)

2. Бэкенд создаёт DiagnosticProfile
   -> AstroGuru API (chart.create + chart.getPlanetData)
   -> natal_data в БД (9 планет: house, sign, degree, isRetrograde, isExalted, isDebilitated)

3. Диагност открывает сессию
   -> BFF (api/diagnostic/[sessionId]/route.ts) собирает всё:
      client + natal_data + quizData + aiProfile + planetImageUrls
   -> DiagnosticContext (фронтенд state)

4. Диагност нажимает "Загрузить срезы"
   -> loadChartSlices() в DiagnosticContext
   -> POST api/chart-interpretation/slices (BFF)
   -> openrouter.ts -> Gemini 2.0 Flash (LLM)
   -> 9 SliceResult[] -> chartSlices state

5. Диагност переключает срезы в ChartControlPanel
   -> goToSlice(index) -> currentSlice + diagnosticianScript обновляются
   -> Диагност читает скрипт, задаёт вопрос

6. Диагност нажимает "Показать клиенту"
   -> sendCurrentSliceToClient() -> WebSocket
   -> Клиент видит: подсвеченные дома на карте + anchor text
```

## WebSocket протокол

```typescript
// Диагност -> Клиент
sendChartInteraction({
  type: 'highlight',
  houses: [{ house: 8, color: 'red', label: 'Блокировка' }],
  anchorText: 'Сатурн в 8 доме — блок финансового потока'
})

sendChartInteraction({ type: 'clear' })  // очистить подсветки
```

## Типы данных

```typescript
// 9 типов срезов
type ChartSliceType =
  | 'pain_link'        // Волна 1: боль
  | 'family_program'   // Волна 1: род
  | 'financial_channel' // Волна 1: деньги
  | 'karmic_axis'      // Волна 1: карма
  | 'resource_planets'  // Волна 2: ресурс (ветвление)
  | 'ketu_talent'      // Волна 2: талант (ветвление)
  | 'atma_karaka'      // Волна 2: душа
  | 'crisis_age'       // Волна 3: кризис
  | 'age_transit';     // Волна 3: транзит

// Результат генерации одного среза
interface SliceResult {
  sliceType: ChartSliceType;
  applicable: boolean;  // AI решает, подходит ли этот срез
  highlightedHouses: { house: number; color: string; label?: string }[];
  anchorPhrase: string; // что видит клиент
}

// Скрипт для диагноста (один срез)
interface DiagnosticScript {
  question: string;        // вопрос клиенту
  talkingPoint: string;    // что сказать после ответа
  talkingPointYes?: string; // ветка "да" (только resource/ketu)
  talkingPointNo?: string;  // ветка "нет" (только resource/ketu)
  guiltRelief: string;     // снятие вины
  bridgePhrase: string;    // фраза-мост к следующему срезу
  listenFor: string[];     // ключевые слова в ответе клиента
  anchorPhrase: string;    // что увидит клиент
}

// DiagnosticSession (app/types/index.ts)
interface DiagnosticSession {
  id: string;
  client: ClientData;
  chart: ChartData;        // planets, houses
  routing: RoutingData;
  quizData?: QuizData;     // V4: ответы квиза
  notes?: string;
  // ... (полный тип в types/index.ts)
}
```

## База трактовок (9 слоев)

| Слой | Таблица БД | Метод | Что даёт |
|------|-----------|-------|----------|
| 1. Позиция | natal_data | — | house, sign, degree |
| 2. Статус | natal_data | — | isRetrograde, isExalted, isDebilitated |
| 3. Дом | planet_in_house | get_planet_in_house() | core, strength, shadow, action |
| 4. Знак | planet_in_sign | get_planet_in_sign() | status, core |
| 5. Природа | functional_nature | get_functional_nature() | nature, reason, is_yogakaraka |
| 6. Соединения | planet_conjunctions | get_planet_conjunction() | effects |
| 7. Накшатра | nakshatras | get_nakshatra() | name, описание |
| 8. AI для клиента | LLM | openrouter.ts | персонализация под боль |
| 9. Речевой модуль | LLM | openrouter.ts | что сказать клиенту |

## Untitled UI иконки (маппинг)

```
import { IconName } from '@untitledui-pro/icons/line/IconName'
```

| Назначение | Иконка | Размер |
|-----------|--------|--------|
| Редактировать | Pencil01 | 14 |
| Развернуть/свернуть | ChevronDown / ChevronRight | 12 |
| Вопрос клиенту | MessageChatCircle | 14 |
| Снятие вины | ShieldTick | 14 |
| Фраза-мост | Link01 | 14 |
| Слушать | Headphones01 | 14 |
| Клиент увидит | Eye | 14 |
| Готово | Check | 14 |
| Зум | ZoomIn | 14 |
| Поиск | SearchLg | 14-20 |

## VedicNatalChart (SVG-компонент)

```typescript
<VedicNatalChart
  planets={planetPlacements}        // массив { planet, house, sign, ... }
  planetImageUrls={urls}            // PNG планет с CDN
  size="small" | "medium" | "large" // 200/340/440px
  showHouseNumbers                  // номера домов
  showHouseIcons                    // иконки сфер жизни
  showZodiacSigns                   // знаки зодиака
  highlightedHouses={[              // подсветка домов
    { house: 8, color: 'red', label: 'Блокировка' }
  ]}
/>
```

Геометрия: 12 домов — cardinal (1,4,7,10 ромб), corner (2,6,8,12 треугольник), inner (3,5,9,11 треугольник).
