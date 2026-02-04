---
description: Enforce diagram-first architecture workflow - creates visual diagrams before any implementation
argument-hint: "[feature description]"
---

# Diagram-First Command

Enforces visual architecture documentation before implementation. Creates Mermaid diagrams (flowcharts, state diagrams, sequence diagrams) and requires user approval before any code is written.

## Usage

```
/diagram-first                              # Start diagram-first workflow for current task
/diagram-first Add shopping cart feature    # Start with specific feature
```

## What It Does

1. **Analyzes** the proposed feature/change
2. **Creates** appropriate Mermaid diagram(s):
   - Flowchart for process flows
   - State diagram for state machines
   - Sequence diagram for interactions
   - Entity relationship for data models
3. **Presents** the diagram for approval
4. **Grills** you on details if you reject
5. **Iterates** until you approve
6. **Saves** approved diagram to `.claude/diagrams/`

## Arguments

$ARGUMENTS

Run the diagram-first skill to begin the workflow.
