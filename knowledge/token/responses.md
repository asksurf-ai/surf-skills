# Token Data — Response Formats

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

- `/info` returns a single object: name, symbol, decimals, total supply, chain, contract address
- `/holders` returns a paginated array of holder objects (address, balance, percentage)
- `/transfers` returns an array of transfer events (from, to, amount, timestamp, tx hash)
- `/top-traders` returns an array ranked by volume or PnL
- `/unlock` returns an array of unlock events with date, amount, and percentage of supply
- `/metrics` returns a time-series array; shape depends on the `metric` parameter
