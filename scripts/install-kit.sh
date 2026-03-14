#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST_PATH="$ROOT_DIR/kit/manifest.txt"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install-kit.sh <target-repo-path> [--force] [--dry-run]

Options:
  --force   Overwrite existing files in the target repo.
  --dry-run Print planned actions without copying files.
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

TARGET_REPO=""
FORCE="no"
DRY_RUN="no"

for arg in "$@"; do
  case "$arg" in
    --force) FORCE="yes" ;;
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

if [[ ! -d "$TARGET_REPO" ]]; then
  echo "Target repo path does not exist: $TARGET_REPO" >&2
  exit 1
fi

if [[ ! -f "$MANIFEST_PATH" ]]; then
  echo "Manifest not found: $MANIFEST_PATH" >&2
  exit 1
fi

copied=0
skipped=0
updated=0

while IFS= read -r entry; do
  [[ -z "$entry" || "$entry" =~ ^# ]] && continue

  if [[ "$entry" == *:* ]]; then
    rel_src="${entry%%:*}"
    rel_dst="${entry##*:}"
  else
    rel_src="$entry"
    rel_dst="$entry"
  fi

  src="$ROOT_DIR/$rel_src"
  dst="$TARGET_REPO/$rel_dst"

  if [[ ! -e "$src" ]]; then
    echo "Missing source file from manifest: $rel_src" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$dst")"

  existed_before="no"
  if [[ -e "$dst" ]]; then
    existed_before="yes"
  fi

  if [[ -e "$dst" && "$FORCE" != "yes" ]]; then
    echo "skip    $rel_dst (exists; use --force to overwrite)"
    skipped=$((skipped + 1))
    continue
  fi

  if [[ "$DRY_RUN" == "yes" ]]; then
    if [[ -e "$dst" ]]; then
      echo "update  $rel_dst"
      updated=$((updated + 1))
    else
      echo "copy    $rel_dst"
      copied=$((copied + 1))
    fi
    continue
  fi

  cp "$src" "$dst"

  if [[ "$rel_src" == scripts/*.sh ]]; then
    chmod +x "$dst"
  fi

  if [[ "$existed_before" == "yes" ]]; then
    echo "update  $rel_dst"
    updated=$((updated + 1))
  else
    echo "copy    $rel_dst"
    copied=$((copied + 1))
  fi
done < "$MANIFEST_PATH"

echo
echo "Install complete."
echo "- copied: $copied"
echo "- updated: $updated"
echo "- skipped: $skipped"

echo
echo "Next steps in target repo:"
echo "1) Review AGENTS/rules for project-specific overrides."
echo "2) Validate the hygiene script locally: bash scripts/proactive-hygiene.sh"
echo "3) Commit the imported kit files."
