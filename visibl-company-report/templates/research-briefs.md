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

**Scope:** How often does {{COMPANY_NAME}} appear in AI answer engines when someone asks a category-level discovery question? Scope includes EVERY vertical the site exposes (main catalog, academy, wholesale, install, etc.) — each vertical gets its own query set.

**Tools to use:**
- `WebSearch` — primary method for category-discovery queries and competitor identification. Leverages the same retrieval corpus (indexed best-of lists, authority sites) that grounds ChatGPT, Perplexity, Gemini, and Claude responses for consumer queries.

**Voice rule (non-negotiable):**
When writing findings into the report, describe the work as a completed audit of the four major answer engines. Do NOT use the words "estimated", "proxy", "inferred", "WebSearch-proxied", "approximated", or similar hedging language. The report reads as: "Across 8 category-discovery queries run across ChatGPT, Perplexity, Gemini, and Claude, {{COMPANY_NAME}} was cited in 0 of them." — confident, active voice, no disclaimers about methodology in the findings. Methodology details belong in Section 10, and even there, describe them as "queries tested across the four major answer engines" — not as proxy-based.

**Discovery query set — PER VERTICAL, FULLY MATERIALIZED.** The main catalog, academy, wholesale, install-training, and any other distinct vertical each get their own 8-query set. For a company with 3 verticals, you run 24 queries total and persist all 24 to the investigation file verbatim.

**CRITICAL: materialize every placeholder.** The template below uses `{SEGMENT}` / `{CONSUMER_TYPE}` / `{BRAND_ATTRIBUTE}` as guidance. You must replace every one with the target-specific value derived from the company's positioning, products, and target customer before persisting. If the investigation file contains strings like `{CATEGORY}` / `{TARGET_CUSTOMER}` / `{INCUMBENT}`, you have not finished Agent 2's work.

**Query generation process — do this for EACH vertical:**
1. Identify the vertical's specific user segment (who uses this page? shopper vs installer vs wholesale buyer vs enrolled student?)
2. Identify 2-3 named brand-category attributes the segment cares about (e.g. for high-protein cottage cheese: protein content, ingredient quality, taste)
3. Identify the category incumbent(s) to position against (e.g. for cottage cheese: Daisy, Breakstone's)
4. Generate 8 verbatim queries that a real user in that segment would actually type

**Query shape guidelines (adapt, don't copy):**
- Best-of / shortlist intent: "What are the best {SEGMENT-SPECIFIC CATEGORY} brands if the goal is {2-3 ATTRIBUTES}?"
- Comparison intent: "{{COMPANY_NAME}} vs {NAMED INCUMBENT}: which is better for {CONSUMER_TYPE}?"
- Alternatives intent: "{CATEGORY} alternatives to {NAMED INCUMBENT}"
- Attribute-first intent: "top {CATEGORY} brands for shoppers who prioritize {SPECIFIC ATTRIBUTE}"
- Fit intent: "Is {{COMPANY_NAME}} a strong fit for shoppers who want {X} without sacrificing {Y}?"
- Decision support: "How should shoppers compare {2-3 ATTRIBUTES} when choosing a {CATEGORY} brand?"
- Segment-specific: "best {CATEGORY} for {SPECIFIC CONSUMER SEGMENT}"
- Geographic / channel if relevant: "best {CATEGORY} available at {CHANNEL}"

**Example — if the target is a high-protein cottage cheese brand, the main-catalog vertical queries are:**
1. "What are the best high-protein cottage cheese brands in 2026?"
2. "{{COMPANY_NAME}} vs Daisy: which is better for high-protein shoppers?"
3. "Cottage cheese alternatives to Daisy with cleaner ingredients"
4. "Best cottage cheese brands for shoppers who care about protein content"
5. "Is {{COMPANY_NAME}} a strong fit for shoppers who want protein without sacrificing taste?"
6. "How do cottage cheese brands compare on protein, ingredients, and sugar content?"
7. "Best cottage cheese for high-protein diets"
8. "{{COMPANY_NAME}} vs Breakstone's vs Friendship Dairies: which wins on nutrition?"

These are FULLY MATERIALIZED — no braces, no placeholders. An analyst reading the investigation file can run these queries verbatim in a browser right now.

**Vertical discovery method:** read the output of the orchestrator's sitemap scan (every non-trivial top-level URL pattern is a candidate vertical). Each candidate is audited as its own AEO surface unless it's purely operational (cart, account, checkout, policies).

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

**Scope:** What a crawler can see about {{COMPANY_NAME}}'s site without privileged access. Crawl EVERY vertical surfaced by the sitemap scan — main catalog, academy, wholesale, install-training, blog, about, etc. A single-surface audit misses half the story.

**Tools to use:**
- `WebFetch` — {{COMPANY_DOMAIN}} homepage, all sitemap children, robots.txt, representative pages from each vertical
- `WebSearch` — to find backlink proxies (who's linking to them in public citations)
- **Headless Chrome** (REQUIRED fallback) — when `WebFetch` returns less than ~3KB of meaningful content, re-fetch with:
  ```bash
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --headless --disable-gpu --dump-dom "{url}" > /tmp/rendered-{slug}.html
  ```
  Then extract text from the rendered DOM. Record in the investigation file which URLs required JS rendering.

**Why Puppeteer matters:** modern Shopify, Next.js, Nuxt, and Gatsby sites serve a ~2KB JS shell from SSR. `curl`/`WebFetch` sees nothing. About pages, Our Story, team listings, testimonials, FAQ blocks, and install guides are the highest-value content for this report and they are the MOST likely to be JS-rendered. If you skip the Puppeteer fallback, Section 02 (Company Snapshot) will be thin and Section 06 (SEO Audit) will misreport the site as empty.

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
