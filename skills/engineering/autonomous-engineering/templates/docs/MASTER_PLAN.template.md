# {{PROJECT_NAME}} — Master Development Plan

> **Tracking Reference**: Governed by the `autonomous-engineering` orchestration loop.
> **Last Reconciled**: {{DATE_ISO}} | **Active Phase**: Phase 1

---

## 1. System Vision & Architecture Scope

{{PROJECT_DESCRIPTION}}

### Core Architecture & Boundaries

| Module / Component | Responsibility | Boundary & Files Owned | Key Interfaces |
| :--- | :--- | :--- | :--- |
| `{{MODULE_1_NAME}}` | {{MODULE_1_DESC}} | `src/{{MODULE_1_PATH}}/**` | {{MODULE_1_API}} |
| `{{MODULE_2_NAME}}` | {{MODULE_2_DESC}} | `src/{{MODULE_2_PATH}}/**` | {{MODULE_2_API}} |
| `{{MODULE_3_NAME}}` | {{MODULE_3_DESC}} | `src/{{MODULE_3_PATH}}/**` | {{MODULE_3_API}} |

---

## 2. Milestone Roadmap

```text
Phase 1: Foundation & Scaffold [In Progress]
  ├── M1.1: Core Interfaces & Types
  └── M1.2: Base Engine & State Management

Phase 2: Core Feature Implementation [Planned]
  ├── M2.1: Domain Logic Implementation
  └── M2.2: Channel / Client Integration

Phase 3: Hardening & Release [Planned]
  ├── M3.1: Security, Fuzzing & QA Verification
  └── M3.2: Production Packaging & Documentation
```

---

## 3. Work Breakdown Structure (Task Contracts)

Every task is an atomic, independent contract worked in an isolated Git worktree.

### [TASK-001] {{INITIAL_TASK_TITLE}}
- **Status**: Ready | **Priority**: High | **Assignee**: `implementer`
- **Goal**: {{INITIAL_TASK_GOAL}}
- **Non-Goals**: Out of scope items not addressed in this slice.
- **Files Owned**: `src/{{MODULE_1_PATH}}/**`, `test/{{MODULE_1_PATH}}/**`
- **Dependencies / Blocking Edges**: None (Ready to assign)
- **Acceptance Criteria**:
  1. Implements designated contract and handles edge cases.
  2. Automated tests pass via `{{TEST_COMMAND}}`.
  3. No regressions in existing test suites.

### [TASK-002] {{NEXT_TASK_TITLE}}
- **Status**: Blocked | **Priority**: Medium | **Assignee**: Unassigned
- **Goal**: {{NEXT_TASK_GOAL}}
- **Dependencies / Blocking Edges**: Blocked by `TASK-001`
- **Acceptance Criteria**:
  1. Verified against output of `TASK-001`.
  2. Integration tests pass.

---

## 4. Completion Evidence Standard

A task is complete ONLY when:
1. Code and tests are committed on a feature branch (`feat/<task-id>-<slug>`).
2. Local validation commands (`{{TEST_COMMAND}}`, `{{LINT_COMMAND}}`) pass with output recorded.
3. Independent reviews (`code-reviewer` and `qa-engineer` or `security-reviewer`) approve the diff.
4. CI checks are green on `{{MAIN_BRANCH}}`.
