# Claude Code Instructions

Refer to [AGENTS.md](AGENTS.md) for full skill authoring conventions, directory architecture, and upstream tracking protocols.

## Primary Commands

### Local Skill Validation & Installation
- Check skill frontmatter: `npm run check-frontmatter`
- Install skills locally (Windows PowerShell): `.\scripts\install.ps1`
- Install skills locally (POSIX Bash): `./scripts/install.sh`
- Preview installation (dry-run): `.\scripts\install.ps1 -DryRun` or `./scripts/install.sh --dry-run`

### Upstream Tracking & Synchronization
- Inspect tracked upstreams against GitHub remote:
  - Windows: `powershell -ExecutionPolicy Bypass -File .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1`
  - POSIX: `./skills/engineering/sync-upstream/scripts/sync-upstream.sh`
- Pull upstream updates and refresh vendor snapshots:
  - Windows: `powershell -ExecutionPolicy Bypass -File .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1 -Update`
  - POSIX: `./skills/engineering/sync-upstream/scripts/sync-upstream.sh --update`

---

## Tracking Upstream Repositories (e.g. `agentara/skills`)

When the user asks to track a new upstream Git repository:
1. Follow the 6-step protocol in [AGENTS.md](AGENTS.md#workflow-how-to-track-a-new-upstream-repository).
2. Snapshot the remote into `upstreams/<upstream-name>/` (pure text mirror, no `.git` folder, no submodules).
3. Create `upstreams/<upstream-name>/UPSTREAM.json` with commit SHA, repository URL, and sync timestamp.
4. Register the new upstream in `skills/engineering/sync-upstream/MAPPING.md`.
5. Expose the upstream skills in `skills/engineering/ask-lihong/SKILL.md` under an explicit namespace (e.g., `/agentara/<skill>` or `/matt/<skill>`).
6. Run `sync-upstream.ps1` and `npm run check-frontmatter` to verify compliance.

---

## Git Commit Standards (git-commit-helper)

All Git commits created by Claude Code in this repository (or target projects) **must strictly follow [git-commit-helper](skills/engineering/git-commit-helper/SKILL.md)**:

### Format & Types
- **Pattern**: `<type>(<scope>): <summary under 72 chars>`
- **Types**: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
- **Internal Scopes (`lihong-skills`)**: `skills`, `upstreams`, `scripts`, `templates`, `docs`, `ci`, `config`
- **Target Project Scopes**: Strictly aligned to `docs/MODULES.md`

### Invariant Rules
1. **One Concern per Commit**: Inspect `git status -s`. Never mix unrelated edits across scopes (e.g., mixing docs with code refactoring). Stage and commit each concern as an atomic slice.
2. **Evidence-First Verification**: The commit body must cite the validation command run and observed result (e.g. `npm run check-frontmatter`). Never fabricate test evidence.
3. **Executable Commit Format**:
   ```bash
   git commit -F - << 'EOF'
   <type>(<scope>): <imperative summary under 72 chars>

   <Paragraph explaining what was changed and the mechanical reason why,
   wrapped neatly around 72 characters.>

   Verified: <test_command> (<observed result summary>)
   EOF
   ```
