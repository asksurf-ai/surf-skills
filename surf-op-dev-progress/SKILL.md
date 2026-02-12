---
name: surf-op-dev-progress
description: >
  Generate daily team progress report from GitHub commits across all cyberconnecthq repos.
  Uses 9am-9am China Time window for idempotent daily reports.
allowed-tools:
  - Bash
  - Read
---

# Team Progress Report

Generate a daily team update showing what each person accomplished, based on GitHub commits across all `cyberconnecthq` repos.

This is meant to be shared with the team — write it so people can quickly see what everyone did.

## How It Works

- **Window**: 9am CST (China Standard Time, UTC+8) to 9am CST — a fixed 24h window
- **All branches**: Captures commits on feature branches too, not just main
- **Idempotent**: Same date always produces the same report. Safe to run multiple times.
- **Bot filtering**: Excludes Future Bot, Surf Backend Bot, dependabot

## Steps

### 1. Generate raw data

```bash
# Today's report (yesterday 9am CST → today 9am CST)
surf-op-dev-progress/scripts/generate-report

# Specific date
surf-op-dev-progress/scripts/generate-report --date 2026-02-12
```

### 2. Read the raw file and summarize

Read the generated file at `/tmp/team-progress-YYYY-MM-DD.md`, then rewrite it into a human-readable team update.

Present TWO tables:

**By Repo:**

| Repo | Contributors | What happened |
|------|-------------|---------------|
| muninn | Darclindy, HappySean | Built vibe coding mode with live preview (proxy + iframe, replaced Sandpack); added tabbed Preview/Debug panel; coupon mapping CRUD |
| swell | Ryan Li, Zhimao Liu, PengDeng | Kalshi prediction market integration; converted daily models to incremental; dbt test framework; CH parquet imports |

**By Person:**

| Person | Repos | What they did |
|--------|-------|---------------|
| Darclindy | muninn, urania, odin-flow | Built vibe coding mode end-to-end: live preview proxy, iframe approach, tabbed debug panel, design skills; unified Bithumb report templates |
| Ryan Li | diver, swell | Session/trace detail pages with Langfuse; UUID lookup page; L3 incident investigation; ClickHouse query fixes; dbt test framework; incremental model refactor |

### How to summarize

The raw data has commit messages like:
> fix: escape single quotes in bot_classification SQL query (#69); fix: ClickHouse 25.x FINAL alias syntax and bot_classification OOM (#70); fix: add missing aiohttp dependency for bot_classification (#71)

Summarize as: **"Bot classification fixes (SQL escaping, OOM, dependency)"**

Rules:
- Write like you're telling a teammate what someone worked on today
- Group related commits into one theme (don't list 5 separate fix commits)
- Lead with the most impactful work, not chores
- Use plain language — "built X", "fixed Y", "added Z"
- Keep each cell to 1-2 lines
- Don't lose meaningful work — every feature/fix should be reflected
- Separate themes with semicolons

### 3. (Optional) Post to Notion

If the user asks, post the summarized report to Notion using the Notion skill.
