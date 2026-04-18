#!/usr/bin/env node
// Deterministic renderer — substitutes {{TOKEN}} placeholders in report.html
// with values from a values.json file.
//
// The skill's Phase 2 used to Write a 63 KB fully-rendered HTML file in a
// single LLM inference (~10 min). This renderer separates concerns: the LLM
// produces a ~20 KB values.json (the actual analysis, prose, numbers, HTML
// blobs for each page-body), and this script splices those values into the
// static template chrome (CSS + page headers + page footers + @page rules).
//
// Usage:
//   node render.mjs <template.html> <values.json> <output.html>
//
// Fails loudly on any unresolved {{TOKEN}} remaining after substitution, so
// the skill knows the values.json was incomplete and can retry.

import { readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const [, , tmplPath, valsPath, outPath] = process.argv;
if (!tmplPath || !valsPath || !outPath) {
  console.error("usage: node render.mjs <template.html> <values.json> <output.html>");
  process.exit(2);
}

const template = readFileSync(resolve(tmplPath), "utf8");
const values = JSON.parse(readFileSync(resolve(valsPath), "utf8"));

// Find every {{TOKEN}} in the template so we can verify coverage.
const tokensInTemplate = new Set();
for (const m of template.matchAll(/\{\{([A-Z][A-Z0-9_]*)\}\}/g)) {
  tokensInTemplate.add(m[1]);
}

// Check every template token has a value
const missing = [];
for (const t of tokensInTemplate) {
  if (!(t in values)) missing.push(t);
}
if (missing.length) {
  console.error(`✗ values.json is missing ${missing.length} required token(s):`);
  for (const m of missing) console.error(`    ${m}`);
  process.exit(3);
}

// Substitute
const rendered = template.replace(/\{\{([A-Z][A-Z0-9_]*)\}\}/g, (_, key) => {
  return String(values[key]);
});

// Post-render leak check: no stray {{TOKEN}} should remain
const leaks = [...rendered.matchAll(/\{\{([A-Z][A-Z0-9_]*)\}\}/g)].map((m) => m[1]);
if (leaks.length) {
  console.error(`✗ rendered output still contains ${leaks.length} unresolved token(s):`);
  for (const l of leaks) console.error(`    {{${l}}}`);
  process.exit(4);
}

writeFileSync(resolve(outPath), rendered);
const extraKeys = [...Object.keys(values)].filter((k) => !tokensInTemplate.has(k));
console.log(`✓ rendered ${rendered.length.toLocaleString()} bytes → ${outPath}`);
console.log(`  ${tokensInTemplate.size} tokens substituted` + (extraKeys.length ? ` (${extraKeys.length} unused keys in values.json: ${extraKeys.join(", ")})` : ""));
