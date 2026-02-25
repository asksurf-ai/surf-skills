---
name: surf-token-data
description: Query token data including holders, transfers, exchange flows, and reserves
tools: ["bash"]
---

# Token Data — Token-level Analytics

Access token-level data including holder distribution, transfers, exchange inflow/outflow, ETF flows, and exchange reserves via the Hermod API Gateway.

## When to Use

Use this skill when you need to:
- Analyze token holder distribution
- Track token transfers
- Monitor exchange inflow/outflow patterns
- Check ETF flow data for a token
- View exchange reserve levels

## CLI Usage

```bash
# Check setup
skills/surf-token-data/scripts/surf-token --check-setup

# Get holder data
skills/surf-token-data/scripts/surf-token holder --symbol BTC

# Get transfer data
skills/surf-token-data/scripts/surf-token transfer --symbol BTC

# Get exchange flow data
skills/surf-token-data/scripts/surf-token exchange-flow --symbol BTC

# Get ETF flow data
skills/surf-token-data/scripts/surf-token etf-flow --symbol BTC

# Get exchange reserve data
skills/surf-token-data/scripts/surf-token exchange-reserve --symbol BTC
```

## Cost

1 credit per request.

## Endpoints Reference

See `references/endpoints.md` for full parameter details and response formats.
