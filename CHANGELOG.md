# Changelog

All notable changes to this guidance framework are documented in this file.

The format is based on Keep a Changelog and uses semantic versioning for guidance documents.

## [Unreleased]

## [1.2.0] - 2026-03-15

### Added
- Mandatory policy compliance script at `scripts/policy-lint.sh` to enforce required guidance files, metadata blocks, version alignment, and changelog/release policy anchors.
- Reusable policy compliance workflow at `.github/workflows/policy-compliance-reusable.yml`.
- Repository policy compliance workflow at `.github/workflows/policy-compliance.yml` running on pull requests and pushes to `main`.
- Template workflow at `templates/workflows/policy-compliance.yml` for distribution to target repos.

### Changed
- Elevated policy compliance to a mandatory CI gate in governance and workflow rules.
- Added policy-compliance status check to required pre-merge checks.
- Updated kit manifest and installer guidance to include compliance artifacts.
- Bumped guidance documents to version `1.2.0` for additive compliance automation.

## [1.1.0] - 2026-03-14

### Added
- Optional `Self-Healing Validation Loop` mode with explicit Layer 2 activation requirements, bounded retry rules, logging requirements, and completion criteria.
- Optional `Proactive Hygiene Sweep` mode with issue discovery, triage, remediation, and deferral workflow guidance.
- New task templates for both optional autonomy modes.
- Project template fields for mode enablement, approved commands, scope, logs, retry budgets, and escalation triggers.
- Manual-trigger activation style and trigger-phrase gates for optional modes, enabling one-time configuration with explicit per-request activation.

### Changed
- Added solo-repository exception for direct commits to `main` with required checks and release documentation safeguards.
- Bumped guidance documents to version `1.1.0` for additive autonomy policy changes.

## [1.0.0] - 2026-03-14

### Added
- Initial Layer 1 framework structure with canonical `AGENTS.md` and rule modules.
- Global governance rules: autonomy boundaries, approval matrix, policy enforcement, security baseline, logging/audit baseline, and definition-of-done gates.
- Stack defaults for frontend, backend, database, tooling, and Canadian-first infrastructure posture.
- Workflow guidance for branching, commit style/cadence, PR behavior, release/deployment, and autonomy bootstrap criteria.
- Task templates for feature build, bug fix, review, investigation, testing, refactoring, incident response, security triage, and database migration/rollback.
- Data classification policy (`public`, `internal`, `confidential`, `restricted`).
- Guidance versioning and change-control policy using semantic versioning.
- Project template fields for sovereignty tier, release/changelog process, and Layer 1 target-version alignment.
