---
name: deep-prd
version: "1.0.0"
description: Deep implementation research with parallel specialist agents, multi-reviewer iteration cycles, and file-based persistence. Use when the user needs comprehensive technical/product planning with granular implementation details. Triggers on "deep research", "implementation plan", "deep prd", or when complex multi-domain analysis is needed.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Task
  - AskUserQuestion
  - TaskCreate
  - TaskUpdate
  - TaskList
  - TaskGet
  - WebSearch
  - WebFetch
  - mcp__telegram__telegram_send_message
---

# Deep PRD Skill - Parallel Research Orchestration

> **Architecture**: Lightweight orchestrator + parallel specialist agents + iterative review cycles
> **Key Innovation**: File-based persistence for orchestrator compaction recovery
> **Templates**: Located in `deep-prd/templates/` directory

## When to Use

- Complex product/technical planning requiring multiple domain expertise
- Implementation research needing Engineering, Product, Strategy, Data, ML perspectives
- Projects requiring iterative review cycles with multiple stakeholders
- Long-running research that may exceed context limits

## Workflow Overview

| Phase | Name | Agents | Output |
|-------|------|--------|--------|
| 0 | Init | Orchestrator | Output directory, task list created |
| 1 | Research | 5 parallel specialists | 5 research documents |
| 2 | Compile | Orchestrator | Unified implementation plan |
| 3 | Review | 3 parallel reviewers | Review feedback |
| 4 | Iterate | Orchestrator | Address feedback, re-review if needed |
| 5 | Finalize | Orchestrator | Final PDF/document |

## File Structure

All artifacts stored in user-specified directory (default: `~/implementation-[project]/`):

```
~/implementation-[project]/
├── 01-engineering-research.md    # Technical architecture, scrapers, infrastructure
├── 02-product-research.md        # MVP definition, features, roadmap, pricing
├── 03-strategy-research.md       # Market analysis, GTM, competitive intel
├── 04-data-architecture-research.md  # Schemas, pipelines, storage
├── 05-ml-research.md             # ML models, feature engineering, MLOps
├── 06-compiled-plan.md           # Unified implementation plan
├── 07-review-feedback.md         # Consolidated review feedback
└── FINAL-implementation-plan.pdf # Final deliverable
```

---

## Entry Point

**FIRST**, parse the user's request:

1. **Input sources**: PDFs, documents, descriptions, or existing research
2. **Output location**: User-specified or default `~/implementation-[project]/`
3. **Review requirements**: Which reviewers needed (default: Engineer, PM, CPO)

### If resuming (output directory exists with files):
1. Read existing research files
2. Determine which phase to resume from
3. Continue from that phase

### If starting fresh:
1. Create output directory
2. Proceed to Phase 0

---

## Phase 0: Initialization

**Actions:**
1. Create output directory: `mkdir -p ~/implementation-[project]/`
2. Create task list with dependencies:

```
Task #1: Complete research phase (5 parallel agents)
Task #2: Compile comprehensive implementation plan [blocked by #1]
Task #3: Software Engineer review cycle [blocked by #2]
Task #4: Product Manager review cycle [blocked by #2]
Task #5: CPO review cycle [blocked by #2]
Task #6: Address review feedback and iterate [blocked by #3, #4, #5]
Task #7: Generate final deliverable [blocked by #6]
```

3. Read any input documents (PDFs, etc.)
4. Extract key context for research agents

**Checkpoint:**
- [ ] Output directory created
- [ ] Task list created
- [ ] Input documents read
- Proceed to Phase 1

---

## Phase 1: Parallel Research

**CRITICAL**: Skip memory_review in agent prompts - proceed directly to research.

Spawn 5 specialist agents in parallel using `Task` tool with `run_in_background: true`:

### Agent 1: Senior Software Engineer
```
Subagent type: general-purpose
Output: ~/implementation-[project]/01-engineering-research.md
Focus:
- Scraper/scanner architecture
- Per-channel technical implementation
- Failure handling & resilience
- Job scheduling
- Proxy & anti-detection infrastructure
- Code snippets where helpful
```

### Agent 2: Product Manager
```
Subagent type: general-purpose
Output: ~/implementation-[project]/02-product-research.md
Focus:
- MVP definition
- Feature-by-feature breakdown with user stories
- Phased roadmap
- Pricing model
- Success metrics
```

### Agent 3: Chief Product Officer (Strategy)
```
Subagent type: general-purpose
Output: ~/implementation-[project]/03-strategy-research.md
Focus:
- Market analysis (TAM, segments)
- Competitive moat analysis
- Go-to-market strategy
- Risk analysis
- Build vs buy decisions
- Team & investment requirements
```

### Agent 4: Data Architect
```
Subagent type: general-purpose
Output: ~/implementation-[project]/04-data-architecture-research.md
Focus:
- Core data models (Prisma schemas)
- Time-series data strategy
- Data pipeline architecture
- Analytics/reporting layer
- Data volume estimates
- Integration data flows
```

### Agent 5: ML Engineer
```
Subagent type: general-purpose
Output: ~/implementation-[project]/05-ml-research.md
Focus:
- Preference profile methodology
- Feature extraction & model architecture
- Statistical rigor
- Natural experiment detection
- Prediction engine design
- MLOps considerations
- Python code snippets
```

**Monitor Progress:**
- Wait for all 5 agents to complete
- Check output files exist and have content
- If any agent fails, resume it or spawn replacement

**Checkpoint:**
- [ ] All 5 research files exist
- [ ] Each file has substantial content (>500 lines ideal)
- Update Task #1 to completed
- Proceed to Phase 2

---

## Phase 2: Compile Implementation Plan

**Actions:**
1. Read all 5 research documents
2. Synthesize into unified implementation plan:
   - Executive summary
   - Technical architecture (from Engineering + Data)
   - Product roadmap (from Product + Strategy)
   - ML/Analytics approach (from ML)
   - Resource requirements (from Strategy)
   - Risk mitigation
   - Timeline with phases
3. Write to `06-compiled-plan.md`

**Checkpoint:**
- [ ] Compiled plan exists
- [ ] All research incorporated
- Update Task #2 to completed
- Proceed to Phase 3

---

## Phase 3: Parallel Review Cycles

Spawn 3 reviewer agents in parallel with `run_in_background: true`:

### Reviewer 1: Software Engineer
```
Subagent type: general-purpose
Role: Technical feasibility review
Check:
- Architecture soundness
- Technical risks not addressed
- Missing implementation details
- Unrealistic technical claims
- Security concerns
Output: List of issues with severity (BLOCKER/HIGH/MEDIUM/LOW)
```

### Reviewer 2: Product Manager
```
Subagent type: general-purpose
Role: Product viability review
Check:
- MVP scope creep
- Missing user stories
- Unclear success metrics
- Pricing alignment with value
- Roadmap feasibility
Output: List of issues with severity
```

### Reviewer 3: CPO
```
Subagent type: general-purpose
Role: Strategic review
Check:
- Market positioning gaps
- Competitive differentiation
- Resource/timeline realism
- Risk mitigation completeness
- Go-to-market clarity
Output: List of issues with severity
```

**Checkpoint:**
- [ ] All 3 reviews complete
- [ ] Feedback consolidated to `07-review-feedback.md`
- Update Tasks #3, #4, #5 to completed
- Proceed to Phase 4

---

## Phase 4: Iterate on Feedback

**Actions:**
1. Read consolidated feedback
2. Count issues by severity:
   - BLOCKER: Must fix before proceeding
   - HIGH: Should fix
   - MEDIUM/LOW: Note for future

3. If BLOCKER or HIGH issues exist:
   - Address each issue in the compiled plan
   - Update relevant sections
   - Re-run review cycle (Phase 3) if major changes

4. If no significant issues:
   - Proceed to finalization

**Iteration Loop:**
```
while (blockers_exist || high_issues > 3):
    address_issues()
    re_run_reviews()
    consolidate_feedback()
```

**Checkpoint:**
- [ ] All BLOCKER issues addressed
- [ ] HIGH issues addressed or documented as accepted risk
- Update Task #6 to completed
- Proceed to Phase 5

---

## Phase 5: Generate Final Deliverable

**Actions:**
1. Read final compiled plan
2. Format for output:
   - If PDF requested: Generate using appropriate tool
   - If markdown: Clean up and finalize
3. Write to specified output location
4. Send Telegram notification if configured

**Output Options:**
- PDF: Use `pandoc` or similar
- Markdown: Direct write
- Multiple formats: Generate both

**Checkpoint:**
- [ ] Final deliverable exists
- [ ] User notified (Telegram if available)
- Update Task #7 to completed
- Workflow complete

---

## Recovery Protocol

If orchestrator compacts or session is interrupted:

1. **Check output directory**: `ls ~/implementation-[project]/`
2. **Determine phase from files**:
   - No files → Phase 0
   - Only research files → Phase 1 complete, go to Phase 2
   - Compiled plan exists → Phase 2 complete, go to Phase 3
   - Review feedback exists → Phase 3 complete, go to Phase 4
   - Final deliverable exists → Complete
3. **Resume from detected phase**

---

## Agent Prompt Templates

### Research Agent Template
```
You are a **[ROLE]** researching the [DOMAIN] implementation for [PROJECT].

**CRITICAL: Skip memory_review - proceed directly to research and writing.**

**Context**: [PROJECT_CONTEXT]

**Your Task**: Research and document GRANULAR implementation details for:

[SPECIFIC_SECTIONS]

Use WebSearch to find current best practices and market data.
Write comprehensive, specific details. Include code snippets where helpful.

Save your complete research to ~/implementation-[project]/[OUTPUT_FILE]
```

### Review Agent Template
```
You are a **[ROLE]** reviewing an implementation plan for [PROJECT].

**Your Task**: Review the compiled implementation plan critically.

Read: ~/implementation-[project]/06-compiled-plan.md

**Review Criteria**:
[ROLE_SPECIFIC_CRITERIA]

**Output Format**:
For each issue found:
- **Severity**: BLOCKER | HIGH | MEDIUM | LOW
- **Section**: Where the issue is
- **Issue**: What's wrong
- **Recommendation**: How to fix

Be thorough but constructive. The goal is to make the plan better.
```

---

## Quick Reference

| Phase | Parallelism | Agents | Output |
|-------|-------------|--------|--------|
| 0 | None | Orchestrator | Directory, tasks |
| 1 | 5 parallel | Specialists | 5 research docs |
| 2 | None | Orchestrator | Compiled plan |
| 3 | 3 parallel | Reviewers | Feedback |
| 4 | None | Orchestrator | Updated plan |
| 5 | None | Orchestrator | Final deliverable |

**Total agents spawned**: 8 (5 research + 3 review)
**Iteration possible**: Yes, Phase 3-4 loop until clean
