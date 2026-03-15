#!/usr/bin/env bash
# Installs the Layer 1 git hooks into .git/hooks for the current repo.
# Run once per clone: bash scripts/install-hooks.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOKS_SRC="$REPO_ROOT/.githooks"
HOOKS_DST="$REPO_ROOT/.git/hooks"

if [[ ! -d "$REPO_ROOT/.git" ]]; then
  echo "Not a git repository: $REPO_ROOT" >&2
  exit 1
fi

for hook_src in "$HOOKS_SRC"/*; do
  hook_name="$(basename "$hook_src")"
  hook_dst="$HOOKS_DST/$hook_name"

  if [[ -e "$hook_dst" ]]; then
    echo "skip    .git/hooks/$hook_name (already exists — remove it first to reinstall)"
    continue
  fi

  cp "$hook_src" "$hook_dst"
  chmod +x "$hook_dst"
  echo "install .git/hooks/$hook_name"
done

echo
echo "Hooks installed. Run 'git push' to verify."
