---
name: web
description: >
  Web search and page fetching: general web search with optional site filtering,
  and URL content extraction.
  Keywords: web, search, fetch, URL, page, browse, internet.
---

# Web Data

## API Access

All endpoints: `${{BASE_URL_VAR}}/web/{endpoint}`

{{AUTH_NOTE}}

## Quick Examples

```bash
curl -s "${{BASE_URL_VAR}}/web/search?q=uniswap%20v4%20launch&limit=5"
curl -s "${{BASE_URL_VAR}}/web/search?q=solana%20docs&limit=5&site=solana.com"
curl -s -X POST "${{BASE_URL_VAR}}/web/fetch" -H 'Content-Type: application/json' -d '{"url":"https://docs.uniswap.org/concepts/overview"}'
```

## When NOT to Use

- Crypto prices -> `market`
- Project info -> `project`
- Token data -> `token`
- Wallet data -> `wallet`
- Social/X data -> `social`
- News articles -> `news`
- On-chain queries -> `onchain`

## Knowledge
