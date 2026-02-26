# Web Data — Endpoint Reference

<!-- Hermod /v1/web/* -->

## Endpoints

All endpoints are under `/v1/web/`.

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/search` | Web search | `q`, `limit`, `site` |
| POST | `/fetch` | Fetch a web page | body: `{"url": "..."}` |

## Notes

- `/search` performs a web search; `site` can restrict results to a specific domain (e.g., `site=coingecko.com`)
- `/fetch` is POST — pass the target URL in the request body
- `/fetch` returns the page content (typically extracted/cleaned text, not raw HTML)
