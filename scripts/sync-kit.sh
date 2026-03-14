#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/sync-kit.sh <target-repo-path> [--dry-run]

This is a convenience wrapper around install-kit.sh with --force enabled.
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

TARGET_REPO=""
DRY_RUN="no"

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN="yes" ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "$TARGET_REPO" ]]; then
        TARGET_REPO="$arg"
      else
        echo "Unexpected argument: $arg" >&2
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$TARGET_REPO" ]]; then
  usage
  exit 1
fi

cmd=(bash "$ROOT_DIR/scripts/install-kit.sh" "$TARGET_REPO" --force)
if [[ "$DRY_RUN" == "yes" ]]; then
  cmd+=(--dry-run)
fi

"${cmd[@]}"
