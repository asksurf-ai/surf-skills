---
name: social
description: >
  Query social/X data: user profiles, posts, sentiment analysis, follower geography,
  batch tweet lookups, and top social accounts.
  Keywords: twitter, X, tweets, social, sentiment, followers, handle, posts.
---

# Social Data

## API Access

All endpoints: `${{BASE_URL_VAR}}/social/{endpoint}`

{{AUTH_NOTE}}

## Quick Examples

```bash
curl -s "${{BASE_URL_VAR}}/social/search?q=vitalik&limit=5"
curl -s "${{BASE_URL_VAR}}/social/user/VitalikButerin"
curl -s "${{BASE_URL_VAR}}/social/user/VitalikButerin/posts?limit=10"
curl -s "${{BASE_URL_VAR}}/social/user/VitalikButerin/related"
curl -s -X POST "${{BASE_URL_VAR}}/social/tweets" -H 'Content-Type: application/json' -d '{"ids":["1234567890"]}'
curl -s "${{BASE_URL_VAR}}/social/sentiment?q=ethereum%20merge"
curl -s "${{BASE_URL_VAR}}/social/follower-geo?handle=VitalikButerin"
curl -s "${{BASE_URL_VAR}}/social/top?metric=followers"
```

## When NOT to Use

- Project-level mindshare, smart followers -> `project`
- News articles -> `news`
- Market prices -> `market`
- On-chain data -> `wallet` or `onchain`

## Knowledge
