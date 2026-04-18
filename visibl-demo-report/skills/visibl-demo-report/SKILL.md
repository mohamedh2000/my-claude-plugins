---
name: visibl-demo-report
version: "1.0.0"
description: Generate a DEEP Visibl AI Visibility diagnostic report for live client demos. Same Good-Culture visual design as visibl-company-report, same 14-page structure, SAME deterministic render flow (values.json + render.mjs), but denser content per page — 15-recommendation 4-phase roadmap (R01-R15 with effort/impact badges), per-query detail table, 24-block per-competitor comparison (6 stats x 4 competitors). Trigger when user asks for "a demo report", "a client demo deck", "Visibl demo report on X", "deep visibility report for X", "detailed report for the demo call".
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

# Visibl Demo Report

This is the **deep-detail** sibling of `visibl-company-report`. It shares the Good-Culture visual design (cream paper, ink, orange accent, Inter + JetBrains Mono, no dark cards) but structurally diverges: the demo report is a **continuous-flow document** with 1 cover + 10 numbered sections, not a fixed 14-page landscape deck. Sections are whatever length their content demands; PDF pages break at section boundaries and auto-paginate inside long sections.

Trigger cases:
- AE has a live client demo scheduled and wants a report they can walk through on screen for 20-30 minutes
- Prospect is further down funnel and expects a detailed deliverable, not a scorecard
- Internal stakeholder review

Runtime target: **20-25 min end-to-end** (research ~4 min unchanged; render grows from ~10 min to ~15-18 min because each page has more LLM-authored detail).

Read these template files before Phase 2:
- `templates/report.html` — continuous-flow document template, Good-Culture styling. 16 placeholders total (5 global + `COVER_BODY` + `SECTION_01_BODY` through `SECTION_10_BODY`). Static CSS scaffold. Do NOT modify.
- `templates/render.mjs` — deterministic substituter, same logic as AE skill.
- `templates/placeholder-catalog.md` — authoritative 16-token reference + all available CSS primitives.
- `templates/section-structure.md` — per-section content contract. Read carefully; shape of each `SECTION_NN_BODY` is defined here.
- `templates/research-briefs.md` — research agent scope. Same 3 agents, same deliverables as AE skill.

---

## Hard rules (non-negotiable — most are shared with the AE skill)

1. **Rendered report is CLIENT-FACING.** Soft-pitch voice (see Voice section below), no platform-jargon leak, no internal-research jargon. Same blocklist as AE skill.

2. **Template structure is frozen.** 1 cover + 10 numbered sections in the order shown below. You author content INTO the 16 `{{TOKEN}}` placeholders; you do not modify the template's CSS or section scaffold. NO dark cards, NO new classes.

3. **Deterministic render.** Produce `values.json` with 16 keys (5 global strings + `COVER_BODY` + `SECTION_01_BODY` through `SECTION_10_BODY`). Then `node render.mjs template.html values.json output.html`. Do NOT Write HTML directly. If render.mjs exits non-zero, fix values.json and re-run.

4. **Demo-specific depth MUST appear in these sections:**
    - **Section 04 (Citation Graph Gap):** per-query detail. Every category query Agent 2 ran gets its own `.query-row` with `.q-text` (verbatim query in quotes), `.q-cites` (1-line interpretation: who was cited, rank, implication), `.q-status` (Lost / Won). Laid out in a `.split-5-5` — LOST column left, WINNING column right. No aggregation; each query visible.
    - **Section 05 (Competitive Landscape):** 4 `.comp-card`s in a `.comp-grid`, each with a nested `.comp-stat-grid` (3×2 = 6 stats). The 6 stats per competitor: Visibility Share, Citation Count, Schema Coverage, Content Depth, Category Anchor, Differentiator. Target company is card #1; top 3 competitors fill 2–4. Total = 24 comp-stat blocks.
    - **Section 08 (180-Day Roadmap):** 15 rec cards (R01–R15) grouped into four phases with `.subsection-header` labels (08a / 08b / 08c / 08d). `.phase-timeline` at top showing all 4 phases side-by-side. Each rec card has `.rec-num` (tier: Critical / High / Defensive / Quick Win), `.rec-title`, `.rec-body` (should reference a specific finding from earlier sections), `.rec-footer` with `.effort` + `.badge` (Impact).

5. **Every demo-depth block must trace to the investigation file.** If Agent 2 didn't produce per-query results, the query table is a bug. If Agent 2+3 didn't produce per-competitor stats, the comp grid is a bug. If a recommendation doesn't tie to a finding, drop it — never fabricate.

6. **No clickable elements.** PDF is the primary deliverable. No `cta-pill`, no button-shaped `<a>`. Same rule as AE skill's Hard Rule #11.

7. **Section order is frozen.** Cover → [01] Executive Summary → [02] Target Company Snapshot → [03] Answer Engine Visibility Scorecard → [04] The Citation Graph Gap → [05] Competitive Landscape · Who's Winning → [06] SEO Audit · Public Signal Analysis → [07] Gap Analysis · Dimension By Dimension → [08] Recommendations · 180-Day Roadmap → [09] Cost Of Inaction → [10] Methodology & Data Sources. See `templates/section-structure.md` for the exact per-section content contract.

---

## Voice: soft pitch + demo framing

Follows the AE skill's soft-pitch voice rules (see `visibl-company-report/skills/visibl-company-report/SKILL.md`):
- Address the reader as "you" / "your brand"
- Frame findings as opportunities, not deficiencies
- Every page ends on an implication
- Numbers stay blunt, language around them softens
- **Tension Rule** — when Visibility ≥ 70% AND Health ≤ 65, Executive Summary leads with defensibility risk

**Demo-specific additions:**
- Each recommendation card's body (`.rec-body`) should name the specific finding from earlier pages that triggered the rec. Example: "R03 — Adding FAQPage schema on the 82 collection pages (referenced on p. 05) is the fastest path to category answer coverage." This lets the AE walk the prospect from evidence → recommendation during the demo.
- Per-query rows should include a one-line interpretation, not just status. "Cited ✓ — Ranked #2 across ChatGPT + Perplexity; GreenPan takes #1 in both" is better than "Cited".
- The demo isn't a sales pitch at this length; it's an advisory walkthrough. Less urgency prose, more evidence-forward content.

---

## Workflow

### Phase 0 — Brief (same as AE skill)

If the command was triggered via Discord, treat the URL argument as the target company URL. Otherwise run `AskUserQuestion` to gather target URL + AE name + any known competitor set.

### Phase 1 — Research (SAME AS AE SKILL)

Three parallel Task subagents (single message, three Task blocks, no prose between them). Same scope caps:
- Max 4 verticals, 4 queries per vertical, 3-4 competitors
- Research agent model: Haiku
- Per-agent investigation files: `~/.claude/investigations/visibl-report-{{COMPANY_SLUG}}-company.md`, `-aeo.md`, `-seo.md`
- Orchestrator merges into `visibl-report-{{COMPANY_SLUG}}.md`
- Emit `[[MILESTONE: research-started]]` before spawning, `[[MILESTONE: research-done]]` after all three return.

See `templates/research-briefs.md` for exact agent scope.

### Phase 2 — Produce values.json (DEMO-DEPTH — different from AE skill)

Emit `[[MILESTONE: render-started]]`. Then:

1. Read `templates/placeholder-catalog.md` — the 16 tokens you must fill.
2. Read `templates/section-structure.md` — the demo-depth shape for each `COVER_BODY` + `SECTION_NN_BODY`.
3. Read the full merged investigation file.
4. Author `values.json` at the output directory. Structure:

```json
{
  "COMPANY_NAME": "...",
  "COMPANY_NAME_ACCENT": "...",
  "COMPANY_DOMAIN": "...",
  "REPORT_DATE": "APR 18, 2026",
  "AE_NAME": "Visibl Team",
  "COVER_BODY": "<div class=\"cover-grid\"><div>...hero + subtitle...</div><div class=\"snapshot-rail\">...</div></div>",
  "SECTION_01_BODY": "<div class=\"split-5-5\"><div>...exec summary left...</div><div class=\"findings\">...right rail findings...</div></div>",
  "SECTION_02_BODY": "...",
  "...": "etc. through SECTION_10_BODY"
}
```

**Density targets** (read section-structure.md for the full contract):
- `SECTION_04_BODY` must include ≤ 16 individual `.query-row`s (per-query detail, split LOST | WINNING)
- `SECTION_05_BODY` must include exactly 4 `.comp-card`s with 6 stats each = 24 comp-stat blocks
- `SECTION_08_BODY` must include exactly 15 rec cards (R01–R15) across 4 phase sub-sections + the `.phase-timeline` overview

5. Run the renderer:
```bash
node /Users/husseinmohamed/my-claude-plugins/visibl-demo-report/templates/render.mjs \
  /Users/husseinmohamed/my-claude-plugins/visibl-demo-report/templates/report.html \
  {OUTPUT_DIR}/values.json \
  {OUTPUT_DIR}/{slug}-demo-report.html
```

If render fails (missing token, unresolved placeholder), fix values.json and re-run. NEVER Write the HTML file directly.

Emit `[[MILESTONE: render-done]]`.

### Phase 3 — PDF (same as AE skill)

Chrome headless print-to-PDF:
```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf={OUTPUT_DIR}/{slug}-demo-report.pdf --print-to-pdf-no-header \
  file://{OUTPUT_DIR}/{slug}-demo-report.html
```

Emit `[[MILESTONE: pdf-done]]`.

### Phase 4 — Open + summarize

`open {output}.html` (macOS). Report:
- Company analyzed
- Section count (should be 10 numbered sections + 1 cover)
- Rec count in Section 08 (target 15, R01–R15)
- Query count in Section 04 (whatever Agent 2 produced, typically 16)
- Competitor count in Section 05 (target 4 comp-cards × 6 stats = 24 stat blocks)
- PDF page count (will vary based on content density — typically 18–25 pages)
- File paths

---

## Post-render leak scan (same as AE skill)

Grep the rendered HTML for platform-jargon, internal-research jargon, and `{{`-delimited placeholder leaks. Zero matches on all three must be the invariant before Phase 3.

---

## Output path

```
~/Desktop/{Company-slug}-Visibl-Demo-Report/
├── values.json
├── {company-slug}-demo-report.html
└── {company-slug}-demo-report.pdf
```

The `-Demo-Report` suffix distinguishes demo artifacts from the AE skill's `-Visibl-Report` folders.
