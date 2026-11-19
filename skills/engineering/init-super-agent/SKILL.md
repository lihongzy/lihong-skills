---
name: init-super-agent
description: >
  Intelligently bootstraps and customizes the Super Agent multi-agent orchestration framework for a project.
  Synthesizes the reference upstream standard with target project realities (both existing codebases and greenfield projects).
  TRIGGER: When the user asks to "initialize super-agent", "setup autonomous engineering", "bootstrap multi-agent workflow", or prepare a project for autonomous development.
  DO NOT TRIGGER: When the project is already fully initialized with active state ledgers and ongoing orchestration cycles.
---

# Init Super Agent

You are the Project Bootstrap Specialist. Your mission is not merely to copy boilerplate templates, but to **intelligently synthesize two perspectives**:
1. **The Reference Example Benchmark**: The battle-tested conventions, strict module boundaries, and task contract standards demonstrated in `upstreams/dsh-super-agent/`.
2. **The Target Project Reality**: The actual codebase state, existing architecture, real dependencies, and specific user goals.

Whether the target is an **existing mature codebase** or a **brand-new greenfield project**, you synthesize both perspectives to produce a bespoke, production-ready orchestration setup.

---

## The Reference Example Benchmark

Before tailoring the project documentation, review the gold-standard reference files in `upstreams/dsh-super-agent/`:
- `upstreams/dsh-super-agent/docs/MASTER_PLAN.md`: Reference for how module boundaries, task contracts (Goal, Non-Goals, Scope, Acceptance Criteria), and blocking dependency edges are structured.
- `upstreams/dsh-super-agent/CLAUDE.md`: Reference for project orchestration laws, single loop ownership, session budgets, and evidence-first principles.
- `upstreams/dsh-super-agent/docs/DEVELOPMENT_STATUS.md`: Reference for cycle checkpoints and state transitions.

Learn the *mindset* and *granularity* from this reference, then apply them to the target project.

---

## Two-Phase Execution Workflow

### Phase 1: Physical Scaffolding Deployment

Deploy the baseline infrastructure, subagents, stop-guard hooks, and state machine schema:
- On Windows:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\skills\engineering\init-super-agent\scripts\bootstrap.ps1 -TargetDir "."
  ```
- On POSIX:
  ```bash
  ./skills/engineering/init-super-agent/scripts/bootstrap.sh "."
  ```

This ensures `.claude/agents/`, `.claude/hooks/`, `.claude/settings.json`, `.super-agent/state.json`, and baseline docs exist.

---

### Phase 2: Dual-Perspective Synthesis & Customization

Examine the target directory and determine which scenario applies:

#### Scenario A: Existing Codebase (已存在的项目)
The project already contains code, files, or existing configurations.

1. **Inspect Existing Reality**:
   - Inspect repository structure (`git status`, directory tree).
   - Read `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, or relevant build files.
   - Discover real test commands, linters, and typecheckers.
   - Scan existing source directories (e.g., `src/`, `lib/`, `pkg/`, `internal/`).
   - Identify existing architectural boundaries, TODOs, or open feature requests.

2. **Synthesize with the Reference Example**:
   - Open and customize `docs/MASTER_PLAN.md`:
     - **Replace generic module tables** with the real modules discovered in the codebase (e.g., Auth, Database, API, CLI), mapping their actual directory paths and ownership.
     - **Synthesize the Roadmap**: Group current project goals into logical phases.
     - **Craft real Task Contracts**: Write `[TASK-001]` as a concrete, actionable next step for this project (e.g., fixing an existing test deficit, refactoring a specific module, or building the next pending feature) with explicit Goals, Non-Goals, and Acceptance Criteria.
   - Open and customize `CLAUDE.md`:
     - Set the exact, working verification commands (`npm test`, `pytest`, `cargo test`, etc.).
     - Document project-specific idioms and conventions.

---

#### Scenario B: Greenfield Project (全新的空白项目)
The project is empty or only has an initial commit with a name.

1. **Understand Project Intent**:
   - Identify what the user wants to build and their preferred tech stack (if unspecified, ask or propose a clean modern stack).
   - Define the fundamental problem the project will solve.

2. **Synthesize with the Reference Example**:
   - Adopt the gold-standard 0-to-1 engineering progression from the reference example:
     - **Phase 1: Foundation & Scaffold**: Setting up types, interfaces, project skeletons, and establishing a green CI/test baseline.
     - **Phase 2: Core Domain Logic**: Implementing the primary business engine in testable vertical slices.
     - **Phase 3: Interfaces & Release**: CLI/API/UI adapters, security auditing, and end-to-end acceptance.
   - Open and customize `docs/MASTER_PLAN.md`:
     - Define the intended architectural modules and their future file paths.
     - Define `[TASK-001]` as establishing the project skeleton, base configuration, and the first executable green test suite.
   - Open and customize `CLAUDE.md`:
     - Configure the target language's standard test and lint commands.

---

## Phase 3: Final Verification & Next Action

1. Verify that `docs/MASTER_PLAN.md` and `CLAUDE.md` are completely free of raw placeholders (`{{...}}`) and reflect genuine, actionable project context.
2. Confirm `.super-agent/state.json` is ready (`mode: "paused"`, `next_action: "plan"`).
3. Present a clear summary to the user:
   - Outline the tailored architectural modules and active Phase 1 roadmap.
   - Announce that the project is primed for autonomous engineering.
   - Prompt the user to run `/autonomous-engineering` to trigger the first development cycle.
