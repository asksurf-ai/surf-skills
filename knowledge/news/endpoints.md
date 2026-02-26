# News Data — Endpoint Reference

<!-- Hermod /v1/news/* -->

## Endpoints

All endpoints are under `/v1/news/`.

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/search` | Search news articles | `q`, `limit`, `offset` |
| GET | `/top` | Top news by metric | `metric` |
| GET | `/ai` | AI-curated news for a project | `project_id`, `limit`, `offset` |
| GET | `/ai/detail` | Full detail of an AI news item | `id` |
| GET | `/feed` | News feed | `id` |

## Notes

- `/search` supports pagination via `limit` and `offset`
- `/ai` returns AI-processed/summarized news tied to a specific project
- `/ai/detail` returns the full article content for a single AI news item
- `/feed` returns a general or project-specific news feed
