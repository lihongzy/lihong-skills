# Guidance for AI Agents

This document defines authoring conventions and engineering practices for AI agents (Claude Code, Google Antigravity, GitHub Copilot, Codex, etc.) working in this repository.

## Repository Purpose

This is a personal library of installable prompt extensions and AI skills. The objective is to accumulate, test, and standardize reusable capabilities over time.

## Directory Structure

```text
upstreams/
  <upstream-name>/         # Pure vendor mirror (read-only baseline without .git)
    UPSTREAM.json          # Machine-readable metadata (repo, branch, commit SHA, sync timestamp)
skills/
  <category>/
    <skill-name>/
      SKILL.md             # Required: Primary skill definition with frontmatter
      scripts/             # Optional: Auxiliary scripts referenced by the skill
      templates/           # Optional: Starter templates or reference schemas
templates/
  SKILL.template.md        # Starter template for drafting new skills
scripts/
  check-frontmatter.mjs    # Validates YAML frontmatter across all skills
  install.ps1              # Windows PowerShell: symlinks skills to local agent directories
  install.sh               # POSIX Bash: symlinks skills to local agent directories
.claude-plugin/            # Manifests for Claude Code / marketplace distribution
.github/workflows/         # CI automation for format and syntax validation
```

### Categories

Group skills by category under `skills/<category>/`. Common categories:
- `engineering`: Software development, debugging, testing, refactoring, code review.
- `productivity`: Workflow automation, notes, documentation, task management.
- `in-progress`: Experimental skills currently being refined.
- `deprecated`: Retired skills kept for reference.

Use short, lowercase, hyphenated category and skill names (`kebab-case`).

## Skill Specification & Frontmatter Rules

Every `SKILL.md` file **must** begin with a YAML frontmatter block:

```yaml
---
name: skill-name-here
description: >
  Concise summary of capabilities.
  TRIGGER: Specific keywords, requests, or scenarios that activate this skill.
  DO NOT TRIGGER: Explicit boundaries and out-of-scope conditions.
---
```

### Essential Rules

1. **`name` must match directory name**: The `name` value in frontmatter must strictly match the directory name `<skill-name>`.
2. **`description` serves as routing logic**: State clear `TRIGGER:` and `DO NOT TRIGGER:` directives so models route accurately.
3. **Single responsibility**: Each skill should focus on one cohesive domain or workflow.
4. **Self-contained assets**: Store helper scripts, mock data, or specialized assets inside `skills/<category>/<skill-name>/` so the skill is portable.

## Workflow: How to Add a New Skill

When asked by the user to add or distill a new skill:

1. Create directory:
   `mkdir -p skills/<category>/<skill-name>`
2. Copy template:
   `cp templates/SKILL.template.md skills/<category>/<skill-name>/SKILL.md`
3. Edit `SKILL.md`:
   - Set `name` to `<skill-name>`.
   - Write clear `TRIGGER` / `DO NOT TRIGGER` rules in `description`.
   - Provide concrete steps, inputs, and expected outputs.
4. Register in index:
   - Add an entry under the corresponding section in the root `README.md`.
5. Validate frontmatter:
   - Run `npm run check-frontmatter` to confirm YAML syntax is valid.
6. Install locally:
   - On Windows: Run `.\scripts\install.ps1`
   - On Linux/macOS: Run `./scripts/install.sh`

## Workflow: How to Track a New Upstream Repository

When asked by the user to track, mirror, or integrate an external upstream repository (e.g. `https://github.com/agentara/skills.git`):

1. **Inspect Remote Repository & Default Branch**:
   Check the remote commit hash without cloning:
   ```bash
   git ls-remote https://github.com/<owner>/<repo>.git refs/heads/main
   ```
2. **Snapshot into Vendor Directory (Pure Text Mirror)**:
   Clone to a temporary directory with `--depth 1`, remove `.git`, and copy all files into `upstreams/<upstream-name>/`:
   ```powershell
   $temp = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString("N"))
   git clone --depth 1 https://github.com/agentara/skills.git $temp
   $commitSha = (git -C $temp rev-parse HEAD).Trim()
   $target = "upstreams\agentara-skills"
   New-Item -ItemType Directory -Path $target -Force
   Get-ChildItem -Path $temp -Exclude ".git" | Copy-Item -Destination $target -Recurse -Force
   Remove-Item -Recurse -Force $temp
   ```
   > [!IMPORTANT]
   > Never use Git submodules. Maintain clean vendor directory snapshots under Git version control to avoid detached HEAD issues and broken submodules.
3. **Generate `UPSTREAM.json`**:
   Save a machine-readable provenance descriptor in `upstreams/<upstream-name>/UPSTREAM.json`:
   ```json
   {
     "name": "agentara-skills",
     "repository": "https://github.com/agentara/skills.git",
     "branch": "main",
     "tracked_commit": "<FULL_40_CHAR_COMMIT_SHA>",
     "last_synced_at": "2026-11-20T02:00:00Z",
     "description": "Upstream snapshot of Agentara personal skills library."
   }
   ```
4. **Register in Upstream Asset Matrix**:
   Add an entry and asset table under `skills/engineering/sync-upstream/MAPPING.md` describing upstream capabilities, domain categories, and mapping status.
5. **Expose in Router via Explicit Namespacing**:
   Add the upstream skills to `skills/engineering/ask-lihong/SKILL.md` under an isolated namespace (e.g., `/agentara/<skill>` or `/matt/<skill>`). This prevents collisions with native Super Agent orchestration flows.
6. **Verify and Refresh**:
   Run the sync inspector to confirm all upstreams are recognized:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1
   ```

## Git Commit Standards (Enforced Protocol)

All AI agents authoring commits in this repository (or any local project bootstrapped by this library) **must strictly adhere to the [git-commit-helper](skills/engineering/git-commit-helper/SKILL.md) protocol**.

### 1. Scope Boundary Alignment
- For `lihong-skills` internal commits, the `<scope>` in `<type>(<scope>): <summary>` must strictly correspond to top-level domains:
  - `skills`: Adding, refactoring, or updating skill definitions (`skills/**`).
  - `upstreams`: Adding or syncing vendor snapshots and metadata (`upstreams/**`).
  - `scripts`: Installer, validator, or automation scripts (`scripts/**`).
  - `templates`: Starter schemas or ledger templates (`templates/**`).
  - `docs`: Documentation updates (`README.md`, `AGENTS.md`, `CLAUDE.md`, etc.).
  - `ci`: GitHub Actions workflows (`.github/**`).
  - `config`: Plugin manifests or npm configurations (`package.json`, `.claude-plugin/**`).
- For target software projects bootstrapped with `init-super-agent`, `<scope>` must strictly align with module boundaries defined in `docs/MODULES.md`.

### 2. One Concern per Commit (Atomic Slicing)
- Never bundle multiple unrelated changes into a single commit (e.g. combining an upstream sync with a documentation rewrite, or committing two distinct skills together).
- Inspect `git status -s` and stage changes atomically.

### 3. Evidence-Backed Commit Body
- Explain the concrete **What & Why** of the change.
- Always include verification evidence proving that validation commands passed (e.g., `npm run check-frontmatter`, test suites, or sync verification).
- Standard template:
  ```bash
  git commit -F - << 'EOF'
  <type>(<scope>): <imperative summary under 72 chars>

  <What changed and the mechanical reason why, wrapped around 72 chars.>

  Verified: <verification_command> (<observed result summary>)
  EOF
  ```

## Maintenance Standards

- Keep the index in `README.md` in sync whenever skills are added, renamed, or moved.
- Verify changes with `npm run check-frontmatter` before committing.
- Commit all changes following the Git Commit Standards above.
