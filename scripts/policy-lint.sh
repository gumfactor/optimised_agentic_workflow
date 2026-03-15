#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

failures=0

fail() {
  echo "[policy-lint] ERROR: $1"
  failures=$((failures + 1))
}

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    fail "Missing required file: $path"
  fi
}

require_contains() {
  local path="$1"
  local pattern="$2"
  local description="$3"
  if ! grep -qE "$pattern" "$path"; then
    fail "$path missing required content: $description"
  fi
}

required_files=(
  "AGENTS.md"
  "CHANGELOG.md"
  "rules/README.md"
  "rules/00-global-governance.md"
  "rules/01-stack-defaults.md"
  "rules/02-workflow-patterns.md"
  "rules/03-agent-task-templates.md"
  "templates/AGENTS.md"
  "scripts/policy-lint.sh"
  ".github/workflows/policy-compliance.yml"
)

for path in "${required_files[@]}"; do
  require_file "$path"
done

if [[ -f "CLAUDE.md" || -f "templates/CLAUDE.md" ]]; then
  fail "CLAUDE.md compatibility files are not allowed; AGENTS.md is canonical"
fi

guidance_files=(
  "AGENTS.md"
  "rules/README.md"
  "rules/00-global-governance.md"
  "rules/01-stack-defaults.md"
  "rules/02-workflow-patterns.md"
  "rules/03-agent-task-templates.md"
  "templates/AGENTS.md"
)

for path in "${guidance_files[@]}"; do
  require_contains "$path" '^## Document Metadata$' 'Document Metadata header'
  require_contains "$path" '^- Guidance version: `[0-9]+\.[0-9]+\.[0-9]+`$' 'Guidance version field'
  require_contains "$path" '^- Last updated: `.+`$' 'Last updated field'
  require_contains "$path" '^- Versioning model: semantic versioning for guidance docs \(`MAJOR\.MINOR\.PATCH`\)$' 'Versioning model field'
done

target_version="$(grep -m1 -oE 'Guidance version: `[0-9]+\.[0-9]+\.[0-9]+`' AGENTS.md | sed -E 's/.*`([0-9]+\.[0-9]+\.[0-9]+)`.*/\1/' || true)"
if [[ -z "$target_version" ]]; then
  fail "Could not parse guidance version from AGENTS.md"
else
  for path in "${guidance_files[@]}"; do
    version="$(grep -m1 -oE 'Guidance version: `[0-9]+\.[0-9]+\.[0-9]+`' "$path" | sed -E 's/.*`([0-9]+\.[0-9]+\.[0-9]+)`.*/\1/' || true)"
    if [[ -z "$version" ]]; then
      fail "Could not parse guidance version in $path"
      continue
    fi
    if [[ "$version" != "$target_version" ]]; then
      fail "Guidance version mismatch in $path: found $version expected $target_version"
    fi
  done
fi

require_contains "CHANGELOG.md" '^## \[Unreleased\]$' 'Unreleased section'
require_contains "rules/02-workflow-patterns.md" '^## Changelog and Release Notes$' 'changelog/release policy section'
require_contains "rules/02-workflow-patterns.md" '^\*\*Solo-repository exception:\*\*$' 'solo-repo exception section'
require_contains "rules/00-global-governance.md" '^## Policy Enforcement$' 'Policy Enforcement section'
require_contains "rules/00-global-governance.md" 'mandatory policy-lint gate' 'mandatory policy-lint requirement'

if (( failures > 0 )); then
  echo "[policy-lint] FAILED with $failures issue(s)."
  exit 1
fi

echo "[policy-lint] PASS"
