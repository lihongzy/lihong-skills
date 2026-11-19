# Google Antigravity Instructions

This repository is a standardized personal skills library compatible with Google Antigravity (AGY), Claude Code, and Codex.
Refer to [AGENTS.md](AGENTS.md) for full skill authoring conventions, directory architecture, and upstream tracking protocols.

## Primary Commands

### Skill Validation & Local Linking
- Check skill frontmatter: `npm run check-frontmatter`
- Link skills globally to Antigravity (`~/.gemini/config/skills/`), Claude Code, and Codex:
  - Windows: `.\scripts\install.ps1`
  - POSIX: `./scripts/install.sh`
- Preview installation (dry-run): `.\scripts\install.ps1 -DryRun` or `./scripts/install.sh --dry-run`

### Upstream Tracking & Synchronization
- Inspect tracked upstreams against GitHub remote:
  - Windows: `powershell -ExecutionPolicy Bypass -File .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1`
  - POSIX: `./skills/engineering/sync-upstream/scripts/sync-upstream.sh`
- Pull upstream updates and refresh vendor snapshots:
  - Windows: `powershell -ExecutionPolicy Bypass -File .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1 -Update`
  - POSIX: `./skills/engineering/sync-upstream/scripts/sync-upstream.sh --update`

---

## Active Skills in Antigravity

All skills in `skills/engineering/` are linked to `~/.gemini/config/skills/` and immediately available in Antigravity:
1. **`/ask-lihong`**: Master router across Super Agent flows, Matt Pocock's "Idea → Ship" flow, and Agentara tools.
2. **`/init-super-agent`**: Bootstraps the Super Agent multi-agent orchestration framework into any target project.
3. **`/autonomous-engineering`**: Continuous 8-step multi-agent autonomous engineering loop.
4. **`/git-commit-helper`**: Quality enforcer for Conventional Commits with scope boundary checks.
5. **`/sync-upstream`**: Multi-upstream tracking and synchronization utility.

---

## Upstream Passthrough Routing in Antigravity

When working with upstream tools via `ask-lihong`:
- Commands starting with `/matt/` (e.g. `/matt/tdd`, `/matt/pr`) invoke Matt Pocock's "Idea → Ship" methodology via `upstreams/mattpocock-skills/`.
- Commands starting with `/agentara/` (e.g. `/agentara/gunpla-poster`, `/agentara/super-daddy`) invoke Agentara's specialized toolkits via `upstreams/agentara-skills/`.
- Native commands (`/init-super-agent`, `/autonomous-engineering`, `/git-commit-helper`) invoke the local Super Agent multi-agent framework.

---

## Git Commit Standards (git-commit-helper)

All Git commits created in this repository must strictly adhere to [git-commit-helper](skills/engineering/git-commit-helper/SKILL.md):
- **Pattern**: `<type>(<scope>): <summary under 72 chars>`
- **Internal Scopes**: `skills`, `upstreams`, `scripts`, `templates`, `docs`, `ci`, `config`
- **Rule 1**: One Concern per Commit (Atomic slicing).
- **Rule 2**: Evidence-first commit body referencing verification commands.
