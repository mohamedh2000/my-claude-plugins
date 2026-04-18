# Demo Report Placeholder Catalog

The template `report.html` contains **16 `{{TOKEN}}` placeholders**. The skill's Phase 2 produces a `values.json` with these exact 16 keys; `render.mjs` substitutes them into the template to produce the final HTML.

| Key | Type | Where it goes | Example value |
|---|---|---|---|
| `COMPANY_NAME` | string | `<title>`, cover hero, footer, inside body copy | `"Real Chemistry"` |
| `COMPANY_NAME_ACCENT` | string | One word in cover hero, rendered in accent orange via `<span class="accent">` inside `COVER_BODY` | `"Visibility"` |
| `COMPANY_DOMAIN` | string | Cover snapshot, body prose | `"realchemistry.com"` |
| `REPORT_DATE` | string | Cover + document footer | `"APR 18, 2026"` |
| `AE_NAME` | string | Cover prepared-by credit | `"Visibl Team"` |
| `COVER_BODY` | HTML | Everything inside the `<section class="cover">` after the static wordmark — hero, subtitle, and snapshot-rail | see "Cover body" below |
| `SECTION_01_BODY` | HTML | Executive Summary content (inside the `[01]` section wrapper, after the static section-header) | see "Section bodies" below |
| `SECTION_02_BODY` | HTML | Target Company Snapshot content | " |
| `SECTION_03_BODY` | HTML | Answer Engine Visibility Scorecard content | " |
| `SECTION_04_BODY` | HTML | The Citation Graph Gap content | " |
| `SECTION_05_BODY` | HTML | Competitive Landscape · Who's Winning content | " |
| `SECTION_06_BODY` | HTML | SEO Audit · Public Signal Analysis content | " |
| `SECTION_07_BODY` | HTML | Gap Analysis · Dimension By Dimension content | " |
| `SECTION_08_BODY` | HTML | Recommendations · 180-Day Roadmap content (largest — 15 rec cards + phase timeline) | " |
| `SECTION_09_BODY` | HTML | Cost Of Inaction content | " |
| `SECTION_10_BODY` | HTML | Methodology & Data Sources content | " |

## Cover body

`COVER_BODY` is the full interior of the cover section. Use a `.cover-grid` for the two-column layout (hero-left, snapshot-rail-right):

```html
<div class="cover-grid">
  <div>
    <div class="eyebrow">AI Visibility Demo Report</div>
    <h1 class="hero">Real Chemistry <span class="accent">Visibility</span> Review</h1>
    <p class="subtitle">How ChatGPT, Perplexity, Gemini, and Claude answer the healthcare communications questions your buyers are asking — and where your brand shows up in the answer.</p>
  </div>
  <div class="snapshot-rail">
    <div class="snapshot-head">SNAPSHOT · APR 18, 2026</div>
    <div class="snapshot-row">
      <div class="snapshot-val green">48%</div>
      <div>
        <div class="snapshot-name">Visibility Score</div>
        <div class="snapshot-desc">Cited in 8 of 16 category-discovery queries.</div>
      </div>
    </div>
    <!-- ~4 snapshot-rows total -->
  </div>
</div>
```

## Section bodies

Each `SECTION_NN_BODY` is the dynamic content for one section. The `<section class="doc-section">` wrapper and the `.section-header` (number + line + label) are static in the template — you just provide the body.

Use the primitives defined in `report.html`'s `<style>` block — **never invent new classes, never inline CSS unless it's scoped layout (grid-template-columns for ad-hoc grids)**:

**Typography:** `.eyebrow`, `.eyebrow-muted`, `.hero`, `.h1`, `.h2`, `.subtitle`, `.label`, `.footnote`, `.t-mono`, `.t-right`, `.t-muted`
**Stats:** `.stat-grid-2`, `.stat-cell`, `.stat-cell-value`, `.stat-cell-name`, `.stat-cell-desc`, `.big-stat`, `.small-stat`, `.stat-row-2`, `.stat-row-3`, `.stat-row-4`
**Findings:** `.findings-head`, `.finding`, `.finding-badge` + badge variants (`.priority`, `.verified`, `.critical`, `.context`, `.opportunity`), `.finding-title`, `.finding-body`
**Recommendations:** `.grid-3`, `.rec-card`, `.rec-num`, `.rec-title`, `.rec-body`, `.rec-footer`, `.effort`, `.badge` + (`.badge-critical`, `.badge-success`, `.badge-moderate`, `.badge-accent`)
**Phase timeline:** `.phase-timeline`, `.phase-card`, `.phase-label`, `.phase-title`, `.phase-body`
**Per-query rows:** `.query-row` + `.lost` or `.won` modifier, `.q-prefix`, `.q-text`, `.q-cites`, `.q-status`
**Competitive cards:** `.comp-grid`, `.comp-card`, `.comp-name`, `.comp-tagline`, `.comp-stat-grid`, `.comp-stat`, `.comp-stat-label`, `.comp-stat-value` + (`.green`/`.amber`/`.red`/`.accent`)
**Bars & schema:** `.bar-row`, `.bar-label`, `.bar-track`, `.bar-fill`, `.bar-value`, `.schema-row`, `.schema-name`, `.schema-bar-track`, `.schema-bar-fill.present`, `.schema-status.present`, `.schema-status.missing`
**Sub-sections:** `.subsection-header`, `.subsection-num`, `.subsection-line`, `.subsection-label` — use these for the 4 phase headers inside Section 08
**Layout:** `.grid-2`, `.grid-3`, `.split-5-5`, `.split-6-4`, `.split-7-3`, `.flex-col`, `.flex-row`, `.mt-8` through `.mt-56`, `.divider`

**Value-color modifiers:** `.green`, `.amber`, `.red`, `.accent` on `.stat-cell-value`, `.big-stat`, `.small-stat`, `.snapshot-val`, `.bar-value`, `.comp-stat-value`

## Validation

`render.mjs` enforces every `{{TOKEN}}` in the template has a matching key in `values.json`. Missing key → exit 3. Unresolved token after substitution → exit 4.
