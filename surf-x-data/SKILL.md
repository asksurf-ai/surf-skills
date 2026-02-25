---
name: surf-x-data
description: Search and query X (Twitter) data including tweets, users, and social activity
tools: ["bash"]
---

# X Data — X/Twitter Social Data

Access X (Twitter) data including search, user profiles, and tweet content via the Hermod API Gateway.

## When to Use

Use this skill when you need to:
- Search X/Twitter for crypto-related discussions
- Look up user profiles by handle
- Get recent tweets from a specific user
- Retrieve specific tweets by ID

## CLI Usage

```bash
# Check setup
surf-x-data/scripts/surf-x --check-setup

# Search tweets (use --limit to control result count)
surf-x-data/scripts/surf-x search --query "bitcoin ETF" --limit 10

# Get user profile
surf-x-data/scripts/surf-x user --handle vitalikbuterin

# Get user tweets (use --limit to control result count)
surf-x-data/scripts/surf-x tweets --handle vitalikbuterin --limit 10

# Get specific tweets by IDs
surf-x-data/scripts/surf-x get-tweets --ids '["1234567890", "0987654321"]'
```

## Cost

- Search: 3 credits
- User profile: 2 credits
- User tweets: 3 credits
- Get tweets by ID: 2 credits

## Endpoints Reference

See `references/endpoints.md` for full parameter details and response formats.
