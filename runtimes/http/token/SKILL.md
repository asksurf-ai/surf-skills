---
name: token
description: >
  Query token data: holders, transfers, top traders, unlock schedules,
  token metadata, and token-level metrics by contract address.
  Keywords: token, holders, transfers, unlock, top traders, contract, address, chain.
---

# Token Data

## API Access

All endpoints: `${{BASE_URL_VAR}}/token/{endpoint}`

{{AUTH_NOTE}}

## Quick Examples

```bash
curl -s "${{BASE_URL_VAR}}/token/search?q=USDC"
curl -s "${{BASE_URL_VAR}}/token/info?address=0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48&chain=ethereum"
curl -s "${{BASE_URL_VAR}}/token/holders?address=0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48&chain=ethereum&limit=20"
curl -s "${{BASE_URL_VAR}}/token/transfers?address=0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48&chain=ethereum&limit=20"
curl -s "${{BASE_URL_VAR}}/token/top-traders?address=0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
curl -s "${{BASE_URL_VAR}}/token/unlock?address=0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
curl -s "${{BASE_URL_VAR}}/token/metrics?asset=BTC&metric=exchange_netflow&window=day&limit=30"
```

## When NOT to Use

- Spot prices, futures, indicators -> `market`
- Wallet balances, PnL -> `wallet`
- Project fundamentals (TVL, team, funding) -> `project`
- Social / X data -> `social`

## Knowledge
