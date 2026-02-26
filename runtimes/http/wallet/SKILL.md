---
name: wallet
description: >
  Query wallet data: balances, token holdings, transfer history, transaction history,
  address labels, PnL, and NFT holdings.
  Keywords: wallet, address, balance, holdings, transfers, PnL, NFT, labels, portfolio.
---

# Wallet Data

## API Access

All endpoints: `${{BASE_URL_VAR}}/wallet/{endpoint}`

{{AUTH_NOTE}}

## Quick Examples

```bash
curl -s "${{BASE_URL_VAR}}/wallet/search?q=vitalik"
curl -s "${{BASE_URL_VAR}}/wallet/balance?address=0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"
curl -s "${{BASE_URL_VAR}}/wallet/tokens?address=0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045&chain=ethereum"
curl -s "${{BASE_URL_VAR}}/wallet/transfers?address=0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045&chain=ethereum&limit=20"
curl -s "${{BASE_URL_VAR}}/wallet/labels?address=0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"
curl -s -X POST "${{BASE_URL_VAR}}/wallet/labels/batch" -H 'Content-Type: application/json' -d '{"addresses":["0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"]}'
curl -s "${{BASE_URL_VAR}}/wallet/pnl?address=0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"
curl -s "${{BASE_URL_VAR}}/wallet/nft?address=0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045&chain=ethereum&limit=10"
```

## When NOT to Use

- Token holder lists, top traders -> `token`
- Market prices, indicators -> `market`
- Project fundamentals (TVL, team) -> `project`
- Social / X data -> `social`

## Knowledge
