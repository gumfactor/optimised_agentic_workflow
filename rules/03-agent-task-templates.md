# Agent Task Templates

## Document Metadata

- Guidance version: `1.1.0`
- Last updated: `2026-03-14`
- Versioning model: semantic versioning for guidance docs (`MAJOR.MINOR.PATCH`)

Reusable invocation patterns for common task types. Use these as the expected shape of agent behavior when a task is initiated. Agents should self-apply the relevant template when a task matches a named type.

---

## Task: Build a Feature

**Trigger:** "build", "implement", "add", "create [feature]"

**Steps the agent must follow:**

1. Restate the feature in one sentence and confirm it matches intent before writing code
2. Identify all surfaces affected: UI, API, DB schema, tests, types
3. Check for existing patterns in the codebase to follow — don't invent new conventions when one already exists
4. Build in this order: types/schema → API/logic → UI → tests
5. Validate: lint, type check, relevant tests pass
6. Summarize what was built, what was intentionally excluded, and any open questions

**Stop and ask if:**
- Acceptance criteria are ambiguous
- The feature requires a public API or schema change with downstream impact
- No clear existing pattern exists and a new convention needs to be established

---

## Task: Fix a Bug

**Trigger:** "fix", "broken", "error", "failing", "[thing] isn't working"

**Steps:**

1. Reproduce the bug before touching anything — describe how you reproduced it
2. State the root cause hypothesis before writing the fix
3. Apply the minimal fix that addresses root cause
4. Add or update a test that would catch this regression
5. Confirm the fix doesn't break adjacent behavior

**Stop and ask if:**
- Root cause is unclear after investigation
- The fix requires modifying a shared interface or cross-service contract

---

## Task: Code Review

**Trigger:** "review this", "what do you think", "check this PR/diff"

**Output format:**

- **Critical** — must change before merge (correctness, security, data loss risk)
- **Suggested** — worth improving, not blocking
- **Note** — observations worth knowing but no action needed

Do not pad the review with praise. Be direct. If something is fine, don't mention it.

---

## Task: Start a New Project

**Trigger:** "start a new project", "scaffold", "new app", "new service"

**Steps:**

1. Load `rules/01-stack-defaults.md` and confirm which defaults apply
2. Ask for any project-specific overrides before generating anything
3. Copy `templates/AGENTS.md` to the new project root and fill in all `[TODO]` fields based on what's been confirmed
4. Scaffold the project structure using the confirmed stack
5. Confirm dev environment works: install, lint, type check, test all pass on empty scaffold
6. Leave a clear `## Next Steps` section in the project README

---

## Task: Investigate / Debug

**Trigger:** "why is", "what's causing", "investigate", "trace", "diagnose"

**Steps:**

1. Gather observability data first (logs, errors, traces) before forming a theory
2. State hypotheses explicitly, ranked by likelihood
3. Test the most likely hypothesis first with the least invasive probe
4. Report findings with evidence — don't just report a conclusion

---

## Task: Write Tests

**Trigger:** "write tests for", "add test coverage", "test this"

**Approach:**

- Test behavior, not implementation — tests should survive a refactor
- Cover: happy path, edge cases, error states, permission boundaries
- Use the existing test patterns in the project — don't introduce a new test style
- Prefer tests that are readable as documentation of expected behavior

---

## Task: Self-Healing Validation Loop

**Trigger:** "self-heal", "auto-fix until green", "heal as you go", or project automation enabling self-healing mode

**Steps:**

1. Confirm the mode is enabled in project `AGENTS.md` and read its command, scope, and retry settings before editing.
2. Define the first validation checkpoint and run the narrowest approved test command before broadening scope.
3. Write a remediation-log entry for each test run, including failure signature and current hypothesis.
4. Apply the smallest fix tied to the observed failure, then rerun the same command immediately.
5. Once the failing check passes, run the next broader approved validation command.
6. Continue until all configured checks pass or an escalation threshold is reached.
7. Finish with a summary that separates what was fixed, what was deferred, and why the loop ended.

**Stop and ask if:**
- The mode is not fully configured at Layer 2.
- The fix would cross a dependency, schema, public API, or sensitive-area boundary.
- The same failure repeats without progress.

---

## Task: Proactive Hygiene Sweep

**Trigger:** "proactively check for issues", "hygiene sweep", "find and fix adjacent issues", or project automation enabling proactive mode

**Steps:**

1. Confirm the mode is enabled in project `AGENTS.md` and load the allowed search and validation commands.
2. Build an issue list from objective signals only: tests, lint, typecheck, static analysis, and allowed issue markers.
3. Keep only maintenance findings: security flaws, correctness bugs, reliability defects, rendering or character-encoding issues, accessibility regressions, and standards compliance issues.
4. Triage the list by severity and blast radius before fixing anything.
5. Fix safe in-scope issues one at a time with immediate validation after each change.
6. Log each item as `fixed`, `deferred`, or `blocked` with a short reason.
7. End only when no actionable in-scope issues remain or the configured sweep budget is exhausted.

**Stop and ask if:**
- The remaining findings need approval or cross-team decisions.
- The sweep starts expanding into broad refactors or policy changes.
- The work would become net-new feature development or major feature expansion.
- The issue source is ambiguous and no high-confidence next move exists.

---

## Task: Refactor

**Trigger:** "refactor", "clean up", "restructure"

**Rules:**

- Refactoring must not change observable behavior
- Make the change in isolation from feature work — never combine a refactor with a feature in the same commit
- Run the full test suite before and after to confirm no regression
- If the refactor reveals a bug, stop, document it, and handle it separately

---

## Task: Dependency / Library Research

**Trigger:** "what should I use for", "compare", "which library", "evaluate"

**Output format:**

- State the decision criteria first (what matters for this use case)
- Compare 2–3 realistic options against those criteria
- Give a clear recommendation with rationale
- Note what would change the recommendation

Do not list every possible option. Make a call.

---

## Task: Incident Response

**Trigger:** "incident", "outage", "sev1", "sev2", "production issue", "service down"

**Steps:**

1. Stabilize first: identify immediate mitigation actions that reduce user impact without risky rewrites.
2. Declare incident context: scope, impacted users/systems, current severity, and current hypothesis.
3. Establish timeline: first failure signal, key events, and mitigations attempted.
4. Contain blast radius: disable non-essential side effects, pause risky deploys, and isolate failing components.
5. Verify mitigation with evidence (metrics, logs, health checks).
6. Open recovery plan with explicit owners and ETA.
7. Produce post-incident summary: root cause, contributing factors, preventive actions, and follow-up tasks.

**Stop and ask if:**
- Mitigation requires production data deletion or irreversible operations.
- Remediation requires changes outside workspace boundary.

---

## Task: Security Triage

**Trigger:** "security", "vulnerability", "CVE", "auth bypass", "injection", "secret leak"

**Steps:**

1. Classify severity and exploitability (critical/high/medium/low) with concrete impact.
2. Confirm exposure: affected versions, reachable surfaces, and whether production is impacted.
3. Apply immediate containment if needed (revoke keys, disable endpoints, roll back vulnerable release).
4. Implement smallest safe fix and add regression tests for the vulnerability class.
5. Re-run security checks and dependency scans.
6. Document disclosure details internally: what happened, who is impacted, what has been mitigated, and next deadlines.

**Stop and ask if:**
- Public disclosure timing or legal/compliance communication is required.
- Fix requires emergency production action beyond approved autonomy boundaries.

---

## Task: Database Migration and Rollback

**Trigger:** "migration", "schema change", "backfill", "drop column", "rollback migration"

**Steps:**

1. Define migration type: additive, backfill, destructive, or rollback.
2. Write migration plan with preconditions, rollout steps, and rollback steps before executing.
3. Validate migration on a production-like dataset in non-production first.
4. Apply additive-first approach: deploy backward-compatible schema before application changes.
5. Run verification queries and application smoke checks after each phase.
6. Keep rollback path warm: known good artifact, reverse migration or compensating migration, and execution command.
7. Document completion evidence and any residual risk.

**Stop and ask if:**
- Migration is destructive or irreversible.
- Data correction affects financial, legal, or user-trust critical records.
