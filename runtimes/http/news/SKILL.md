---
name: news
description: >
  Query crypto news: search articles, AI-curated project news,
  news detail, and news feeds.
  Keywords: news, articles, headlines, AI news, crypto news, feed.
---

# News Data

## API Access

All endpoints: `${{BASE_URL_VAR}}/news/{endpoint}`

{{AUTH_NOTE}}

## Quick Examples

```bash
curl -s "${{BASE_URL_VAR}}/news/search?q=bitcoin%20etf&limit=10"
curl -s "${{BASE_URL_VAR}}/news/top?metric=trending"
curl -s "${{BASE_URL_VAR}}/news/ai?project_id=bitcoin&limit=5"
curl -s "${{BASE_URL_VAR}}/news/ai/detail?id=abc123"
curl -s "${{BASE_URL_VAR}}/news/feed?id=bitcoin"
```

## When NOT to Use

- Social media posts / tweets -> `social`
- Project fundamentals (team, funding) -> `project`
- Market prices -> `market`
- On-chain data -> `onchain`

## Knowledge
