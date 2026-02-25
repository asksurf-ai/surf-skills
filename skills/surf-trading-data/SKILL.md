---
name: surf-trading-data
description: Query crypto trading data including prices, futures, options, liquidations, and market indicators
tools: ["bash"]
---

# Trading Data — Crypto Market Data

Access real-time and historical crypto trading data via the Hermod API Gateway. Covers prices, futures, options, liquidations, technical indicators, ETFs, and volume.

## When to Use

Use this skill when you need to:
- Get current or historical crypto prices
- Check futures and options market data
- Monitor liquidation events
- Calculate technical indicators (RSI, MACD, etc.)
- Track ETF flow data
- Analyze market-wide indicators and volume

## CLI Usage

```bash
# Check setup
skills/surf-trading-data/scripts/surf-trading --check-setup

# Get price data
skills/surf-trading-data/scripts/surf-trading price --symbol BTC --interval 1d

# Get futures data
skills/surf-trading-data/scripts/surf-trading future --symbol BTC

# Get options data
skills/surf-trading-data/scripts/surf-trading option --symbol BTC

# Get liquidation data
skills/surf-trading-data/scripts/surf-trading liquidation --symbol BTC

# Get technical indicator
skills/surf-trading-data/scripts/surf-trading indicator --symbol BTC --indicator rsi --interval 1d

# Get market-wide indicator
skills/surf-trading-data/scripts/surf-trading market-indicator --indicator fear-greed

# Get ETF data
skills/surf-trading-data/scripts/surf-trading etf --symbol BTC

# Get volume data
skills/surf-trading-data/scripts/surf-trading volume --symbol BTC
```

## Cost

1 credit per request.

## Endpoints Reference

See `references/endpoints.md` for full parameter details and response formats.
