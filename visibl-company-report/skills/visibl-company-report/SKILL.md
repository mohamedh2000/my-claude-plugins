---
name: visibl-company-report
version: "1.0.0"
description: Generate a detailed AEO + SEO visibility diagnostic report for a target company in Visibl's Paper/Ink design language. Outputs HTML + PDF. Use when the user asks for "a company report", "AE report", "Visibl report on X", "diagnostic on X", or "research [company] for our platform". Produces a 10-section letter-size diagnostic suitable for handing to an account executive.
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
- You only need the executive summary, not the full 10-section report → write it directly, don't run this skill

---

## Hard rules (non-negotiable)

1. **Never fabricate data.** If research comes up thin, surface the gap in Section 10 (Methodology). A report with honest gaps is stronger than a report with invented numbers.
2. **Never change the section structure.** 10 sections, in order, every time. See `templates/section-structure.md`.
3. **Never change the design tokens.** The :root block in `templates/report.html` IS the Visibl Paper/Ink identity. Don't introduce new colors, fonts, or card types. If you think a new component is needed, the answer is: use an existing one.
4. **Brand-name queries don't count.** "What is {{company}}" returning {{company}} is not AEO signal. The scorecard tracks category-discovery queries only.
5. **Cite every named data point.** In the investigation files, every fact traces back to a source URL. If you can't cite it, drop it.
6. **All findings go on disk first.** Research agents persist to `~/.claude/investigations/visibl-report-{slug}.md` before the render step reads them. No research kept only in context.

---

## Workflow

### Phase 0 · Brief

Invoke `AskUserQuestion` with 2-3 grouped questions:

1. **Target** (required inputs):
   - Company name (e.g. "Notion Labs")
   - Company URL (e.g. "notion.so")
2. **Strategic angle** (AEO-heavy / SEO-heavy / balanced — default: balanced)
3. **Page depth** (concise 10-12pp / full 16-20pp — default: full)
4. **Optional**: AE name for byline, known competitors to include

Derive:
- `{{COMPANY_NAME}}` — user's full input, title-cased
- `{{COMPANY_NAME_COVER}}` — for the cover page, split with `<br/>` at a natural break (e.g. "Notion<br/>Labs", or `{{COMPANY_NAME}}` alone if one word)
- `{{COMPANY_DOMAIN}}` — bare domain, no scheme (e.g. "notion.so")
- `{{COMPANY_SLUG}}` — lowercase, hyphenated, for filenames (e.g. "notion-labs")
- `{{REPORT_DATE}}` — today, formatted `DD Month YYYY` (e.g. "16 April 2026")
- `{{AE_NAME}}` — blank-string if not provided (skill renders "Visibl Team" as fallback)

### Phase 1 · Research (3 parallel agents)

Read `templates/research-briefs.md` first — it contains the exact scope and deliverable shape for each agent.

Spawn three `Task` subagents in parallel (single message, three `Task` tool calls):

- **Agent 1 · Company Profile** (`subagent_type: researcher`)
- **Agent 2 · AEO Signals** (`subagent_type: researcher`)
- **Agent 3 · SEO Signals** (`subagent_type: researcher`)

Each agent gets:
- The research brief text for its section
- The target company name + URL
- The investigation file path to persist to: `~/.claude/investigations/visibl-report-{{COMPANY_SLUG}}.md`
- Mandatory `## Status` section updated as the agent works

**Wait for all 3 agents to return** before proceeding. Do NOT start rendering with partial data.

**Research gate (hard stop):** Before Phase 2, read the investigation file. Verify:
- All 3 sections (`## Agent 1`, `## Agent 2`, `## Agent 3`) are present and have `Status: complete` lines
- Every named data point has a source URL
- No "TODO" or placeholder strings remain

If the gate fails → report to the user which agent came back thin and ask whether to re-run that agent, relax the rubric, or abort. Do not render.

### Phase 2 · Render HTML

1. Read `templates/report.html` — the structural template. Don't paraphrase from memory; read it each time.
2. Read `templates/section-structure.md` — the contract for what each section must contain.
3. Read `templates/design-tokens.css` — the color and type system. These values are already embedded in `report.html`; this file is a reference.

**Rendering process:**
- Copy the template to the output path (see Phase 4 for location)
- Substitute the 5 literal placeholders in-place:
  - `{{COMPANY_NAME}}` → e.g. "Notion Labs"
  - `{{COMPANY_NAME_COVER}}` → e.g. "Notion<br/>Labs"
  - `{{COMPANY_DOMAIN}}` → e.g. "notion.so"
  - `{{REPORT_DATE}}` → e.g. "16 April 2026"
  - `{{AE_NAME}}` → e.g. "Sarah Chen" or "Visibl Team"
- **Rewrite every section body** using the investigation file's findings:
  - Keep the section chrome (`[NN]` header, card classes, grid layouts) intact
  - Replace Remix-specific prose with the target company's researched content
  - Keep the tone: confident, direct, specific numbers, no hedging in the executive summary
  - Every statistic must be traceable to the investigation file — if you're about to write a number, confirm you pulled it from there first
- Preserve dark cards as section visual anchors — don't add new ones, don't remove existing ones

**Section-by-section check (before you write each section):**
- Section 01 — at least 3 dark-card callouts with numerical proof
- Section 03 — the weighted AEO Index shows its math
- Section 04 — the citation-graph table names real sources
- Section 05 — 4-6 real competitor cards, not hypotheticals
- Section 07 — dimension table has a concrete P0/P1/P2 priority column
- Section 08 — 4 phases, each with 3-5 recommendation cards with active-verb titles
- Section 09 — max 3 scenarios, each with a dated horizon + named competitor
- Section 10 — data gaps listed honestly

### Phase 3 · Render PDF

Attempt Chrome headless print-to-PDF:

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
OUT_HTML="$HOME/Desktop/{{COMPANY_NAME}}-Visibl-Report/{{COMPANY_SLUG}}-aeo-seo-gap-report.html"
OUT_PDF="${OUT_HTML%.html}.pdf"

if [ -x "$CHROME" ]; then
  "$CHROME" \
    --headless --disable-gpu \
    --no-pdf-header-footer \
    --print-to-pdf="$OUT_PDF" \
    "file://$OUT_HTML"
else
  echo "Chrome not found — HTML generated but PDF skipped."
fi
```

Acceptance:
- PDF opens in Preview
- Page breaks fall between sections (not mid-card)
- Cream / ink / orange colors render correctly (no banding)
- Letter size, 0.4in × 0.35in margins

If PDF fails for any reason → keep the HTML, report the failure, don't retry silently.

### Phase 4 · Output location + open

**Output directory:** `~/Desktop/{{COMPANY_NAME}}-Visibl-Report/`

Files produced:
- `{{COMPANY_SLUG}}-aeo-seo-gap-report.html`
- `{{COMPANY_SLUG}}-aeo-seo-gap-report.pdf` (if Chrome available)

After rendering:
```bash
open "$OUT_HTML"
```

### Phase 5 · Summarize to user

Chat reply is 4-6 lines max:
- Company analyzed
- 10 sections rendered
- File paths (click to open)
- Any research gaps flagged in Section 10
- Invite them to review + ask for follow-ups

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
