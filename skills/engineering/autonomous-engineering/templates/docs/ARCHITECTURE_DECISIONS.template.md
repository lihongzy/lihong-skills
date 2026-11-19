# {{PROJECT_NAME}} — Architecture Decision Records (ADRs)

---

## ADR-001: Autonomous Multi-Agent Engineering Architecture

- **Date**: {{DATE_ISO}}
- **Status**: Accepted
- **Context**:
  To develop {{PROJECT_NAME}} systematically with high test coverage and zero regression, we adopt an evidence-driven multi-agent orchestration architecture.
- **Decision**:
  1. Main orchestrator runs the 7-step loop (Reconcile, Plan, Delegate, Collect, Review, Integrate, Persist).
  2. Subagents execute in isolated Git worktrees.
  3. All modifications land via Pull Requests with mandatory independent adversarial reviews.
- **Consequences**:
  - Positive: High code quality, full audit trail, safe concurrent implementation.
  - Negative: Requires formal reviews and PR overhead for every change.
