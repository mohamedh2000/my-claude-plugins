# Research Briefs

Three parallel research agents run during Phase 1 of the skill. Each agent has a tight scope, a deliverable shape, and a rule set. Output is persisted to `~/.claude/investigations/visibl-report-{company-slug}.md` so it survives compaction.

All three agents run as `Task` subagents with `subagent_type: "Explore"` (read-only, fast) or `"researcher"` (read/write, persists findings). Prefer `researcher` since we need findings on disk.

---

## Agent 1 · Company Profile

**Scope:** Who is {{COMPANY_NAME}}, what do they sell, who do they sell to, what's happening with them right now.

**Tools to use:**
- `WebSearch` — broad queries for positioning, funding, recent news
- `WebFetch` — pull their homepage, About page, Team page, Pricing page (if public), Customers / Case Studies page

**Deliverable (persist to investigation file under `## Agent 1 · Company Profile`):**
```
### Positioning
<one-line from homepage hero>

### Category
<their self-declared category + our read of the real category they compete in>

### Founding / geography / size
- Founded: YYYY
- HQ: <city>
- Team size: <from LinkedIn "Employees on LinkedIn" count>
- Client count signal: <from site>
- Funding: <round / amount / date if public>

### Customer proof (verified on site)
- <named clients with logos>
- <case study titles + links>

### Recent moves (last 6 months)
- <dated items with source URL>

### Disambiguation
<other entities with similar names that dilute brand SERPs>
```

**Rules:**
- Only public data. Don't pull from Crunchbase behind a paywall, LinkedIn Premium, etc.
- Cite every data point with a source URL in the investigation file.
- If a data point can't be verified → drop it, don't estimate.

---

## Agent 2 · AEO Signals

**Scope:** How often does {{COMPANY_NAME}} appear in AI answer engines when someone asks a category-level discovery question?

**Tools to use:**
- `WebSearch` — for competitor identification and category queries
- (Ideally) direct engine calls: ChatGPT, Perplexity, Gemini, Claude — but in the absence of API access, proxy by running the queries through `WebSearch` and reading cached snapshots, or ask the human to paste in the responses

**Discovery query set (adapt wording per vertical, keep count at 8 minimum):**
1. "best {CATEGORY} agencies / tools / platforms"
2. "top {CATEGORY} for {TARGET_CUSTOMER}"
3. "{CATEGORY} alternatives to {INCUMBENT}"
4. "how to choose a {CATEGORY} vendor"
5. "{CATEGORY} vs {ADJACENT_CATEGORY}"
6. "best {CATEGORY} in {GEO}"
7. "enterprise {CATEGORY} recommendations"
8. "{CATEGORY} with {KEY_CAPABILITY}"

**Scoring rubric (apply identically across engines — do NOT change weights per-run):**
| Dimension | Weight | 0 | 50 | 100 |
|---|---|---|---|---|
| Share of Voice | 40% | 0 of 8 queries | 4 of 8 | 8 of 8 |
| Citation Rank | 30% | never ranked top-5 | avg rank 5-10 | avg rank 1-3 |
| Completeness | 20% | mention only | named + linked | named + linked + attributed |
| Recency | 10% | sources >24mo old | 12-24mo | <12mo |

**Deliverable shape (persist under `## Agent 2 · AEO Signals`):**
```
### Discovery queries tested
<numbered list of exact query strings>

### Per-engine results
#### ChatGPT (date: YYYY-MM-DD)
| Query | Did {{COMPANY_NAME}} get cited? | Rank | Who WAS cited |
|---|---|---|---|
| ... | ... | ... | ... |

#### Perplexity ...
#### Gemini ...
#### Claude ...

### Weighted AEO Index
<0-100, with math shown>

### Key finding
<one sentence — "every hit is brand-name driven, category-discovery = zero" or equivalent>
```

**Rules:**
- Run the EXACT same queries across all 4 engines. No adaptation per engine.
- Record the date. Engines change weekly; a 2-week-old snapshot is stale.
- Distinguish brand queries ("what is {{COMPANY_NAME}}") from category queries. Brand queries don't count toward the scorecard — they're table stakes.

---

## Agent 3 · SEO Signals

**Scope:** What a crawler can see about {{COMPANY_NAME}}'s site without privileged access.

**Tools to use:**
- `WebFetch` — {{COMPANY_DOMAIN}} homepage, sitemap.xml (if present), robots.txt, 2-3 deep content pages
- `WebSearch` — to find backlink proxies (who's linking to them in public citations)

**Deliverable (persist under `## Agent 3 · SEO Signals`):**
```
### Homepage signals
- <title>: <actual title tag text>
- <meta description>: <actual text>
- Quality: <fair / thin / strong> + one-line justification

### Schema markup
- Organization: <yes/no>
- Service / Product: <yes/no>
- FAQ: <yes/no>
- BreadcrumbList: <yes/no>
- BlogPosting / Article: <yes/no>
- Review / Rating: <yes/no>

### Site depth
- Approx pages indexed (via sitemap or site: search): <N>
- Content depth: <blog cadence last 6mo, avg word count, topics covered>
- Owned category pages: <list of /category/ or /solutions/ URLs>
- Comparison pages (/alternatives, /vs): <list or NONE>

### Backlink signals (public-only)
- <3-5 named citing domains with anchor text>
- Direction: <primary citation sources — press, directories, partners, etc.>

### Performance signals (if PageSpeed Insights is accessible)
- LCP, CLS, mobile usability

### Gaps vs category median
- <concrete items: missing schema, no comparison pages, blog inactive, etc.>
```

**Rules:**
- Public signals only. NEVER claim data from Google Search Console, GA4, Ahrefs, Semrush, or any paid tool unless the AE explicitly provides that data.
- If performance data isn't reachable → say so in Section 10, don't fabricate Core Web Vitals numbers.
- Flag any "invisible to crawlers" assets (video-only case studies, gated PDFs, unindexable interactive pages).

---

## Research gate

Before the skill renders HTML, it must confirm:
- All 3 investigation files exist and have `## Status: complete` lines
- Every named data point can be traced back to a source URL
- No section has a "TODO" or placeholder left behind

If the gate fails → stop and report what's missing. Don't render a half-finished report.
