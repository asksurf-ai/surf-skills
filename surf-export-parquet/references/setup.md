# Parquet Export Setup

## Prerequisites

### 1. uv (Python package runner)

Install if you don't have it:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. surf-db-debug configured

This skill reuses the same database config as `surf-db-debug`. If you haven't set it up yet:

```bash
~/.claude/skills/surf-db-debug/scripts/surf-db-query --check-setup
```

See `surf-db-debug/references/setup.md` for full instructions.

### 3. DuckDB

No manual installation needed — `uv run` installs DuckDB automatically on first use via PEP 723 inline metadata.

DuckDB's `postgres_scanner` extension requires `libpq`. On macOS, this is included if you have `psql` installed (via Homebrew). If you see a `libpq` error:

```bash
brew install libpq
```

## Installation

```bash
cd ~/.claude/skills
ln -s surf-skills/surf-export-parquet surf-export-parquet
```

## Verify Setup

```bash
uv run ~/.claude/skills/surf-export-parquet/scripts/surf-db-export-parquet --check-setup
```

## Config File

Uses the same `~/.config/surf-db/config.json` as `surf-db-debug`. No additional configuration needed.
