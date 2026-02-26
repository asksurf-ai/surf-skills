# News Data — Response Formats

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

- `/search` returns an array of news articles (title, source, url, published_at, snippet)
- `/ai` returns AI-summarized articles with sentiment and relevance scores
- `/ai/detail` returns a single article with full content
- `/feed` returns a chronological array of news items
