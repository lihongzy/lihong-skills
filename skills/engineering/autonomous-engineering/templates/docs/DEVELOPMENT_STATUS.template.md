# {{PROJECT_NAME}} — Development Status & Recovery Checkpoint

> **Status Protocol**: Written by the main orchestrator at the end of every cycle and checkpoint boundary.
> **Session State**: Session initialized | Mode: `paused`

---

## 1. Executive Summary

- **Current Cycle**: 0 (Session Cycles: 0 / Max: 4)
- **Active Phase**: Phase 1 Foundation
- **Next Required Action**: `plan`
- **Queue Metrics**:
  - Ready Tasks: 1
  - In Progress: 0
  - Blocked: 1

---

## 2. In-Flight Work & Active Agents

| Subagent ID | Role | Branch Name | Assigned Task | PR URL / Status | Since |
| :--- | :--- | :--- | :--- | :--- | :--- |
| *None currently active* | - | - | - | - | - |

---

## 3. Pull Requests Under Review

| PR # | Title | Branch | Reviewers | CI Status | Next Step |
| :--- | :--- | :--- | :--- | :--- | :--- |
| *No open PRs* | - | - | - | - | - |

---

## 4. Latest Verification Evidence

- **Last Green Test Command**: `{{TEST_COMMAND}}`
- **Executed At**: {{DATE_ISO}}
- **Observed Result Summary**:
  ```text
  All unit tests passing. 0 failures.
  ```

---

## 5. Recovery Checkpoint for Next Session

When starting the next session, the orchestrator should:
1. Reconcile `.super-agent/state.json` and git working tree (`git status`, `git branch`).
2. Inspect open tasks in `docs/MASTER_PLAN.md` (Next up: `[TASK-001]`).
3. Spawn `implementer` subagent with isolated Git worktree for `[TASK-001]`.
4. Refresh `last_progress_at` in state machine.
