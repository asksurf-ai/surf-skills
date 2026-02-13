# Surf Product Database — Key Tables & Gotchas

These tables exist in the production Postgres database. The same schema is mirrored in ClickHouse (surf-analytics).

## Users

Table: `users`

> **IMPORTANT — Email lookup**: The `email` column is usually NULL. Most users sign up via OAuth, so their email is stored in `google_email` or `apple_email` instead. Always search ALL email fields:
> ```sql
> SELECT id, name, email, google_email, apple_email, created_at, last_login_at
> FROM users
> WHERE email ILIKE '%query%' OR google_email ILIKE '%query%' OR apple_email ILIKE '%query%';
> ```

Key columns: `id` (UUID PK), `name`, `email` (often NULL), `google_email`, `apple_email`, `invitation_code` (referrer's code used at signup), `stripe_customer_id`, `created_at`, `last_login_at`, `banned`, `deleted`.

## Invitation Codes (Referral Tracking)

Table: `invitation_codes`

> **This is the primary table for referral tracking**, not `users.invitation_code`. Each row is a single-use invite code linking a referrer to an invited user.

Key columns: `id` (UUID PK), `code`, `is_used` (bool), `owner_user_id` (FK to users — the referrer), `invited_user_id` (FK to users — who signed up), `type`, `shared`, `created_at`.

```sql
-- Count referrals and paying conversions for a user
SELECT
    count(*) FILTER (WHERE invited_user_id IS NOT NULL) as successful_referrals,
    count(*) FILTER (WHERE invited_user_id IN (
        SELECT user_id FROM user_subscriptions
        WHERE payment_source != 'FREE' AND subscription_type != 'PRO_TRIAL'
    )) as converted_to_paying
FROM invitation_codes
WHERE owner_user_id = 'uuid-here';
```

## User Subscriptions

Table: `user_subscriptions`

> **IMPORTANT — Paying vs free**: To identify real paying users, filter out free trials.
> - `status` values are **UPPERCASE**: `ACTIVE`, `INACTIVE`
> - `payment_source` values: `STRIPE`, `GOOGLEPAY`, `APPLEPAY` (real payment) vs `FREE` (not paying)
> - `subscription_type` values: `PRO`, `PLUS` (real plans) vs `PRO_TRIAL` (free trial)

Key columns: `id` (UUID PK), `user_id` (FK), `subscription_type`, `status`, `period` (monthly/yearly), `payment_source`, `start_date`, `end_date`.

```sql
-- Currently paying users (real money, not free trials)
SELECT user_id FROM user_subscriptions
WHERE status = 'ACTIVE' AND payment_source != 'FREE';

-- Users who ever paid
SELECT DISTINCT user_id FROM user_subscriptions
WHERE payment_source != 'FREE' AND subscription_type != 'PRO_TRIAL';
```
