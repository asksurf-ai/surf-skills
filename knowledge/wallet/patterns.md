# Wallet Data — Patterns & Gotchas

## When to Use

Use `wallet` for anything about a specific wallet address: balances, token holdings, transfer history, PnL, NFTs, and address labels.

## Common Gotchas

1. **`address` is a wallet/EOA address**, not a token contract — for token contracts use the `token` domain
2. **`/labels/batch` is POST** — pass `{"addresses": ["0x...", "0x..."]}` in the body
3. **`/tokens`, `/transfers`, `/nft` return large arrays** — always pass `limit`
4. **`/balance`** gives a cross-chain summary; use `/tokens` with `chain` for chain-specific holdings
5. **`/history`** returns raw transactions (not just token transfers) — can be very large

## Skill Boundaries

- Token holder lists, top traders -> `token`
- Spot prices, market data -> `market`
- Project fundamentals (TVL, team) -> `project`
- Social / X data -> `social`
- News -> `news`
- Raw SQL queries -> `onchain`
