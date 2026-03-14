# optimised_agentic_workflow

This repository is a reusable agent-governance and maintenance-automation kit.

It is the source of truth for:
- Layer 1 guidance documents (`AGENTS.md`, `rules/*.md`, `templates/AGENTS.md`)
- Proactive hygiene automation (`scripts/proactive-hygiene.sh`, `.github/workflows/proactive-hygiene.yml`)
- Installation and sync helpers (`scripts/install-kit.sh`, `scripts/sync-kit.sh`)

## Use This As A Template Kit

### Option A: New repository bootstrap

From this repository, run:

```bash
bash scripts/install-kit.sh /path/to/target-repo
```

Use `--force` to overwrite existing files, and `--dry-run` to preview actions.

### Option B: Existing repository sync/update

From this repository, run:

```bash
bash scripts/sync-kit.sh /path/to/target-repo
```

Use `--dry-run` to preview. This sync path always applies `--force`.

### Kit file scope

The copied file list is controlled by `kit/manifest.txt`.

## Proactive Hygiene Automation

This repository includes a background hygiene workflow that runs a bounded maintenance pass for documentation quality and safety.

- Workflow: `.github/workflows/proactive-hygiene.yml`
- Script: `scripts/proactive-hygiene.sh`
- Log output: `.agent/logs/hygiene.md`
- Schedule: daily via GitHub Actions cron, plus manual `workflow_dispatch`

The automation is intentionally maintenance-only. It focuses on low-risk issues such as markdown consistency, metadata alignment, TODO/FIXME surfacing, and rendering or character-set formatting cleanup. It must not perform net-new feature work.

This runner can stay active in this repository and in any target repository where these files are installed.