---
name: surf-app
description: >-
  Build crypto data web apps with the Surf SDK. The system prepares the Surf
  app scaffold and dev servers before the agent starts, so this skill focuses
  on writing frontend/backend code, using SDK hooks, and validating behavior.
  Triggers on "build a price tracker", "create a whale dashboard", "make a
  DeFi comparison page", etc.
---

# Surf App

Build full-stack crypto data apps with the scaffolded Surf app and `@surf-ai/sdk`.

- **This skill**: Build a web app / dashboard / visualization with crypto data.
- **The `surf` skill**: Research, investigate, or fetch data via CLI (no web UI).

## Environment

The system already prepared the project before you start:

- The Surf app scaffold is already present in `frontend/`, `backend/`, and `CLAUDE.md`.
- Dependencies are already installed.
- Frontend and backend dev servers are already started and managed by the system.

Do not scaffold the app again. Do not run `npm install`, `npm run dev`, `pkill`, or other process-management commands unless the user explicitly asks you to debug infrastructure.

## Project Structure

```text
frontend/src/App.tsx           <- Main UI, build here
frontend/src/components/       <- Add components
backend/routes/*.js            <- API routes (auto-mounted at /api/{name})
backend/db/schema.js           <- Database tables (Drizzle ORM)
CLAUDE.md                      <- Project rules (READ FIRST)
```

Do not modify: `vite.config.ts`, `server.js`, `entry-client.tsx`, `entry-server.tsx`, `index.html`, `index.css`.

## First Step

Read the generated project rules and SDK docs before writing code:

```bash
cat CLAUDE.md
cat frontend/node_modules/@surf-ai/sdk/README.md
cat frontend/node_modules/@surf-ai/theme/CHARTS.md
cat frontend/node_modules/@surf-ai/theme/DESIGN-SYSTEM.md
```

## Workflow: Data Discovery -> Code

Always start by exploring available data with the `surf` CLI, then map directly to SDK code. The CLI -> SDK mapping is mechanical (see Step 2). Do not run `node -e` to test individual endpoints.

### Step 1: Discover endpoints with CLI

```bash
surf sync
surf list-operations -g
surf market-price --help
surf market-price --symbol BTC --time-range 7d
```

CLI flags use kebab-case (for example `--time-range`). `surf` is a global command, not `npx surf`.

### Step 2: Check SDK exports before writing code

Do not guess hook or method names. Read actual exports:

```bash
grep -o 'function use[A-Za-z]*' frontend/node_modules/@surf-ai/sdk/dist/react/index.js | sort
```

Naming convention:
- CLI: `surf market-ranking --limit 5` -> Frontend: `useMarketRanking({ limit: 5 })` or `useInfiniteMarketRanking({ limit: 5 })`
- CLI: `surf market-ranking --limit 5` -> Backend: `dataApi.market.ranking({ limit: 5 })`
- CLI flags are kebab-case (`--time-range`), SDK params are snake_case (`{ time_range: '7d' }`)

### Step 3: Write code

Write frontend and backend code using the confirmed names from Step 2. Do not re-run scaffold or dev server setup. If the preview looks broken, inspect app code and server responses rather than trying to restart services yourself.

## Frontend — SDK Hooks

```tsx
import { useMarketPrice } from '@surf-ai/sdk/react'

const { data, isLoading } = useMarketPrice({ symbol: 'BTC', time_range: '1d' })
// data.data -> items array; data.meta -> pagination/credits
```

The `/proxy/*` route is built-in — hooks automatically call `/proxy/market/price` which the Express backend forwards to the data API. No manual fetch needed.

## Backend — dataApi

```js
// backend/routes/portfolio.js -> /api/portfolio
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

Tailwind CSS 4 + `@surf-ai/theme` (dark default). Use `shadcn/ui` components, `echarts-for-react` for charts, and `lucide-react` for icons. These are already installed in the scaffold.
