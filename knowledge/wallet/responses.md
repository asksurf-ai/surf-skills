# Wallet Data — Response Formats

## Unified Response Envelope

All hermod responses use the same envelope:

**Success:**
```json
{
  "data": T,
  "meta": {
    "credits": N
  }
}
```

**Error:**
```json
{
  "error": {
    "code": "...",
    "message": "..."
  }
}
```

## Domain-Specific Notes

- `/balance` returns a summary object with native balances across chains
- `/tokens` returns an array of token holdings (symbol, balance, value, chain)
- `/transfers` returns an array of transfer events with direction (in/out)
- `/labels` returns known labels for an address (e.g., "Binance Hot Wallet", "Vitalik")
- `/labels/batch` returns a map of address -> labels
- `/pnl` returns realized and unrealized profit/loss figures
- `/nft` returns an array of NFT holdings with collection, token ID, and estimated value
