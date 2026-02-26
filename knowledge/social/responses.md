# Social Data — Response Formats

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

- `/user/{handle}` returns a single profile object (follower count, bio, verified status, etc.)
- `/user/{handle}/posts` returns an array of post objects — use `limit` to control size
- `/tweets` returns an array matching the requested IDs (order may differ)
- `/sentiment` returns aggregated sentiment scores (positive, negative, neutral ratios)
- `/follower-geo` returns a breakdown by country/region
