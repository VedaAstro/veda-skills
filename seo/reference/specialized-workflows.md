# Specialized Workflows

## Когда открывать

- Нужен SEO-workflow, который не закрывается одним runtime-аудитом
- Нужно быстро понять, какой playbook открывать под задачу

## Маршрутизация

| Задача | Что делать сначала | Какой файл открыть |
|--------|--------------------|--------------------|
| Полный аудит сайта/URL | Запустить `node scripts/run-audit.js` | `audit-runtime.md` |
| Programmatic SEO / batch pages | Проверить policy risk и template value | `programmatic-playbook.md` |
| Hreflang / international SEO | Проверить canonical model и reciprocal pairs | `hreflang-playbook.md` |
| Comparison / alternatives pages | Проверить intent и fairness | `competitor-pages.md` |
| E-E-A-T / экспертность / trust | Проверить автора, proof, commercial completeness | `eeat-playbook.md` |
| Visual SEO / mobile first screen | Снять snapshot/screenshots и проверить above-the-fold | `visual-qa-playbook.md` |
| GEO / AI search | Проверить indexability, structure, crawler access | `geo-playbook.md` |
| Domain launch / migration | Проверить measurement + onboarding | `domain-onboarding-checklist.md`, `measurement-debug.md` |

## Правило порядка

1. Сначала runtime или фактическая техпроверка.
2. Потом профильный playbook.
3. Потом только рекомендации по стратегии и контенту.

## Чего не делать

- Не выдавать playbook-эвристику за “данные”
- Не миксовать off-page гипотезы с page-level поломками
- Не запускать массовую публикацию без `search-policies.md`
