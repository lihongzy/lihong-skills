# Module Boundaries & File Ownership Map — {{PROJECT_NAME}}

> **Core Purpose**: Concurrency Control & Conflict Prevention.
> No two subagents may own or modify overlapping files simultaneously.
> Every task contract in `docs/MASTER_PLAN.md` must claim an exclusive boundary from this table before starting work.

---

## 1. Project Ownership Boundaries

The directory tree of {{PROJECT_NAME}} is partitioned into the non-overlapping boundaries below.
Subagents dispatched by the orchestrator must operate strictly within their assigned boundary.

| Boundary / Subsystem | Directory Scope | Ownership Rule & Restrictions |
| :--- | :--- | :--- |
| **{{BOUNDARY_1_NAME}}** | `{{BOUNDARY_1_PATH}}/**` | Exclusive to tasks targeting this subsystem. |
| **{{BOUNDARY_2_NAME}}** | `{{BOUNDARY_2_PATH}}/**` | Exclusive to tasks targeting this subsystem. |
| **{{BOUNDARY_3_NAME}}** | `{{BOUNDARY_3_PATH}}/**` | Exclusive to tasks targeting this subsystem. |

---

## 2. Universal Concurrency & Invariant Rules

1. **Exclusive Ownership (排他性所有权)**:
   - When an `implementer` subagent receives a task, its Task Contract must explicitly declare which directory boundary it owns.
   - The orchestrator will **never** dispatch two concurrent agents whose file scopes overlap.

2. **Inward Dependency Direction (单向依赖流)**:
   - Foundational and shared components (e.g. types, utilities, common schemas) must never import from higher-level domain or presentation modules.
   - Cross-boundary communication must traverse published, public interfaces.

3. **Forbidden Modifications (禁改区域)**:
   - Subagents are strictly prohibited from editing:
     - `.super-agent/state.json` (State machine is owned exclusively by the main orchestrator)
     - `docs/MASTER_PLAN.md` (Master plan is owned exclusively by the main orchestrator)
     - Any file outside their assigned task contract boundary.

4. **Safety & Blockers**:
   - If an assigned task discovers it cannot be completed without modifying files in an adjacent boundary, the subagent must **halt and report a blocker** rather than widening its own scope.
