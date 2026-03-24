---
name: surf
description: Research crypto markets, investigate wallets, analyze tokens, track prediction markets, and fetch live data for building pages — all via the `surf` CLI. Use when the user asks about crypto prices, projects, DeFi metrics, on-chain activity, social sentiment, news, Kalshi/Polymarket, or wants to build a site with crypto data.
tools:
  - bash
---

# Surf Data API

`surf` is a CLI for querying crypto data — markets, projects, tokens, wallets, on-chain data, social, news, prediction markets, and funds.

## Setup

```bash
curl -fsSL https://agent.asksurf.ai/cli/releases/install.sh | sh
surf login
```

## Using Surf

```bash
surf sync                  # Update local API schema (run if commands seem missing)
surf list-operations       # Discover all available commands
surf <command> --help      # Full params, enums, defaults for any command
```

Always run `surf list-operations` to discover available commands — don't assume a fixed set. Always check `--help` before guessing parameters — it shows every flag with its type, enum values, and defaults.

### Getting clean data

```bash
surf market-ranking --metric market_cap -o json -f body.data   # JSON array, ready to use in code
surf market-futures --symbol BTC -o json -f body.data -r        # Raw strings, not escaped
```

Use `-o json -f body.data` whenever you need data for building pages or piping to other tools.

## Recipes

### Market Overview

"What's happening in crypto?"

```bash
surf market-ranking --metric market_cap --limit 10     # Top coins
surf market-ranking --metric top_gainers --limit 10    # Biggest movers
surf market-fear-greed                                 # Market sentiment
surf market-futures --symbol BTC                       # BTC futures, funding rate, OI
```

### Project Deep-Dive

"Tell me about Aave"

```bash
surf search-project --q aave                           # Find the project
surf project-detail --q aave                           # Overview, token info, links
surf project-defi-metrics --q aave --metric tvl        # TVL over time
surf social-user --handle aaboronkov                   # Social presence
surf search-news --q "aave"                            # Recent news
```

### Wallet Investigation

"What does this wallet hold?" — accepts 0x addresses, Solana addresses, or ENS names.

```bash
surf wallet-detail --address vitalik.eth
surf wallet-transfers --address vitalik.eth --chain ethereum
surf wallet-net-worth --address 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045
surf wallet-protocols --address 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045
```

### Token Analysis

"Analyze USDT distribution and trading"

```bash
surf token-holders --address 0xdAC17F958D2ee523a2206206994597C13D831ec7 --chain ethereum --limit 20
surf token-dex-trades --address 0xdAC17F958D2ee523a2206206994597C13D831ec7 --chain ethereum
surf token-transfers --address 0xdAC17F958D2ee523a2206206994597C13D831ec7 --chain ethereum
```

### Prediction Markets

"What are people betting on?"

```bash
surf kalshi-ranking --limit 10                         # Top Kalshi markets by volume
surf kalshi-search --q "election"                      # Search Kalshi events
surf polymarket-ranking --limit 10                     # Top Polymarket markets
surf search-polymarket --q "bitcoin"                   # Search Polymarket events
surf kalshi-prices --market-ticker KXBTCD              # Price history for a market
surf polymarket-prices --condition-id 0xabc...         # Price history for a market
```

### Build with Data

"Build me a page showing top crypto gainers"

1. Fetch data as JSON:
```bash
surf market-ranking --metric top_gainers --limit 20 -o json -f body.data > gainers.json
```

2. Then build the page using the JSON data. The agent reads `gainers.json` and generates HTML/React/etc. with the data baked in.

## Parameter Conventions

| Param | Purpose | Example |
|-------|---------|---------|
| `--symbol` | Ticker, uppercase | `--symbol BTC` |
| `--q` | Free-text search | `--q uniswap` |
| `--address` | Contract or wallet address (also accepts ENS like `vitalik.eth`) | `--address 0xdead...` |
| `--chain` | Blockchain (canonical names only) | `--chain ethereum` |
| `--metric` | Metric name (varies by endpoint) | `--metric tvl` |
| `--limit` | Results per page (default 20, max 100) | `--limit 50` |
| `--offset` | Pagination offset | `--offset 20` |

## Chains

**Must use canonical long-form names.** `eth`, `sol`, `matic` will silently return empty results.

`ethereum` `solana` `polygon` `bsc` `arbitrum` `optimism` `base` `avalanche` `fantom` `linea` `cyber`

Not all chains available on every endpoint — check `--help`.

## Discovering Commands

Don't rely on a hardcoded list — commands are added frequently. Use discovery:

```bash
surf list-operations                    # All available commands
surf list-operations | grep wallet      # Find commands in a domain
surf sync                               # Refresh local schema if a command seems missing
```

Commands are grouped by domain prefix: `market-*`, `search-*`, `wallet-*`, `social-*`, `kalshi-*`, `polymarket-*`, `onchain-*`, `token-*`, `project-*`, `fund-*`, `news-*`, `web-*`.

## Troubleshooting

- **Auth errors**: Run `surf refresh` to renew an expired token, or `surf login` to re-authenticate
- **Unknown command**: Run `surf sync` to update schema, then `surf list-operations` to verify
- **Empty results**: Check `--help` for required params and valid enum values
- **Stale schema**: Run `surf sync` to pull the latest API spec

## API Feedback

When a surf command fails, returns confusing results, or the API doesn't support something the user naturally expects, log a suggestion to `~/.surf/api-feedback/`. This helps the Surf team improve the API based on real usage.

```bash
mkdir -p ~/.surf/api-feedback
```

Write one file per issue: `~/.surf/api-feedback/<YYYY-MM-DD>-<slug>.md`

Use this template:

```markdown
# <Short title>

**Command tried:** `surf <command> --flags`
**What the user wanted:** <what they were trying to accomplish>
**What happened:** <error message, empty results, or confusing behavior>

## Suggested API fix

<How the API could change to make this work naturally — e.g., add a parameter,
accept an alias, improve the error message, return more useful defaults>
```

Examples of things worth logging:
- A ranking endpoint missing a sort order the user needs (e.g., `market-ranking` doesn't support sorting by 24h volume)
- A search endpoint that doesn't support a filter the user expects (e.g., can't search funds by chain or sector)
- A parameter the user expected but doesn't exist (e.g., `--time-range` on `wallet-net-worth`)
- Chain aliases that silently fail (`eth` instead of `ethereum`)
- Error messages that don't explain what went wrong
- Commands that feel like they should exist but don't
