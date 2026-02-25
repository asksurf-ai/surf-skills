# Project Data — Endpoint Reference

## Semantic Endpoints

Base path: `/gateway/v1/project`. Cost: 1 credit each.

### GET /overview
Get project overview. Params: `project` (required, slug e.g. uniswap, aave, lido).

### GET /token-info
Get token information. Params: `project` (required).

### GET /funding
Get funding rounds & investors. Params: `project` (required).

### GET /team
Get team members. Params: `project` (required).

### GET /contract-address
Get contract addresses across chains. Params: `project` (required).

### GET /social
Get social media links. Params: `project` (required).

### GET /volume
Get trading volume. Params: `project` (required), `interval` (optional).

### GET /fee
Get protocol fees. Params: `project` (required), `interval` (optional).

### GET /revenue
Get protocol revenue. Params: `project` (required), `interval` (optional).

### GET /tvl
Get Total Value Locked. Params: `project` (required), `interval` (optional).

### GET /users
Get active user metrics. Params: `project` (required), `interval` (optional).

---

## Proxy Endpoints (Advanced)

### Muninn — Project Search & Disambiguation (1 credit)

```bash
# Search by project name, ticker, or contract address
GET /gateway/v1/proxy/muninn/v1/agents/search?query={QUERY}&limit=5
```

Response includes: project name, description, tags, token info (symbol, contract addresses, market data), funding rounds, team, twitter.

### Token Terminal — Protocol Financial Metrics (2 credits)

Rate limit: 1,000 req/min.

```bash
# List all projects
GET /gateway/v1/proxy/tt/v2/projects

# Project details & metric availability
GET /gateway/v1/proxy/tt/v2/projects/{PROJECT_ID}

# Project metrics (time series)
GET /gateway/v1/proxy/tt/v2/projects/{PROJECT_ID}/metrics?metric_ids=revenue,tvl&start=2025-01-01&end=2025-12-31&chain_ids=ethereum,base

# Cross-project rankings by metric
GET /gateway/v1/proxy/tt/v2/metrics/tvl
GET /gateway/v1/proxy/tt/v2/metrics/revenue
GET /gateway/v1/proxy/tt/v2/metrics/{METRIC_ID}?project_ids=aave,uniswap,compound

# List all available metrics
GET /gateway/v1/proxy/tt/v2/metrics

# Chain ecosystem metrics
GET /gateway/v1/proxy/tt/v2/projects/ethereum/metrics?metric_ids=ecosystem_tvl,ecosystem_fees,ecosystem_dex_trading_volume
```

Common metric IDs: `revenue`, `fees`, `tvl`, `active_users`, `user_dau`, `market_cap`, `market_cap_fully_diluted`, `price`

Response:
```json
{
  "data": [
    {
      "metric_id": "tvl",
      "project_id": "aave",
      "timestamp": "2026-02-04T00:00:00.000Z",
      "value": 50400000000.0
    }
  ]
}
```

### CoinGecko — Market Data & Trending (2 credits)

```bash
# Simple price lookup
GET /gateway/v1/proxy/coingecko/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=usd&include_24hr_change=true

# Trending tokens
GET /gateway/v1/proxy/coingecko/api/v3/search/trending

# Global market data
GET /gateway/v1/proxy/coingecko/api/v3/global
```
