---
name: surf-data-db
description: Use when debugging database issues, exploring data, or running SQL queries against staging/production databases. Provides safe database access with built-in safety checks. Supports direct connections and SSH bastion tunnels.
---

# Database Debugging Skill

> **SKILL_DIR**: Replace with the base directory provided at skill load time (e.g. "Base directory for this skill: /path/to/skill").

Query staging and production databases for debugging. Config is auto-loaded from AWS Secrets Manager if the `aws` CLI is configured (secret: `postgres/prd-odin/bot_ro`), otherwise falls back to `~/.config/surf-db/config.json`. SSH tunnels are only used when a `bastion` key is present in the config; otherwise the tool connects directly.

## First-Time Setup Check

**IMPORTANT**: Before using any database commands, ALWAYS check if the tool is configured:

```bash
SKILL_DIR/scripts/surf-db-query --check-setup
```

If setup is not complete, guide the user through setup:
1. Direct them to read: `SKILL_DIR/references/setup.md`
2. Help them create the config file at `~/.config/surf-db/config.json`
3. Verify setup completes successfully

Do NOT proceed with any database queries until setup is confirmed.

## Available Commands

Use the full path: `SKILL_DIR/scripts/surf-db-query`

### List Databases

```bash
SKILL_DIR/scripts/surf-db-query --env stg --list-dbs
```

### Query Database

```bash
# Query default database
SKILL_DIR/scripts/surf-db-query --env stg --sql "SELECT * FROM users WHERE id = 123"

# Query specific database (env:db format)
SKILL_DIR/scripts/surf-db-query --env stg:analytics --sql "SELECT * FROM events LIMIT 10"
SKILL_DIR/scripts/surf-db-query --env prd:main --sql "EXPLAIN ANALYZE SELECT ..."

# With output format
SKILL_DIR/scripts/surf-db-query --env stg --sql "SELECT ..." --format csv
SKILL_DIR/scripts/surf-db-query --env stg --sql "SELECT ..." --format json
```

### Tunnel Management (bastion configs only)

Tunnels are only needed when the config has a `bastion` key. Direct-connect configs skip tunnels automatically.

```bash
# Start persistent tunnel (recommended at session start)
SKILL_DIR/scripts/surf-db-query --env stg --tunnel start
SKILL_DIR/scripts/surf-db-query --env stg:analytics --tunnel start

# Check tunnel status
SKILL_DIR/scripts/surf-db-query --env stg --tunnel status

# Stop tunnel when done (optional - auto-closes after 10min idle)
SKILL_DIR/scripts/surf-db-query --env stg --tunnel stop
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
- `INSERT`, `UPDATE`, `DELETE`
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
SKILL_DIR/scripts/surf-db-query --env stg:main --sql "UPDATE users SET status = 'active' WHERE id = 123" --write
```

The `--write` flag is REQUIRED for any write operation. The tool will refuse to execute writes without it.

### Production Extra Caution

For **production** (`--env prd` or `--env prd:*`):
- Double-check the query logic
- Prefer running on staging first if possible
- For writes, make the confirmation question very clear about production impact

## Debugging Workflow

1. **Check available databases**:
   ```bash
   SKILL_DIR/scripts/surf-db-query --env stg --list-dbs
   ```

2. **Start tunnel** (bastion configs only) for faster repeated queries:
   ```bash
   SKILL_DIR/scripts/surf-db-query --env stg --tunnel start
   ```

3. **Explore schema**:
   ```bash
   # PostgreSQL
   SKILL_DIR/scripts/surf-db-query --env stg --sql "\\dt"
   SKILL_DIR/scripts/surf-db-query --env stg --sql "\\d table_name"

   # MySQL
   SKILL_DIR/scripts/surf-db-query --env stg:events --sql "SHOW TABLES"
   SKILL_DIR/scripts/surf-db-query --env stg:events --sql "DESCRIBE table_name"
   ```

4. **Investigate data**:
   ```bash
   SKILL_DIR/scripts/surf-db-query --env stg --sql "SELECT * FROM orders WHERE user_id = 123 ORDER BY created_at DESC LIMIT 10"
   ```

5. **Check query performance**:
   ```bash
   SKILL_DIR/scripts/surf-db-query --env stg --sql "EXPLAIN ANALYZE SELECT ..."
   ```

## Error Handling

If you see connection errors:
1. For bastion configs: Check if tunnel is running: `--env stg --tunnel status`
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
