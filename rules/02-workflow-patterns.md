# Workflow Patterns

## Document Metadata

- Guidance version: `1.2.0`
- Last updated: `2026-03-15`
- Versioning model: semantic versioning for guidance docs (`MAJOR.MINOR.PATCH`)

How I structure development work. Agents should follow these patterns unless the project `AGENTS.md` specifies otherwise.

---

## Branch Strategy

**Model:** GitHub Flow (short-lived branches off `main`)

**Branch naming:**

```
feat/<short-slug>
fix/<short-slug>
chore/<short-slug>
spike/<short-slug>   ← exploratory, never merged directly
```

**Rules:**

- `main` is always deployable
- Short-lived branches only — if a branch lives more than a few days, it should be broken into smaller pieces
- Never force-push to `main` or shared branches without explicit approval

**Commit cadence on active branches:**

- On any day work is performed on a branch, make at least one meaningful commit.
- No commit is required on inactive days.
- Never create synthetic or empty commits just to satisfy cadence.
- If a branch is inactive for 5 business days, close/archive it or leave a status note in the PR/issue.

---

## Commit Style

**Format:** Conventional Commits  

```
feat: add user invitation flow
fix: correct token expiry calculation
chore: update dependencies
```

**Rules:**

- One logical change per commit
- Commit message describes *what changed and why*, not *what files were touched*
- Do not squash informative commit history without reason
- Commit format: `type(scope): concise outcome`.
- Use a commit body for non-trivial changes including what changed, why, and rollback notes.
- Avoid mixing unrelated work types in one commit (feature + refactor + chore).

---

## Pull Request Pattern

**Before opening a PR:**

- Lint, type checks, and tests pass locally
- Self-review: read the diff as if reviewing someone else's code
- Description covers: what changed, why, and how to verify
- Include risk level and rollback plan for medium/high-risk changes.

**PR size target:** Reviewable in under 15 minutes. If larger, split it.

**Merge strategy:** Squash merge (single clean commit to `main`)

**Required status checks before merge:**

- Policy compliance (`scripts/policy-lint.sh`)
- Lint
- Type check
- Unit/integration tests
- Build
- Security/dependency scan (if configured)

**Approvals default:**

- 1 approval required for standard changes.
- 2 approvals required for security, schema, or public API contract changes.

**Agent merge authority:**

- Agents may open and update PRs.
- Agents may not merge high-risk PRs without explicit human approval.

**Solo-repository exception:**

- In single-maintainer repositories, direct commits to `main` are allowed.
- Even in solo mode, required checks still apply (`lint`, `typecheck`, `test`, `build` where available).
- In solo mode, every production-affecting change must still update changelog/release-note artifacts.
- If a repository moves from solo to team collaboration, default PR and approval rules apply immediately.

---

## Feature Development Flow

When building a new feature, follow this sequence:

1. **Clarify** — confirm acceptance criteria before writing code; flag ambiguity
2. **Scaffold** — create the skeleton (types, interfaces, routing) before implementing logic
3. **Implement** — fill in logic in small verifiable steps
4. **Test** — write or update tests as part of the same unit of work, not afterward
5. **Review** — self-review the diff, then open PR
6. **Ship** — merge only when checks pass; document rollback if risk is non-trivial

Agents should not jump straight to implementation without completing step 1.

---

## Bug Fix Flow

1. **Reproduce** — confirm the bug is reproducible before changing anything
2. **Isolate** — identify the root cause; don't fix symptoms
3. **Fix** — minimal change that addresses root cause
4. **Regression test** — add a test that would have caught this
5. **Document** — note cause and fix in the PR description

---

## Optional Execution Modes

These are opt-in workflows. They are active only when a project-level `AGENTS.md` enables them and fills in the required commands, scope, and safeguards.

### Self-Healing Validation Loop

Use this mode when the agent should continuously validate and remediate during implementation.

**Activation behavior:**

- `manual-trigger`: run only when the user includes a configured trigger phrase in the request.
- `always-on`: run by default for in-scope implementation tasks.
- Recommended default: `manual-trigger`.

**Activation prerequisites:**

- Activation style and trigger phrases (if manual) are defined.
- Approved validation commands are defined.
- A remediation log path is defined.
- Retry ceilings and escalation thresholds are defined.
- Excluded paths and sensitive areas are explicit.

**Operating sequence:**

1. Establish validation checkpoints before editing: after scaffold, after each meaningful logic change, and before handoff.
2. Run the narrowest relevant tests first: touched unit tests, nearest package/module tests, then wider suites only if the narrow checks pass.
3. Append a remediation-log entry for each run with timestamp, command, result, hypothesis, and touched files.
4. If validation fails, isolate the smallest failing unit, apply the minimal corrective change, and rerun the same command before expanding scope.
5. After the original failure is green, run adjacent validation to confirm the fix did not regress nearby behavior.
6. Stop only when the configured validation set is green or an escalation condition is triggered.

**Escalation conditions:**

- Same failure repeats twice with no meaningful signal improvement.
- Fix would cross a public API, schema, dependency, or approval boundary.
- Wider validation reveals unrelated failures outside allowed scope.
- Retry or time budget is exhausted.

### Proactive Hygiene Sweep

Use this mode when the agent should actively look for additional issues and fix safe ones beyond the immediate request.

This is a gentle maintenance pass, not a feature-delivery mode.

**Activation behavior:**

- `manual-trigger`: run only when the user includes a configured trigger phrase in the request.
- `always-on`: run by default for in-scope tasks after primary implementation validation is complete.
- Recommended default: `manual-trigger`.

**Activation prerequisites:**

- Activation style and trigger phrases (if manual) are defined.
- Approved search and validation commands are defined.
- A hygiene issue log path is defined.
- A severity model or triage rule is defined.
- Scope boundaries for opportunistic fixes are explicit.

**Operating sequence:**

1. Build an issue queue from objective signals only: failing tests, lint errors, type errors, static analysis findings, and documented TODO or FIXME markers if the project allows them.
2. Limit scope to maintenance findings: security flaws, correctness bugs, reliability defects, rendering or character-encoding issues, accessibility regressions, and standards compliance issues.
3. Rank findings by severity, user impact, and proximity to the current task.
4. Fix one issue at a time, starting with high-confidence, low-blast-radius defects.
5. Validate each fix immediately with the narrowest command that proves resolution, then rerun the relevant broader check.
6. Record every finding as `fixed`, `deferred`, or `blocked`, including rationale for anything not remediated.
7. End the sweep when no in-scope actionable issues remain or only approval-gated work is left.

**Scope controls:**

- Do not convert a feature task into a repo-wide cleanup.
- Do not rewrite stable areas merely because improvements are possible.
- Do not create or expand product features under hygiene mode.
- Keep opportunistic changes reviewable and logically separate from the primary task when practical.

---

## When to Stop and Escalate

Stop and surface to the developer when:

- The root cause is ambiguous and multiple interpretations would lead to different solutions
- The fix requires changing a public interface or shared contract
- The change would affect more than one service or team's scope
- A test is failing and the fix isn't clear within 2 attempts
- An optional autonomous mode reaches its configured retry or time budget
- The remaining issues are real but outside configured auto-fix permissions

Do not retry indefinitely. Surface the blocker with context.

---

## Release and Deployment

**Deployment trigger:** Merge to `main` auto-deploys to production after checks pass; manual promote for high-risk changes  
**Environments:** Preview per PR, staging (integration), production  
**Rollback method:** Revert commit + redeploy last green build; use feature flags for fast mitigation when available

Agents may not trigger production deployments without explicit approval.

## Changelog and Release Notes

- Maintain a changelog for user-visible or integration-impacting changes.
- Update changelog at release time, not for every commit.
- Changelog categories: Added, Changed, Fixed, Deprecated, Removed, Security.
- Mark breaking changes explicitly with migration steps.
- Every production deployment must publish release notes.
- Release notes must include: user-facing changes, operational changes, breaking changes, and rollback instructions.
- Tag each release note with risk level: low, medium, or high.

---

## Autonomy Bootstrap Checklist

Agent autonomy is fully active only after all items below are complete in the project-level `AGENTS.md`:

1. Project purpose and scope are explicitly written.
2. Commands are filled and verified (`install`, `dev`, `test`, `lint`/`typecheck`, `build`, migrations).
3. Environment variable list is complete (names and meaning, no values).
4. Sensitive areas are documented with approval requirements.
5. Deployment and rollback procedure is documented and tested in non-production.
6. Primary reviewers or owners are identified.
7. Optional autonomy modes are either disabled or fully configured with commands, logs, scope, and stop conditions.

If any checklist item is incomplete, agents may proceed with implementation work but must surface assumptions and avoid high-impact actions.
