# Project Data — Patterns & Gotchas

## When to Use

Use `project` for anything about a crypto project as an entity: overview, team, funding, tokenomics, protocol metrics (TVL, revenue, fees), social mindshare, and smart followers.

## Common Gotchas

1. **`id` is a hermod project ID**, not a ticker or contract address — use `/search` first to resolve
2. **`/metrics` requires a specific `metric` name** (e.g., `tvl`, `revenue`, `fees`, `active_users`) — it does not return all metrics at once
3. **Mindshare and smart-followers** are social-signal features tied to the project, not raw X/Twitter data
4. **`/discover`** with no `id` returns a general feed; with `id` it scopes to that project

## Skill Boundaries

- Spot prices, futures, indicators -> `market`
- Token holders, transfers, unlock schedules -> `token`
- Wallet balances, PnL -> `wallet`
- Raw tweets, user profiles -> `social`
- News articles -> `news`
- On-chain SQL queries -> `onchain`
