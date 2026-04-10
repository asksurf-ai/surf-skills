# Surf Credit Pricing

Each Surf API call costs credits. The cost depends on the endpoint's data source complexity.

**Studio and Enterprise API keys are charged the same rate** (as of hermod v0.1.55).

## Data API Credits

| Tier | Credits | Endpoints |
|------|---------|-----------|
| **Light** | 1 cr | social, news, web, fund, exchange, project (search/events/detail), search-airdrop |
| **Standard** | 2 cr | market (price/futures/options/etf/indicators/liquidation/top), token (holders/transfers), wallet (detail/transfers/history/protocols/net-worth/chains), project (metrics/top), onchain (tx) |
| **Heavy** | 4 cr | wallet (search/label-batch/approvals), token (dex-trades), onchain (bridge-ranking/yield-ranking/query/sql/schema), polymarket, prediction-market, kalshi, matching-market, PM intelligence |
| **Free** | 0 cr | database operations (billed separately by compute time) |

**Special cases** (1 cr instead of their tier default):
- `market-fear-greed` — 1 cr (not 2)
- `token-tokenomics` — 1 cr (not 2)
- `onchain-gas-price` — 1 cr (not 2)

### Full Endpoint Breakdown

#### Light (1 cr)

| Domain | Endpoints |
|--------|-----------|
| Social | search, tweets, user, user-posts, mindshare, mindshare-top, detail, smart-follower-history, search-people, user-following, user-followers, user-replies, tweet-replies |
| News | search, feed, ai-detail |
| Web | search, fetch |
| Fund | detail, portfolio, search, ranking |
| Exchange | markets, price, depth, klines, perp, funding-history, long-short-ratio |
| Project | search, events, detail |
| Search | airdrop |

#### Standard (2 cr)

| Domain | Endpoints |
|--------|-----------|
| Market | price, futures, options, etf, price-indicator, onchain-indicator, top, liquidation-chart, liquidation-exchange-list, liquidation-order |
| Token | holders, transfers |
| Wallet | detail, transfers, history, protocols, net-worth, chains |
| Project | metrics, top |
| Onchain | tx |

#### Heavy (4 cr)

| Domain | Endpoints |
|--------|-----------|
| Wallet | search, label-batch, approvals |
| Token | dex-trades |
| Onchain | bridge-ranking, yield-ranking, query, sql, schema |
| Polymarket | markets, events, trades, positions, prices, volumes, open-interest, ranking, search, detail, activity, smart-money, whale-trades, leaderboard |
| Prediction Market | category-metrics, detail, markets, ranking, trades, price-history, open-interest, search, discover, dashboard, momentum, correlations, spreads |
| Kalshi | markets, events, search, trades, prices, volumes, open-interest, ranking, detail |
| Matching Market | pairs, find, daily |
| PM Real-Time | exchanges, markets, orderbook, candles, recent-trades |

#### Free (0 cr)

| Domain | Endpoints |
|--------|-----------|
| Database | provision, query, tables, table-schema, status, reset-dev, sync-schema, schema-diff |

> Database operations are free per-request but billed by compute time (CU-hour).

## Chat API Credits

| Model | Credits |
|-------|---------|
| surf-ask | 1 |
| surf-1.5-instant | 2 |
| surf-1.5-low | 3 |
| surf-1.5-medium | 5 |
| surf-research | 10 |
| surf-1.5-high | 12 |

## Free Tier

Anonymous users (no API key) get **30 free credits per day**.

## Checking Credit Usage

Each response includes `meta.credits_used`:

```bash
surf market-price --symbol BTC -o json -f body.meta
# → { "credits_used": 2, "cached": false }
```

## Subscription Plans

| Plan | Price (monthly) | Price (yearly) |
|------|----------------|----------------|
| PLUS | $19 | $108 |
| PRO | $29 | $348 |

### MAX Tiers ($1 = 30 credits)

| Tier | Monthly | Credits/month |
|------|---------|---------------|
| MAX 1 | $100 | 3,000 |
| MAX 2 | $200 | 6,000 |
| MAX 3 | $300 | 9,000 |
| MAX 4 | $400 | 12,000 |
| MAX 5 | $600 | 18,000 |
| MAX 6 | $800 | 24,000 |
| MAX 7 | $1,000 | 30,000 |

### Booster Packs (add-on, expires in 90 days)

| Pack | Credits | Price |
|------|---------|-------|
| Small | 400 | $20 |
| Medium | 1,000 | $45 |
| Large | 3,000 | $130 |
