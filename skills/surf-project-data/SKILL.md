---
name: surf-project-data
description: Query crypto project data including overview, TVL, revenue, fees, and user metrics
tools: ["bash"]
---

# Project Data — Crypto Project Analytics

Access comprehensive project-level data including overview, token info, funding, team, contracts, social links, volume, fees, revenue, TVL, and user metrics via the Hermod API Gateway.

## When to Use

Use this skill when you need to:
- Get project overview and metadata
- Check token information for a project
- Look up funding rounds and investors
- Find team members
- Get contract addresses across chains
- View social media links
- Analyze volume, fees, revenue, TVL, and user metrics

## CLI Usage

```bash
# Check setup
skills/surf-project-data/scripts/surf-project --check-setup

# Get project overview
skills/surf-project-data/scripts/surf-project overview --project uniswap

# Get token info
skills/surf-project-data/scripts/surf-project token-info --project uniswap

# Get funding data
skills/surf-project-data/scripts/surf-project funding --project uniswap

# Get team info
skills/surf-project-data/scripts/surf-project team --project uniswap

# Get contract addresses
skills/surf-project-data/scripts/surf-project contract-address --project uniswap

# Get social links
skills/surf-project-data/scripts/surf-project social --project uniswap

# Get volume data
skills/surf-project-data/scripts/surf-project volume --project uniswap

# Get fee data
skills/surf-project-data/scripts/surf-project fee --project uniswap

# Get revenue data
skills/surf-project-data/scripts/surf-project revenue --project uniswap

# Get TVL data
skills/surf-project-data/scripts/surf-project tvl --project uniswap

# Get user metrics
skills/surf-project-data/scripts/surf-project users --project uniswap
```

## Cost

1 credit per request.

## Endpoints Reference

See `references/endpoints.md` for full parameter details and response formats.
