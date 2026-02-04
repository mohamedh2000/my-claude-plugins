# Grill Questions Template

Use these question batches when the user rejects a diagram. Ask 2-3 questions at a time, wait for answers, then ask the next batch.

---

## Batch 1: Core Purpose

1. "What is the PRIMARY goal of this feature/change?"
2. "What specific problem does this solve?"
3. "What does SUCCESS look like when this is done?"

---

## Batch 2: Trigger & Entry

1. "What EXACTLY triggers this flow to start?"
2. "From where can this be triggered? (button, API, event, etc.)"
3. "What conditions must be true BEFORE this can begin?"

---

## Batch 3: Happy Path

1. "Walk me through the IDEAL scenario step by step"
2. "What happens immediately after [the trigger]?"
3. "What is the final outcome when everything works?"

---

## Batch 4: Decision Points

1. "At [identified decision point], what determines the path taken?"
2. "Who/what makes that decision - user action, system logic, or external service?"
3. "Are there any other decision points I missed?"

---

## Batch 5: Data Requirements

1. "What data is REQUIRED to start this flow?"
2. "What data gets CREATED or MODIFIED during the flow?"
3. "Where does the data come from and where does it go?"

---

## Batch 6: Error Handling

1. "What happens if [critical step] fails?"
2. "Should failures auto-retry, require user action, or silently fail?"
3. "What should the user SEE when an error occurs?"

---

## Batch 7: Edge Cases

1. "What if the user does [unexpected action]?"
2. "What if [external dependency] is slow or unavailable?"
3. "What about concurrent requests or race conditions?"

---

## Batch 8: Integration

1. "How does this interact with existing [related feature]?"
2. "Should this REPLACE, EXTEND, or work ALONGSIDE existing behavior?"
3. "What existing functionality should NOT change?"

---

## Batch 9: UI/UX (if applicable)

1. "What should the user see during each state?"
2. "Are there loading states, progress indicators, or feedback needed?"
3. "What are the success/error message patterns?"

---

## Batch 10: Performance & Scale

1. "How much data/traffic do you expect?"
2. "Are there any timeout or response time requirements?"
3. "Should this work offline or require connectivity?"

---

## After Each Batch

After receiving answers:
1. **Summarize**: "So to confirm: [summary of answers]"
2. **Update diagram**: Incorporate new information
3. **Show updated diagram**: "Here's the updated design based on your input:"
4. **Ask for approval**: "Does this now match your vision?"

---

## Iteration Rules

- **Max 3 iterations** before escalating to a sync call
- **If contradictions arise**, call them out: "Earlier you said X, but now Y - which is correct?"
- **If scope creeps**, note it: "That sounds like a separate feature. Should I capture it for later?"
- **When 80% clear**, show diagram and ask about remaining 20%
