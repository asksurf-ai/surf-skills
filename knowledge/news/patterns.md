# News Data — Patterns & Gotchas

## When to Use

Use `news` for crypto news search, AI-curated project news, and news feeds.

## Common Gotchas

1. **`/search` uses `q` for free-text search** — e.g., `q=bitcoin etf`
2. **`/ai` requires `project_id`**, not a ticker or name — resolve via `/project/search` first
3. **`/search` and `/ai` support pagination** with `limit` and `offset` — use them for large result sets
4. **`/ai/detail` returns full article content** — can be long; use when you need the full text, not just headlines

## Skill Boundaries

- Social media posts / tweets -> `social`
- Project fundamentals (team, funding) -> `project`
- Market prices / indicators -> `market`
- On-chain data -> `onchain` or `token`
