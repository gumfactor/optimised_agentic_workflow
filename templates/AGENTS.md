# [Project Name]

> Layer 2 project context. Overrides personal defaults in `gumfactor/optimised_agentic_workflow` where stated.

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
