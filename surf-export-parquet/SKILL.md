---
name: surf-export-parquet
description: Export database query results to Parquet format. Use when user needs to export data from staging/production databases as Parquet files for analytics or data engineering.
allowed-tools:
  - Bash
  - Read
---

# Parquet Export Skill

Export database query results to Parquet files via DuckDB. Uses the same SSH tunnel and config as `surf-db-debug`.

## First-Time Setup Check

```bash
uv run --script ~/.claude/skills/surf-export-parquet/scripts/surf-db-export-parquet --check-setup
```

Requires:
- `uv` (Python package runner)
- `surf-db-debug` configured (`~/.config/surf-db/config.json`)
- DuckDB is auto-installed by `uv run` on first use

## Usage

### Via surf-db-query (recommended — handles tunnel automatically)

```bash
# Export to parquet (auto-generated filename in /tmp/surf-export/)
~/.claude/skills/surf-db-debug/scripts/surf-db-query --env stg --sql "SELECT * FROM users LIMIT 1000" --format parquet

# Export to specific file
~/.claude/skills/surf-db-debug/scripts/surf-db-query --env stg --sql "SELECT * FROM users LIMIT 1000" --format parquet --output /tmp/users.parquet

# Production read-only export
~/.claude/skills/surf-db-debug/scripts/surf-db-query --env prd:odin-ro --sql "SELECT id, name FROM accounts" --format parquet --output /tmp/accounts.parquet
```

### Direct invocation (when tunnel is already running)

```bash
# Using environment config
uv run --script ~/.claude/skills/surf-export-parquet/scripts/surf-db-export-parquet \
    --env stg --sql "SELECT * FROM users LIMIT 1000" --output /tmp/users.parquet

# Using explicit connection params
uv run --script ~/.claude/skills/surf-export-parquet/scripts/surf-db-export-parquet \
    --host localhost --port 15432 --user readonly --password secret \
    --dbname myapp --sql "SELECT * FROM users" --output /tmp/users.parquet
```

### Reading the exported file

```bash
# With DuckDB
python3 -c "import duckdb; print(duckdb.sql(\"SELECT * FROM '/tmp/users.parquet' LIMIT 5\"))"

# With pandas
python3 -c "import pandas as pd; print(pd.read_parquet('/tmp/users.parquet').head())"
```

## Safety Rules

- **Read-only**: Only SELECT queries are allowed. Write operations (INSERT, UPDATE, DELETE, etc.) are rejected.
- Same safety model as `surf-db-debug` — no data modification.

## How It Works

1. Connects to Postgres/MySQL through the existing SSH tunnel (localhost port)
2. DuckDB's `postgres_scanner` extension reads data directly from the database
3. Writes native Parquet with full type preservation (no intermediate CSV)
