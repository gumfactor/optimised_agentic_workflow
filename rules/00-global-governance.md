# Global Agent Governance

## Purpose
Define the autonomy contract: what agents may do freely, what requires approval, and how to behave under uncertainty.

This is Layer 1 — it applies to every project unless explicitly overridden in that project's `AGENTS.md`.

## Operating Principles
- Bias toward action over asking. If the decision is reversible and low-risk, do it.
- Prefer small, verifiable steps over large speculative rewrites.
- Use constraints and outcomes to guide decisions — not rigid implementation prescriptions.
- Keep actions explainable: be able to describe what you did and why.

## Workspace Autonomy Boundary
- Agents may autonomously read, create, edit, and validate files inside this repository workspace.
- Agents may autonomously run build, lint, test, and local tooling commands within workspace scope.
- Any action outside this workspace requires explicit human approval first.
- Any network, system, or account-level change that could impact other projects requires explicit approval.

## Mandatory Approval Matrix
Approval is required before:
- Reading or modifying files outside the project workspace.
- Creating, rotating, or exposing secrets and credentials.
- Running destructive operations (data deletion, force push, dropping schemas, irreversible migrations).
- Publishing releases, deploying to production, or changing billing-impacting resources.
- Installing system-level packages not already approved for this environment.

## Decision Rights
Agents may decide autonomously when:
- The change is local to this repo.
- The change is reversible with a clear rollback path.
- Verification can be executed in the current environment.
- Security and privacy constraints are not weakened.

## Reliability Contract
- Every meaningful change must include validation evidence.
- Prefer small, incremental changes over large speculative rewrites.
- Preserve existing public interfaces unless change impact is documented.
- On failure: stop, surface root cause, propose safe recovery options — do not retry blindly.

## Policy Enforcement
- Governance must be enforceable by checks, not only prose. If a policy can be tested, automate it.
- Every repo must expose standard validation commands in `package.json` scripts (or language-equivalent): `lint`, `typecheck`, `test`, `build`.
- CI must block merges when required checks fail.
- Required checks for protected branches: lint, typecheck, unit/integration tests, and build.
- If security scanning is available, it is required on pull requests and main branch merges.
- Any bypass of required checks requires explicit approval and a written rationale in the PR.
- Rule exceptions must be time-bound and tracked with an owner and removal date.

## Security Baseline
- Never commit secrets, keys, tokens, or credentials.
- Minimize sensitive data in logs, errors, and traces.
- Follow least-privilege principles for integrations and runtime permissions.

## Communication Style
- State assumptions before high-impact decisions.
- Report progress at short checkpoints during multi-step work.
- Report blockers immediately with options and tradeoffs — not just the problem.
- Provide concise change summaries with validation outcomes.

## Definition of Done
A task is complete only when:
- Requirements are implemented and traceable.
- Relevant tests and checks pass, or gaps are explicitly documented with rationale and owner.
- Risks, caveats, and rollback path are noted for non-trivial changes.
- Handoff is clear and actionable.

Minimum measurable gates (unless Layer 2 explicitly overrides):
- `lint`: zero errors.
- `typecheck`: zero errors.
- `test`: all tests pass; no new flaky test introduced.
- Coverage: no decrease on touched files and at least 80% line coverage for new or heavily modified modules.
- Performance: no regression above 10% on established benchmarked paths (when benchmarks exist).
- Security: zero known high/critical vulnerabilities introduced by new dependencies.
- Docs: update required when behavior, setup, or operations change.
