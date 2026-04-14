---
name: ceo-council
description: Мульти-агентный стратегический анализ. Запускает 3-5 параллельных Opus-агентов как независимых C-level экспертов для анализа проекта с разных стратегических линз. Используй для product decisions, pricing, market positioning, архитектурных развилок.
---

# CEO Council — Independent Strategic Analysis

## Суть
Один AI = одно мнение. Council = 3-5 независимых экспертов с разными линзами, которые могут СПОРИТЬ друг с другом. Снижает слепые зоны при стратегических решениях.

## Когда использовать
- Product roadmap и приоритизация
- Pricing / monetization решения
- Архитектурные развилки (build vs buy, monolith vs micro)
- Competitive analysis и positioning
- Go-to-market стратегия

## Процесс (6 шагов, строго по порядку)

### Step 1: Scan Context
```
READ: CLAUDE.md, README, file structure, git log --oneline -20
IDENTIFY: domain, stage, team size, tech stack, revenue model
```

### Step 2: Generate Roles (4-6 штук)
Роли АДАПТИРОВАНЫ к проекту, не generic. Примеры для VEDA:
- **Product Strategist** — product-market fit, user journey, retention
- **Revenue Architect** — pricing, monetization, unit economics
- **Tech CTO** — scalability, tech debt, architecture decisions
- **Growth Hacker** — acquisition channels, conversion, virality
- **Domain Expert** — ведическая астрология, рынок эзотерики, конкуренты
- **Devil's Advocate** — contrarian view, risks, что может пойти не так

### Step 3: User Selects Experts
```
MANDATORY: AskUserQuestion с multiSelect
MINIMUM: 2 эксперта
RECOMMEND: 3-4 для баланса signal/noise
```

### Step 4: Gather Data
```
COLLECT: metrics, strategy docs, recent changes, user feedback
EXCLUDE: vanity metrics (stars, traffic без контекста)
PREPARE: identical data block для ВСЕХ экспертов
```

### Step 5: Execute (параллельно)
```
FOR EACH expert:
  Task(subagent_type="general-purpose", model="opus"):
    - Role: {expert_role}
    - Personality: {contrarian|pragmatic|data-driven|visionary}
    - Context: {identical_data_block}
    - Focus areas: 3-6 вопросов специфичных для роли
    - Output: findings + recommendations + risks

CRITICAL: все Task-вызовы в ОДНОМ сообщении (параллельность)
CRITICAL: ОДИНАКОВЫЙ контекст всем — различия только в линзе анализа
```

### Step 6: Synthesize
```
OUTPUT FORMAT:
## Council Members
[кто участвовал, какая линза]

## Consensus (все согласны)
- Point 1...
- Point 2...

## Disagreements (спорные точки)
| Тема | Expert A | Expert B | Аргументы |
|------|----------|----------|-----------|

## Decisions (action items)
1. [решение] — based on [consensus/majority]
2. [решение] — requires further data
```

## Anti-patterns
- Выбирать роли БЕЗ согласования с user
- Давать РАЗНЫЙ контекст разным экспертам
- Более 5 экспертов (noise > signal)
- Использовать bash/shell вместо Task tool
- Собирать vanity metrics
