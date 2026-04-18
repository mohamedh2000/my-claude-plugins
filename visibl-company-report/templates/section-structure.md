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
- **Lead on vulnerability, not victory.** If Visibility ≥ 70% AND Health ≤ 65, the H1 and the first finding MUST explicitly tie the two numbers and frame the lead as fragile. See SKILL.md "Tension Rule" for exact sentence patterns.
- Sample H1 when tension applies: "Your brand is cited at 81% today — but <strong>that lead sits on a 55/100 foundation competitors can copy</strong>."
- Sample first finding title: "Visibility Dominance Built on Thin Schema — Easy to Replicate" (not "Category Leader in AI Citations").
- NEVER use H1 phrases like "already winning", "locking in the lead", "dominant". Those signals close the sale; they don't open it.

---

## [03] How AI Identifies You

**Purpose:** Show what large language models ALREADY know about the target — AND what they don't. The gap between the two is where the prospect is losing today's category conversations.

**Required elements:**
- Eyebrow: "How AI Identifies You"
- H1: frame what AI sees as partial/incomplete. Example: "AI engines can only partially identify {{COMPANY_NAME}} — <strong>and the gaps competitors are filling</strong>"
- Positioning one-liner pulled verbatim from the homepage hero (label it "Positioning AI repeats")
- 2-stat row: Named Proof AI Can Cite (count of public logos/case-studies/press), Disambiguation Risk (count of same-named entities)
- Right rail: 4 findings (Product, Customer, Proof, Recent Motion). At least one finding should name an identity gap — something AI should see about this brand but can't.

**What NOT to include:**
- Founding year, HQ city, employee count, funding history — none of that shapes AI retrieval. Keep the page focused on identity signals AI actually uses.
- DO NOT frame this page as "here's your company bio." Frame it as "here's what AI sees and where the holes are."

**Voice:**
- Only cite facts verifiable on the public site.
- Drop anything unverifiable — don't flag it in this section.
- Lead with gap, not accomplishment. Example finding: "Named Customer Proof — AI Engines Cite 3 of Your 10 Retail Partners" rather than "10 Major Retail Partners Verified."

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

**Purpose:** Phased roadmap. What's done vs what's next vs what's ongoing. The emphasis is that today's score is the FLOOR, not the ceiling — and that without the "Next Sprint" column the score goes backwards as competitors catch up.

**Required elements:**
- Eyebrow: "The Path Forward"
- H1 framed as durability, not victory. Good: "Turn {vis}% visibility into a <strong>durable lead</strong>." Bad: "63.7% → 72%+. Now make it durable." (implies "we already made it, just lock in").
- 3 path rows: Current Snapshot (Now), Next Sprint (30 Days), Monitoring (60-90 Days). Each row shows 4-5 chip pills.
- "Done" chips use a green dot + muted ink text. Future chips use an orange dot + normal ink text.

**Voice:**
- Phase names are platform-consistent. Don't invent new phase labels.
- The "Now" column lists what's ALREADY in place (crawlable site, brand recognition, etc.) and calls it a **foundation** — never a **lead** or **advantage**. The second column is what converts foundation into lead.

---

## [13] Next Steps

**Purpose:** Concrete suggested timeline that an AE can put in a proposal or SOW. The page also names the cost of NOT acting — competitors close gaps fast in AEO.

**Required elements:**
- Eyebrow: "Next Steps"
- H1 frames the work as securing fragile ground. Example: "Your visibility lead is <strong>fragile</strong> — the next 90 days decide whether it becomes a market position or evaporates."
- Right rail: "Suggested Timeline" with 4 timeline rows. Each: name, when (colored orange for this-quarter, green for next-quarter), and a filled progress track.

**Voice:**
- The timeline implicitly commits Visibl. Be conservative with dates.
- Never say "lock in the lead". Say "turn it into durable position", "protect it before competitors copy it", "convert visibility into defensibility." The lead is not owned yet; the client still has to earn it.
- Timeline entries start at "Next 30 Days" — do not include "This Week" or "Week of April X" rows; those are too soon for typical AE-to-prospect engagement timing.

---

## [14] Progress Snapshot · Let's Keep Building (final page)

**Purpose:** Closing note. Contact email + one headline health score + the forward-looking framing. This is a PDF deliverable so nothing clickable, nothing that duplicates data already shown earlier in the report.

**Required elements:**
- Eyebrow: "Progress Snapshot"
- Hero-size title: "Let's keep building." with "building." in orange
- Subtitle: one-paragraph forward-looking framing. Subtitle must call back to the Tension Rule — reference the fragility of the current position and the window to act — not "you're already winning, we'll help you lock it in."
- Right rail: 1 big-number row (Current Health Score only) + "Get In Touch" block with hello@bordlabs.ai and the prepared-for byline

**What NOT to include:**
- No "Keep Building →" button or any other button — the deliverable is a PDF and buttons don't function.
- No "Current AI Mentions" stat — already shown in the Executive Summary scorecard.
- No "Scope of this audit" strip — duplicates data shown elsewhere and adds no new insight for the client.
- No "Projected Visibility Increase" — projections are not claimed anywhere in the report.

**Voice:**
- Forward-looking, collaborative. Not a hard sell.
- Short. The page is mostly whitespace by design — a quiet closing beat after 13 data-dense pages.
- Sample subtitle when tension applies: "You have the foundation to lead category AI conversations — but that foundation is exposed. The next 60-90 days decide whether visibility becomes defensibility. Here's how we get there together." (Not: "You already lead the category. The next move locks that in.")
