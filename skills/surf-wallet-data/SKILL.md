---
name: surf-wallet-data
description: Query wallet data including balances, holdings, transaction history, and address labels
tools: ["bash"]
---

# Wallet Data — On-chain Wallet Analysis

Access wallet-level data including balances, token holdings, transfers, trading history, and address labels via the Hermod API Gateway.

## When to Use

Use this skill when you need to:
- Check wallet balance and token holdings
- View transfer and transaction history for an address
- Look up address labels (exchange, whale, smart money, etc.)
- Search for entities by name
- Batch query labels for multiple addresses

## CLI Usage

```bash
# Check setup
skills/surf-wallet-data/scripts/surf-wallet --check-setup

# Get wallet balance
skills/surf-wallet-data/scripts/surf-wallet balance --address 0x...

# List token holdings
skills/surf-wallet-data/scripts/surf-wallet token-list --address 0x...

# Get transfer history
skills/surf-wallet-data/scripts/surf-wallet transfer --address 0x...

# Get trading history
skills/surf-wallet-data/scripts/surf-wallet trading-history --address 0x...

# Get transaction history
skills/surf-wallet-data/scripts/surf-wallet transaction-history --address 0x...

# Look up address label
skills/surf-wallet-data/scripts/surf-wallet label --address 0x...

# Batch label lookup
skills/surf-wallet-data/scripts/surf-wallet label-batch --addresses '["0x...", "0x..."]'

# Search entity by name
skills/surf-wallet-data/scripts/surf-wallet entity-search --query "binance"
```

## Cost

1-2 credits per request.

## Endpoints Reference

See `references/endpoints.md` for full parameter details and response formats.
