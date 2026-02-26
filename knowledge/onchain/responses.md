# Onchain Data — Response Formats

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

- `/tx` returns a single transaction object (hash, from, to, value, gas, status, block, timestamp)
- `/query` returns query results in a tabular format (columns + rows)
- `/sql` returns ClickHouse results: `{"columns": [...], "rows": [[...], ...], "row_count": N}`
- `/sql` errors include ClickHouse error messages — check SQL syntax if you get parse errors
