# Demo Report Section Structure

**Cover + 10 numbered sections**, continuous-flow document. No fixed page dimensions — PDF pages break at section boundaries and auto-paginate inside long sections. Structure matches the Remix Communications report taxonomy.

Each section below describes the SHAPE of the `SECTION_NN_BODY` HTML fragment the LLM must author into `values.json`. CSS classes are all defined in `templates/report.html`. Do NOT invent new classes or inline CSS beyond ad-hoc `grid-template-columns` where an existing grid primitive doesn't fit.

---

## Cover · `COVER_BODY`

**Purpose:** Title card. Establishes brand, target company, and the snapshot of headline scores.

**Required shape:** `.cover-grid` (left 3fr / right 2fr).

- Left: `.eyebrow` "AI Visibility Demo Report" → `.hero` with `{{COMPANY_NAME}}` + `<span class="accent">{{COMPANY_NAME_ACCENT}}</span>` → `.subtitle` (1 paragraph framing what the report covers).
- Right: `.snapshot-rail` with `.snapshot-head` + 4 `.snapshot-row` entries. Each row: `.snapshot-val` (big colored number) + `.snapshot-name` + `.snapshot-desc` (1 sentence).

**Snapshot rows (in order):** Visibility Score (%), Health Score (/100), Indexed URLs, Missing Schema Types.

**Voice:** No buttons. No transitional "continue below" prompts. No "Prepared for / by" block. Let the snapshot rail carry the cover.

---

## [01] Executive Summary · `SECTION_01_BODY`

**Purpose:** One-sentence diagnosis backed by headline stats and prioritized findings. This is what the prospect reads if they read only one section.

**Required shape:** `.split-5-5` outer.

- Left column: `.eyebrow` "The Bottom Line" → `.h1` with diagnosis (`<strong>` on the key emphasis clause) → `.subtitle` (2–3 sentences of context) → `.stat-grid-2` with 4 `.stat-cell`s (Visibility Score, Health Score, Buy-Zone Placement %, Gap vs Leader pts).
- Right column: `.findings-head` "Key Findings" → 5 `.finding` blocks, each with a `.finding-badge` (priority | verified | critical | context | opportunity), `.finding-title`, `.finding-body`.

**Tension Rule:** when Visibility ≥ 70% AND Health ≤ 65, the `.h1` MUST name both numbers and frame the lead as fragile. Reference SKILL.md "Voice".

---

## [02] Target Company Snapshot · `SECTION_02_BODY`

**Purpose:** Who the company is + the category AI buyers compare them against. Establishes the frame of reference.

**Required shape:** `.split-5-5` outer.

- Left: `.eyebrow` "Target Company" → `.h1` ("Who {{COMPANY_NAME}} is and the category we are judging") → positioning `.h2` pulled verbatim from the rendered homepage hero → `.stat-row-3` with 3 `.big-stat`s (Founded year, Named Clients count, Disambiguation Risk count).
- Right: `.findings-head` "Company Profile" → 4 findings (Product, Customer, Proof, Recent Motion).

Every stat must be cited in research — no guessed founding years, no "est." counts.

---

## [03] Answer Engine Visibility Scorecard · `SECTION_03_BODY`

**Purpose:** Per-engine breakdown of the category-query performance. Shows ChatGPT / Perplexity / Gemini / Claude side-by-side with the scoring rubric (Share of Voice, Citation Rank, Completeness, Recency).

**Required shape:** 4-column `.stat-row-4` of engine cards — each card uses `.stat-cell`-like structure showing the engine name, SoV %, avg citation rank, and a 1-line interpretation. Followed by a dimension-by-dimension bar chart using 4 `.bar-row`s (Share of Voice 40%, Citation Rank 30%, Completeness 20%, Recency 10%) with the aggregate weighted score on the right.

Header: `.eyebrow` "AEO Scorecard" → `.h1` with a sharp diagnosis of the worst-performing engine.

---

## [04] The Citation Graph Gap · `SECTION_04_BODY`

**Purpose:** Per-query detail. THIS is the page where the demo pivots from aggregate to evidence.

**Required shape:**
- Header: `.eyebrow` "Citation Graph" → `.h1` ("The queries where you don't yet show up are the ones that move the sale") → `.subtitle` framing how AEO citation shape differs from traditional SEO rank.
- Then a `.split-5-5` with two columns of `.query-row`s:
  - LEFT column header: `.label` "LOST · N queries where your brand is not yet cited" (red)
  - RIGHT column header: `.label` "WINNING · N queries where your brand already leads" (green)
  - Each `.query-row` uses `.q-prefix` (colored dot), `.q-text` (the verbatim category query in quotes), `.q-cites` (1-line interpretation: who was cited, what rank, what the implication is), `.q-status` (Lost / Won).

Target: every category query from Agent 2 shown individually. Typically 8 lost + 8 winning = 16 rows. If research returned fewer, show what exists — do not pad.

---

## [05] Competitive Landscape · Who's Winning · `SECTION_05_BODY`

**Purpose:** Name every brand the engines cite alongside the target and benchmark them on 6 axes. The prospect reads themselves against this grid.

**Required shape:**
- Header: `.eyebrow` "Competitive Landscape" → `.h1` ("The cohort AI engines name alongside you").
- Then a `.comp-grid` (2 columns) with 4 `.comp-card`s. The target company is card #1; top 3 competitors fill 2–4.
- Each `.comp-card` contains: `.comp-name` + `.comp-tagline` + `.comp-stat-grid` (3×2 of `.comp-stat` blocks — each with `.comp-stat-label` + `.comp-stat-value` possibly with color modifier).
- The 6 stats per competitor (fixed order): **Visibility Share**, **Citation Count**, **Schema Coverage**, **Content Depth** (pages indexed), **Category Anchor** (their 1-word positioning), **Differentiator** (1 short phrase).

4 competitors × 6 stats = 24 stat blocks. Exactly.

---

## [06] SEO Audit · Public Signal Analysis · `SECTION_06_BODY`

**Purpose:** Crawlable signal audit — what AI retrievers can see about the site without privileged access.

**Required shape:** `.split-5-5` outer.

- Left column: eyebrow + `.h1` ("What AI retrievers can see about {{COMPANY_DOMAIN}}") + short intro paragraph + stacked sub-sections:
  - `.subsection-header` "Sitemap & Crawl Posture" → 4 `.bar-row`s (Indexed Sitemaps, Internal Links, H1 Headings, Homepage Size) with real numbers.
  - `.subsection-header` "AI Bot Access" → 6 `.bar-row`-like rows (one per bot: GPTBot, PerplexityBot, ClaudeBot, Google-Extended, CCBot, Bytespider), status per bot from parsed robots.txt.
- Right column: `.findings-head` "Signal Assessment" → 4 findings covering Crawl Posture, Bot Access, Technical Stack Readiness, Speed/LCP.

---

## [07] Gap Analysis · Dimension By Dimension · `SECTION_07_BODY`

**Purpose:** Six dimensions scored side-by-side: Schema Depth, Content Freshness, Authority Backlinks, Category Coverage, Comparison Content, Editorial Citations. Each dimension shows target vs category leader.

**Required shape:**
- Header: `.eyebrow` "Gap Analysis" → `.h1` ("Where the scorecard numbers come from, dimension by dimension").
- Then a 6-row stacked layout. Each row uses a custom `grid-template-columns: 200px 1fr 1fr 80px` inline-styled div: label / target bar+value / leader bar+value / gap delta.
- Each row uses `.bar-row`-style internals but the target and leader share one row (not split-5-5).

Every dimension must have real citations in research — no fabricated leader numbers.

---

## [08] Recommendations · 180-Day Roadmap · `SECTION_08_BODY`  (LARGEST SECTION)

**Purpose:** 15 ordered recommendations (R01-R15) grouped into 4 phases, with effort/impact tagging on each.

**Required shape:**

1. Header: `.eyebrow` "Roadmap" → `.h1` ("Your 180-day plan to convert visibility into durable position") → `.subtitle` (1-paragraph frame of the 4-phase structure).

2. `.phase-timeline` grid (4 columns, one `.phase-card` per phase). Each phase card has:
   - `.phase-label` ("Phase 1 · 0-30d" in mono orange)
   - `.phase-title` (2-3 word phase theme, e.g. "Stop the bleeding")
   - `.phase-body` (1-2 sentences summarizing what the phase accomplishes)

3. Phase 1 · Immediate (0-30 days):
   - `.subsection-header` with `.subsection-num` "08a", `.subsection-line`, `.subsection-label` "Phase 1 · Immediate (0-30 days)"
   - `.grid-3` containing 3-4 `.rec-card`s (R01-R03 or R04). Each rec card:
     - `.rec-num` "R01 · Critical" (or High / Defensive / Quick Win)
     - `<h4 class="rec-title">` — the action in 4-8 words
     - `.rec-body` — 2-3 sentences explaining what + why, ideally naming a specific finding from earlier sections
     - `.rec-footer` with `.effort` label (Low/Medium/High) + `.badge` (Impact · Low/Medium/High/Critical)

4. Phase 2 · Build AEO Assets (30-90 days): `.subsection-header` "08b", then `.grid-3` with 5-6 `.rec-card`s (R04-R09 or so).

5. Phase 3 · Pursue Authority (90-180 days): `.subsection-header` "08c", then `.grid-3` with 3 `.rec-card`s (R10-R12).

6. Phase 4 · Close The Moat (180d+): `.subsection-header` "08d", then `.grid-3` with 3 `.rec-card`s (R13-R15).

**Target: exactly 15 rec cards across 4 phases.** If research doesn't support 15 solid recs, shrink to 12 — don't fabricate.

---

## [09] Cost Of Inaction · `SECTION_09_BODY`

**Purpose:** What happens if the roadmap isn't executed — framed as quantified competitive cost, not fear-mongering.

**Required shape:** `.split-5-5` outer.

- Left column: `.eyebrow` "Cost Of Inaction" → `.h1` ("What this report is worth in pipeline — and what it costs if we don't ship") → 2-paragraph prose modeling the competitive math (e.g., "If GreenPan's schema sprint closes the 17pp citation gap in 90 days, the brand loses ~X% of AI-sourced buyer intent by year-end").
- Right column: 3-4 `.finding`s framing specific pipeline/revenue risks. `.finding-badge.critical` for the sharpest.

Voice: directional not fabricated. "Losing ~15–25% of AI-sourced pipeline in 6 months if nothing changes" is fine; "$3.2M of lost revenue" is NOT unless research has specific numbers.

---

## [10] Methodology & Data Sources · `SECTION_10_BODY`

**Purpose:** Credibility anchor. Shows what was audited, how the numbers were produced, what the limits of the audit are.

**Required shape:** `.split-5-5` outer.

- Left: `.eyebrow` "Methodology" → `.h1` ("How this report was produced") → `.subsection-header` "Scope" → `.stat-row-3` (Category Queries count, Answer Engines 4, Primary Domain) → `.subsection-header` "Data Sources" → bullet list of real sources (sitemap.xml, Puppeteer-rendered homepage, robots.txt, public press citations, etc.).
- Right: `.findings-head` "Limitations" → 3-4 findings explicitly calling out what was NOT measured.

Voice on this section is neutral / analytical, not pitch voice. This is the credibility anchor.

**NEVER** include the verbatim category query list here — that's internal.

---

## Density guardrails

- Section 04 (Citation Graph): ≤ 16 query rows total
- Section 05 (Competitive Landscape): exactly 4 comp cards × 6 stats = 24 comp-stat blocks
- Section 08 (Roadmap): exactly 15 rec cards across 4 phases (R01-R15)

If research didn't produce enough signal to fill these, shrink rather than fabricate. Use `.footnote` for "not enough signal yet — revisit when [X]" callouts.
