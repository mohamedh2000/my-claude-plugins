---
description: Generate a Visibl-branded AEO/SEO diagnostic report for a target company (HTML + PDF)
argument-hint: "[company name or URL]"
---

# Visibl Company Report

Generate a detailed 10-section AEO + SEO visibility diagnostic for the given target company, rendered in the Visibl Paper/Ink design language. Outputs a self-contained HTML file + a letter-size PDF to `~/Desktop/{Company}-Visibl-Report/`.

## Usage

```
/visibl-company-report                          # Skill prompts for company + URL
/visibl-company-report notion.so                # Kicks off with URL pre-filled
/visibl-company-report Remix Communications     # Kicks off with name
```

## What it does

1. **Interviews** — confirms target company + URL, AE byline, strategic angle, page depth
2. **Researches** — 3 parallel agents dig into company profile, AEO signals (ChatGPT/Perplexity/Gemini/Claude), and public SEO signals
3. **Renders** — self-contained HTML using the Visibl Paper/Ink template, 10 fixed sections, letter-size print-ready
4. **Exports PDF** — via Chrome headless print-to-PDF
5. **Opens** — HTML in browser, PDF sibling file placed next to it

## Arguments

$ARGUMENTS

Run the `visibl-company-report` skill to begin. Read `templates/section-structure.md` and `templates/research-briefs.md` before spawning research agents.
