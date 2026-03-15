# Global Agent Governance

## Document Metadata

- Guidance version: `1.2.0`
- Last updated: `2026-03-15`
- Versioning model: semantic versioning for guidance docs (`MAJOR.MINOR.PATCH`)

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

## Optional Autonomous Operating Modes

Two higher-autonomy modes may be enabled at Layer 2. Both are `off` by default and require explicit project-level configuration before use.

### Mode A: Self-Healing Validation Loop

- Purpose: run tests during implementation, log each validation attempt, fix failures related to the current work, and continue until either the checks pass or a stop condition is met.
- Scope default: only the files, modules, and tests directly touched by the active task.
- Allowed behavior when enabled: run approved local validation commands, create or update tests related to the task, make bounded corrective edits, and re-run validation.
- Not allowed without separate approval: broad refactors, dependency upgrades, schema changes, production actions, or fixes outside configured scope.

### Mode B: Proactive Hygiene Sweep

- Purpose: actively search for adjacent quality and risk issues, fix safe ones, and leave a documented queue for anything that exceeds scope or approval boundaries.
- Scope default: the current task surface plus explicitly listed hygiene targets in project `AGENTS.md`.
- Allowed behavior when enabled: run approved search, lint, typecheck, test, and static-analysis commands; remediate local defects in maintenance categories; and document deferred findings.
- Maintenance categories include: security flaws, correctness bugs, reliability issues, rendering and character-encoding issues, accessibility regressions, and clear standards compliance defects.
- Not allowed without separate approval: net-new feature development, major feature expansion, repo-wide churn, speculative rewrites, policy relaxations, or opportunistic changes in sensitive areas.

### Layer 2 Activation Requirements

Projects must define all of the following before either mode is considered active:

- Whether the mode is enabled.
- Activation style: `manual-trigger` or `always-on`.
- Manual trigger phrases if `manual-trigger` is selected.
- Which commands are approved for the mode.
- Which paths are in scope and which are excluded.
- Where remediation and issue logs are written.
- Maximum retry counts, time budget, and escalation threshold.
- Which change classes are allowed for auto-fix and which require human approval.

If any activation input is missing, agents must treat the mode as disabled.

### Manual Trigger Rule (Recommended Default)

- Recommended default for both optional modes: `manual-trigger`.
- In `manual-trigger`, the mode is preconfigured but inactive until the user explicitly invokes it in the request.
- If no trigger phrase appears, agents must run normal mode behavior even when the optional mode is enabled.
- A project should define short trigger aliases (for example `self-heal on` and `hygiene sweep`) to keep activation fast and explicit.

## Reliability Contract

- Every meaningful change must include validation evidence.
- Prefer small, incremental changes over large speculative rewrites.
- Preserve existing public interfaces unless change impact is documented.
- On failure: stop, surface root cause, propose safe recovery options — do not retry blindly.
- When an optional autonomous mode is active, every loop iteration must be logged with the command run, result, files touched, and next decision.
- Autonomous retry loops must be bounded. Default ceiling if Layer 2 does not specify a stricter value: 3 fix attempts per issue and 10 total remediation attempts per task.
- If the same failure repeats twice without measurable improvement, stop the loop and escalate with evidence.
- Validation must narrow before it broadens: run focused checks first, then wider suites only after local checks pass.

## Policy Enforcement

- Governance must be enforceable by checks, not only prose. If a policy can be tested, automate it.
- Every repo must expose standard validation commands in `package.json` scripts (or language-equivalent): `lint`, `typecheck`, `test`, `build`.
- Every repo must include and pass a mandatory policy-lint gate (`bash scripts/policy-lint.sh`) in CI.
- CI must block merges when required checks fail.
- Required checks for protected branches: lint, typecheck, unit/integration tests, and build.
- If security scanning is available, it is required on pull requests and main branch merges.
- Any bypass of required checks requires explicit approval and a written rationale in the PR.
- Rule exceptions must be time-bound and tracked with an owner and removal date.
- If self-healing or proactive hygiene modes are enabled, their log artifacts must be retained in the workspace or CI artifacts long enough to support review.

## Security Baseline

- Never commit secrets, keys, tokens, or credentials.
- Minimize sensitive data in logs, errors, and traces.
- Follow least-privilege principles for integrations and runtime permissions.

## Data Classification Policy

- Use four default data classes: `public`, `internal`, `confidential`, `restricted`.
- `public`: safe for external disclosure.
- `internal`: non-public operational/business data with low sensitivity.
- `confidential`: customer or business-sensitive data requiring controlled access.
- `restricted`: highest sensitivity data (credentials, financial data, high-risk personal data, legal-sensitive records).
- If classification is uncertain, default upward to `confidential`.
- `confidential` and `restricted` data must remain in approved Canadian regions unless project policy explicitly allows otherwise.
- `restricted` data must never appear in logs, prompts, error payloads, or analytics events.

## Guidance Versioning and Change Control

- All guidance documents in this repository and project repositories must declare a document version.
- Versioning uses semantic versioning:
 	- `PATCH`: wording/clarity updates with no behavioral policy change.
 	- `MINOR`: additive policy updates that are backward compatible.
 	- `MAJOR`: breaking policy changes requiring project behavior updates.
- Every guidance update must include a short change note in commit message body.
- Major version changes must include an explicit migration note describing what projects must update.
- Project-level `AGENTS.md` should record which Layer 1 guidance version it targets.

## Logging and Audit Baseline

- Application logs must be structured JSON in non-local environments.
- Every request or job must carry a correlation ID that is propagated across service boundaries.
- Minimum log fields: timestamp, level, service, environment, correlation ID, event name.
- Logs must never include secrets, raw tokens, full credentials, or sensitive personal payloads.
- State-changing and permission-sensitive actions must emit audit events.
- Minimum audit fields: actor, action, target, timestamp, source, correlation ID, outcome.
- Audit trails must be append-only and access-restricted.
- Retention defaults: application logs 30-90 days; audit/security logs 365 days unless stricter requirements apply.
- Any override to retention defaults must be documented in project `AGENTS.md` with rationale.

## Communication Style

- State assumptions before high-impact decisions.
- Report progress at short checkpoints during multi-step work.
- Report blockers immediately with options and tradeoffs — not just the problem.
- Provide concise change summaries with validation outcomes.
- When an autonomous mode is active, distinguish between `fixed`, `deferred`, and `blocked` issues in the summary.

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
- Release communication: changelog and release notes updated when user-facing or operational behavior changes.

Mode-specific completion criteria when enabled:

- Self-healing mode: relevant validation commands are green, remediation log shows each failed-to-pass transition, and unresolved items are explicitly marked with owner and next action.
- Proactive hygiene mode: configured issue-search commands have been run, safe findings were either fixed or logged as deferred, and no high-severity actionable finding remains unclassified.
