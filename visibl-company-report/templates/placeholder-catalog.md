# Placeholder Catalog

The template `report.html` contains **19 `{{TOKEN}}` placeholders**. The skill's Phase 2 produces a `values.json` with these exact 19 keys; the `render.mjs` script substitutes them into the template to produce the final HTML.

| Key | Type | Where it goes | Example value |
|---|---|---|---|
| `COMPANY_NAME` | string | Multiple (`<title>`, cover hero, page footers, exec summary subtitle, closing page) | `"Caraway Home"` |
| `COMPANY_NAME_ACCENT` | string | One word in cover hero, rendered in accent orange | `"Visibility"` |
| `COMPANY_DOMAIN` | string | Cover snapshot + exec summary subtitle + footer | `"carawayhome.com"` |
| `REPORT_DATE` | string | Cover subtitle + closing page byline | `"APR 18, 2026"` |
| `AE_NAME` | string | Cover prepared-for credit | `"Visibl Team"` |
| `PAGE_1_BODY` | HTML | Inner content of the cover page's `<div class="page-body ...">` | See "Page bodies" below |
| `PAGE_2_BODY` | HTML | Inner content of Executive Summary page | ditto |
| `PAGE_3_BODY` | HTML | Inner content of How AI Identifies You page | ditto |
| `PAGE_4_BODY` | HTML | Inner content of Sitemap & Discoverability page | ditto |
| `PAGE_5_BODY` | HTML | Inner content of Schema & Structured Data page | ditto |
| `PAGE_6_BODY` | HTML | Inner content of Content Depth page | ditto |
| `PAGE_7_BODY` | HTML | Inner content of AI Bot Access page | ditto |
| `PAGE_8_BODY` | HTML | Inner content of Query Gap Analysis page | ditto |
| `PAGE_9_BODY` | HTML | Inner content of Citation Gap Analysis page | ditto |
| `PAGE_10_BODY` | HTML | Inner content of Competitive Landscape page | ditto |
| `PAGE_11_BODY` | HTML | Inner content of Answer Gap Analysis page | ditto |
| `PAGE_12_BODY` | HTML | Inner content of The Path Forward page | ditto |
| `PAGE_13_BODY` | HTML | Inner content of Next Steps page | ditto |
| `PAGE_14_BODY` | HTML | Inner content of Progress Snapshot (closing CTA) page | ditto |

## Page bodies

Each `PAGE_N_BODY` value is an HTML fragment that lives INSIDE the template's `<div class="page-body ...">` div. The wrapping div and its layout class (`.split-5-5`, `.split-6-4`, `.split-7-3`, or none) are static in the template — do NOT repeat them in the body HTML.

The HTML may use any of the primitives defined in the template's CSS — do NOT invent new classes or inline styles, since your job is ONLY to fill in dynamic content. Available primitives:

**Typography:** `.eyebrow`, `.eyebrow-muted`, `.hero`, `.h1`, `.h2`, `.subtitle`, `.label`, `.footnote`
**Stats:** `.stat-grid-2`, `.stat-cell`, `.stat-cell-value`, `.stat-cell-name`, `.stat-cell-desc`, `.big-stat`, `.small-stat`, `.stat-row-2`, `.stat-row-3`, `.stat-row-4`
**Findings:** `.findings`, `.findings-head`, `.finding`, `.finding-badge`, `.finding-title`, `.finding-body` + badge variants (`.priority`, `.verified`, `.context`, `.accent`)
**Bars:** `.bar-row`, `.bar-label`, `.bar-value`, `.bar-track`, `.bar-fill`
**Schema:** `.schema-row`, `.schema-name`, `.schema-bar-track`, `.schema-bar-fill`, `.schema-status` + `.missing` / `.present`
**Competitive:** `.comp-grid`, `.comp-row`, `.comp-name`, `.comp-score`, `.comp-score-val`, `.comp-score-label`
**Recommendations:** `.rec-grid-4`, `.rec-card`, `.rec-title`, `.rec-body`
**Chips:** `.chip`, `.chip.done`, `.path-chips`
**Timeline:** `.timeline-row`, `.timeline-when`, `.timeline-fill`, `.timing-chip`
**Colors for values:** `.green`, `.amber`, `.red`, `.accent` (applied to `.big-stat` / `.stat-cell-value` / etc.)
**Layout primitives:** `.flex-col`, `.flex-row`, `.mt-8`, `.mt-16`, `.mt-24`, `.mt-32`, `.mt-40`

## Validation

`render.mjs` enforces that every `{{TOKEN}}` in the template has a matching key in `values.json`. Missing key → exit 3 with the missing name. Unresolved token after substitution → exit 4. Both are hard fails that the skill's Phase 4 must handle by re-authoring `values.json`, not by writing HTML directly.
