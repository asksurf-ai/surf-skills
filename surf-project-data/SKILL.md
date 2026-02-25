---
name: surf-project-data
description: Query crypto project data including overview, TVL, revenue, fees, and user metrics
tools: ["bash"]
---

# Project Data — Crypto Project Analytics

Access comprehensive project-level data including overview, token info, funding, team, contracts, social links, volume, fees, revenue, TVL, and user metrics via the Hermod API Gateway.

Hermod routes project endpoints to two upstreams:
- **overview / token-info / funding / team / social / contract-address** → Muninn (use `--query`)
- **volume / fee / revenue / tvl / users** → Token Terminal (use `--project-id`)

## When to Use

Use this skill when you need to:
- Get project overview, token info, or social links
- Look up funding rounds, investors, and team members
- Get contract addresses across chains for a project
- Analyze volume, fees, revenue, TVL, and active users over time
- Compare protocol metrics across projects
- Search for a project by name to find its project-id
- Discover available Token Terminal projects and metrics
- Get project detail with available metric list

## CLI Usage

```bash
# Check setup
surf-project-data/scripts/surf-project --check-setup

# Get project overview (Muninn — use --query with project name)
surf-project-data/scripts/surf-project overview --query aave

# Get token info (Muninn)
surf-project-data/scripts/surf-project token-info --query uniswap

# Get funding data (Muninn)
surf-project-data/scripts/surf-project funding --query aave

# Get team info (Muninn)
surf-project-data/scripts/surf-project team --query aave

# Get contract addresses (Muninn)
surf-project-data/scripts/surf-project contract-address --query aave

# Get social links (Muninn)
surf-project-data/scripts/surf-project social --query aave

# Get volume data (Token Terminal — use --project-id)
surf-project-data/scripts/surf-project volume --project-id uniswap

# Get fee data (Token Terminal)
surf-project-data/scripts/surf-project fee --project-id uniswap

# Get revenue data (Token Terminal)
surf-project-data/scripts/surf-project revenue --project-id lido

# Get TVL data (Token Terminal)
surf-project-data/scripts/surf-project tvl --project-id aave

# Get user metrics (Token Terminal)
surf-project-data/scripts/surf-project users --project-id opensea

# Search for project (Muninn proxy — use to find project-id)
surf-project-data/scripts/surf-project search --query aave --limit 5

# Get multi-metric time series (Token Terminal proxy, 2 credits)
surf-project-data/scripts/surf-project tt-metrics --project-id aave --metrics revenue,tvl --start 2024-01-01 --end 2024-12-31

# Get metric rankings across projects (Token Terminal proxy, 2 credits)
surf-project-data/scripts/surf-project tt-ranking --metric tvl --project-ids aave,uniswap,lido

# List all Token Terminal projects — 1369 total, use --limit (2 credits, proxy)
surf-project-data/scripts/surf-project tt-projects --limit 20

# Get project detail with available metrics (2 credits, proxy)
surf-project-data/scripts/surf-project tt-project --project-id aave

# List all 194 available Token Terminal metrics (2 credits, proxy)
surf-project-data/scripts/surf-project tt-metrics-list
```

## Important Notes

- **Two parameter styles**: Muninn endpoints use `--query` (project name). Token Terminal endpoints use `--project-id` (slug).
- **Use `search` to find project-id** when you don't know the exact slug for Token Terminal endpoints.
- **Use `tt-projects` to discover project-ids** — lists all 1369 Token Terminal projects with their slugs.
- **Use `tt-metrics-list` to discover metrics** — lists all 194 available metric IDs (tvl, fees, revenue, etc.).
- **Use `tt-project` to check a project's available metrics** before querying `tt-metrics`.
- **tt-metrics** supports multiple metrics in one call: `--metrics revenue,tvl,fees`

## Cost

- Semantic endpoints (overview, tvl, revenue, etc.): 1 credit
- Proxy endpoints (search, tt-metrics, tt-ranking): 2 credits

## Endpoints Reference

See `references/endpoints.md` for full parameter details and response formats.
