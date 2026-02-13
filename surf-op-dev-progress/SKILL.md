---
name: surf-op-dev-progress
description: >
  Generate daily team progress report from GitHub commits across all cyberconnecthq repos.
  Uses 9am-9am China Time window for idempotent daily reports.
  Use when user asks for team report, daily progress, dev update, or says /surf-op-dev-progress.
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

### 3. (Optional) Post to Notion

If the user asks, post the summarized report using the Notion skill.
