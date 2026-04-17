# Report Section Structure

The Visibl company report has **10 fixed sections**. Keep the structure identical across every run — only prose and data points change. Section order is load-bearing: each builds on the previous.

Section numbering convention: `[NN]` for top-level sections (01–10), `08a`, `08b`, … for sub-phases inside the roadmap.

---

## [01] Executive Summary

**Purpose:** The one-page elevator pitch. If the AE only reads this page, they still walk into the meeting with the three sharpest facts.

**Required elements:**
- Hero statement (1 sentence) — the single most important finding
- 3-4 "dark-card" callouts with numerical proof points (e.g. "Zero cites across 8 discovery prompts")
- A closing strong-text paragraph that names what the company HAS (assets) + what it LACKS (citation infrastructure)

**Rules:**
- No hedging. The executive summary states findings flat-out; nuance goes in later sections.
- Always include a concrete "share of citations" or "AEO index" number, even if estimated — cite the method.

---

## [02] Target Company Snapshot

**Purpose:** Who are they, what do they sell, who do they sell it to. Grounds the rest of the report.

**Required elements:**
- Positioning one-liner
- Founding year + geography + size signal (employees / client count / revenue proxy)
- Customer proof: named clients if public (logos / case studies), else "X+ clients in {category}"
- Proof points from their own site: team size, years in market, notable press
- What they are NOT: explicit disambiguation from similarly-named entities

**Rules:**
- Only public information. If a data point can't be verified, drop it — never estimate.
- Flag ambiguous company names (e.g. multiple "Remix" entities) since they dilute brand SERPs.

---

## [03] Answer Engine Visibility Scorecard

**Purpose:** The AEO heart of the report. How often does {{COMPANY_NAME}} appear when an LLM answers a category question?

**Required elements:**
- Weighted AEO Index (0-100 composite score) — single headline number on a dark card
- Per-engine share (ChatGPT / Perplexity / Gemini / Claude) — 4-column grid using platform colors for labels only
- Per-query transcript excerpts: 6-10 real queries tested, who got cited, where {{COMPANY_NAME}} ranked
- Coverage map: out of N tested discovery queries, how many cited {{COMPANY_NAME}}

**Scoring rubric (lock this in):**
- **Share of Voice**: percent of queries where cited (weight 40%)
- **Citation Rank**: average position when cited, 1 = first (weight 30%)
- **Completeness**: cited by name, with link, with attribution (weight 20%)
- **Recency**: freshness of the cited source (weight 10%)

**Rules:**
- Always run the same set of category-level discovery queries across all 4 engines. Save the transcripts.
- Distinguish brand-name queries ("what is {{COMPANY_NAME}}") from category queries ("best {{CATEGORY}} agencies"). Brand queries don't count toward the scorecard — they're table stakes.

---

## [04] The Citation Graph Gap

**Purpose:** Why does the AEO score look the way it does? Trace it back to the real-world sources AI engines cite.

**Required elements:**
- A table showing: listicle/article source → which competitors it cites → whether {{COMPANY_NAME}} is in it
- A percentage gap stat: "X% of category citations go to {{COMPANY_NAME}} vs Y% category median"
- Brief explainer: why listicles matter (AI engines re-index them every 6-12 months)
- The moat math: cost of entry today vs cost of entry 12 months from now

**Rules:**
- Use named sources, not "some industry articles". If a source can't be named publicly, cite the proxy (e.g. "Clutch Top 10", "Gartner Peer Insights").

---

## [05] Competitive Landscape · Who's Winning

**Purpose:** Put faces to the competitors. Who specifically is eating {{COMPANY_NAME}}'s share?

**Required elements:**
- 4-6 competitor cards in a grid. Each card:
  - Competitor name + logo (if public)
  - One-line positioning
  - Why they're winning (content cadence, schema, partnerships, recent moves)
  - Their AEO score vs {{COMPANY_NAME}}'s
- A "moves of note" callout for recent events (acquisitions, fundraises, product launches within 6 months)

**Rules:**
- Competitors must be real, named, and currently operating. Do not compose hypothetical competitors.
- Flag any recent M&A — acquisitions shift the competitive weight immediately.

---

## [06] SEO Audit · Public Signal Analysis

**Purpose:** The public-signal SEO layer — what a crawler sees without any private GSC/GA data.

**Required elements:**
- Homepage title + meta description evaluation
- Schema markup present / absent (Organization, Service, FAQ, BreadcrumbList)
- Site depth: number of indexable pages, depth of content, blog cadence
- Backlink proxies (who's linking, anchor text patterns)
- Performance + mobile signals (LCP, CLS, mobile-responsive)

**Rules:**
- Only public signals. Never claim data from GSC / GA4 / Ahrefs / Semrush unless the AE has supplied it.
- Flag in Section 10 if the audit was visual-only (no crawler access).

---

## [07] Gap Analysis · Dimension By Dimension

**Purpose:** The scorecard that ties AEO + SEO findings into a dimension-by-dimension comparison with competitors.

**Required elements:**
- A table: dimension | category leader | {{COMPANY_NAME}} today | gap | priority
- 10-12 dimensions minimum (content cadence, schema coverage, podcast/media, case studies, comparison pages, etc.)
- A summary line: "Across N dimensions, {{COMPANY_NAME}} is structurally behind on X and tied on Y."

**Rules:**
- Priority column must be concrete (P0 / P1 / P2), not "high / medium / low".
- "Tied" is a real status — don't force-rank everything as behind.

---

## [08] Recommendations · 180-Day Roadmap

**Purpose:** What do we do about it? Four phases, each with a tight list of actions.

**Required elements — four phases, each its own sub-section:**
- `[08a]` Phase 1 · Immediate (0-30 days) — quick wins, mostly technical (schema, comparison pages, proof content)
- `[08b]` Phase 2 · Build AEO Assets (30-90 days) — editor outreach, original research, case study polish
- `[08c]` Phase 3 · Pursue Authority (90-180 days) — owned media, awards, annual research launch
- `[08d]` Phase 4 · Close The Moat (180d+) — certifications, category definitions, M&A routes

Each phase contains 3-5 recommendation cards. Each card:
- Title (active-voice verb)
- Why it matters (1 sentence)
- Concrete first step

**Rules:**
- Every recommendation must be executable by a 2-3 person marketing team within its stated window. No "hire a VP of content" type asks.
- Include one M&A / acquisition note if the category is consolidating — it's a real option, not a footnote.

---

## [09] Cost Of Inaction

**Purpose:** The "if you do nothing" section. Hardest section to write honestly.

**Required elements:**
- 2-3 scenarios with concrete time horizons (e.g. "Q3 2026: Kitcaster/Moburst ships 6 months of integrated content…")
- Each scenario names a specific competitor + specific outcome, not "competitors will pull ahead"

**Rules:**
- No doom. The section establishes urgency through specific, named inevitabilities — not FUD.
- Maximum 3 scenarios. More dilutes the punch.

---

## [10] Methodology & Data Sources

**Purpose:** How this report was assembled. Not an afterthought — it's the credibility layer.

**Required elements:**
- AEO queries tested: exact query text, engines run against, date run
- Dark card with 3-4 stat tiles: URLs audited, competitors analyzed, queries tested, sources cited
- Data gaps disclosure: what we DIDN'T have (no GSC access, no Ahrefs, no rank-tracker) — told straight
- What a full Visibl integration would add (organic traffic, authenticated GSC, rank-tracking)

**Rules:**
- This is where research gaps live. If the skill couldn't verify something, it goes HERE, not inside an earlier section as a false claim.
- Never fabricate data. If the research came up thin, say so — a report with honest gaps is stronger than a report with invented numbers.
