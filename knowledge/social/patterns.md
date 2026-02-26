# Social Data — Patterns & Gotchas

## When to Use

Use `social` for X/Twitter user profiles, posts, sentiment analysis, follower geography, and batch tweet lookups.

## Common Gotchas

1. **`handle` does not include `@`** — use `vitalikbuterin`, not `@vitalikbuterin`
2. **`/tweets` is POST, not GET** — pass `{"ids": ["123456", "789012"]}` in the body
3. **`/user/{handle}/posts`** can return large responses — always pass `limit`
4. **`/sentiment`** takes a free-text query `q`, not a handle — e.g., `q=ethereum merge`

## Skill Boundaries

- Project-level social mindshare, smart followers -> `project`
- Crypto news articles -> `news`
- On-chain activity -> `wallet` or `onchain`
- Token price / market data -> `market`
