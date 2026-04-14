# Tools Map — Trendwatching Pipeline

Mapping of pipeline tasks to available MCP tools on Alex's machine.

## Search & Research

| Task | MCP Tool | Usage |
|------|----------|-------|
| Semantic web search | `mcp__exa__web_search_exa` | Deep research, company profiles, market analysis. Best for "find pages about X" |
| Keyword web search | `mcp__brave-search__brave_web_search` | Broad search, news, recent events. Best for factual queries |
| Company research | `mcp__exa__company_research_exa` | Quick company overview (deprecated, prefer web_search_advanced) |
| People search | `mcp__exa__people_search_exa` | Find founders, executives |

### Search Strategy
- **Phase 1 (Scout)**: 2 Exa queries (semantic) + 2 Brave queries (keyword) = 4 queries minimum
- **Phase 3c (Traffic)**: Exa for marketing spend articles + Brave for traffic data

## Ad Collection

| Task | MCP Tool | Usage |
|------|----------|-------|
| Meta Ad Library | `mcp__Apify__call-actor` | Actor: `apify/facebook-ads-scraper`. Input: `{"searchQuery": "Brand", "countryCode": "US", "maxResults": 50}` |
| TikTok Ads | `mcp__playwright__browser_*` | Navigate to TikTok Creative Center, snapshot, screenshot |
| VK Ads | `mcp__playwright__browser_*` | Navigate to VK group wall, filter promoted posts |
| Get Apify results | `mcp__Apify__get-actor-output` | Fetch full dataset after actor completes |
| Find Apify actors | `mcp__Apify__search-actors` | Search for platform-specific scrapers |

### Apify Patterns
```
# Start Meta Ad scraper
call-actor: actor="apify/facebook-ads-scraper", input={"searchQuery":"...", "countryCode":"US"}
# Wait for completion, then:
get-actor-output: datasetId="..."
```

## Web Scraping & Screenshots

| Task | MCP Tool | Usage |
|------|----------|-------|
| Full page screenshot | `mcp__playwright__browser_take_screenshot` | `fullPage: true` for landing analysis |
| Page content (text) | `mcp__playwright__browser_snapshot` | Accessibility tree — text, roles, structure |
| CSS inspection | `mcp__playwright__browser_inspect` | Check specific element styles |
| Page navigation | `mcp__playwright__browser_navigate` | Open competitor URL |
| Click/interact | `mcp__playwright__browser_click` | Navigate within page |
| Content extraction | `mcp__Apify__apify-slash-rag-web-browser` | Get markdown content from URL. Fallback if Playwright blocked |

### Playwright Pattern (Landing Analysis)
```
1. browser_navigate → URL
2. browser_snapshot → get page structure + text
3. browser_take_screenshot → fullPage visual
4. browser_inspect → check CSS of key elements (CTA buttons, hero)
5. browser_console_logs → check for errors/tech stack clues
```

## Yandex Tools (Russian Market)

| Task | MCP Tool | Usage |
|------|----------|-------|
| Keyword volume | `mcp__yandex-wordstat__top-requests` | Brand queries = awareness proxy |
| Search trends | `mcp__yandex-wordstat__dynamics` | Seasonal patterns |
| Regional distribution | `mcp__yandex-wordstat__regions` | Geographic demand |
| Site indexing | `mcp__yandex-webmaster__get-summary` | Competitor's indexed pages |
| Search queries | `mcp__yandex-webmaster__get-popular-queries` | What drives traffic (own sites only) |
| Traffic summary | `mcp__yandex-metrika__get-traffic-summary` | Own sites analytics |
| Traffic sources | `mcp__yandex-metrika__get-traffic-sources` | Channel breakdown (own sites only) |

### Yandex Pattern (Competitor Research)
```
# Brand awareness via Wordstat
top-requests: phrase="бренд конкурента" → monthly volume
dynamics: phrase="бренд конкурента" → trend over time
regions: phrase="бренд конкурента" → geographic demand

# NOTE: Yandex Metrika and Webmaster only work for OUR sites
# For competitor traffic data, use Exa/Brave search
```

## Google Workspace (Report)

| Task | MCP Tool | Usage |
|------|----------|-------|
| Create Doc | `mcp__gws__docs_documents_create` | body: `{"title": "Конкурентный анализ — Ниша — Дата"}` |
| Write to Doc | `mcp__gws__docs_documents_batchUpdate` | Insert text, headings, tables |
| Create Sheet | `mcp__gws__sheets_spreadsheets_create` | body: `{"properties": {"title": "Сравнение конкурентов"}}` |
| Write to Sheet | `mcp__gws__sheets_spreadsheets_values_batchUpdate` | Write data rows |
| Format Sheet | `mcp__gws__sheets_spreadsheets_batchUpdate` | Bold headers, colors, column widths |
| Add Sheet tab | `mcp__gws__sheets_spreadsheets_batchUpdate` | Add tabs: Обзор, Креативы, Трафик, Лендинги, Идеи |

### GWS Doc Writing Pattern
```
1. docs_documents_create → get documentId
2. docs_documents_batchUpdate → insertText requests (insert from end to start to preserve indices)
3. docs_documents_batchUpdate → formatText requests (bold headings, etc.)
```

### GWS Sheet Writing Pattern
```
1. sheets_spreadsheets_create → get spreadsheetId
2. sheets_spreadsheets_batchUpdate → addSheet for each tab
3. sheets_spreadsheets_values_batchUpdate → write headers + data
4. sheets_spreadsheets_batchUpdate → format (bold row 1, column widths, colors)
```

## File Management

| Task | Tool | Usage |
|------|------|-------|
| Create workspace | `Bash` | `mkdir -p ~/Projects/Claude_Docs/trendwatching/{niche}_{date}/data` |
| Write JSON | `Write` | Save structured data to `data/*.json` |
| Read previous step | `Read` | Load data from previous pipeline step |
| Update state | `Edit` | Update `state.json` step status |

## Tools NOT Available (don't try)

| Tool | Why not | Alternative |
|------|---------|-------------|
| SimilarWeb API | No subscription, blocks scraping | Exa/Brave for traffic estimates |
| TabStack | Not installed | Apify RAG browser or Playwright |
| `~/.claude/.env` | Not our machine | MCP tools are pre-authenticated |
| Custom Python scripts | Not our machine | Direct MCP tool calls |
| Chrome MCP | Disabled | Playwright MCP instead |
