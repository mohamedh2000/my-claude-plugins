---
name: visibl-company-report
version: "1.0.0"
description: Generate a detailed AEO + SEO visibility diagnostic report for a target company in Visibl's Paper/Ink design language. Outputs HTML + PDF. Use when the user asks for "a company report", "AE report", "Visibl report on X", "diagnostic on X", or "research [company] for our platform". Produces a 14-page landscape diagnostic suitable for handing to an account executive.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - WebSearch
  - WebFetch
  - AskUserQuestion
  - Task
---

# Visibl Company Report

Generate a Visibl-branded AEO/SEO visibility diagnostic for a single target company. External research only — this skill does NOT read Visibl workspace data. It's designed for prospect research where the target company is not yet in a Visibl workspace.

Output: a self-contained HTML file (browser-native) and a PDF sibling, both written to `~/Desktop/{Company-slug}-Visibl-Report/`.

---

## When to use

- AE needs to walk into a meeting with a researched report on a prospect
- Sales wants to send a "we noticed these gaps in your AI visibility" leave-behind
- Marketing wants a template diagnostic for outbound content
- Any time you see "can you make a Visibl report on X" or "AE report for {company}"

## When NOT to use

- The target company is already in a Visibl workspace with real scan data → use the Intelligence Hub instead (richer, real pipeline data, not external proxies)
- You only need the executive summary, not the full 14-page report → write it directly, don't run this skill

---

## Hard rules (non-negotiable)

1. **The rendered report is a CLIENT-FACING pitch, not an internal audit.** This report is sent by an AE directly to the prospect. Voice rules (see "Voice: soft pitch" below) apply to pages 1-13 and 14. Methodology-style content (scope summary) now lives as a compact strip on page 14 (Progress Snapshot CTA) — it does NOT get its own page. The query list is never shown to the client.

2. **Platform jargon is BANNED in rendered prose.** Never write the name of the target's CMS, storefront, framework, or hosting platform anywhere in a visible page. No "Shopify", "WordPress", "Webflow", "Wix", "Squarespace", "Next.js", "Nuxt", "Gatsby", "BigCommerce", "Magento", "WooCommerce", "PrestaShop", "Contentful", "Sanity", "Strapi". No internal-research jargon either: no "SSR", "client-rendered", "crawl posture", "schema posture", "audit posture", "Puppeteer", "headless Chrome", "JSON-LD" (use "schema markup" instead). Investigation-file notes can use these terms; the rendered report cannot. See the full blocklist in the post-render leak scan.

3. **The template is STRUCTURE ONLY. 100% of prose, numbers, queries, and findings in the final report MUST be generated from the investigation file — NOT copy-pasted from the template.** The Good Culture prose baked into `templates/report.html` is layout scaffolding to show you what shape each page takes. It is NOT a fallback to leave in place. A render that outputs the phrase "One-line hero statement from the company's homepage, verbatim" or a query containing `{CATEGORY}` / `{TARGET_CUSTOMER}` / `{INCUMBENT}` is a BUG — those are template guidance markers, not content. Replace every such marker with real, target-specific content sourced from research.

4. **Queries are vertical-specific and verbatim.** Category queries run during research must be the ACTUAL queries each agent executed — fully materialized, no placeholder curly-braces. These queries stay INTERNAL to the investigation file; they are NOT rendered in the client-facing report (the query list was removed from page 14 in the 2026-04-17 redesign — clients see scope counts, not the raw queries). No `{VERTICAL_CATEGORY}` placeholders. No generic "best X brands" filler.

5. **Never fabricate data.** If research came up thin on a specific data point, drop it entirely from the rendered report. The scope-summary strip on page 14 is the only visible surface describing what was audited — keep it accurate (actual vertical count, actual query count).

6. **Never change the page structure.** 14 pages, in order, every time. See `templates/section-structure.md`.

7. **Never change the design tokens.** The :root block in `templates/report.html` IS the Visibl Good-Culture identity. Don't introduce new colors, fonts, or card types. No dark cards. No gradient backgrounds. No violet/indigo. If you think a new component is needed, the answer is: use an existing one.

8. **Brand-name queries don't count.** "What is {{company}}" returning {{company}} is not AEO signal. The scorecard tracks category-discovery queries only.

9. **Cite every named data point.** In the investigation files, every fact traces back to a source URL. If you can't cite it, drop it.

10. **All findings go on disk first.** Research agents persist to `~/.claude/investigations/visibl-report-{slug}.md` before the render step reads them. No research kept only in context.

11. **No clickable-looking elements anywhere in the report.** The deliverable is a static PDF + HTML share link — neither surface supports clicks on `<button>` or `<a class="cta-pill">` elements in a useful way. Do NOT include:
    - `<a class="cta-pill">` or any button-shaped "View scorecard →" / "Keep Building →" / "Read full report →" element on the cover, path-forward, or CTA pages
    - Any element styled as a pill, button, or link-with-arrow that implies the reader should click it
    Instead, use quiet transitional copy styled as text — e.g. `<div class="eyebrow-muted">Let's deep dive below ↓</div>` or `<p class="footnote">Continue to the Executive Summary →</p>`. A cover page whose last visible element is a static sentence or eyebrow-muted line is correct; a cover page with an orange pill button is a bug.

---

## Voice: soft pitch (pages 1-13 + 14)

The report is a conversation with the prospect. Not a lab report. Five rules, applied to every page of body copy. The scope-summary strip at the bottom of page 14 is the ONLY exception (stays neutral/analytical, see below):

1. **Address the reader as "you" / "your brand" / "your site".** Never refer to the target company in third person in body copy (headlines can use the company name for positioning; findings must switch to "you").
2. **Frame findings as opportunities, not deficiencies.** "Schema is one of the quickest ways to unlock AI readability" beats "Missing Core Entity Markup: CRITICAL GAP."
3. **Every page ends on an implication.** The last finding or paragraph hints at what to do about it, without explicitly naming Visibl (the sell is implicit). Visibl is named only on the Cover, Path Forward (page 12), and CTA (page 14).
4. **Numbers stay blunt; language around them softens.** "0 of 8 category queries cited your brand" is fine. Wrap it with "This is the biggest single opportunity on the page — and the one that moves the visibility score fastest."
5. **Emphasis words in `<strong>` are phrased as insights, not alerts.** "…but AI engines don't know it exists yet" not "…CRITICAL VISIBILITY GAP."
6. **Tension Rule — name the vulnerability, don't hide it.** "Frame as opportunity" (rule 2) does NOT mean "say everything is fine." This report is sent to convince a prospect they need help. If the company is already doing well on some metric but weak on another, the job of the Executive Summary is to NAME that gap as a defensibility risk, not to celebrate the strength. The specific trigger:

   **If Visibility Score ≥ 70% AND Health Score ≤ 65, the Executive Summary's lead finding MUST explicitly tie the two together and frame the lead as fragile.**

   Template sentence shapes (pick one, adapt to the company):
   - "Your brand is cited at {vis}% today — but that lead sits on a {health}/100 foundation. A competitor with {N} targeted schema additions could close the gap in {timeframe}."
   - "The visibility is real; the defensibility isn't. {Specific-weakness} means the {vis}% citation share can be copied faster than it was earned."
   - "{Company} leads today, but {specific gap} is what competitors will attack — and {specific gap} is the cheapest thing in AI marketing to fix."

   Every page after the Exec Summary should echo this frame somewhere: the lead is real, the lead is vulnerable, here's what fixes it. A prospect reading this should close the PDF thinking "we need to move fast" — not "we're doing fine."

**Page 14 exception:** the scope-of-audit strip embedded inside the CTA page stays neutral and analytical — it's the credibility anchor. Active voice, completed-work framing, no hedging, but ALSO no second-person "you" addressing. Example methodology line: "Ran 4 category queries across ChatGPT, Perplexity, Gemini, and Claude on 16 April 2026." — not "We ran queries to see where your brand shows up."

**Platform-agnostic rewrite examples (apply these patterns every time):**
| Jargon-y (banned) | Soft-pitch (use instead) |
|---|---|
| "clean Shopify stack" | "clean site architecture" |
| "Shopify storefront with ~1,080 product URLs" | "~1,080 product pages indexed" |
| "Clean Shopify-default crawl posture" | "Your site is well-configured for search — sitemaps are published, your robots file welcomes AI crawlers" |
| "Organization (Shopify default)" | "Organization" |
| "Shopify-default entity blocks likely present" | "Baseline identity markup is present" |
| "sitemap.xml fans out to …" | "Your sitemap covers …" |
| "WebFetch returned <3KB, Puppeteer-rendered via headless Chrome" | (do not mention at all in rendered prose) |
| "JSON-LD" | "schema markup" |
| "SSR / client-rendered" | (do not mention at all in rendered prose) |

---

## Workflow

### Phase 0 · Brief

**Default behavior: run autonomously.** Do NOT ask clarifying questions when the user provides a URL or company name. This skill must work end-to-end without human interaction because it will eventually be called by a background worker (Chrome extension → SQS queue → headless runner) where there is no human to answer prompts. Asking questions when you already have what you need is a bug, not caution.

**ONLY ask a question if:**
- No URL or company name was provided AT ALL (the one and only required input). In that case, ask a single question for the URL. Nothing else.

**Everything else uses defaults — derive, never prompt:**

| Input | Default (use unless user explicitly overrode in their invocation) |
|---|---|
| Strategic angle | Balanced (equal AEO + SEO weight) |
| Page depth | Full (14 pages, Good-Culture taxonomy) |
| AE name | "Visibl Team" |
| Competitor set | Auto-derive during Agent 2 research (do not pre-seed) |
| Report date | Today, formatted as the template expects (`MON DD, YYYY` for the cover snapshot eyebrow, `DD Month YYYY` for byline) |
| Accent word | "Visibility" (for hero title). Swap to "AI", "Citation", "Answer", or "Search" only if the category strongly demands it. |

**Only re-ask if the user themselves explicitly said something like "ask me about X first" in their invocation.** Otherwise: defaults are law.

**Derive these values from the URL/name input without asking:**
- `{{COMPANY_NAME}}` — from URL (`auravinyl.com` → "Aura Vinyl") or explicit name input. Title-case.
- `{{COMPANY_NAME_ACCENT}}` — the ONE word rendered in orange in the cover hero (e.g. "Visibility" in "Good Culture Visibility Review"). Stays as a separate token in the template so you can swap it thematically without hand-editing HTML.
- `{{COMPANY_DOMAIN}}` — strip scheme + www (e.g. "https://www.auravinyl.com/" → "auravinyl.com").
- `{{COMPANY_SLUG}}` — lowercase, hyphenated (e.g. "aura-vinyl").
- `{{REPORT_DATE}}` — today. Cover snapshot uses `MAR 20, 2026` format; byline on page 14 uses `16 April 2026` format. Same date, two formats.
- `{{AE_NAME}}` — "Visibl Team" fallback.

### Phase 1 · Research (3 parallel agents · speed-tuned for ≤10 min total runtime)

Read `templates/research-briefs.md` first — it contains the exact scope and deliverable shape for each agent.

**HARD SCOPE LIMITS (non-negotiable — the target runtime is 10-12 min end-to-end):**

| Constraint | Value |
|---|---|
| Max verticals audited | **4** (cap at 4 even if sitemap exposes more — pick the 4 most strategic by traffic/category importance) |
| Queries per vertical | **4** (down from 8 — still enough for SoV scoring with acceptable variance) |
| Competitors profiled | **3-4** (page 10 grid shows the 3-4 most cited; skip "emerging" tier to save time) |
| Research agent model | **Haiku** (`model: claude-haiku-4-5` — ~3× faster than Sonnet/Opus for tool-use research, rate-limit-friendly) |
| Render model | Sonnet/Opus (your default) — the 14-page render is where quality matters most |

**Phase transition MILESTONE markers (print exactly as shown, on their own line):**
The worker parses stdout for these strings to surface progress to the AE in Discord. Print them at the exact moments named:

- `[[MILESTONE: research-started]]` — immediately after spawning the 3 research agents
- `[[MILESTONE: research-done]]` — after the research gate passes (all 3 agents complete + investigation file verified)
- `[[MILESTONE: render-started]]` — before starting HTML render (Phase 2)
- `[[MILESTONE: render-done]]` — after HTML file is written to Desktop
- `[[MILESTONE: pdf-done]]` — after Chrome print-to-PDF completes

These must appear on their own line with nothing else, so the worker's regex matches cleanly. Don't explain or annotate them inline.

**TRUE-PARALLEL SPAWN — the single most important rule in Phase 1.**

In a prior Caraway run, subagent finish times were 22:57 / 22:59 / 23:17 — staggered, not parallel. Research took 29 minutes instead of ~10. The fix is enforced by the mechanic below; if you deviate, research cost doubles.

**Required mechanic:** after emitting `[[MILESTONE: research-started]]`, your very next assistant message MUST contain exactly **three `Task` tool_use blocks and nothing else between them**. No prose. No TodoWrite. No Read. No intermediate reasoning. Three Task calls, issued as one message. The Claude Code runtime will execute them concurrently only when they appear in the same message — any prose or non-Task tool call between them serializes the next Task.

If you find yourself tempted to write "let me spawn Agent 1 first, then check its output" — stop. That pattern produces the 29-minute regression. All three agents must go out together; you aggregate only after all three return.

Spawn:

- **Agent 1 · Company Profile** (`subagent_type: researcher`, model: haiku)
- **Agent 2 · AEO Signals** (`subagent_type: researcher`, model: haiku)
- **Agent 3 · SEO Signals** (`subagent_type: researcher`, model: haiku)

Each agent gets:
- The research brief text for its section
- The target company name + URL
- The scope limits above (max 4 verticals, 4 queries per vertical, 3-4 competitors)
- Mandatory `## Status` section updated as the agent works
- **Per-agent investigation file paths (separate files — avoids the `block-write-existing.sh` hook collision seen when all three wrote to the same file):**
  - Agent 1 → `~/.claude/investigations/visibl-report-{{COMPANY_SLUG}}-company.md`
  - Agent 2 → `~/.claude/investigations/visibl-report-{{COMPANY_SLUG}}-aeo.md`
  - Agent 3 → `~/.claude/investigations/visibl-report-{{COMPANY_SLUG}}-seo.md`

After all three return, the orchestrator concatenates the three files into the aggregate `~/.claude/investigations/visibl-report-{{COMPANY_SLUG}}.md` for the render phase to read.

**Vertical-aware scoping — this is critical.** Before the three research agents spawn, the orchestrator MUST:
1. Fetch `{{COMPANY_DOMAIN}}/sitemap.xml` (and any child sitemap indices it points to)
2. Parse out the distinct top-level verticals the site exposes
3. **Cap the list at 4 verticals**, ranked by strategic importance (main product > comparison-value verticals like academy/wholesale > support/help > blog). Skip operational paths (cart, account, checkout, policies, legal)
4. Pass the capped vertical list to all three research agents so they scope work to those 4 surfaces only

Agent 2 (AEO Signals) generates **vertical-specific query sets**: the main catalog gets "best car wrap brands" queries, the academy gets "best vinyl wrap training" queries, the wholesale vertical gets "wholesale wrap film distributors" queries. A single-vertical query set leaves half the business invisible.

Agent 3 (SEO Signals) MUST use **Puppeteer/headless Chrome** when a content page returns less than ~3KB of HTML (typical Shopify / Next.js JS shell). The `curl` or `WebFetch` tool alone misses content that's client-rendered. The fallback sequence:
1. First try `WebFetch`
2. If response body is <3KB OR lacks expected content markers, spawn headless Chrome: `/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --headless --disable-gpu --dump-dom "{url}" > /tmp/rendered.html`
3. Extract text from rendered HTML
4. Record which URLs required JS rendering in the investigation file

**Wait for all 3 agents to return** before proceeding. Do NOT start rendering with partial data.

**Research gate (hard stop):** Before Phase 2, read the investigation file. Verify:
- All 3 sections (`## Agent 1`, `## Agent 2`, `## Agent 3`) are present and have `Status: complete` lines
- Every named data point has a source URL
- No "TODO" or placeholder strings remain

If the gate fails → report to the user which agent came back thin and ask whether to re-run that agent, relax the rubric, or abort. Do not render.

### Phase 2 · Render HTML

1. Read `templates/report.html` — the structural template. Read it each time; don't paraphrase from memory. **Treat every piece of prose in the template as example/placeholder content that MUST be replaced.** The Good Culture copy is there to show you what shape each page takes — it is not fallback content.
2. Read `templates/section-structure.md` — the contract for what each page must contain, including the data-source requirements.
3. Read `templates/design-tokens.css` — the color and type system. These values are already embedded in `report.html`; this file is a reference.
4. Read the full investigation file at `~/.claude/investigations/visibl-report-{{COMPANY_SLUG}}.md` BEFORE starting to write. All page content must trace to findings there.

**Pre-render gate — MUST pass all of these before writing any HTML:**

| Check | How to verify |
|---|---|
| Sitemap scan produced a vertical list | Investigation file has an explicit `## Verticals` section with 2+ URL patterns |
| Agent 2 generated per-vertical query sets | For each vertical, investigation file has 8 real queries (no `{CATEGORY}` / `{TARGET_CUSTOMER}` placeholders) |
| Per-vertical citation counts exist | Each vertical has a result block showing which of its 8 queries got cited vs which didn't |
| Schema audit has per-type results | Investigation file lists each schema type (Organization/WebSite/FAQPage/Service/Review/CollectionPage) as Present or Not Detected, with a cited source line (SSR HTML or Puppeteer-rendered) |
| Competitor set is named | At least 4 real competitor names with cited visibility numbers — no "Competitor A/B/C" placeholders in the final report |
| Sitemap metrics are concrete | Indexed Sitemaps count, Internal Links, H1 Headings, Homepage Size — all actual numbers from fetched data |

If ANY of these fails → pause the render, report which check failed, and ask the user to re-run the agent or accept degraded output. Do NOT proceed with placeholder prose.

**Rendering process — deterministic template substitution (NOT raw HTML generation):**

The template `templates/report.html` contains **19 `{{TOKEN}}` placeholders**: 5 global tokens (`COMPANY_NAME`, `COMPANY_NAME_ACCENT`, `COMPANY_DOMAIN`, `REPORT_DATE`, `AE_NAME`) and 14 `PAGE_N_BODY` tokens — one per page. The CSS block, page-header/page-footer chrome, @page rules, @media print rules, and mobile responsive block are all STATIC and do NOT change per company.

Your job in Phase 2 is to produce a `values.json` file (NOT to write HTML directly). The json has the 19 keys listed above; each value is the content that slots into its placeholder:

- `COMPANY_NAME`, `COMPANY_NAME_ACCENT`, `COMPANY_DOMAIN`, `REPORT_DATE`, `AE_NAME` — simple strings
- `PAGE_1_BODY` through `PAGE_14_BODY` — HTML fragments for each page's body (the inner content of `<div class="page-body ...">`, everything between that opening div and its closing `</div>`)

Each `PAGE_N_BODY` value is HTML you author using the primitives already defined in the template's CSS: `.eyebrow`, `.hero`, `.h1`, `.h2`, `.subtitle`, `.split-5-5`, `.findings`, `.finding`, `.finding-title`, `.finding-body`, `.finding-badge`, `.stat-grid-2`, `.stat-cell`, `.big-stat`, `.small-stat`, `.bar-row`, `.schema-row`, `.schema-bar-track`, `.schema-bar-fill`, `.comp-grid`, `.comp-row`, `.rec-grid-4`, `.chip`, `.path-chips`, `.timeline-row`, `.snapshot-row`, etc. Do NOT invent new classes. Do NOT inline CSS. Do NOT add `<style>` blocks — all styling is in the template.

**Step-by-step:**

1. Author `values.json` in the output directory. Structure:
   ```json
   {
     "COMPANY_NAME": "Caraway Home",
     "COMPANY_NAME_ACCENT": "Visibility",
     "COMPANY_DOMAIN": "carawayhome.com",
     "REPORT_DATE": "APR 18, 2026",
     "AE_NAME": "Visibl Team",
     "PAGE_1_BODY": "<div>\\n  <div class=\\"eyebrow\\">AI Visibility Progress Report</div>\\n  ...</div>",
     "PAGE_2_BODY": "<div class=\\"split-5-5\\">\\n  <div>\\n    <div class=\\"eyebrow\\">The Bottom Line</div>\\n    <h1 class=\\"h1\\">You lead cookware — <strong>but the rest of your catalog is invisible</strong></h1>\\n    ...\\n  </div>\\n  <div class=\\"findings\\">...</div>\\n</div>",
     ...
   }
   ```

2. Invoke the renderer via Bash to substitute placeholders into the template and produce the final HTML:
   ```bash
   node /Users/husseinmohamed/my-claude-plugins/visibl-company-report/templates/render.mjs \
     /Users/husseinmohamed/my-claude-plugins/visibl-company-report/templates/report.html \
     {OUTPUT_DIR}/values.json \
     {OUTPUT_DIR}/{slug}-visibility-report.html
   ```
   The renderer exits non-zero if any `{{TOKEN}}` is missing from `values.json` or if any placeholder remains unresolved after substitution. On failure, you MUST fix `values.json` and re-run — do NOT Write the HTML file directly as a workaround.

3. Apply the Voice rules (soft pitch + Tension Rule) WHEN AUTHORING THE VALUES — not after render. Each `PAGE_N_BODY` HTML fragment should already be in soft-pitch voice before it goes into the JSON.

**Why this matters:**
- Render phase drops from ~10 min (generating 63 KB of HTML) to ~2 min (generating ~20 KB of JSON values).
- The CSS scaffold stops drifting — fixes like the `@media print body margin reset` and the mobile responsive block are preserved by design because the LLM never touches CSS.
- Placeholder coverage is enforced: the renderer verifies every token in the template has a matching value.

Do NOT introduce new components in the `PAGE_N_BODY` fragments (dark cards, new card grids, new color accents). The Good-Culture aesthetic is intentionally restrained — all uniformly light on dotted cream, orange only for eyebrows/accent words/CTAs, green/amber/red only for metric values on bar rows.

**Page-by-page data source check — each page names its required research inputs:**

| Page | Required data from investigation file | What to write |
|---|---|---|
| 01 Cover | Visibility Score (%), Health Score (/100), Indexed Sitemaps count, count of Missing Schema Types, category leader name | 4 snapshot stat rows — real numbers, not "63.7%" copied from template |
| 02 Executive Summary | Visibility Score, Health Score, Buy Zone Placement %, Gap-vs-leader delta, 4-5 prioritized findings | One-sentence diagnosis specific to the target. The `<strong>` emphasis clause names the actual competitive context (e.g. "but still trails Daisy" not "but still trails the leader") |
| 03 Company Snapshot | Positioning one-liner from Puppeteer-rendered homepage, founding year + HQ, named clients (real list, count), disambiguation entities | Write the actual positioning sentence from the site. Name real clients if public. |
| 04 Sitemap & Discoverability | Actual sitemap.xml parse (indexed count, URL count), internal-link count, H1 count, homepage size KB, category-leader sitemap figures | 4 bar rows with REAL numbers. The "Top Competitor" finding names the real competitor and their real sitemap count. |
| 05 Schema | Per-schema-type findings from SSR + Puppeteer scan (Organization/WebSite/FAQPage/Service/Review/CollectionPage) | Green bar ONLY for schema types actually detected. Grey "Not Detected" for missing. Don't invent Present/Missing status. |
| 06 Content Depth | Total page count from sitemap, blog post count, service page count, avg word count (sampled). Competitor ranking data from Agent 2. | Named competitors in the ranking table. Real word counts. |
| 07 AI Bot Access | Actual robots.txt contents + per-bot rule status (GPTBot, PerplexityBot, ClaudeBot, Google-Extended, CCBot, Bytespider) | Raw robots.txt line IS the footnote. Per-bot IMPLICIT/ALLOW/DENY is determined by parsing real directives. |
| 08 Query Gap | **Vertical-specific query sets** — for each vertical the site exposes, show 8 real queries + which got cited vs lost. If the site has N verticals, this page shows N × 8 query slots total. | Queries are verbatim, specific to the target's actual segments (e.g. "best high-protein cottage cheese brands 2026" for Good Culture, not "best {CATEGORY} brands"). Winning/Lost labels come from actual cite results. |
| 09 Citation Gap | Owned vs third-party vs competitor-owned citation counts from Agent 2's per-query results | Real cite counts on the bar rows. 3 findings (Current State / Recommended Fix / Competitive Signal) all reference concrete data. |
| 10 Competitive Landscape | 4-6 real competitor names with their visibility scores + positioning + recent-moves | NO "Competitor A/B/C". Name each. Pull real taglines from their homepages or category listings. |
| 11 Answer Gap | Specific page-type gaps identified in Agent 3 + Agent 2 (comparison pages missing, explainers missing, FAQ gaps, proof pages) | 4 recommendation cards. Each title is a specific page type (e.g. "Comparison Pages"). Each body explains WHY this target specifically needs it. |
| 12 Path Forward | Current state (what audit confirmed), 30-day next-sprint items (from Answer Gap recommendations), 60-90d monitoring items | Chip labels describe target-specific actions (e.g. "FAQ pages for cottage cheese shoppers" not "FAQ / educational content") |
| 13 Next Steps | Target-appropriate timeline derived from Path Forward + audit urgency signals | 4 timeline items with concrete week-level dates |
| 15 CTA | Projected visibility increase (from Path Forward), current health score, current AI mentions count | "Let's keep building." stays. Accent word on "building" stays. Numbers on right rail are real. |

**Post-render leak scan — BEFORE writing the file to disk, grep the rendered HTML for these anti-patterns. If any match, FIX them before writing:**

```
─── Placeholder leaks (template markers that weren't replaced) ───
  {CATEGORY}             — unreplaced research-brief placeholder
  {TARGET_CUSTOMER}      — ditto
  {INCUMBENT}            — ditto
  {ADJACENT_CATEGORY}    — ditto
  {GEO}                  — ditto
  {KEY_CAPABILITY}       — ditto
  {YEAR}                 — use the actual year
  {VERTICAL_CATEGORY}    — ditto
  {SEGMENT}              — ditto
  {CONSUMER_TYPE}        — ditto
  {BRAND_ATTRIBUTE}      — ditto
  COMPETITOR_NAME_1..5   — replace with the 5 real competitor names from Agent 2
  COMPETITOR_NAME_       — any leftover marker means you forgot one
  "RENDER:" (in visible output)  — HTML comment guidance text rendered accidentally
  "An unanswered or under-owned AI query"                — old template filler
  "Current strong query. ... ranks at position #2 here"  — old template filler
  "Write the actual positioning sentence"                — template guidance leaked
  "One-line hero statement from the company's homepage"  — template guidance leaked

─── Platform-name leaks (CMS / storefront / framework) ───
  Shopify, shopify, Shopify-default
  WordPress, wordpress, WP, wp-admin
  Webflow, webflow, webflow.io
  Wix, wix.com
  Squarespace, squarespace
  Next\.js, NextJS, next\.js
  Nuxt, nuxt\.js
  Gatsby, gatsbyjs
  BigCommerce, Magento, WooCommerce, PrestaShop
  Contentful, Sanity(?!zed), Strapi       (word-bounded — avoid false-matches on "sanity")
  Ghost CMS, Drupal, Joomla
  \bReact\b, \bVue\b, \bAngular\b, \bSvelte\b      (word-bounded — these words are OK in prose that's NOT describing the site's stack, but the leak scan flags ALL occurrences and you manually confirm)

─── Internal research jargon leaks ───
  SSR, client-rendered, server-rendered
  crawl posture, schema posture, audit posture
  Puppeteer, headless Chrome, headless chrome
  JSON-LD           (use "schema markup" in prose)
  WebFetch, WebSearch    (tool names — internal)
  sitemap\.xml fans out, fan-out
  entity blocks likely present   (template leak phrase)
```

The leak scan is a `grep -E` run over the rendered HTML (content outside `<!-- -->` blocks). A single match means the render is incomplete — fix the offending passage and re-emit before saving to disk. HTML comments containing these terms are fine (they're guidance to future you).

This leak scan is mandatory. Think of it as a compile step — no output ships with these strings present.

### Phase 3 · Render PDF

Attempt Chrome headless print-to-PDF. The template uses a landscape widescreen page size (15in × 9.4in, defined in the embedded `@page` rule), so Chrome picks that up automatically — the command itself doesn't need a page-size flag.

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
OUT_HTML="$HOME/Desktop/{{COMPANY_NAME}}-Visibl-Report/{{COMPANY_SLUG}}-visibility-report.html"
OUT_PDF="${OUT_HTML%.html}.pdf"

if [ -x "$CHROME" ]; then
  "$CHROME" \
    --headless --disable-gpu \
    --no-pdf-header-footer \
    --print-to-pdf-no-header \
    --print-to-pdf="$OUT_PDF" \
    "file://$OUT_HTML"
else
  echo "Chrome not found — HTML generated but PDF skipped."
fi
```

Acceptance:
- PDF opens in Preview at the intended 15in × 9.4in landscape page size
- Each of the 15 pages renders as ONE PDF page — no mid-page breaks
- Dotted paper background renders on every page (no banding, no missing dots)
- Accent orange, status greens/amber/red are color-faithful (matches the Good Culture reference)
- No browser chrome / URL footer bleed into the PDF (enforced by `--no-pdf-header-footer`)

If PDF fails for any reason → keep the HTML, report the failure, don't retry silently.

### Phase 4 · Output location + open

**Output directory:** `~/Desktop/{{COMPANY_NAME}}-Visibl-Report/`

Files produced:
- `{{COMPANY_SLUG}}-visibility-report.html`
- `{{COMPANY_SLUG}}-visibility-report.pdf` (if Chrome available)

After rendering:
```bash
open "$OUT_HTML"
```

### Phase 5 · Summarize to user

Chat reply is 4-6 lines max:
- Company analyzed
- 14 pages rendered (Good-Culture taxonomy)
- File paths (click to open)
- Accent word used on the cover (e.g. "Visibility")
- Verticals audited (chips on page 14)

---

## Degradation modes

| Situation | Behavior |
|---|---|
| Chrome not installed | HTML still generated; PDF skipped; user warned |
| WebFetch blocked by target's robots.txt | Fall back to WebSearch cached snippets; flag in Section 10 |
| Research agent returns thin | Prompt user to decide: re-run / relax / abort. Never proceed silently. |
| User provides no AE name | Render "Visibl Team" as fallback byline |
| Company name is ambiguous (e.g. "Remix") | Confirm target domain in Phase 0 before researching; note disambiguation in Section 02 |

---

## Files this skill reads

- `templates/report.html` — structural template with 5 placeholder tokens
- `templates/section-structure.md` — per-section contract
- `templates/research-briefs.md` — per-agent scope + rubric
- `templates/design-tokens.css` — color/type reference

## Files this skill writes

- `~/.claude/investigations/visibl-report-{{COMPANY_SLUG}}.md` — research findings (append-only by 3 agents)
- `~/Desktop/{{COMPANY_NAME}}-Visibl-Report/{{COMPANY_SLUG}}-aeo-seo-gap-report.html`
- `~/Desktop/{{COMPANY_NAME}}-Visibl-Report/{{COMPANY_SLUG}}-aeo-seo-gap-report.pdf`

---

## v2 (future, out of scope)

- Detect if target company is in a Visibl workspace; if yes, pull internal pipeline data
- Swap the external AEO proxy for real pipeline AEO scores
- Add a GSC/GA4/Ahrefs data-enrichment path when the AE supplies credentials
- Produce an email-ready summary alongside the HTML + PDF
