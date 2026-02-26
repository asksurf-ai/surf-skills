# Web Data — Patterns & Gotchas

## When to Use

Use `web` for general web search and fetching web page content. This is the fallback when no structured API endpoint covers the data you need.

## Common Gotchas

1. **`/fetch` is POST** — pass `{"url": "https://example.com"}` in the body
2. **`/search` supports `site` filtering** — use it to restrict results (e.g., `site=docs.uniswap.org`)
3. **`/fetch` returns extracted text**, not raw HTML — do not expect to parse DOM elements
4. **Prefer structured endpoints first** — only use `web` when market/project/token/wallet/social/news/onchain don't cover the data

## Skill Boundaries

- Crypto prices -> `market`
- Project info -> `project`
- Token data -> `token`
- Wallet data -> `wallet`
- Social/X data -> `social`
- News articles -> `news`
- On-chain queries -> `onchain`
- General web / fallback -> `web` (this domain)
