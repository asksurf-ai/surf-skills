---
name: odin-op-dev-progress
description: >
  Generate daily team progress report from GitHub commits across all cyberconnecthq repos.
  Uses 9am-9am China Time window for idempotent daily reports.
  Use when user asks for team report, daily progress, dev update, or says /odin-op-dev-progress.
allowed-tools:
  - Bash
  - Read
---

# Team Progress Report

Generate a daily team update from GitHub commits across all `cyberconnecthq` repos. Output is meant to be shared with the team.

## How It Works

- **Window**: 9am CST (UTC+8) to 9am CST — fixed 24h window
- **All branches**: Captures feature branch commits, not just main
- **Idempotent**: Same date always produces the same report
- **Bot filtering**: Excludes Future Bot, Surf Backend Bot, dependabot

## Steps

### 1. Generate raw data

```bash
# Today's report (yesterday 9am CST → today 9am CST)
scripts/generate-report

# Specific date
scripts/generate-report --date 2026-02-12

# Custom output directory (default: /tmp)
scripts/generate-report --output /path/to/dir
```

Output: `/tmp/team-progress-YYYY-MM-DD.md`

### 2. Summarize

Read the generated file, then rewrite into a human-readable team update with TWO tables (By Repo and By Person).

For summarization format, examples, and rules, see [references/summarization-guide.md](references/summarization-guide.md).

### 3. Post to Notion

Post the summarized report to the **Docs** database in Notion (product-sync workspace).

```bash
# From a summary file
scripts/post-to-notion --title "Dev Team Progress — 2026-02-12" --file /tmp/team-progress-2026-02-12-summary.md

# From inline content
scripts/post-to-notion --title "Dev Team Progress — 2026-02-12" --body "report content here"

# Verify setup
scripts/post-to-notion --check-setup
```

- Notion token is loaded from AWS Secrets Manager (`notion/bot`)
- Database ID: `2e60c7ec-751f-804c-99ec-f5e12e1f571c`
- Converts markdown (headings, bold, bullets, dividers) to Notion blocks
- Max 100 blocks per page (Notion API limit)

### 4. Post Notion link to Slack (manual runs only)

> **Note:** When run via OpenClaw cron, skip this step — OpenClaw's `announce` delivery posts the summary to `#team-product` automatically.

Share the Notion page URL in Slack so the team gets notified.

```bash
scripts/post-to-slack --title "Dev Team Progress — 2026-02-12" --url "https://notion.so/..."

# Verify setup
scripts/post-to-slack --check-setup
```

- Webhook URL is loaded from AWS Secrets Manager (`slack/dev-progress-webhook`)
- Posts to `#team-product` by default
