# Wallet Data — Endpoint Reference

<!-- Hermod /v1/wallet/* -->

## Endpoints

All endpoints are under `/v1/wallet/`.

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/search` | Search wallets / addresses | `q` |
| GET | `/top` | Top wallets by metric | `metric` |
| GET | `/balance` | Native balance summary | `address` |
| GET | `/tokens` | Token holdings for a wallet | `address`, `chain` |
| GET | `/transfers` | Transfer history | `address`, `chain`, `limit` |
| GET | `/history` | Transaction history | `address`, `chain` |
| GET | `/labels` | Labels / tags for an address | `address` |
| POST | `/labels/batch` | Batch label lookup | body: `{"addresses": [...]}` |
| GET | `/pnl` | Realized & unrealized PnL | `address` |
| GET | `/nft` | NFT holdings | `address`, `chain`, `limit` |

## Notes

- `address` is a wallet/EOA address, not a token contract
- `/labels/batch` is POST — pass addresses in the request body
- `/tokens`, `/transfers`, `/history`, and `/nft` can return large lists — use `limit`
- `/balance` returns a cross-chain summary; `/tokens` is chain-specific
