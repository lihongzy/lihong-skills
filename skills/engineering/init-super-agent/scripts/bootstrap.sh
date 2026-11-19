#!/usr/bin/env bash
#
# bootstrap.sh — Deploys the Super Agent orchestration framework into the target project.

set -euo pipefail

TARGET_DIR="${1:-$(pwd)}"
PROJECT_NAME="$(basename "$TARGET_DIR")"
MAIN_BRANCH="main"
TEST_COMMAND=""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
SKILLS_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
SOURCE_SKILL_DIR="$SKILLS_ROOT/autonomous-engineering"

if [ ! -d "$SOURCE_SKILL_DIR" ]; then
  echo "Error: Source template not found at $SOURCE_SKILL_DIR" >&2
  exit 1
fi

echo "=== Bootstrapping Super Agent Framework ==="
echo "Target: $TARGET_DIR"

# Auto-detect language
if [ -f "$TARGET_DIR/package.json" ]; then
  TEST_COMMAND="npm test"
  LINT_COMMAND="npm run lint"
  TYPECHECK_COMMAND="npm run typecheck"
elif [ -f "$TARGET_DIR/pyproject.toml" ] || [ -f "$TARGET_DIR/requirements.txt" ]; then
  TEST_COMMAND="pytest"
  LINT_COMMAND="flake8"
  TYPECHECK_COMMAND="mypy ."
elif [ -f "$TARGET_DIR/Cargo.toml" ]; then
  TEST_COMMAND="cargo test"
  LINT_COMMAND="cargo clippy"
  TYPECHECK_COMMAND="cargo check"
elif [ -f "$TARGET_DIR/go.mod" ]; then
  TEST_COMMAND="go test ./..."
  LINT_COMMAND="golangci-lint run"
  TYPECHECK_COMMAND="go vet ./..."
else
  TEST_COMMAND="echo 'No test command configured'"
  LINT_COMMAND="echo 'No lint command configured'"
  TYPECHECK_COMMAND="echo 'No typecheck command configured'"
fi

ISO_DATE="$(date -u +"%Y-%m-%d")"

mkdir -p "$TARGET_DIR/.claude/agents" \
         "$TARGET_DIR/.claude/hooks" \
         "$TARGET_DIR/.claude/skills/autonomous-engineering" \
         "$TARGET_DIR/.claude/skills/git-commit-helper" \
         "$TARGET_DIR/docs" \
         "$TARGET_DIR/.super-agent"

render_file() {
  local src="$1"
  local dest="$2"
  sed \
    -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
    -e "s|{{PROJECT_DESCRIPTION}}|Automated multi-agent engineering workflow for $PROJECT_NAME.|g" \
    -e "s|{{TEST_COMMAND}}|$TEST_COMMAND|g" \
    -e "s|{{LINT_COMMAND}}|$LINT_COMMAND|g" \
    -e "s|{{TYPECHECK_COMMAND}}|$TYPECHECK_COMMAND|g" \
    -e "s|{{MAIN_BRANCH}}|$MAIN_BRANCH|g" \
    -e "s|{{DATE_ISO}}|$ISO_DATE|g" \
    -e "s|{{ARCHITECTURE_SPEC_DOC}}|docs/MASTER_PLAN.md|g" \
    -e "s|{{INITIAL_TASK_TITLE}}|System Architecture & Baseline Test Suite|g" \
    -e "s|{{INITIAL_TASK_GOAL}}|Verify base project dependencies and ensure baseline tests pass.|g" \
    -e "s|{{NEXT_TASK_TITLE}}|First Core Feature Implementation|g" \
    -e "s|{{NEXT_TASK_GOAL}}|Implement primary domain feature.|g" \
    -e "s|{{MODULE_1_NAME}}|Core Engine|g" \
    -e "s|{{MODULE_1_DESC}}|Core business logic and state|g" \
    -e "s|{{MODULE_1_PATH}}|core|g" \
    -e "s|{{MODULE_1_API}}|Internal API|g" \
    -e "s|{{MODULE_2_NAME}}|CLI / Interfaces|g" \
    -e "s|{{MODULE_2_DESC}}|User and agent interaction boundaries|g" \
    -e "s|{{MODULE_2_PATH}}|cli|g" \
    -e "s|{{MODULE_2_API}}|Console API|g" \
    -e "s|{{MODULE_3_NAME}}|Utilities|g" \
    -e "s|{{MODULE_3_DESC}}|Cross-cutting helper functions|g" \
    -e "s|{{MODULE_3_PATH}}|utils|g" \
    -e "s|{{MODULE_3_API}}|Helper API|g" \
    -e "s|{{BOUNDARY_1_NAME}}|Core Application / Source|g" \
    -e "s|{{BOUNDARY_1_PATH}}|src|g" \
    -e "s|{{BOUNDARY_2_NAME}}|Test Suites & Verification|g" \
    -e "s|{{BOUNDARY_2_PATH}}|test|g" \
    -e "s|{{BOUNDARY_3_NAME}}|Build & Tooling Scripts|g" \
    -e "s|{{BOUNDARY_3_PATH}}|scripts|g" \
    "$src" > "$dest"
}

# Deploy Agents
for f in "$SOURCE_SKILL_DIR/agents"/*.md; do
  [ -f "$f" ] || continue
  render_file "$f" "$TARGET_DIR/.claude/agents/$(basename "$f")"
  echo "  + Deployed agent: $(basename "$f")"
done

# Deploy Hook & Settings
cp "$SOURCE_SKILL_DIR/hooks/super-agent-stop-guard.py" "$TARGET_DIR/.claude/hooks/"
cp "$SOURCE_SKILL_DIR/settings.json" "$TARGET_DIR/.claude/"
cp "$SOURCE_SKILL_DIR/SKILL.md" "$TARGET_DIR/.claude/skills/autonomous-engineering/"
if [ -f "$SKILLS_ROOT/git-commit-helper/SKILL.md" ]; then
  cp "$SKILLS_ROOT/git-commit-helper/SKILL.md" "$TARGET_DIR/.claude/skills/git-commit-helper/"
fi
cp "$SOURCE_SKILL_DIR/templates/state.json" "$TARGET_DIR/.super-agent/state.json"

# Deploy docs
for f in "$SOURCE_SKILL_DIR/templates/docs"/*.template.md; do
  [ -f "$f" ] || continue
  out_name="$(basename "$f" .template.md).md"
  if [ ! -f "$TARGET_DIR/docs/$out_name" ]; then
    render_file "$f" "$TARGET_DIR/docs/$out_name"
    echo "  + Generated docs/$out_name"
  fi
done

# Deploy CLAUDE.md if not present
if [ ! -f "$TARGET_DIR/CLAUDE.md" ]; then
  render_file "$SOURCE_SKILL_DIR/CLAUDE.template.md" "$TARGET_DIR/CLAUDE.md"
  echo "  + Generated CLAUDE.md"
fi

# Ensure .gitignore has .super-agent/
if [ -f "$TARGET_DIR/.gitignore" ]; then
  if ! grep -q "\.super-agent" "$TARGET_DIR/.gitignore"; then
    echo -e "\n# Super Agent State Machine\n.super-agent/" >> "$TARGET_DIR/.gitignore"
    echo "  + Added .super-agent/ to .gitignore"
  fi
else
  echo -e "# Super Agent State Machine\n.super-agent/" > "$TARGET_DIR/.gitignore"
  echo "  + Created .gitignore"
fi

echo -e "\n✓ Super Agent framework initialized successfully in $TARGET_DIR!"
