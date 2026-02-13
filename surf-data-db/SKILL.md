---
name: surf-data-db
description: Use when debugging database issues, exploring data, or running SQL queries against staging/production databases. Provides safe database access with built-in safety checks. Supports direct connections and SSH bastion tunnels.
---

# Database Debugging Skill

All paths below are relative to this skill's base directory. Resolve to absolute paths before executing.

Query staging and production databases for debugging. Config is auto-loaded from AWS Secrets Manager if the `aws` CLI is configured (secret: `postgres/prd-odin/bot_ro`), otherwise falls back to `~/.config/surf-db/config.json`. SSH tunnels are only used when a `bastion` key is present in the config; otherwise the tool connects directly.

## First-Time Setup Check

**IMPORTANT**: Before using any database commands, ALWAYS run setup check first:

```bash
scripts/surf-db-query --check-setup
```

If setup is not complete, guide the user through setup:
1. Direct them to read: `references/setup.md`
2. Help them create the config file at `~/.config/surf-db/config.json`
3. Verify setup completes successfully

Do NOT proceed with any database queries until setup is confirmed.

## Discovering Available Environments

Run `--check-setup` to discover which environments and databases are configured. Do NOT assume `stg` or `prd` exist — the config varies per user.

```bash
# Discover all environments and their databases (no --env required)
scripts/surf-db-query --check-setup

# List databases for a specific environment
scripts/surf-db-query --env <ENV> --list-dbs
```

## Available Commands

Script: `scripts/surf-db-query`

### Query Database

```bash
# Query default database
scripts/surf-db-query --env <ENV> --sql "SELECT * FROM users WHERE id = 123"

# Query specific database (env:db format)
scripts/surf-db-query --env <ENV>:<DB> --sql "SELECT * FROM events LIMIT 10"

# With output format
scripts/surf-db-query --env <ENV> --sql "SELECT ..." --format csv
scripts/surf-db-query --env <ENV> --sql "SELECT ..." --format json
```

### Tunnel Management (bastion configs only)

Tunnels are only needed when the config has a `bastion` key. Direct-connect configs skip tunnels automatically.

```bash
scripts/surf-db-query --env <ENV> --tunnel start
scripts/surf-db-query --env <ENV> --tunnel status
scripts/surf-db-query --env <ENV> --tunnel stop   # optional - auto-closes after 10min idle
```

## Safety Rules - MUST FOLLOW

### Read Operations (Safe)
You may execute these without user confirmation:
- `SELECT`
- `EXPLAIN`
- `SHOW`
- `DESCRIBE`

### Write Operations (DANGEROUS - Always Ask First)

**NEVER** execute write operations without explicit user approval:
- `INSERT`, `UPDATE`, `DELETE`, `REPLACE`, `MERGE`
- `CREATE`, `ALTER`, `DROP`, `TRUNCATE`
- `GRANT`, `REVOKE`

**Before ANY write operation, you MUST:**

1. Show the exact SQL to the user
2. Explain what it will do and what rows/tables are affected
3. Use AskUserQuestion tool to get explicit confirmation:
   - Question: "This will modify data in [env:db]. Proceed?"
   - Options: "Yes, execute" / "No, cancel"
4. Wait for explicit "Yes" confirmation
5. Only then execute with `--write` flag:

```bash
scripts/surf-db-query --env <ENV>:<DB> --sql "UPDATE users SET status = 'active' WHERE id = 123" --write
```

The `--write` flag is REQUIRED for any write operation. The tool will refuse to execute writes without it.

### Production Extra Caution

For **production** environments:
- Double-check the query logic
- Prefer running on staging first if possible
- For writes, make the confirmation question very clear about production impact

## Table Schema Reference

Before writing queries against the Surf product database, read `references/surf-tables.md` for key table schemas and common gotchas (e.g., user email lookup, referral tracking, subscription status values).

## Debugging Workflow

1. **Discover environments and databases**:
   ```bash
   scripts/surf-db-query --check-setup
   scripts/surf-db-query --env <ENV> --list-dbs
   ```

2. **Start tunnel** (bastion configs only) for faster repeated queries:
   ```bash
   scripts/surf-db-query --env <ENV> --tunnel start
   ```

3. **Explore schema**:
   ```bash
   # PostgreSQL (meta-commands only work with default table format, not --format csv/json)
   scripts/surf-db-query --env <ENV> --sql "\\dt"
   scripts/surf-db-query --env <ENV> --sql "\\d table_name"
   # Alternative using standard SQL (works with all --format options):
   scripts/surf-db-query --env <ENV> --sql "SELECT tablename FROM pg_tables WHERE schemaname = 'public'"

   # MySQL
   scripts/surf-db-query --env <ENV>:<DB> --sql "SHOW TABLES"
   scripts/surf-db-query --env <ENV>:<DB> --sql "DESCRIBE table_name"
   ```

4. **Investigate data**:
   ```bash
   scripts/surf-db-query --env <ENV> --sql "SELECT * FROM orders WHERE user_id = 123 ORDER BY created_at DESC LIMIT 10"
   ```

5. **Check query performance**:
   ```bash
   scripts/surf-db-query --env <ENV> --sql "EXPLAIN ANALYZE SELECT ..."
   ```

## Error Handling

If you see connection errors:
1. For bastion configs: Check if tunnel is running: `--tunnel status`
2. Try restarting tunnel: `--tunnel stop` then `--tunnel start`
3. Verify SSH key permissions: should be 600
4. Check if bastion is reachable
5. For direct configs: Verify the database host is reachable from the current network
6. Guide user to verify their config file

## What This Skill Does NOT Know

- Database hostnames, IPs, or ports
- SSH bastion addresses
- Usernames or passwords
- SSH key file locations

All connection details come from AWS Secrets Manager or the user's private config file (`~/.config/surf-db/config.json`), neither of which is shared or committed.
