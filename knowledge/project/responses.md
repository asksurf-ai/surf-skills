# Project Data — Response Formats

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

- `/overview` returns a single object with project name, description, category, links, and key stats
- `/metrics` returns a time-series array; the shape varies by `metric` value (e.g., TVL, revenue, fees, active users)
- `/funding` returns an array of funding rounds, each with date, amount, round type, and investors
- `/smart-followers/members` returns a paginated list — may be large
- `/discover` returns a feed array — response size varies
