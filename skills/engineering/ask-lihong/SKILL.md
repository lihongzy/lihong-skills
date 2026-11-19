---
name: ask-lihong
description: >
  Ask which skill or flow fits your current situation. The master router and navigator across all skills in this repository.
  TRIGGER: When the user asks "which skill should I use", "what should I do next", "how do I start", "guide me through the workflow", or describes a situation without naming a specific skill.
  DO NOT TRIGGER: When the user has already explicitly invoked and named an exact skill to run.
disable-model-invocation: true
---

# Ask Lihong

You don't need to memorize every skill, flag, or workflow in this repository. Just ask.

Before recommending a step or executing upstream skills, read that skill's `SKILL.md`: the summaries here are for orientation only.

---

## The Master Map: Proven Engineering & Creative Methodologies

This repository synthesizes battle-tested AI software engineering methodologies, creative/domain toolkits, alongside repository maintenance tools:

```text
                                [Where are you working?]
                                            │
        ┌───────────────────┬───────────────┴───────────────┬───────────────────┐
        ▼                   ▼                               ▼                   ▼
【A. Super Agent】  【B. Matt Pocock Flow】        【C. Agentara Tools】  【D. Maintenance】
(Autonomous Loop)   (Disciplined Craftsmanship)     (AIGC, Health, Prod)  (Repo Sync & Meta)
        │                   │                               │                   │
  /init-super-agent    Stage 1: /matt/grill-with-docs  /agentara/gunpla-     /sync-upstream
  /autonomous-         Stage 2: /matt/to-spec          /agentara/super-daddy AGENTS.md
   engineering         Stage 3: /matt/implement       /agentara/feature-
  /git-commit-helper   Stage 4: /matt/pr & /retro       dev-loop
```

---

## Part A: Super Agent Autonomous Engineering (LofiSu Methodology)

The **Super Agent methodology** is built for **autonomous multi-agent orchestration**. It treats software development as an 8-step state machine running in isolated Git worktrees, governed by 5 specialized agent roles and strict architectural boundaries.

### Core Philosophy:
- **Zero Human Micromanagement**: The orchestrator reconciles state, plans tasks, delegates to subagents in worktrees, conducts adversarial reviews, and integrates automatically.
- **Strict Boundary Locks (`docs/MODULES.md`)**: Prevents Git merge conflicts among parallel agents by strictly enforcing exclusive file ownership.
- **Audit Ledger System**: Maintains 7 persistent markdown ledgers (`MASTER_PLAN.md`, `DEVELOPMENT_STATUS.md`, `AGENT_REGISTRY.md`, etc.).

### Commands:
1. **Day 0: Bootstrap Environment ➔ `/init-super-agent`**
   - Scaffolds `docs/MODULES.md`, `docs/MASTER_PLAN.md`, subagents, hooks, and deploys both `autonomous-engineering` and `git-commit-helper`.
2. **Day 1 ~ Day N: Autonomous Loop ➔ `/autonomous-engineering`**
   - Drives the continuous 8-step cycle (`Reconcile` ➔ `Plan` ➔ `Delegate` ➔ `Collect` ➔ `Review` ➔ `Integrate` ➔ `Persist` ➔ `Continue`).
3. **Commit Quality Enforcement ➔ `/git-commit-helper`**
   - Validates single-concern diffs, enforces boundary ownership against `docs/MODULES.md`, and formats Conventional Commits with evidence.

---

## Part B: Matt Pocock's "Idea → Ship" Methodology (Matt Pocock Flow)

> [!NOTE] Dynamic Single Source of Truth (SSOT)
> The authoritative, live specification for this flow is maintained upstream in `upstreams/mattpocock-skills/skills/engineering/ask-matt/SKILL.md`.
> The summary below provides orientation. When executing or elaborating on `/matt/...` workflows, the AI agent must read `upstreams/mattpocock-skills/skills/engineering/ask-matt/SKILL.md` directly. When upstream updates are pulled via `/sync-upstream`, changes reflect at runtime immediately without manual rewrites.

The **Matt Pocock methodology** is built for **disciplined human-agent craftsmanship**. It focuses on conversational sharpening, deep module architecture, context window hygiene (smart zone management), tracer-bullet ticket graphs, and continuous environmental retrospectives.

All skills in this school are accessible via the `/matt/<skill>` or `upstream:matt/<skill>` namespace (zero rewrite, executed directly from `upstreams/mattpocock-skills/`):

### 1. The Main Lifecycle (Idea ➔ Ship)

```text
/matt/grill-with-docs ──► /matt/to-spec ──► /matt/to-tickets ──► /matt/implement ──► /matt/pr ──► /matt/retro
        │                                                              │
(if design unclear)                                            (drives /matt/tdd +
        ▼                                                      /matt/code-review)
/matt/prototype + /matt/handoff
```

- **Step 1: Sharpen the Idea ➔ `/matt/grill-with-docs`**
  - Relentless Socratic interview that challenges assumptions and builds a stateful paper trail in `GLOSSARY.md` and ADRs.
- **Detour: Explore Unknowns ➔ `/matt/prototype` (bridged via `/matt/handoff`)**
  - Detour to answer design/UI questions with throwaway code in a clean branch before committing to specs.
- **Step 2: Formalize & Decompose ➔ `/matt/to-spec` ➔ `/matt/to-tickets`**
  - Turns interview notes into a cohesive technical specification (`/matt/to-spec`), then decomposes it into tracer-bullet tickets declaring blocking edges (`/matt/to-tickets`).
- **Step 3: Build & Verify ➔ `/matt/implement` or `/matt/implement-spec`**
  - Drives implementation ticket-by-ticket with fresh context windows (`/matt/implement`), or orchestrates the full task graph with parallel subagents (`/matt/implement-spec`).
  - **Single-slice TDD discipline**: Drives `/matt/tdd` (Red ➔ Green ➔ Refactor) per ticket.
  - **Adversarial verification**: Runs `/matt/code-review` (evaluating diff against Standards + Spec contracts).
- **Step 4: Ship with Evidence ➔ `/matt/pr`**
  - Generates industry-grade PR descriptions: diff-sketch visual, Before/After evidence, merge danger, blast radius, and one-way/two-way door classification.
- **Step 5: Systemic Learning ➔ `/matt/retro`**
  - Retrospective after a build to improve the agent's **environment** (tooling, automated checks, coding standards) rather than just patching code.

### 2. Specialized On-Ramps & Architectural Health
- **Greenfield / Foggy Efforts ➔ `/matt/wayfinder`**: Charts a shared map of decision tickets on your issue tracker to clear fog before specifying.
- **Scientific Bug Diagnosis ➔ `/matt/diagnosing-bugs`**: Enforces a tight feedback loop (command that fails on this bug) and regression tests before attempting fixes.
- **Incoming Work ➔ `/matt/triage`**: Triages external bug reports and requests into agent-ready issues.
- **Codebase Deepening ➔ `/matt/improve-codebase-architecture`**: Surfaces deep module opportunities (small interfaces over rich behaviors).
- **Design Vocabulary ➔ `/matt/domain-modeling` & `/matt/codebase-design`**: Clarifies domain language and deep-module design abstractions.

---

## Part C: Agentara Specialized Toolkits (AIGC, Health, Productivity via `/agentara/...`)

When you need creative visual workflows, specialized domain assistants, or Google-style change reviews, invoke them via the `/agentara/<skill>` namespace (executed directly from `upstreams/agentara-skills/`):

### 1. AIGC & Creative Direction
- **`/agentara/gunpla-poster`**: Guided interview to create premium collectible Gunpla model-photography posters.
- **`/agentara/presentation-design`**: 6-slide composite presentation design board as a single composite image with light/dark modes.
- **`/agentara/torn-paper-collage-poster`**: Layered torn-paper editorial collage poster prompts with rough typography and photocopied texture.
- **`/agentara/video-plan` & `/agentara/video-storyboard`**: Plan story arcs, visual continuity, and generate shot-by-shot storyboard boards.
- **`/agentara/video-character-design`**: Reusable character design specs and character turnarounds for video workflows.

### 2. High-Leverage Productivity & Simulations
- **`/agentara/feature-dev-loop`**: PR-sized feature development: requirements baseline, plan review, serial implementation, acceptance matrix, and HTML PR summary.
- **`/agentara/article-to-html`**: Renders markdown drafts into self-contained, publication-grade academic paper HTML pages with SVG figures and inline CSS.
- **`/agentara/doctor-strange`**: Causal sand-table simulations of future scenarios through parallel universe subagents.
- **`/agentara/mega-goal-prompt`**: Structured interview to generate production-ready `/goal` long-horizon agent prompts.
- **`/agentara/publish-research-site`**: Deploys citation-backed interactive research sites via Vercel CLI.

### 3. Family Health & Parenting
- **`/agentara/super-daddy`**: Family-doctor Chinese parenting assistant with profile tracking, structured checkups, and visual plans.
- **`/agentara/lab-interpreter`**: Medical laboratory report analyzer (blood tests, biochemistry, abnormal value flags).
- **`/agentara/emergency-triage`**: Urgent symptom triage and clinical examination preparation.

### 4. Google-Style Engineering Standards
- **`/agentara/engineering-code-review`**: High-standard code health, complexity, and maintainability review.
- **`/agentara/engineering-small-prs`**: Decomposes large changes into atomic, easily reviewable pull request sequences.
- **`/agentara/engineering-change-descriptions`**: Drafts pristine PR, CL, and commit descriptions.

---

## Part D: Maintaining `lihong-skills` Itself (Repo-Internal)

Use these flows **ONLY** when working inside the `lihong-skills` repository directory:

### Flow 4: Upstream Sync ➔ `/sync-upstream`
- **Scope**: ⚠️ **Internal to `lihong-skills` only**.
- **When**: Check for new commits on remote GitHub repos (`dsh-super-agent`, `mattpocock-skills`, `agentara-skills`), inspect the diff comparison table in `skills/engineering/sync-upstream/MAPPING.md`, and pull updates.

### Flow 5: Authoring a New Personal Skill
- **Scope**: Internal to `lihong-skills`.
- **When**: Distill a reusable custom prompt or workflow. Follow [AGENTS.md](AGENTS.md) and copy `templates/SKILL.template.md`.

---

## Deterministic Execution Rules for Agents

1. **Namespace Isolation**:
   - Commands starting with `/matt/` invoke the **Matt Pocock methodology** by reading directly from `upstreams/mattpocock-skills/...`.
   - Commands starting with `/agentara/` invoke **Agentara specialized skills** by reading directly from `upstreams/agentara-skills/...`.
   - Commands `/init-super-agent`, `/autonomous-engineering`, and `/git-commit-helper` invoke the **Super Agent methodology**.
2. **Upstream Internal Dependency Resolution (Scope Fallback)**:
   - When an upstream skill instructs the agent to invoke another internal skill by its unqualified name (e.g. `Call the Skill tool with "tdd"`, `Call the Skill tool for "grilling"` or `"code-review"`):
     - First, attempt to invoke the skill via the host `Skill` tool if registered globally.
     - If the unqualified skill is not registered in the host harness, dynamically locate and read its definition under the corresponding upstream vendor directory:
       - For Matt Pocock skills: `upstreams/mattpocock-skills/skills/**/<skill-name>/SKILL.md`
       - For Agentara skills: `upstreams/agentara-skills/skills/**/<skill-name>/SKILL.md`
     - Execute the resolved instructions inline within the active context window.
     - **Never rewrite or prefix internal dependency lookups**: internal calls preserve their pure upstream unqualified names (`tdd`, `code-review`, `grilling`, etc.).
3. **Zero Hallucination / Zero Assumptions**:
   - When asked for guidance, present this master map. Never guess between methodologies without explicit command or context.
