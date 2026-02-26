# Onchain Data — Patterns & Gotchas

## When to Use

Use `onchain` for raw transaction lookups, structured on-chain queries, and direct SQL queries against ClickHouse on-chain data.

## Common Gotchas

1. **`/sql` costs ~5 credits per query** — more expensive than other endpoints; use sparingly
2. **Always set `max_rows`** in `/sql` requests to avoid returning millions of rows
3. **`/query` vs `/sql`**: use `/query` for structured templates; use `/sql` only when you need custom SQL
4. **`chain` is required for `/tx`** — specify `ethereum`, `bsc`, `polygon`, etc.
5. **ClickHouse SQL syntax** differs from MySQL/PostgreSQL in some areas (e.g., array functions, date handling)

## Skill Boundaries

- Token holders, transfers -> `token` (simpler, pre-built endpoints)
- Wallet balances, history -> `wallet`
- Market data -> `market`
- Project metrics (TVL, revenue) -> `project`
- News -> `news`
- Social data -> `social`
