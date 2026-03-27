---
name: surf-app
description: >-
  Build crypto data web apps with the Surf SDK. Scaffolds a full-stack project
  (Vite + React 19 + Express + Tailwind) with typed data hooks and server-side
  API access. Use when the user wants to build a dashboard, app, tool, or
  visualization that displays crypto data. Triggers on "build a price tracker",
  "create a whale dashboard", "make a DeFi comparison page", etc.
---

# Surf App

Build full-stack crypto data apps with `create-surf-app` and `@surf-ai/sdk`.

- **This skill**: Build a web app / dashboard / visualization with crypto data.
- **The `surf` skill**: Research, investigate, or fetch data via CLI (no web UI).

## Scaffold

```bash
npx create-surf-app .
```

Ports are read from `VITE_PORT` / `VITE_BACKEND_PORT` env vars (defaults: 5173 / 3001). Override with `--port` and `--backend-port` if needed.

After scaffolding, install dependencies and start dev servers:

```bash
cd backend && npm install && npm run dev &
cd ../frontend && npm install && npm run dev
```

Then **read the generated `CLAUDE.md`** at the project root — it has the full SDK reference, built-in endpoints, and rules for which files not to modify.

## Project Structure

```
frontend/src/App.tsx           ← Main UI, build here
frontend/src/components/       ← Add components
backend/routes/*.js            ← API routes (auto-mounted at /api/{name})
backend/db/schema.js           ← Database tables (Drizzle ORM)
CLAUDE.md                      ← Project rules (READ FIRST)
```

Do not modify: `vite.config.ts`, `server.js`, `entry-client.tsx`, `entry-server.tsx`, `index.html`, `index.css`.

## Frontend — SDK Hooks

```tsx
import { useMarketPrice } from '@surf-ai/sdk/react'

const { data, isLoading } = useMarketPrice({ symbol: 'BTC', time_range: '1d' })
// data.data → items array; data.meta → pagination/credits
```

Paginated endpoints use `useInfinite*` hooks (React Query infinite query pattern).

### Naming Convention

CLI command → hook → backend API:

```
market-price       →  useMarketPrice              →  dataApi.market.price()
wallet-detail      →  useWalletDetail             →  dataApi.wallet.detail()
social-user-posts  →  useInfiniteSocialUserPosts  →  dataApi.social.userPosts()
```

Use `surf list-operations` to discover all endpoints. Hook params match CLI flags.

## Backend — dataApi

```js
// backend/routes/portfolio.js → /api/portfolio
const { dataApi } = require('@surf-ai/sdk/server')
const { Router } = require('express')
const router = Router()

router.get('/', async (req, res) => {
  const data = await dataApi.wallet.detail({ address: req.query.address })
  res.json(data)
})

module.exports = router
```

Escape hatch: `dataApi.get('any/path', params)` / `dataApi.post('any/path', body)`.

Built-in endpoints (do not recreate): `/api/health`, `/api/__sync-schema`, `/api/cron`, `/proxy/*`.

## Styling

Tailwind CSS 4 + `@surf-ai/theme` (dark default). Use `shadcn/ui` components (`npx shadcn@latest add button`), `echarts-for-react` for charts, `lucide-react` for icons. All pre-installed.

## Data Discovery

Use the `surf` CLI (global command, NOT `npx surf`) to explore available data:

```bash
surf sync                                    # First time: download API spec
surf list-operations -g                      # List all endpoints by category
surf market-price --symbol BTC --time-range 7d   # Fetch data
```

**Important:** CLI flags use **kebab-case** (e.g. `--time-range`), while SDK hook params use **snake_case** (e.g. `time_range: '7d'`).

Naming convention: `market-price` → `useMarketPrice()` hook → `dataApi.market.price()` server method.
