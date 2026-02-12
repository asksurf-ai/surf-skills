# Trace Analysis Skill - Test Cases

## Sample Trace IDs

| Trace ID | Description | Observations |
|----------|-------------|--------------|
| `0dd243840d794a46d38b6abd7b10c269` | AskFast - Optimism DEX USDC query | 16 |

## Test Questions & Expected Behavior

### 1. Basic Analysis
**Question**: "Analyze trace 0dd243840d794a46d38b6abd7b10c269"

**Expected Actions**:
1. Run `fetch_trace.py` with trace ID
2. Read `call_tree.txt` for overview
3. Read `cost_summary.txt` for token usage
4. Report: trace name, duration, observation count, key agents involved

**Expected Answer Should Include**:
- Trace name: AskFast
- Total duration: ~35s
- 16 observations
- Key agents: ask_reporter, ask_fast_coordinator
- Models used: grok-4-1-fast-reasoning, gpt-oss-120b

---

### 2. Data Origin - Number
**Question**: "Where does $33.3M come from?"

**Expected Actions**:
1. Check `key_values.txt` first (fast lookup)
2. If not found, grep `all_outputs.txt`
3. Read the specific observation file

**Expected Answer**:
- Source: Observation #004 `external_search`
- Data from: CoinGecko (Optimism DEX rankings page)
- Original value: $33,302,131 (Velodrome SlipStream 24h volume)

---

### 3. Data Origin - Percentage
**Question**: "Where does 83.5% come from?"

**Expected Actions**:
1. Check `key_values.txt` for "83.5"
2. Read observation #004

**Expected Answer**:
- Same source as $33.3M
- CoinGecko market share calculation

---

### 4. Data Origin - Address
**Question**: "Where does 0x0b2c639c533813f4aa9d7837caf62653d097ff85 come from?"

**Expected Actions**:
1. Grep for address in `key_values.txt` or `all_outputs.txt`
2. Identify source observation

**Expected Answer**:
- This is the native USDC contract on Optimism
- First appears in observation output (external_search or LLM generation)

---

### 5. Execution Flow
**Question**: "Show me the call hierarchy"

**Expected Actions**:
1. Read `call_tree.txt` directly

**Expected Output**:
```
SPAN: AskFast (35.73s)
    ├── SPAN: ask_fast_retriever (96ms)
    ├── SPAN: ask_fast_coordinator (1.54s)
        ├── GENERATION: ChatLiteLLMRouter [gpt-oss-120b]
    ├── SPAN: ask_reporter (34.04s)
        ├── GENERATION: XAIChatModel [grok-4-1-fast-reasoning]
        ├── TOOL: external_search (x2)
        ...
```

---

### 6. LLM Decisions
**Question**: "What did the LLM decide to do?"

**Expected Actions**:
1. Read `llm_only.txt` directly

**Expected Answer Should Include**:
- Coordinator (gpt-oss-120b) decided to handoff to "search" target
- Reporter (grok-4-1-fast-reasoning) called external_search, twitter_search, listing_batch_token
- Final answer generation

---

### 7. Cost Analysis
**Question**: "How much did this trace cost?"

**Expected Actions**:
1. Read `cost_summary.txt` directly

**Expected Answer**:
- Total: $0.001581
- 51,539 input tokens / 2,238 output tokens
- 3 LLM calls
- gpt-oss-120b: $0.001581 (9,850 in / 172 out)
- grok-4-1-fast-reasoning: $0.00 (not tracked)

---

### 8. Tool Calls
**Question**: "What tools were called?"

**Expected Actions**:
1. Read `tools_only.txt` or check `call_tree.txt`

**Expected Answer**:
- listing_batch_token (1.19s) - USDC/ETH exchange listings
- twitter_search_advanced (1.52s) - Twitter search for O1 DEX
- external_search (10.37s) - Web search for Optimism USDC DEX pairs
- external_search (10.46s) - Another web search
- news_search (49ms) - News search

---

### 9. Bottleneck Analysis
**Question**: "What was the slowest operation?"

**Expected Actions**:
1. Read `call_tree.txt` and look at durations
2. Identify longest operations

**Expected Answer**:
- Slowest: `external_search` at 10.46s and 10.37s (~20s total)
- Second: LLM generation at 14.55s
- These account for ~95% of the 35s total

---

### 10. Error Detection
**Question**: "Were there any errors?"

**Expected Actions**:
1. Grep for "error", "failed", "timeout" in `all_outputs.txt`
2. Check tool outputs

**Expected Answer**:
- One timeout: geckoterminal.com (9s timeout in external_search)
- Twitter search returned 0 results (not an error, just no matches)

---

## Efficiency Guidelines

### File Selection Priority

| Question Type | Check First | Then If Needed |
|--------------|-------------|----------------|
| "Where does X number come from?" | `key_values.txt` | `all_outputs.txt` → specific obs |
| "Where does X address come from?" | `key_values.txt` | `all_outputs.txt` → specific obs |
| "Show call flow" | `call_tree.txt` | - |
| "What did LLM decide?" | `llm_only.txt` | specific obs for full output |
| "What tools called?" | `call_tree.txt` | `tools_only.txt` for details |
| "How much cost?" | `cost_summary.txt` | - |
| "Any errors?" | grep `all_outputs.txt` | specific obs |

### Avoid

- Don't read `all_outputs.txt` fully - it's large. Use grep.
- Don't read individual observation files unless you need full content.
- Don't re-fetch trace if files already exist in `/tmp/trace_analysis/<id>/`.

---

## Trace 2: Complex Multi-Agent Research

| Field | Value |
|-------|-------|
| Trace ID | `b2b77d333d67562b4231f190aac51141` |
| Name | V2 |
| Observations | 46 |
| Duration | 187.78s |
| LLM Calls | 16 |
| Total Cost | $0.258667 |
| Query | "让我们想想它的积分系统是如何计算积分的？" (Opinion Labs PTS) |

### Characteristics
- Multi-turn conversation with prior context
- 4 team_planner cycles (gemini-3-flash-preview)
- 5 different models used
- 13+ tool calls across web_search, web_fetch, twitter_search, news_search, db_internal_data
- Complex handoff chains between agents

---

### Test 11: Multi-Model Cost Breakdown
**Question**: "Which model cost the most?"

**Expected Actions**:
1. Read `cost_summary.txt` directly

**Expected Answer**:
- Most expensive: **gemini-3-flash-preview** at $0.225730 (4 calls, 114,389 input tokens)
- Second: deepseek-v3p1 at $0.026830
- grok-4-1-fast-reasoning: $0.00 (9 calls, 218,082 input tokens - not tracked)

---

### Test 12: Team Planner Analysis
**Question**: "How many times did team_planner run?"

**Expected Actions**:
1. Read `call_tree.txt`
2. Count AGENT: team_planner entries

**Expected Answer**:
- 4 team_planner cycles
- Each used gemini-3-flash-preview
- Durations: 5.05s, 9.18s, 16.93s, 16.94s

---

### Test 13: Tool Usage Summary
**Question**: "What data sources were used?"

**Expected Actions**:
1. Read `tools_only.txt` or `call_tree.txt`

**Expected Answer**:
- db_internal_data (599ms) - Internal Opinion Labs data
- twitter_search (2x) - @opinionlabsxyz tweets
- news_search (3x) - News articles
- web_search (4x) - General web search
- web_fetch (2x) - Fetched docs.opinion.trade, cryptorank.io, bingx.com

---

### Test 14: Data Origin - $200 Threshold
**Question**: "Where does the $200 minimum threshold come from?"

**Expected Actions**:
1. Grep `key_values.txt` for "$200"
2. Find the source observation
3. Read the observation to find original source

**Expected Answer**:
- Found in `key_values.txt`: `$200 | #001 | ChatLiteLLMRouter | INPUT`
- Original source: OPINION Docs (docs.opinion.trade/incentive-plans/point-system-pts)
- Fetched via `web_fetch` tool

---

### Test 15: Find Specific URL Source
**Question**: "Which tool fetched docs.opinion.trade?"

**Expected Actions**:
1. Grep for "docs.opinion.trade" in `tools_only.txt` or observations
2. Identify the tool

**Expected Answer**:
- `web_fetch` (observation #006, 9.07s) fetched:
  - https://docs.opinion.trade/incentive-plans/point-system-pts
  - https://docs.opinion.trade/incentive-plans/referral-program

---

### Test 16: Execution Timeline Bottleneck
**Question**: "What took the longest in this trace?"

**Expected Actions**:
1. Read `call_tree.txt`
2. Identify longest operations

**Expected Answer**:
- Total: 187.78s
- Main bottleneck: `reporter` agent at 181.00s (96% of total)
- Within reporter:
  - LLM generations: ~95s total (9x grok-4-1-fast-reasoning)
  - team_planner: ~48s total (4x gemini-3-flash-preview)
  - web_fetch: ~13.5s total (2 calls)

---

### Test 17: Twitter Data Found
**Question**: "Did Twitter search find any results?"

**Expected Actions**:
1. Read `tools_only.txt` and check twitter_search outputs

**Expected Answer**:
- twitter_search #1 (from:opinionlabsxyz): Found 2 tweets
- twitter_search #2 (from:OpinionLabs): Found 0 tweets (wrong handle)

---

### Test 18: Internal Data Source
**Question**: "What did db_internal_data return?"

**Expected Actions**:
1. Read observation for db_internal_data (observation #013 based on tools_only.txt)

**Expected Answer**:
- Returned Opinion Labs project overview
- Included: project description, tokenomics data
- Entities queried: "Opinion Labs", "OPINION"

---

### Test 19: Follow-up Questions Generated
**Question**: "What follow-up questions were generated?"

**Expected Actions**:
1. Read `llm_only.txt` - check kimi-k2-instruct-0905 output

**Expected Answer**:
6 follow-up questions generated:
1. "有哪些预测市场也有类似质量权重积分" (broader)
2. "Opinion Labs团队如何防止积分算法被逆向" (broader)
3. "权重公式中价格接近度如何量化计算" (deeper)
4. "$200最低门槛会随用户增长上调吗" (deeper)
5. "积分未来空投比例和锁仓规则是什么" (missing_research)
6. "系统检测到刷量会清零积分吗" (missing_research)

---

### Test 20: Compare Models Used
**Question**: "How many different models were used?"

**Expected Actions**:
1. Read `cost_summary.txt`

**Expected Answer**:
5 models:
1. grok-4-1-fast-reasoning (9 calls, 218K input tokens)
2. gemini-3-flash-preview (4 calls, 114K input tokens)
3. deepseek-v3p1 (1 call, 40K input tokens)
4. grok-4-fast-non-reasoning (1 call, 16K input tokens)
5. kimi-k2-instruct-0905 (1 call, 3K input tokens)

---

## Efficiency Comparison: Trace 1 vs Trace 2

| Metric | Trace 1 (Simple) | Trace 2 (Complex) |
|--------|------------------|-------------------|
| Observations | 16 | 46 |
| Duration | 35.73s | 187.78s |
| LLM Calls | 3 | 16 |
| Models Used | 2 | 5 |
| Total Cost | $0.001581 | $0.258667 |
| Input Tokens | 51,539 | 393,067 |

---

## Adding New Test Traces

To add a new test trace:
1. Run: `/trace-analysis <new_trace_id>`
2. Document: trace name, observation count, key characteristics
3. Add sample questions specific to that trace
