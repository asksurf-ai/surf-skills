# Onchain Data — Endpoint Reference

<!-- Hermod /v1/onchain/* -->

## Endpoints

All endpoints are under `/v1/onchain/`.

| Method | Endpoint | Description | Key Params |
|--------|----------|-------------|------------|
| GET | `/tx` | Look up a transaction by hash | `hash`, `chain` |
| POST | `/query` | Structured on-chain query | body: structured query object |
| POST | `/sql` | Raw SQL query (ClickHouse) | body: `{"sql": "...", "max_rows": N}` |

## Notes

- `/tx` is a simple GET for transaction details by hash and chain
- `/query` accepts a structured query object (not raw SQL) — useful for pre-built query templates
- `/sql` executes raw ClickHouse SQL against on-chain data tables — most flexible but highest credit cost
- `/sql` supports `max_rows` to cap result size (important for large queries)
