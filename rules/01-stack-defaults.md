# Stack Defaults

Personal technology defaults for new projects. These represent my actual preferences — not generic best practice. When a project's `CLAUDE.md` specifies different choices, defer to that.

---

## Language and Runtime

**Default:** TypeScript everywhere (frontend, backend, scripts).  
Rationale: single language, strong types, good tooling across the stack.

**Deviations allowed:** Python for ML/data workloads, SQL for migrations.  
**Not acceptable:** untyped JavaScript in new code without explicit justification.

---

## Frontend

**Framework:** [TODO — e.g. Next.js / Remix / SvelteKit]  
**Styling:** [TODO — e.g. Tailwind CSS / CSS Modules]  
**Component pattern:** functional components only, no class components  
**State:** [TODO — e.g. Zustand / Jotai / React Query for server state]  
**Forms:** [TODO — e.g. React Hook Form + Zod]

Non-negotiables regardless of framework:
- Validate all form input client-side before submission
- Accessible by default — don't add ARIA as an afterthought
- No inline styles except for truly dynamic values

---

## Backend

**Runtime:** [TODO — e.g. Node.js / Bun / Deno]  
**Framework:** [TODO — e.g. Hono / Fastify / Express]  
**API style:** [TODO — e.g. REST / tRPC / GraphQL]  
**Validation:** Zod for all request/response validation at boundaries  
**Error shape:** RFC 9457 (Problem Details) for all API errors  
**Auth:** [TODO — e.g. Clerk / Auth.js / custom JWT]

Non-negotiables:
- Validate at every external boundary — never trust input
- Idempotency on operations that may be retried
- Structured logging with correlation IDs

---

## Database

**Default:** [TODO — e.g. PostgreSQL / SQLite / PlanetScale]  
**ORM/query layer:** [TODO — e.g. Drizzle / Prisma / Kysley]  
**Migration strategy:** additive-first; destructive changes require explicit approval  
**Connection:** [TODO — e.g. direct / pooled via PgBouncer / Neon serverless]

Non-negotiables:
- Migrations are version-controlled and deterministic
- Rollback strategy documented for every destructive migration
- No nullable columns without intentional reasoning

---

## Toolchain

**Package manager:** [TODO — e.g. pnpm / npm / bun]  
**Linter:** ESLint  
**Formatter:** Prettier  
**Test runner:** [TODO — e.g. Vitest / Jest / Playwright for E2E]  
**Monorepo:** [TODO — e.g. Turborepo / none]

---

## Hosting and Infrastructure

**Preferred hosting:** [TODO — e.g. Vercel / Fly.io / Railway / AWS]  
**Containers:** Docker for anything that isn't pure serverless  
**Secrets management:** [TODO — e.g. .env + Doppler / AWS SSM / Vercel env]  
**CI/CD:** [TODO — e.g. GitHub Actions]

---

## How to Fill This In

Replace every `[TODO]` with your actual choice. The value isn't the structure — it's that agents know your actual defaults so they stop asking or guessing wrong.
