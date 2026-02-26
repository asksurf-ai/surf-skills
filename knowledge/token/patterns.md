# Token Data — Patterns & Gotchas

## When to Use

Use `token` for on-chain token-specific data: holder distribution, transfers, top traders, unlock schedules, and token metadata by contract address.

## Common Gotchas

1. **`address` is a contract address**, not a wallet address — for wallet data use the `wallet` domain
2. **`chain` is required** alongside `address` for multi-chain tokens (e.g., USDC on ethereum vs solana)
3. **`/holders` and `/transfers` return large arrays** — always pass `limit`
4. **`/top-traders`** only needs `address` (chain is inferred)
5. **`/metrics`** uses `asset` (symbol or ID) not `address` — different from other token endpoints

## Skill Boundaries

- Spot prices, futures, indicators -> `market`
- Project-level data (TVL, revenue, team) -> `project`
- Wallet balances and PnL -> `wallet`
- Social / X data -> `social`
- News -> `news`
- Raw SQL on-chain queries -> `onchain`
