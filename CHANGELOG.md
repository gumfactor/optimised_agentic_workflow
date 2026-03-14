# Changelog

All notable changes to this guidance framework are documented in this file.

The format is based on Keep a Changelog and uses semantic versioning for guidance documents.

## [Unreleased]

### Added
- Repository runtime configuration now includes `Proactive Hygiene Sweep` with manual-trigger phrases and bounded sweep/logging controls.

### Changed
- Refined `Proactive Hygiene Sweep` as maintenance-only hygiene work (security, bugs, reliability, rendering/character-encoding, accessibility, compliance) and explicitly disallowed net-new feature expansion under hygiene mode.
- Updated repository runtime config so proactive hygiene runs as a bounded always-on background maintenance pass, while self-healing remains explicit-trigger only.

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
