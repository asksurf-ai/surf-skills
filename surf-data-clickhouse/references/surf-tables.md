# Surf ClickHouse — Blockchain Data

Host: `jhi34kymov.us-west-2.aws.clickhouse.cloud`

100+ databases covering Ethereum blockchain data, DeFi protocols, cross-chain bridges, and token prices.

## Core Databases

### `ethereum` — Raw Ethereum Data

| Table | Description |
|-------|-------------|
| `transactions` | All Ethereum transactions |
| `event_logs` | Contract event logs |
| `traces` | Internal transaction traces |
| `tx_lookup` | Transaction lookup index |
| `withdrawals` | Beacon chain withdrawals |

**`transactions` schema:**
| Column | Type | Notes |
|--------|------|-------|
| block_date | Date | Partition key |
| block_number | UInt64 | |
| block_timestamp | DateTime64(3) | |
| transaction_hash | String | |
| from_address | String | |
| to_address | String | |
| value | UInt256 | In wei (divide by 1e18 for ETH) |
| gas_price | UInt64 | |
| receipt_gas_used | UInt64 | |
| receipt_status | UInt64 | 1=success, 0=fail |
| input | String | Calldata (hex) |

### `prices` — Token Prices

| Table | Description |
|-------|-------------|
| `prices_coingecko_hour` | Hourly prices from CoinGecko |
| `coingecko_hour` | Alias |
| `arkham_token_mapping` | Arkham token mappings |
| `coingecko_ethereum_contracts` | CoinGecko contract mappings |

**`prices_coingecko_hour` schema:**
| Column | Type |
|--------|------|
| hour | DateTime |
| coingecko_id | String |
| symbol | String |
| name | String |
| price | Float64 |
| market_cap | Float64 |
| total_volume | Float64 |

### `tokens` — Token Metadata

| Table | Description |
|-------|-------------|
| `erc20` | ERC20 token contract info |

**`erc20` schema:**
| Column | Type |
|--------|------|
| blockchain | String |
| contract_address | String |
| symbol | Nullable(String) |
| name | Nullable(String) |
| decimals | Nullable(Int64) |

### `dex` — DEX Aggregated Data

Contains Uniswap v4 pool manager data and dbt test tables.

## DeFi Protocol Databases

Each protocol has its own database with protocol-specific tables.

### DEX Protocols
| Database | Protocol |
|----------|----------|
| `uniswap_v1_ethereum` | Uniswap V1 |
| `uniswap_v2_ethereum` | Uniswap V2 |
| `uniswap_v3_ethereum` | Uniswap V3 |
| `uniswap_v4_ethereum` | Uniswap V4 |
| `sushiswap_v1_ethereum` | SushiSwap V1 |
| `sushiswap_v2_ethereum` | SushiSwap V2 |
| `curve_ethereum` | Curve |
| `balancer_v1_ethereum` | Balancer V1 |
| `balancer_v2_ethereum` | Balancer V2 |
| `balancer_v3_ethereum` | Balancer V3 |
| `pancakeswap_v2_ethereum` | PancakeSwap V2 |
| `pancakeswap_v3_ethereum` | PancakeSwap V3 |
| `maverick_v1_ethereum` | Maverick V1 |
| `maverick_v2_ethereum` | Maverick V2 |

### Lending Protocols
| Database | Protocol |
|----------|----------|
| `aave_v1_ethereum` | Aave V1 |
| `aave_v2_ethereum` | Aave V2 |
| `aave_v3_ethereum` | Aave V3 |
| `compound_v1_ethereum` | Compound V1 |
| `compound_v2_ethereum` | Compound V2 |
| `compound_v3_ethereum` | Compound V3 |
| `morpho_ethereum` | Morpho |
| `spark_ethereum` | Spark |
| `radiant_ethereum` | Radiant |

### Bridges
| Database | Protocol |
|----------|----------|
| `bridges_ethereum` | Aggregated bridge data |
| `across_v2_ethereum` | Across V2 |
| `celer_ethereum` | Celer |
| `circle_ethereum` | Circle (CCTP) |
| `layerzero_ethereum` | LayerZero |
| `synapse_ethereum` | Synapse |

### Staking & Restaking
| Database | Protocol |
|----------|----------|
| `eigenlayer_ethereum` | EigenLayer |
| `rocketpool_ethereum` | Rocket Pool |
| `staking_ethereum` | ETH staking aggregated |

### Other Chains
| Database | Description |
|----------|-------------|
| `arbitrum` | Arbitrum chain data |
| `base` | Base chain data |
| `polygon` | Polygon chain data |

### Other
| Database | Description |
|----------|-------------|
| `kalshi` | Kalshi prediction market |
| `polymarket_polygon` | Polymarket on Polygon |
| `metrics_ethereum` | Ethereum network metrics |
| `tvl_ethereum` | TVL tracking |
