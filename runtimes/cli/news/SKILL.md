---
name: surf-news
description: Search crypto news, get AI-powered summaries, and monitor breaking stories for market-moving events
tools: ["bash"]
---

# News Data — Search, AI Summaries & Signals

Search and monitor crypto news with semantic ranking, AI-generated summaries and signal analysis, and real-time feeds.

## Quick Reference

| Command | Description | Cost |
|---------|-------------|------|
| `search` | Semantic search across crypto news articles | 1 credit |
| `top` | Top news by recency or trending | 1 credit |
| `feed` | News feed, optionally filtered by project | 1 credit |
| `ai` | AI-analyzed news signals with sentiment and impact assessment | 1 credit |
| `ai-detail` | Detailed AI analysis of a specific news signal | 1 credit |

## Common Tasks

### Task: Research a topic in crypto news
Find relevant articles about a specific subject.
```bash
# Search for articles about Bitcoin ETFs
surf-news search --query "bitcoin ETF" --limit 5

# Search for articles about Ethereum upgrades
surf-news search --query "ethereum upgrade pectra" --limit 5

# Search for DeFi protocol news
surf-news search --query "aave lending protocol" --limit 5

# Narrow results for faster context
surf-news search --query "solana outage" --limit 3
```
**What to look for:** Check `published_at` timestamps to gauge recency. The `summary` field gives a quick overview without reading the full article. Multiple articles from different sources on the same topic signal high importance.

### Task: Monitor breaking and trending news
Stay on top of what's happening right now.
```bash
# Most recent news
surf-news top --metric recency --limit 10

# Trending news (most discussed/shared)
surf-news top --metric trending --limit 10

# General news feed
surf-news feed

# Project-specific feed
surf-news feed --id bitcoin
```
**Available metrics for top:** recency, trending

**What to look for:** Compare recency vs trending to distinguish new stories from stories gaining traction. Cluster of articles on the same topic = market-moving event. Check if trending stories have already been priced in by comparing timestamps with recent price moves.

### Task: Get AI-analyzed market signals
Get AI-curated news signals with sentiment analysis and impact assessment.
```bash
# Latest AI-analyzed signals
surf-news ai --limit 5

# AI signals for a specific project
surf-news ai --project-id bitcoin --limit 5

# Get detailed analysis of a specific signal
surf-news ai-detail --id ethereum
```
**What to look for:** AI signals include `tldr` bullet points, `signal_type`, source tweets/articles, and project associations. Use these to quickly assess whether a news event is bullish, bearish, or noise. The `sources` array links to original content for verification.

## Cross-Domain Workflows

### Event Impact Analysis
When a major news event breaks, assess its market impact.
```bash
# 1. Find the news
surf-news search --query "SEC crypto regulation" --limit 5

# 2. Check AI analysis for structured sentiment
surf-news ai --limit 5

# 3. See if the market has reacted (use surf-market)
surf-market price --ids bitcoin,ethereum --vs-currencies usd
surf-market top --metric fear_greed

# 4. Check derivatives for positioning shifts
surf-market futures --symbol BTC
surf-market liquidation --symbol BTC
```

### Project News Deep Dive
Research all recent news about a specific project.
```bash
# 1. Search for project-specific news
surf-news search --query "uniswap" --limit 5

# 2. Get AI-analyzed signals for the project
surf-news ai --project-id uniswap --limit 5

# 3. Check web for additional context (use surf-web)
surf-web search --query "uniswap v4 launch" --limit 3

# 4. Check price impact (use surf-market)
surf-market price --ids uniswap --vs-currencies usd
```

## Tips
- All output is JSON. Data goes to stdout, errors to stderr.
- Use `--limit` to control response size. Start with 3-5 results to save context window, increase if needed.
- Search uses semantic ranking, so natural language queries work well (e.g., "bitcoin ETF approval impact").
- The `--offset` parameter enables pagination for browsing through larger result sets.
- News `published_at` is a Unix timestamp. Compare with current time to assess freshness.
- Cross-reference news with price data to determine if events are already priced in.
- Run `--check-setup` to verify your API credentials before first use.
