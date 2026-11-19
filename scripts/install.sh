#!/usr/bin/env bash
#
# install.sh — Symlink every skill in this repository into local agent skill directories.
#
# Supported harnesses:
#   - ~/.claude/skills          (Claude Code)
#   - ~/.agents/skills          (Codex & Agent Skills compatible harnesses)
#   - ~/.gemini/config/skills   (Google Antigravity)
#
# Usage:
#   ./scripts/install.sh            # Install / refresh symlinks
#   ./scripts/install.sh --dry-run  # Preview actions without changing filesystem

set -euo pipefail

DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
SKILLS_DIR="$REPO_DIR/skills"

TARGETS=(
  "$HOME/.claude/skills"
  "$HOME/.agents/skills"
  "$HOME/.gemini/config/skills"
)

if [ ! -d "$SKILLS_DIR" ]; then
  echo "No skills/ directory found at $SKILLS_DIR" >&2
  exit 0
fi

for t in "${TARGETS[@]}"; do
  [ "$DRY_RUN" -eq 1 ] || mkdir -p "$t"
done

count=0
linked=0

while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  name="$(basename "$skill_dir")"
  count=$((count + 1))

  for t in "${TARGETS[@]}"; do
    link="$t/$name"
    if [ -L "$link" ]; then
      [ "$DRY_RUN" -eq 1 ] || rm "$link"
    elif [ -e "$link" ]; then
      echo "  [skip] $name: $link exists and is not a symlink" >&2
      continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  [dry-run] Would link $name -> $t/$name"
    else
      ln -s "$skill_dir" "$link"
      echo "  [linked] $name -> $t/$name"
      linked=$((linked + 1))
    fi
  done
done < <(find "$SKILLS_DIR" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' | sort)

if [ "$count" -eq 0 ]; then
  echo "No active skills found. Add a skill under skills/<category>/<name>/SKILL.md and re-run."
else
  echo "Finished. Processed $count skill(s); created $linked link(s)."
fi
