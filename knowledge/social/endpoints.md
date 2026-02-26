# Social Data — Endpoint Reference

<!-- Hermod /v1/social/* -->

## Endpoints

All endpoints are under `/v1/social/`.

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/search` | Search social users | `q`, `limit` |
| GET | `/user/{handle}` | User profile | `handle` (path) |
| GET | `/user/{handle}/posts` | User's recent posts | `handle` (path), `limit` |
| GET | `/user/{handle}/related` | Related / similar accounts | `handle` (path) |
| POST | `/tweets` | Batch fetch tweets by IDs | body: `{"ids": [...]}` |
| GET | `/sentiment` | Sentiment analysis for a query | `q` |
| GET | `/follower-geo` | Follower geography distribution | `handle` |
| GET | `/top` | Top social accounts by metric | `metric` |

## Notes

- `handle` is the X/Twitter handle without the `@` prefix
- `/tweets` is a POST endpoint — pass tweet IDs in the request body
- `/user/{handle}/posts` supports `limit` to control response size
