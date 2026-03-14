# optimised_agentic_workflow

## Proactive Hygiene Automation

This repository includes a background hygiene workflow that runs a bounded maintenance pass for documentation quality and safety.

- Workflow: `.github/workflows/proactive-hygiene.yml`
- Script: `scripts/proactive-hygiene.sh`
- Log output: `.agent/logs/hygiene.md`
- Schedule: daily via GitHub Actions cron, plus manual `workflow_dispatch`

The automation is intentionally maintenance-only. It focuses on low-risk issues such as markdown consistency, metadata alignment, TODO/FIXME surfacing, and rendering or character-set formatting cleanup. It must not perform net-new feature work.