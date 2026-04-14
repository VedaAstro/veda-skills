# Domain Onboarding Checklist (SEO Skill)

## Цель

Подключить один целевой домен так, чтобы `veda-seo` мог делать не только HTML-аудит, но и опираться на реальные данные Google/Yandex.

## Step 0: Определи единственный target domain

- Пример: `sales.myveda.ru`
- Все доступы ниже должны быть именно на этот домен/host-property.

## Step 1: Google Search Console

- Дать текущему Google-аккаунту права `Owner` или `Full` на target domain.
- Проверка:
  - `search-console.accounts_list`
  - `search-console.sites_list`
- Ожидаемо: target domain есть в списке сайтов.

## Step 2: Yandex Webmaster

- Подтвердить target domain в том же Yandex-аккаунте, на который выдан OAuth token.
- Проверка:
  - `yandex-webmaster.list-hosts`
- Ожидаемо: target domain появляется в hosts.

## Step 3: Yandex Metrika

- Убедиться, что есть counter именно для target domain.
- Проверка:
  - `yandex-metrika.get-counters`
  - (при необходимости прямой API check через `management/v1/counters`)
- Ожидаемо: counter с site, совпадающим с target domain (или его рабочим поддоменом).

## Step 4: Wordstat + Brave

- Wordstat:
  - `yandex-wordstat.get-regions-tree`
  - `yandex-wordstat.top-requests` (после выбора seed query)
- Brave:
  - `brave-search.web_search` для SERP/competitive context.

## Step 5: Smoke-check end-to-end

Все проверки должны проходить в одной свежей сессии:

- `search-console.sites_list` -> target domain виден
- `yandex-webmaster.list-hosts` -> target domain виден
- `yandex-metrika.get-counters` -> нужный counter виден
- `yandex-wordstat.get-regions-tree` -> отвечает
- `brave-search.web_search` -> отвечает

## Если появляются ложные ошибки токена

- Симптом: токен валиден прямым API-запросом, но MCP-tool даёт `invalid_token`/`transport closed`.
- Причина: старые MCP-процессы из параллельных сессий.
- Действие:
  - закрыть старые сессии,
  - перезапустить Codex,
  - повторить smoke-check в новой сессии.
