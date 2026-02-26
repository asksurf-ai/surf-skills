# Token Data — Endpoint Reference

<!-- Hermod /v1/token/* -->

## Endpoints

All endpoints are under `/v1/token/`.

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/search` | Search tokens | `q` |
| GET | `/top` | Top tokens by metric | `metric` |
| GET | `/info` | Token metadata (name, symbol, decimals, etc.) | `address`, `chain` |
| GET | `/holders` | Token holder list | `address`, `chain`, `limit`, `offset` |
| GET | `/transfers` | Recent token transfers | `address`, `chain`, `limit`, `sort` |
| GET | `/top-traders` | Top traders for a token | `address` |
| GET | `/unlock` | Token unlock schedule | `address` |
| GET | `/metrics` | Token-level metrics (volume, liquidity, etc.) | `asset`, `metric`, `window`, `limit`, `exchange`, `type` |

## Notes

- `address` is the token contract address; `chain` specifies the network (e.g., `ethereum`, `solana`, `bsc`)
- `/holders` and `/transfers` can return large lists — always use `limit`
- `/metrics` shares a similar interface with `/market/market-indicator` but is scoped to token-level data
- `/unlock` returns scheduled unlock events with dates and amounts
