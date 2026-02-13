# Surf-Analytics ClickHouse — Product Data

Instance: `surf-analytics` (host resolved from AWS Secrets Manager at runtime)

Single `default` database containing product analytics tables synced from the application.

## Tables

### `users` — User accounts (557K rows)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | Primary key |
| name | String | Display name |
| email | Nullable(String) | |
| avatar_url | String | |
| invitation_code | String | Referral code used to sign up |
| x_id, x_handle, x_display_name | Nullable(String) | Twitter/X profile |
| x_followers_count | Nullable(Int64) | |
| google_id, google_email, google_name | Nullable(String) | Google OAuth |
| apple_id, apple_email | Nullable(String) | Apple Sign In |
| turnkey_default_eth_address | Nullable(String) | Embedded wallet ETH address |
| turnkey_default_sol_address | Nullable(String) | Embedded wallet SOL address |
| stripe_customer_id | Nullable(String) | Stripe billing |
| platform | Nullable(String) | Signup platform |
| banned | Bool | |
| deleted | Bool | Soft delete |
| created_at | DateTime64(3) | |
| last_login_at | Nullable(DateTime64(3)) | |

### `chat_sessions` — Chat sessions (1.9M rows)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | |
| user_id | UUID | FK to users |
| title | Nullable(String) | Session title |
| type | Nullable(String) | Session type |
| project_ids | Nullable(String) | Associated projects |
| is_public | Bool | Shared session |
| archived | Bool | |
| campaign | Nullable(String) | Marketing campaign |
| folder_id | Nullable(UUID) | |
| created_at | DateTime64(3) | |

### `chat_messages` — Chat messages (2.8M rows)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | |
| session_id | UUID | FK to chat_sessions |
| user_id | UUID | FK to users |
| human_message | Nullable(String) | User's message |
| ai_massage | Nullable(String) | AI response (note: typo "massage" in column name) |
| status | LowCardinality(String) | Message status |
| project_id | Nullable(UUID) | |
| session_type | Nullable(String) | |
| user_goal | Nullable(String) | Classified user intent |
| core_subject | Nullable(String) | Classified topic |
| ai_action | Nullable(String) | Classified AI action |
| lang | LowCardinality(Nullable(String)) | Language |
| surf_platform | Nullable(String) | web/ios/android |
| created_at | DateTime64(3) | |

### `langfuse_traces` — LLM traces (7.6M rows, 335 GiB)
| Column | Type | Notes |
|--------|------|-------|
| id | String | Trace ID |
| name | Nullable(String) | Trace name |
| session_id | Nullable(String) | |
| user_id | String | |
| timestamp | DateTime64(3) | |
| environment | Nullable(String) | |
| project_id | Nullable(String) | |
| metadata | Nullable(String) | JSON metadata |
| tags | Array(String) | |
| input | Nullable(String) | JSON input |
| output | Nullable(String) | JSON output |

### `langfuse_observations` — LLM observations (129M rows, 1.29 TiB)
Detailed LLM call observations. Largest table.

### `langfuse_scores` — LLM evaluation scores (633K rows)

### `posthog_events` — Product analytics events (16.5M rows)
| Column | Type | Notes |
|--------|------|-------|
| uuid | String | Event ID |
| timestamp | DateTime64(3) | |
| event | LowCardinality(String) | Event name |
| distinct_id | String | User identifier |
| properties | String | JSON event properties |
| person_id | Nullable(String) | |
| person_properties | Nullable(String) | JSON person properties |

### `projects` — Crypto projects (23K rows)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | |
| name | String | Project name |
| slug | Nullable(String) | URL slug |
| tier | Int32 | Project tier |
| description | Nullable(String) | |
| cryptorank_id | Nullable(Int32) | CryptoRank mapping |
| image | Nullable(String) | Logo URL |

### `user_subscriptions` — Subscription billing (26K rows)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | |
| user_id | UUID | FK to users |
| subscription_type | Nullable(String) | Plan type |
| status | LowCardinality(Nullable(String)) | active/canceled/etc |
| period | Nullable(String) | monthly/yearly |
| payment_source | Nullable(String) | stripe/daimo/revenue_cat |
| start_date | Nullable(DateTime64(3)) | |
| end_date | Nullable(DateTime64(3)) | |
| rank | Int64 | |

### `bot_labels` — User classification labels (92K rows)
| Column | Type |
|--------|------|
| user_id | UUID |
| label | LowCardinality(String) |

### `invitation_codes` — Referral codes (530K rows)

### `feedbacks` — User feedback (970 rows)

### `message_interactions` — Message interactions (15K rows)

### `recommend_questions` — Recommended questions (2K rows)

### `invoices` — Payment invoices (7K rows)

### `mv_daily_user_stats` — Materialized view: daily user stats (823K rows)
Pre-aggregated daily user statistics. Use this for DAU/retention queries instead of scanning chat_messages.
