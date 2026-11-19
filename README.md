# lihong-skills

A personal library of reusable AI agent skills designed for software engineering, workflow automation, and productivity.

Crafted by synthesizing architectural patterns from [mattpocock/skills](https://github.com/mattpocock/skills) (enterprise-grade validation, CI, and multi-agent distribution) and [LofiSu/lofisu-skill](https://github.com/LofiSu/lofisu-skill) (agent-friendly authoring conventions and explicit trigger routing).

---

## Repository Architecture

```text
lihong-skills/
├── upstreams/                              # Pure vendor mirrors (read-only upstream baselines)
│   ├── dsh-super-agent/                    # Upstream snapshot of LofiSu/dsh-super-agent
│   │   └── UPSTREAM.json                   # Machine-readable provenance & commit SHA
│   ├── mattpocock-skills/                  # Upstream snapshot of mattpocock/skills
│   │   └── UPSTREAM.json                   # Tracked commit SHA & repository metadata
│   └── agentara-skills/                    # Upstream snapshot of agentara/skills
│       └── UPSTREAM.json                   # Tracked commit SHA & repository metadata
├── .github/
│   └── workflows/
│       └── check.yml                       # GitHub Actions: automates SKILL.md validation
├── .claude-plugin/
│   ├── plugin.json                         # Claude Code / Codex plugin specification
│   └── marketplace.json                    # Marketplace catalog metadata
├── templates/
│   └── SKILL.template.md                   # Template for authoring new skills
├── scripts/
│   ├── check-frontmatter.mjs               # Validates YAML frontmatter & naming consistency
│   ├── install.ps1                         # Windows: links skills via NTFS directory junctions
│   └── install.sh                          # POSIX (macOS/Linux/WSL): symlinks skills
├── skills/
│   └── engineering/
│       ├── git-commit-helper/              # Conventional commit generator
│       ├── sync-upstream/                  # Upstream tracking, diffing, & sync manager
│       ├── autonomous-engineering/         # Parameterized multi-agent orchestrator with placeholders
│       └── init-super-agent/               # Project bootstrap scaffolder
├── .gitignore                              # Ignores .idea/, .vscode/, node_modules/, etc.
├── AGENTS.md                               # Core instruction manual for AI agents
├── CLAUDE.md                               # Quick reference for Claude Code
├── package.json                            # Project metadata & npm validation scripts
└── README.md                               # Project overview & index
```

---

## Installation & Local Linking

Skills are linked to your local agent directories via junctions or symlinks. Edits inside this repository reflect immediately across your local AI agents without copying files.

Supported agent harnesses:
- **Claude Code**: `~/.claude/skills/`
- **Codex & Agent standard**: `~/.agents/skills/`
- **Google Antigravity**: `~/.gemini/config/skills/`

### Windows (PowerShell)

```powershell
# Preview changes without modifying files:
.\scripts\install.ps1 -DryRun

# Link all active skills to your local agents:
.\scripts\install.ps1
```

### macOS / Linux / WSL (Bash)

```bash
# Preview changes:
./scripts/install.sh --dry-run

# Link all active skills:
chmod +x ./scripts/install.sh
./scripts/install.sh
```

---

## Upstream Synchronization

Manage and check updates from upstream open-source skill repositories:

```powershell
# Inspect all tracked upstreams against remote GitHub HEAD:
powershell -ExecutionPolicy Bypass -File .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1

# Pull updates and refresh vendor snapshot:
powershell -ExecutionPolicy Bypass -File .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1 -Update
```

---

## Skills Index

### Project Engineering (For Your Software Projects)

- **[ask-lihong](skills/engineering/ask-lihong/SKILL.md)**: 🧭 Master skill router & navigator. Automatically directs you to the appropriate flow based on your current project situation.
- **[init-super-agent](skills/engineering/init-super-agent/SKILL.md)**: Bootstraps the Super Agent autonomous engineering framework, subagents, and state ledgers into any target project.
- **[autonomous-engineering](skills/engineering/autonomous-engineering/SKILL.md)**: Continuous multi-agent engineering orchestration loop (Reconcile → Plan → Delegate → Collect → Review → Integrate → Persist → Continue).
- **[git-commit-helper](skills/engineering/git-commit-helper/SKILL.md)**: Quality enforcer for Conventional Commits, checking boundary alignment with `docs/MODULES.md` and evidence attachment.

### Repository Maintenance (Internal to lihong-skills)

- **[sync-upstream](skills/engineering/sync-upstream/SKILL.md)**: 🛠️ Inspects, diffs, and synchronizes upstream open-source skill repositories with vendor snapshots in `upstreams/`.

---

## License

[MIT](LICENSE)
