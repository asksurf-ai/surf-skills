---
name: project
description: >
  Query project data: overview, tokenomics, funding, team, contracts, listings,
  protocol metrics (TVL, revenue, fees), mindshare, smart followers, and discovery.
  Keywords: project, TVL, revenue, fees, funding, team, tokenomics, mindshare, smart followers, VC, discover.
---

# Project Data

## API Access

All endpoints: `${{BASE_URL_VAR}}/project/{endpoint}`

{{AUTH_NOTE}}

## Quick Examples

```bash
curl -s "${{BASE_URL_VAR}}/project/search?q=uniswap&limit=5"
curl -s "${{BASE_URL_VAR}}/project/overview?id=uniswap"
curl -s "${{BASE_URL_VAR}}/project/metrics?id=uniswap&metric=tvl&start=2024-01-01&end=2024-12-31"
curl -s "${{BASE_URL_VAR}}/project/funding?id=uniswap"
curl -s "${{BASE_URL_VAR}}/project/tokenomics?id=uniswap"
curl -s "${{BASE_URL_VAR}}/project/mindshare?id=uniswap&timeframe=7d"
curl -s "${{BASE_URL_VAR}}/project/smart-followers?id=uniswap"
curl -s "${{BASE_URL_VAR}}/project/discover"
```

## When NOT to Use

- Spot prices, futures, indicators -> `market`
- Token holders, transfers -> `token`
- Wallet balances, PnL -> `wallet`
- Raw tweets, user profiles -> `social`
- News articles -> `news`

## Knowledge
