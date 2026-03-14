# Personal Agent Defaults

## Document Metadata

- Guidance version: `1.1.0`
- Last updated: `2026-03-14`
- Versioning model: semantic versioning for guidance docs (`MAJOR.MINOR.PATCH`)

This repository is **Layer 1** agent configuration — personal defaults, workflow patterns, and task templates that travel with me across all projects.

## What This Is

A portable set of constraints, preferences, and reusable agent task patterns.  
It is **not** a project. It has no stack, no commands, no architecture to describe.  
It defines *how I work*, not *what I'm building*.

## How Agents Should Use This Repo

Load these files when starting any session where they are relevant:

| File | When to load |
|---|---|
| `rules/00-global-governance.md` | Always — defines autonomy boundaries and escalation rules |
| `rules/01-stack-defaults.md` | When starting a new project or making stack decisions |
| `rules/02-workflow-patterns.md` | When managing branching, commits, PRs, or delivery flow |
| `rules/03-agent-task-templates.md` | When executing a named task type (feature, bug, review, etc.) |

## How to Start a New Project

1. Copy `templates/AGENTS.md` into the new project root.
2. Fill in every `[TODO]` section with project-specific context.
3. Reference this repo's rules as the Layer 1 baseline — override specific items in the project `AGENTS.md` where the project differs.

## Layer 1 vs Layer 2

- **This repo (Layer 1):** Personal defaults. Universal. Project-agnostic.
- **Project `AGENTS.md` (Layer 2):** Project-specific. Stack, commands, architecture, MCP tools, deployment. Overrides Layer 1 where stated.

Agents should treat Layer 2 as authoritative where it conflicts with Layer 1.

## This Repository Runtime Mode Config

This repository is guidance-first, so optional autonomy modes are configured for documentation maintenance workflows only.

### Self-Healing Validation Loop
- Enabled: `yes`
- Activation style: `manual-trigger`
- Manual trigger phrases: `self-heal on`, `run self-healing`
- Approved commands:
	- `markdownlint "**/*.md"`
	- `rg "Guidance version" AGENTS.md rules templates`
- Scope: `AGENTS.md`, `rules/**/*.md`, `templates/**/*.md`, `CHANGELOG.md`
- Excluded paths / sensitive areas: non-markdown files, git history rewrites, external systems
- Remediation log path: `.agent/logs/self-healing.md`
- Retry budget: `3 retries per issue`, `10 total attempts per task`, `30 minutes max`
- Allowed auto-fixes: markdown clarity/consistency fixes, metadata version alignment, internal link/section consistency
- Must escalate for: structural policy changes, changes affecting non-doc automation, any action outside workspace

Default behavior: even though configured, self-healing stays off unless one of the trigger phrases is explicitly present in the request.
