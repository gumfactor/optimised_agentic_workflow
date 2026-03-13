# Agent Task Templates

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
3. Copy `templates/CLAUDE.md` to the new project root and fill in all `[TODO]` fields based on what's been confirmed
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
