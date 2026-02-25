# Trading Data — Endpoint Reference

## Semantic Endpoints

Base path: `/gateway/v1/trading-data`. Cost: 1 credit each.

### GET /price
Get price data. Params: `symbol` (required), `interval` (optional: 1h, 4h, 1d, 1w).

### GET /future
Get futures data. Params: `symbol` (required).

### GET /option
Get options data. Params: `symbol` (required).

### GET /liquidation
Get liquidation data. Params: `symbol` (required).

### GET /indicator
Get technical indicator. Params: `symbol` (required), `indicator` (required: rsi, macd, ema, sma, bbands), `interval` (optional).

### GET /market-indicator
Get market-wide indicator. Params: `indicator` (required: fear-greed, dominance).

### GET /etf
Get ETF data. Params: `symbol` (required: BTC, ETH).

### GET /volume
Get volume data. Params: `symbol` (required).

---

## Proxy Endpoints (Advanced)

For more granular data, use the proxy routes at `/gateway/v1/proxy/{service}/...`. These call upstream APIs directly through Hermod with automatic API key injection.

### CoinGecko — Price & Market Data (2 credits)

```bash
# Simple price lookup (multi-token)
GET /gateway/v1/proxy/coingecko/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=usd&include_24hr_change=true

# OHLCV candles
GET /gateway/v1/proxy/coingecko/api/v3/coins/bitcoin/ohlc?vs_currency=usd&days=30

# Trending tokens
GET /gateway/v1/proxy/coingecko/api/v3/search/trending

# Global market data
GET /gateway/v1/proxy/coingecko/api/v3/global
```

### CoinGlass — Derivatives & Futures (3 credits)

```bash
# Open Interest
GET /gateway/v1/proxy/coinglass/api/futures/openInterest/chart?symbol=BTC&interval=1d&limit=30

# Funding Rates
GET /gateway/v1/proxy/coinglass/api/futures/fundingRate?symbol=BTC&exchange=binance

# Long/Short Ratio
GET /gateway/v1/proxy/coinglass/api/futures/longShortRatio?symbol=BTC

# Liquidations
GET /gateway/v1/proxy/coinglass/api/futures/liquidation?symbol=BTC&timeRange=1d
```

### TAAPI — Technical Indicators (2 credits)

200+ indicators available. Common ones:

```bash
# RSI
GET /gateway/v1/proxy/taapi/indicator/rsi?exchange=binance&symbol=BTC/USDT&interval=1d

# MACD
GET /gateway/v1/proxy/taapi/indicator/macd?exchange=binance&symbol=BTC/USDT&interval=1h

# Bollinger Bands
GET /gateway/v1/proxy/taapi/indicator/bbands?exchange=binance&symbol=BTC/USDT&interval=4h
```

Params: `exchange` (binance), `symbol` (BTC/USDT format), `interval` (1m, 5m, 15m, 1h, 4h, 1d, 1w, 1mo).

### SosoValue — ETF Flows (2 credits)

```bash
# BTC spot ETF flows
GET /gateway/v1/proxy/sosovalue/api/v1/etf/bitcoin-spot?date=2026-02-18

# ETH spot ETF flows
GET /gateway/v1/proxy/sosovalue/api/v1/etf/ethereum-spot?date=2026-02-18
```

### CryptoQuant — On-Chain Metrics (3 credits)

```bash
# Exchange Flows Netflow
GET /gateway/v1/proxy/cryptoquant/v1/btc/exchange-flows/netflow?window=day&limit=30

# Miner Revenue
GET /gateway/v1/proxy/cryptoquant/v1/btc/miner-revenue?window=day

# SOPR (Spent Output Profit Ratio)
GET /gateway/v1/proxy/cryptoquant/v1/btc/sopr?window=day

# NUPL (Net Unrealized Profit/Loss)
GET /gateway/v1/proxy/cryptoquant/v1/btc/nupl?window=day
```
