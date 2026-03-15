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

- Script: `scripts/proactive-hygiene.sh` — the hygiene logic; copied to each target repo
- Reusable workflow: `.github/workflows/proactive-hygiene-reusable.yml` — central, callable definition
- Caller workflow (installed to target repos): `templates/workflows/proactive-hygiene.yml` → `.github/workflows/proactive-hygiene.yml`
- Log output: `.agent/logs/hygiene.md`
- Schedule: daily via GitHub Actions cron, plus manual `workflow_dispatch`

The automation is intentionally maintenance-only. It must not perform net-new feature work.

### How the reusable workflow pattern works

This repo hosts the full workflow logic in one place (`proactive-hygiene-reusable.yml`). Target repos receive a tiny caller file that references it:

```yaml
jobs:
  hygiene:
    uses: gumfactor/optimised_agentic_workflow/.github/workflows/proactive-hygiene-reusable.yml@main
```

This means:

- Workflow logic updates (steps, tools, patterns) are inherited by all target repos automatically on next run.
- Only the hygiene script needs re-syncing when its logic changes.
- Target repos control their own schedule and trigger settings in the caller file.
