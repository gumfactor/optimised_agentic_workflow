# Workflow Patterns

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

## When to Stop and Escalate

Stop and surface to the developer when:
- The root cause is ambiguous and multiple interpretations would lead to different solutions
- The fix requires changing a public interface or shared contract
- The change would affect more than one service or team's scope
- A test is failing and the fix isn't clear within 2 attempts

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

If any checklist item is incomplete, agents may proceed with implementation work but must surface assumptions and avoid high-impact actions.
