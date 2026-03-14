#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

LOG_PATH=".agent/logs/hygiene.md"
mkdir -p "$(dirname "$LOG_PATH")"

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

{
  echo
  echo "## Run $timestamp"
  echo "- Runner: proactive-hygiene"
} >> "$LOG_PATH"

files_to_scan=(AGENTS.md CHANGELOG.md rules/*.md templates/AGENTS.md)

# 1) Try markdown autofix first.
if command -v markdownlint >/dev/null 2>&1; then
  if markdownlint "**/*.md" --fix >/tmp/hygiene_markdownlint_fix.log 2>&1; then
    echo "- markdownlint --fix: success" >> "$LOG_PATH"
  else
    echo "- markdownlint --fix: completed with remaining findings" >> "$LOG_PATH"
    sed 's/^/  /' /tmp/hygiene_markdownlint_fix.log >> "$LOG_PATH"
  fi

  # Re-check to record unresolved lint issues in the log.
  if markdownlint "**/*.md" >/tmp/hygiene_markdownlint_check.log 2>&1; then
    echo "- markdownlint check: clean" >> "$LOG_PATH"
  else
    echo "- markdownlint check: unresolved issues (deferred)" >> "$LOG_PATH"
    sed 's/^/  /' /tmp/hygiene_markdownlint_check.log >> "$LOG_PATH"
  fi
else
  echo "- markdownlint: skipped (tool unavailable)" >> "$LOG_PATH"
fi

# 2) Keep guidance version headers aligned with AGENTS.md.
target_version="$(grep -m1 -oE 'Guidance version: `[0-9]+\.[0-9]+\.[0-9]+`' AGENTS.md | sed -E 's/.*`([0-9]+\.[0-9]+\.[0-9]+)`.*/\1/')"
if [[ -n "$target_version" ]]; then
  while IFS= read -r path; do
    current="$(grep -m1 -oE 'Guidance version: `[0-9]+\.[0-9]+\.[0-9]+`' "$path" | sed -E 's/.*`([0-9]+\.[0-9]+\.[0-9]+)`.*/\1/' || true)"
    if [[ -n "$current" && "$current" != "$target_version" ]]; then
      sed -i -E "s/Guidance version: `[0-9]+\.[0-9]+\.[0-9]+`/Guidance version: `$target_version`/" "$path"
      echo "- fixed version header: $path ($current -> $target_version)" >> "$LOG_PATH"
    fi
  done < <(printf '%s\n' "${files_to_scan[@]}")
else
  echo "- version alignment: skipped (could not parse target version)" >> "$LOG_PATH"
fi

# 3) Report TODO/FIXME markers as hygiene findings.
todo_hits="$(grep -RInE 'TODO|FIXME' AGENTS.md CHANGELOG.md rules templates 2>/dev/null || true)"
if [[ -n "$todo_hits" ]]; then
  count="$(printf '%s\n' "$todo_hits" | sed '/^$/d' | wc -l | tr -d ' ')"
  echo "- TODO/FIXME findings: $count (deferred by default)" >> "$LOG_PATH"
else
  echo "- TODO/FIXME findings: 0" >> "$LOG_PATH"
fi

# 4) Summarize change outcome for this run.
if git diff --quiet; then
  echo "- decision: no_changes" >> "$LOG_PATH"
else
  echo "- decision: fixed" >> "$LOG_PATH"
  echo "- files touched:" >> "$LOG_PATH"
  git diff --name-only | sed 's/^/  - /' >> "$LOG_PATH"
fi
