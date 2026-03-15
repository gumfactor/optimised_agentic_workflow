# [Project Name]

> Layer 2 project context. Overrides personal defaults in `gumfactor/optimised_agentic_workflow` where stated.

## Document Metadata

- Guidance version: `1.2.0`
- Last updated: `[TODO — YYYY-MM-DD]`
- Versioning model: semantic versioning for guidance docs (`MAJOR.MINOR.PATCH`)
- Targets Layer 1 version: `[TODO — e.g. 1.2.0]`

---

## What This Project Is

[TODO — 2–3 sentence description of what this project does, who uses it, and what problem it solves]

**Data sovereignty tier:** [TODO — choose one]

- `standard` — Canadian data residency required (data stored in Canada; US-company managed services acceptable)
- `strict` — Canadian ownership required (WHC VPS, AWS ca-central-1 only; no US-company managed services)

---

## Stack

| Layer | Choice | Notes |
|---|---|---|
| Language | TypeScript | End-to-end default for frontend, backend, and scripts |
| Frontend framework | Next.js (App Router) | Default web app framework |
| Backend framework | Fastify | Service/API default |
| Database | PostgreSQL | Primary relational datastore |
| ORM / query layer | Drizzle ORM | Type-safe schema + queries |
| Auth | Auth.js | Provider adapters by project needs |
| Hosting | Fly.io (yyz) or WHC VPS | Fly.io for standard tier, WHC VPS for strict sovereignty |
| CI/CD | GitHub Actions | Required checks gate merge/deploy |

**Deviations from personal defaults:** none

**Policy change note (required on updates):** [TODO — brief summary of what changed in this guidance version]

---

## Project Structure

```
[TODO — paste a `tree -L 2` output or describe key folders]
```

Key areas:

- `[TODO path]` — [what lives here]
- `[TODO path]` — [what lives here]

---

## Commands

```bash
# Install
[TODO]

# Run dev
[TODO]

# Run tests
[TODO]

# Lint / type check
[TODO]

# Build
[TODO]

# Database migrations
[TODO]
```

---

## Optional Autonomy Modes

Configure these only if you want agents to use them. Leave disabled otherwise.

### Self-Healing Validation Loop

**Enabled:** `[TODO — yes/no]`

**Activation style:** `[TODO — manual-trigger (recommended) / always-on]`

**Manual trigger phrases (required if manual-trigger):**
`[TODO — e.g. "self-heal on", "run self-healing", "heal as you go"]`

**Approved commands:**

```bash
[TODO — e.g. pnpm test -- --runInBand src/foo/*.test.ts]
[TODO — e.g. pnpm lint src/foo --max-warnings=0]
```

**Scope:** `[TODO — paths, packages, or services this mode may touch]`

**Excluded paths / sensitive areas:** `[TODO]`

**Remediation log path:** `[TODO — e.g. docs/agent-remediation-log.md or .agent/logs/self-healing.jsonl]`

**Retry budget:** `[TODO — e.g. 3 retries per issue, 10 total attempts, 30 minutes max]`

**Allowed auto-fixes:** `[TODO — e.g. tests, local logic fixes, config corrections inside service boundary]`

**Must escalate for:** `[TODO — e.g. dependency upgrades, schema changes, auth, billing, public API]`

### Proactive Hygiene Sweep

**Enabled:** `[TODO — yes/no]`

**Activation style:** `[TODO — manual-trigger (recommended) / always-on]`

**Manual trigger phrases (required if manual-trigger):**
`[TODO — e.g. "hygiene sweep", "proactive fix pass", "find and fix nearby issues"]`

**Approved search / validation commands:**

```bash
[TODO — e.g. pnpm lint]
[TODO — e.g. pnpm typecheck]
[TODO — e.g. pnpm test -- --changedSince=origin/main]
[TODO — e.g. rg "TODO|FIXME" src]
```

**Scope:** `[TODO — where opportunistic fixes are allowed]`

**Excluded paths / sensitive areas:** `[TODO]`

**Issue log path:** `[TODO — e.g. docs/agent-hygiene-log.md or .agent/logs/hygiene.jsonl]`

**Sweep budget:** `[TODO — e.g. 60 minutes or 15 findings per run]`

**Severity / triage rule:** `[TODO — what counts as high, medium, low and what must be fixed immediately]`

**Allowed auto-fixes:** `[TODO — e.g. lint errors, missing tests near touched code, straightforward type fixes]`

**Must escalate for:** `[TODO — e.g. repo-wide refactors, security posture changes, flaky test investigation across teams]`

---

## Environment Setup

Required environment variables (never commit values):

```
[TODO — list variable names and what they're for]
```

Where to get them: [TODO — e.g. "ask team lead", "AWS Secrets Manager ca-central-1", "Infisical instance"]

---

## Architecture Notes

[TODO — describe any non-obvious architecture decisions: why this pattern, what not to change, known constraints]

---

## MCP Tools Available

[TODO — list any MCP servers configured for this project, what they do, and when to use them]
[Remove this section if no MCP tools are in use]

---

## Sensitive Areas

The following require extra care or explicit approval before changing:

- [TODO — e.g. "auth middleware — touch only with security review"]
- [TODO — e.g. "payment flow in `/src/billing` — no changes without QA sign-off"]

---

## Known Issues / Tech Debt

[TODO — note anything an agent should know about before diving in: known workarounds, temporary hacks, areas to avoid touching]
[Remove or mark "none" if not applicable]

---

## Deployment

**Environments:** [TODO — e.g. preview (auto per PR), staging, production]  
**How to deploy to staging:** [TODO]  
**How to deploy to production:** [TODO — note if this requires manual approval]  
**Rollback procedure:** [TODO]

**Changelog policy:** [TODO — where changelog lives and who updates it at release time]  
**Release note policy:** [TODO — where release notes are published and required sections]

---

## Team Context

**Repo owner:** [TODO]  
**Primary reviewers:** [TODO]  
**Slack / comms channel:** [TODO]  
[Remove this section for solo projects]

---

## Autonomy Readiness Checklist

Mark complete before granting full autonomy to agents:

- [ ] Purpose and scope are complete.
- [ ] Data sovereignty tier is declared (`standard` or `strict`).
- [ ] Command block is fully filled and verified.
- [ ] Environment variable inventory is complete.
- [ ] Sensitive areas and approval boundaries are explicit.
- [ ] Deployment and rollback steps are tested in non-production.
- [ ] Changelog and release-note process is defined.
- [ ] Owners/reviewers are defined.
- [ ] Optional autonomy modes are either disabled or fully configured.
