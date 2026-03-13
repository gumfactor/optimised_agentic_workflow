# Rules

Personal Layer 1 rules for agent behavior. These are project-agnostic — they apply everywhere unless a project's `CLAUDE.md` explicitly overrides them.

## Files

| File | Purpose |
|---|---|
| `00-global-governance.md` | Autonomy contract: what agents may do freely vs. what needs approval |
| `01-stack-defaults.md` | Personal technology defaults for new projects |
| `02-workflow-patterns.md` | Branch, commit, PR, and delivery workflow preferences |
| `03-agent-task-templates.md` | How agents should behave for named task types |

## Load Order

Always load `00-global-governance.md` first. Load others as relevant to the current task.  
Project-specific context in the project's `CLAUDE.md` takes precedence over everything here.