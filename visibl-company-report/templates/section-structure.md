# Report Section Structure (v2 · Good-Culture taxonomy)

The Visibl AI Visibility Progress Report has **14 fixed pages**. The taxonomy is hybrid: it follows the platform's canonical AI Visibility Progress Report structure (Good Culture template) with two additional Visibl-native sections (Competitive Landscape · Methodology) inserted.

Keep the page order identical across every run. Only prose and data points change. Page 1 is always the cover; page 14 is always the closing CTA.

---

## Voice (applies to pages 1-13 + 14)

This report is client-facing — an AE hands it to the prospect. Every page outside page 14 follows a soft-pitch advisor voice:

- Address the reader as **"you" / "your brand" / "your site"** in body copy
- Frame findings as **opportunities**, not deficiencies
- Every page ends on an **implication** — a sentence or line that hints at what to do about it, without naming Visibl (the sell is implicit; Visibl appears only on Cover, Path Forward page 12, and CTA page 15)
- Keep **numbers blunt**; soften the language wrapped around them
- **Never mention platform / CMS names** (Shopify, WordPress, Webflow, Next.js, Nuxt, Gatsby, WooCommerce, BigCommerce, Magento, etc.). Use "your site", "the storefront", or the schema type alone.
- **Never use internal research jargon** — no "crawl posture", "SSR", "JSON-LD" (say "schema markup"), "Puppeteer", "WebFetch". These are audit-tooling words that don't belong in a client artifact.

(Methodology page has been removed — scope summary is merged into the closing page 14.) — it stays neutral and analytical (active voice, completed-work framing, no "you" addressing).

---

## [01] Cover

**Purpose:** Hero page that names the company, the report type, and the four highest-signal metrics at a glance.

**Required elements:**
- `eyebrow`: "AI Visibility Progress Report" in orange mono uppercase
- `hero` title: "{{COMPANY_NAME}} {{COMPANY_NAME_ACCENT}} Review" — ONE word in orange (see accent rule below)
- Subtitle: one-paragraph framing of the report's scope
- "View scorecard →" CTA pill
- Right rail: `SNAPSHOT · {{REPORT_DATE}}` with 4 stat rows (Visibility Score, Health Score, Indexed Sitemaps, Missing Schema Types). Each row: big colored number + metric name + one-line description

**Voice:**
- No hedging. Numbers are numbers.
- The accent word must be thematic: for Visibl's template the canonical choice is "Visibility" (as in "Good Culture Visibility Review"). Other fits: "AI", "Citation", "Answer", "Search".

---

## [02] Executive Summary · The Bottom Line

**Purpose:** One-sentence diagnosis of where the company stands, backed by the four most important numbers and the prioritized finding list. If the AE reads only this page, they still win the meeting.

**Required elements:**
- Eyebrow: "The Bottom Line"
- H1: one-sentence diagnosis with the final clause in `<strong>` for emphasis
- Subtitle: 2-3 sentences of context
- 2×2 stat grid: Visibility Score, Health Score, Buy Zone Placement, Gap vs Leader
- Right rail: "Key Findings" — 4-5 findings, each with a colored badge (Priority orange / Verified green / Critical red / Context grey), title, and 1-2 line explanation

**Voice:**
- Diagnosis is declarative. No "may be", "could be", "appears to".
- Numbers appear as clean percentages or fractions (no `~`, no "est.").

---

## [03] Target Company Snapshot

**Purpose:** Ground the rest of the audit in who the target is and what category AI buyers compare them against. This is a Visibl-native section (not in the reference's 12-page structure).

**Required elements:**
- Eyebrow: "Target Company"
- H1: "Who {{COMPANY_NAME}} is and the category we are judging"
- Positioning one-liner pulled verbatim from homepage hero
- 3-stat row: Founded (year + HQ), Named Clients (count), Disambiguation Risk (count of same-named entities)
- Right rail: 4 findings (Product, Customer, Proof, Recent Motion)

**Voice:**
- Only cite facts verifiable on the public site.
- Drop anything unverifiable — don't flag it in this section.

---

## [04] Sitemap & Discoverability

**Purpose:** Technical crawlability audit. Can AI engines find the site, and how deep does the crawlable footprint go?

**Required elements:**
- Eyebrow: "Sitemap & Discoverability"
- H1 emphasis phrase: "…needs more depth" or similar
- 4 bar rows: Indexed Sitemaps, Internal Links, H1 Headings, Homepage Size. Each row has label, big colored value, and a thin horizontal progress bar.
- Right rail: 4 findings (Current State, Interpretation, Top Competitor, Competitive Context)

**Voice:**
- Never report a page as "empty" when Puppeteer wasn't used to render it. The fallback is mandatory.

---

## [05] Schema & Structured Data

**Purpose:** Per-schema-type audit. Which entity schema blocks exist vs which are missing. Schema is "the fastest technical win" framing.

**Required elements:**
- Eyebrow: "Schema & Structured Data"
- H1: "AI engines still need more help understanding what {{COMPANY_NAME}} is"
- Per-schema rows for: Organization, WebSite, FAQPage, Service, Review/Rating, CollectionPage. Each with a thin bar (green when Present, grey when Not Detected)
- Right rail: 4 findings (Verified detected schema, Critical Gap missing markup, Competitor signal, Fast Technical Win framing)

**Voice:**
- Schema absence detected via SSR HTML or Puppeteer render ONLY. Never claim absence based on an empty `curl` on a JS-rendered page.

---

## [06] Content Depth

**Purpose:** Compare the target's content footprint to category competitors. Who has the deepest body of owned, citable content?

**Required elements:**
- Eyebrow: "Content Depth"
- H1 emphasis: "…still thin" or "…already leading depth"
- "Current Content Footprint" stat box: Total Pages, Blog Posts, Service Pages, Avg Words/Page
- Right rail: "Competitive Ranking · Content Depth" — 5-6 competitor rows with bars and `38 / 449 avg words`-style labels

**Voice:**
- Numbers from sitemap counts, not guesses. If a sitemap is gated, say so in Methodology, don't report `0`.

---

## [07] AI Bot Access

**Purpose:** robots.txt audit — which AI crawlers (GPTBot, PerplexityBot, ClaudeBot, Google-Extended, CCBot, Bytespider) are explicitly allowed, denied, or implicit.

**Required elements:**
- Eyebrow: "AI Bot Access"
- H1: "Crawlers can reach the site. Access is not the blocker." (or inverted if they ARE blocking)
- 3-stat row: Explicit Bot Mentions, Sitemaps Listed, Global Crawl Rule
- raw robots.txt excerpt as footnote (monospace)
- Right rail: "Robots.txt Signals" table with 6 bot rows — bot name, rule, owner, IMPLICIT/ALLOW/DENY status

**Voice:**
- "No explicit rule" + `Allow: /` = IMPLICIT, not DENIED. Distinction matters.

---

## [08] Query Gap Analysis

**Purpose:** The AEO scorecard. Across N category-discovery queries, how often does the company appear and where does it rank?

**Required elements:**
- Eyebrow: "Query Gap Analysis"
- H1 emphasis: "…already in the prompt" or similar
- 3-stat grid (full width): Queries Tracked (green), Top 3 Rankings (green), Gap Queries (red)
- 2-column split: Lost Queries (red dots, 3 items) vs Winning Queries (green dots, 3 items). Each with query text + one-line meta.

**Voice:**
- Queries are verbatim strings, in quotes.
- "Lost" = absent from top-3. "Winning" = top-3 or explicit cite.

---

## [09] Citation Gap Analysis

**Purpose:** Where do AI citations actually come from — the company's own site, third-party coverage, or competitor-owned sources?

**Required elements:**
- Eyebrow: "Citation Gap Analysis"
- H1: "AI engines need more reasons to cite {{COMPANY_NAME}} directly"
- Subtitle naming owned-citation percentage
- 3 bar rows: {{COMPANY_DOMAIN}} (usually small), third-party coverage, competitor-owned sources
- Right rail: 3 findings (Current State, Recommended Fix, Competitive Signal)

**Voice:**
- "Owned" = appears as cited source on the company's domain. "Third-party" = any citing domain.

---

## [10] Competitive Landscape

**Purpose:** Named competitor cards with their visibility scores. Who's eating the company's share? This is a Visibl-native section (not in the reference's 12-page structure).

**Required elements:**
- Eyebrow: "Competitive Landscape"
- H1 emphasis: "…eating {{COMPANY_NAME}}'s citation share"
- 3-column grid of 6 competitor cards (including {{COMPANY_NAME}} itself as one entry for direct comparison)
- Each card: name, 1-line positioning, visibility % (colored green/amber/red by relative standing)

**Voice:**
- Competitors MUST be real, currently operating, and actually cited in the AEO data. No hypothetical competitors.
- Recent M&A or funding within 6 months gets called out in the tagline.

---

## [11] Answer Gap Analysis

**Purpose:** What types of pages does the site need to build to answer AI buyers' questions? The prescriptive follow-up to Citation Gap.

**Required elements:**
- Eyebrow: "Answer Gap Analysis"
- H1 emphasis: "…directly answer what buyers and AI systems want to know"
- 2×2 grid of recommendation cards. Each: rank label (01 — Critical / 02 — High Upside / 03 — High Upside / 04 — Strategic), title, 1-2 sentence description, timing chip (Do This Week / Week 2 / Week 2-3 / Strategic)

**Voice:**
- 4 cards is the target. Don't exceed.
- Titles are nouns or noun phrases, not verbs ("Comparison Pages" not "Build Comparison Pages").

---

## [12] The Path Forward

**Purpose:** Phased roadmap. What's done vs what's next vs what's ongoing.

**Required elements:**
- Eyebrow: "The Path Forward"
- H1 with projected metric change ("63.7% → 72%+. Now make it durable.")
- 3 path rows: Current Snapshot (Now), Next Sprint (30 Days), Monitoring (60-90 Days). Each row shows 4-5 chip pills.
- "Done" chips use a green dot + muted ink text. Future chips use an orange dot + normal ink text.

**Voice:**
- Phase names are platform-consistent. Don't invent new phase labels.

---

## [13] Next Steps

**Purpose:** Concrete suggested timeline that an AE can put in a proposal or SOW.

**Required elements:**
- Eyebrow: "Next Steps"
- H1 emphasis: "…turns that into movement"
- Right rail: "Suggested Timeline" with 4 timeline rows. Each: name, when (colored orange for this-quarter, green for next-quarter), and a filled progress track.

**Voice:**
- The timeline implicitly commits Visibl. Be conservative with dates.

---

## [14] Progress Snapshot · Let's Keep Building (final page)

**Purpose:** Closing CTA + audit scope summary. Contact email, two headline scores, "Keep Building →" button, and a compact scope-of-audit strip (what was tested — NO query list).

**Required elements:**
- Eyebrow: "Progress Snapshot"
- Hero-size title: "Let's keep building." with "building." in orange
- Subtitle: one-paragraph forward-looking framing
- Filled orange "Keep Building →" CTA
- Right rail: 2 big-number rows (Current Health Score, Current AI Mentions) — NO "Projected Visibility Increase" — then "Get In Touch" with hello@bordlabs.ai and the prepared-for byline

**Voice:**
- Forward-looking, collaborative. Not a hard sell.
- Scope summary on the left column (below CTA button): 3-stat row (N Category Queries · 4 Answer Engines · {{COMPANY_DOMAIN}}) + verticals-audited chip row. Up to 4 chips. NEVER include the verbatim query list — that is internal.
