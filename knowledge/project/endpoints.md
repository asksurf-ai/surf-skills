# Project Data — Endpoint Reference

<!-- Hermod /v1/project/* -->

## Endpoints

All endpoints are under `/v1/project/`.

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/search` | Search projects | `q`, `limit` |
| GET | `/top` | Top projects by metric | `metric` |
| GET | `/overview` | Project overview / summary | `id` |
| GET | `/token-info` | Token details for a project | `id` |
| GET | `/tokenomics` | Token supply & distribution | `id` |
| GET | `/funding` | Funding rounds & investors | `id` |
| GET | `/team` | Team members | `id` |
| GET | `/contracts` | Smart contract addresses | `id` |
| GET | `/social` | Social links & handles | `id` |
| GET | `/vc-portfolio` | VC portfolio (projects backed by this VC) | `id` |
| GET | `/listings` | Exchange listings | `id` |
| GET | `/events` | Project events (launches, upgrades, etc.) | `id`, `type` |
| GET | `/metrics` | On-chain & protocol metrics (TVL, revenue, etc.) | `id`, `metric`, `start`, `end`, `chain` |
| GET | `/tags` | Project tags / categories | `id` |

### Mindshare Group

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/mindshare` | Social mindshare score | `id`, `timeframe` |
| GET | `/mindshare/by-tag` | Mindshare broken down by tag | `id` |
| GET | `/mindshare/leaderboard` | Mindshare leaderboard | `id` |
| GET | `/mindshare/geo` | Mindshare by geography | `id` |
| GET | `/mindshare/lang` | Mindshare by language | `id` |

### Smart Followers Group

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/smart-followers` | Smart follower count & score | `id` |
| GET | `/smart-followers/history` | Smart follower history over time | `id` |
| GET | `/smart-followers/events` | Smart follower change events | `id` |
| GET | `/smart-followers/members` | List of smart follower accounts | `id` |

### Discover Group

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/discover` | Discovery feed of notable projects | -- |
| GET | `/discover/summary` | Discover summary for a project | `id` |
| GET | `/discover/fdv` | FDV-based discovery data | `id` |
| GET | `/discover/tweets` | Discovery-related tweets | `id` |

## Notes

- All endpoints return 1 credit cost unless otherwise documented
- `id` is the hermod project identifier (use `/search` to resolve names to IDs)
- `/metrics` supports time-range queries with `start`/`end` and optional `chain` filter
