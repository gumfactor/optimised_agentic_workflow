# Stack Defaults

## Document Metadata

- Guidance version: `1.2.0`
- Last updated: `2026-03-15`
- Versioning model: semantic versioning for guidance docs (`MAJOR.MINOR.PATCH`)

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

**Auth decision policy:**
- Default auth architecture: Auth.js + PostgreSQL session/account tables on the same project database.
- For Canadian residency projects, run auth and database in Canada (Fly.io `yyz` or WHC VPS / ca-central-1 managed services).
- Supabase is opt-in, not default. Use it only when a project explicitly needs bundled platform capabilities (auth + storage + realtime + instant APIs).
- If only auth is required, prefer Auth.js over self-hosted Supabase to minimize operational complexity.
- If Supabase is selected, document why in project `AGENTS.md`, pin versions, and define backup/patching cadence before launch.

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

**Preferred hosting:** Fly.io (yyz — Toronto) for all services; deploy all apps as Docker containers pinned to the `yyz` region  
**Strict sovereignty alternative:** WHC VPS (whc.ca — Montreal) for projects requiring Canadian company ownership of infrastructure, in addition to Canadian data residency  
**CDN:** Cloudflare (Canadian PoPs in Toronto, Vancouver, Montreal)  
**File/media storage:** AWS S3 (ca-central-1 — Montreal) or Cloudflare R2  
**Database hosting:** Neon (ca-central-1) or self-hosted PostgreSQL on Fly.io (yyz) / WHC VPS  
**Containers:** Docker for all services — required for Fly.io deployment and WHC VPS portability  
**Secrets management:** AWS Secrets Manager (ca-central-1) as default; self-hosted Infisical on WHC VPS for strict sovereignty projects  
**CI/CD:** GitHub Actions (hosted runners are acceptable for CI; for strict sovereignty projects use self-hosted runners on WHC VPS)

**Data residency policy:**
- All projects default to Canadian data residency (data physically stored in Canada).
- Projects flagged as strict sovereignty must also use Canadian-owned infrastructure (WHC VPS) and avoid US-company managed services where alternatives exist.
- When starting a project, explicitly declare in its `AGENTS.md` whether it is standard (Canadian residency) or strict sovereignty (Canadian ownership required).
- Vercel is not an acceptable default — it has no Canadian compute region.

---

## How to Use This

Treat these as the default decisions unless a project-level `AGENTS.md` explicitly overrides them. If you deviate, document why and what risk the deviation introduces.
