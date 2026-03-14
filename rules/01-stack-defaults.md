# Stack Defaults

Personal technology defaults for new projects. These represent my actual preferences — not generic best practice. When a project's `AGENTS.md` specifies different choices, defer to that.

---

## Language and Runtime

**Default:** TypeScript everywhere (frontend, backend, scripts).  
Rationale: single language, strong types, good tooling across the stack.

**Deviations allowed:** Python for ML/data workloads, SQL for migrations.  
**Not acceptable:** untyped JavaScript in new code without explicit justification.

---

## Frontend

**Framework:** Next.js (App Router)  
**Styling:** Tailwind CSS + CSS variables  
**Component pattern:** functional components only, no class components  
**State:** Zustand (client state) + TanStack Query (server state)  
**Forms:** React Hook Form + Zod

Non-negotiables regardless of framework:
- Validate all form input client-side before submission
- Accessible by default — don't add ARIA as an afterthought
- No inline styles except for truly dynamic values

---

## Backend

**Runtime:** Node.js (LTS)  
**Framework:** Fastify  
**API style:** REST  
**Validation:** Zod for all request/response validation at boundaries  
**Error shape:** RFC 9457 (Problem Details) for all API errors  
**Auth:** Auth.js (with provider adapters as needed)

Non-negotiables:
- Validate at every external boundary — never trust input
- Idempotency on operations that may be retried
- Structured logging with correlation IDs

---

## Database

**Default:** PostgreSQL  
**ORM/query layer:** Drizzle ORM  
**Migration strategy:** additive-first; destructive changes require explicit approval  
**Connection:** pooled via PgBouncer (or managed equivalent)

Non-negotiables:
- Migrations are version-controlled and deterministic
- Rollback strategy documented for every destructive migration
- No nullable columns without intentional reasoning

---

## Toolchain

**Package manager:** pnpm  
**Linter:** ESLint  
**Formatter:** Prettier  
**Test runner:** Vitest (unit/integration) + Playwright (E2E)  
**Monorepo:** Turborepo when multiple deployable apps/packages exist; otherwise none

---

## Hosting and Infrastructure

**Preferred hosting:** Vercel (web) + Fly.io (stateful services/workers when needed)  
**Containers:** Docker for anything that isn't pure serverless  
**Secrets management:** Doppler + environment-level `.env` injection  
**CI/CD:** GitHub Actions

---

## How to Use This

Treat these as the default decisions unless a project-level `AGENTS.md` explicitly overrides them. If you deviate, document why and what risk the deviation introduces.
