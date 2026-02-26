---
name: onchain
description: >
  Query on-chain data: transaction lookups, structured queries,
  and raw SQL (ClickHouse) against on-chain tables.
  Keywords: onchain, transaction, tx, SQL, ClickHouse, query, blockchain.
---

# Onchain Data

## API Access

All endpoints: `${{BASE_URL_VAR}}/onchain/{endpoint}`

{{AUTH_NOTE}}

## Quick Examples

```bash
curl -s "${{BASE_URL_VAR}}/onchain/tx?hash=0xabc123...&chain=ethereum"
curl -s -X POST "${{BASE_URL_VAR}}/onchain/query" -H 'Content-Type: application/json' -d '{"table":"transfers","filters":{"address":"0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"}}'
curl -s -X POST "${{BASE_URL_VAR}}/onchain/sql" -H 'Content-Type: application/json' -d '{"sql":"SELECT count() FROM ethereum.transactions WHERE toAddress = '\''0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045'\''","max_rows":100}'
```

## When NOT to Use

- Token holders, transfers (pre-built) -> `token`
- Wallet balances, history -> `wallet`
- Market prices -> `market`
- Project metrics (TVL, revenue) -> `project`

## Knowledge
