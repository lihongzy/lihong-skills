# {{PROJECT_NAME}} — project instructions

{{PROJECT_DESCRIPTION}}

## Commands

```bash
{{TYPECHECK_COMMAND}}                  # Type validation
{{LINT_COMMAND}}                       # Linter / repo invariant checks
{{TEST_COMMAND}}                       # Test suite
{{TEST_COVERAGE_COMMAND}}              # Offline fixture suite with coverage
{{RUN_COMMAND}}                        # Run the application / CLI
```

Offline checks must not depend on a live model or external credentials.

## Naming

Name features by what they do and by the module boundary
(`docs/MODULES.md`). Do not reintroduce removed extension switches or
untracked milestone naming.

## Engineering rules

- Evidence first: never claim a test, PR, or check passed without the command
  output or URL that proves it.
- One concern per PR. Branch off current `{{MAIN_BRANCH}}`; never commit directly to
  `{{MAIN_BRANCH}}`; never force-push a shared branch.
- Keep `{{MAIN_BRANCH}}` green. Local checks (`{{TYPECHECK_COMMAND}}`, `{{LINT_COMMAND}}`, and `{{TEST_COMMAND}}`) must pass
  locally before a PR is opened; CI must pass before merge.
- Secrets never enter the repo. State and runtime files are gitignored.

# SUPER AGENT — PROJECT ORCHESTRATION

## 1. Single loop ownership

The main Claude Code session is the only owner of the project-level
orchestration loop. The `autonomous-engineering` skill defines that loop.

Stop hooks are safety guards, not schedulers.

Do not use `/loop`, `/goal`, a second recursive shell scheduler, or nested
project-level orchestration agents.

## 2. Task ownership

The main orchestrator:

- owns the master plan and the persistent state;
- assigns tasks and tracks subagents;
- reviews every PR, controls merges, and updates priorities.

Subagents:

- own only their assigned task;
- work in isolated Git worktrees;
- write tests and submit PRs;
- report evidence (branch, commit SHA, commands, results, PR URL);
- never merge their own PR, never edit `.super-agent/state.json`, never write
  the master plan.

## 3. Concurrency

Start with at most 3 implementation agents while the pipeline is being
validated. Raise to 4–6 only after a clean integration cycle. Never run two
agents that own the same files.

## 4. Session budget

Maximum 4 completed development cycles per session. At the boundary: stop
spawning agents, collect results, persist unfinished tasks, update the master
plan, set `mode` to `paused`, and write a recovery report.

## 5. State protocol

Only the main orchestrator writes `.super-agent/state.json`. Every real
progress checkpoint updates `current_cycle`, `cycles_this_session`,
`next_action`, `queue`, `active_agents`, `open_prs`, `last_progress_at`, and
`updated_at`. Merely printing text is not progress.

`next_action` uses exactly: `plan`, `execute`, `review`, `integrate`,
`checkpoint`, `idle`, `owner_input`. `mode` uses `running`, `paused`, or
`stopped`.

## 6. GitHub policy

All implementation changes use PRs. The orchestrator reviews independently.
Ordinary PRs may be auto-merged only after required reviews and required CI
checks pass. Never bypass branch protection (typecheck and test is required
on `{{MAIN_BRANCH}}`; enforce_admins is on). High-risk changes need owner approval.

## 7. Completion evidence

Never mark a task complete without code evidence, test evidence, review
evidence, PR status, and integration verification.
