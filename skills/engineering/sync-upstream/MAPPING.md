# Upstream-to-Local Skill Mapping & Comparison Matrix

This document defines the definitive mapping between upstream vendor assets (`upstreams/`) and your parameterized, reusable skills (`skills/engineering/`).
When upstream releases updates, use this matrix to pinpoint affected files and port improvements without breaking local parameterization.

---

## 1. Registry: `dsh-super-agent`

- **Upstream Repository**: `https://github.com/LofiSu/dsh-super-agent.git`
- **Tracked Branch**: `main`
- **Tracked Commit**: `ca9823e5c096ea6ff4552b73b2d417cefaea88b9`
- **Local Mirror**: `upstreams/dsh-super-agent/`
- **Target Local Skill**: `skills/engineering/autonomous-engineering/`

### Asset Mapping & Diff Matrix

| # | Upstream Source Path | Local Reusable Skill Path | Parity Status | Key Differences / Adaptation Details |
| :--- | :--- | :--- | :--- | :--- |
| **1** | `.claude/skills/autonomous-engineering/SKILL.md` | `skills/engineering/autonomous-engineering/SKILL.md` | **Parameterized + Bootstrap Guard** | • Replaced `deepseek-super-agent` with `{{PROJECT_NAME}}`<br>• Parameterized build commands with `{{TEST_COMMAND}}`<br>• Added `## 0. Bootstrap Verification` self-healing check<br>• Preserved 100% of all 8 cycles, Starting/stopping, and Recovery checkpoints |
| **2** | `.claude/hooks/super-agent-stop-guard.py` | `skills/engineering/autonomous-engineering/hooks/super-agent-stop-guard.py` | **100% Identical** | Byte-for-byte identical copy. Enforces stop-continuation guard. |
| **3** | `.claude/settings.json` | `skills/engineering/autonomous-engineering/settings.json` | **100% Identical** | Wires Stop hook command to `$CLAUDE_PROJECT_DIR/.claude/hooks/super-agent-stop-guard.py`. |
| **4** | `CLAUDE.md` | `skills/engineering/autonomous-engineering/CLAUDE.template.md` | **Parameterized** | • Replaced project specifics with `{{PROJECT_NAME}}`, `{{MAIN_BRANCH}}`, `{{TEST_COMMAND}}`, `{{LINT_COMMAND}}`<br>• Preserves all 7 core orchestration laws, Naming rules, and Evidence-first standards |
| **5** | `.claude/agents/architect.md` | `skills/engineering/autonomous-engineering/agents/architect.md` | **Parameterized** | • Substituted `{{PROJECT_NAME}}`<br>• 100% identical role rules, boundary review criteria, read-only restriction |
| **6** | `.claude/agents/code-reviewer.md` | `skills/engineering/autonomous-engineering/agents/code-reviewer.md` | **Parameterized** | • Substituted `{{PROJECT_NAME}}`<br>• 100% identical adversarial checklist and mandatory verdict enums (`APPROVE`, `REQUEST_CHANGES`, `REJECT`, `BLOCKED`) |
| **7** | `.claude/agents/implementer.md` | `skills/engineering/autonomous-engineering/agents/implementer.md` | **Parameterized** | • Substituted `{{PROJECT_NAME}}`, `{{MAIN_BRANCH}}`, and build commands<br>• Removed author-only restriction (`owner-only repository`)<br>• Preserved `isolation: worktree` and strict 5-item report format |
| **8** | `.claude/agents/qa-engineer.md` | `skills/engineering/autonomous-engineering/agents/qa-engineer.md` | **Parameterized** | • Substituted `{{PROJECT_NAME}}` and `{{TEST_COMMAND}}`<br>• Preserved mandatory "fail without change" check and anti-fabrication rules |
| **9** | `.claude/agents/security-reviewer.md` | `skills/engineering/autonomous-engineering/agents/security-reviewer.md` | **Parameterized** | • Substituted `{{PROJECT_NAME}}`<br>• Generalized platform scripts from AppleScript to `shell, scripts, gh`<br>• Preserved all 8 vulnerability attack vectors |
| **10** | `docs/MODULES.md` | `skills/engineering/autonomous-engineering/templates/docs/MODULES.template.md` | **Universal Ownership Boundaries** | • Abstracted upstream's M0–M11 engine structure into a universal **Concurrency Control & File Ownership Boundary** system.<br>• Rather than forcing a rigid architectural dogma (e.g. Ingress/Harness/Channels, which fails across frontends, CLIs, Monorepos, or data pipelines), it enforces the true physical invariant: **strictly non-overlapping directory ownership** so concurrent subagents never create Git merge conflicts.<br>• Directory scopes are synthesized dynamically by `init-super-agent` based on target codebase realities. |
| **11** | `docs/MASTER_PLAN.md` | `skills/engineering/autonomous-engineering/templates/docs/MASTER_PLAN.template.md` | **Template Extraction** | Converted upstream master plan into parameterized roadmap, task contracts (Goal, Non-Goals, Scope, Tests), and blocking dependency edges. |
| **12** | `docs/DEVELOPMENT_STATUS.md` | `skills/engineering/autonomous-engineering/templates/docs/DEVELOPMENT_STATUS.template.md` | **Template Extraction** | Parameterized session recovery checkpoint, cycle counter, in-flight PR tracking table, and latest green test evidence log. |
| **13** | `docs/AGENT_REGISTRY.md` | `skills/engineering/autonomous-engineering/templates/docs/AGENT_REGISTRY.template.md` | **Template Extraction** | Parameterized subagent concurrency table and isolated Git worktree tracking registry. |
| **14** | `docs/AGENT_LOG.md` | `skills/engineering/autonomous-engineering/templates/docs/AGENT_LOG.template.md` | **Template Extraction** | Parameterized append-only execution evidence stream. |
| **15** | `docs/PR_REVIEW_LOG.md` | `skills/engineering/autonomous-engineering/templates/docs/PR_REVIEW_LOG.template.md` | **Template Extraction** | Parameterized independent adversarial review audit table. |
| **16** | `docs/ARCHITECTURE_DECISIONS.md` | `skills/engineering/autonomous-engineering/templates/docs/ARCHITECTURE_DECISIONS.template.md` | **Template Extraction** | Standardized Architecture Decision Record (ADR) template. |
| **17** | *(Runtime state file)* | `skills/engineering/autonomous-engineering/templates/state.json` | **Schema Baseline** | Clean initial state machine schema (`mode: "paused"`, `cycles: 0`). |
| **18** | `CLAUDE.md` *(Engineering Rules)* | `skills/engineering/git-commit-helper/SKILL.md` | **Rule Enforcement** | Enforces upstream engineering invariants: Conventional Commits with scope strictly aligned to `docs/MODULES.md`, "One Concern per commit" slicing, and evidence-backed commit bodies. |

---

## 2. Registry: `mattpocock-skills`

- **Upstream Repository**: `https://github.com/mattpocock/skills.git`
- **Tracked Branch**: `main`
- **Tracked Commit**: `abeeaf95660ba9e8b7c753eb38f441ca707a8823`
- **Local Mirror**: `upstreams/mattpocock-skills/`
- **Target Local Skill(s)**: `skills/engineering/ask-lihong/`, `scripts/check-frontmatter.mjs`

### Asset Mapping & Adaptation Matrix

| # | Upstream Source Path | Local Reusable Asset | Parity Status | Key Differences / Adaptation Details |
| :--- | :--- | :--- | :--- | :--- |
| **1** | `skills/engineering/ask-matt/SKILL.md` | `skills/engineering/ask-lihong/SKILL.md` | **Adapted Master Router** | Adapted Matt Pocock's famous routing philosophy into the master navigator for your personal skills library. Segregates project engineering flows from internal repository maintenance. |
| **2** | `scripts/check-frontmatter.mjs` | `scripts/check-frontmatter.mjs` | **Enhanced Validator** | Reused Matt's YAML frontmatter AST parser; enhanced with directory-name validation and custom reporting. |
| **3** | `.claude-plugin/` & `package.json` | `.claude-plugin/` & `package.json` | **Standardized Distribution** | Reused Matt's multi-agent plugin manifest specifications for Claude Code and Codex compatibility. |
| **4** | `skills/engineering/pr/` | *(Candidate for porting)* | Available in Upstream | Industry-standard PR generator with Summary diff-sketches, Before/After evidence, and Blast Radius merge danger assessments. |
| **5** | `skills/engineering/tdd/` | *(Candidate for porting)* | Available in Upstream | Pure test-driven development workflow (Red ➔ Green ➔ Refactor slices). |
| **6** | `skills/engineering/code-review/` | *(Candidate for porting)* | Available in Upstream | Standards + Spec two-axis adversarial review system. |

---

## 3. Registry: `agentara-skills`

- **Upstream Repository**: `https://github.com/agentara/skills.git`
- **Tracked Branch**: `main`
- **Tracked Commit**: `950e1bfb11e1df67b46df19804ed85ada9012c33`
- **Local Mirror**: `upstreams/agentara-skills/`
- **Target Local Skill(s)**: Available via `/agentara/...` namespace and candidate for direct integration

### Domain Asset Mapping Matrix

| Category | Upstream Skills | Capabilities & Highlights | Integration Status |
| :--- | :--- | :--- | :--- |
| **AIGC** | `gunpla-poster`, `presentation-design`, `soviet-storybook-grotesque`, `torn-paper-collage-poster`, `video-character-design`, `video-plan`, `video-poster-design`, `video-storyboard`, `fluffy-poofy-3d-characters`, `portrait-clone` | Image stylization prompts, presentation board compositing, video planning, character sheets, storyboards. | Available via `/agentara/<skill>` |
| **Productivity** | `feature-dev-loop`, `article-to-html`, `doctor-strange`, `mega-goal-prompt`, `publish-research-site` | PR-sized feature development loops, markdown to paper HTML, causal simulation sand-tables, goal prompting, research deployment. | Available via `/agentara/<skill>` |
| **Engineering** | `engineering-code-review`, `engineering-small-prs`, `engineering-change-descriptions`, `engineering-review-comments`, `engineering-review-feedback`, `engineering-emergency-changes` | Google-style change descriptions, small PR slicing, code review etiquette and emergency hotfix decisions. | Available via `/agentara/<skill>` |
| **Health** | `super-daddy`, `emergency-triage`, `lab-interpreter` | Family doctor parenting assistant with profile tracking, urgent symptom triage, and medical lab report interpretation. | Available via `/agentara/<skill>` |
| **Entertainment** | `world-cup-predictor` | Sports forecasting, Polymarket prediction integration, and real-time dashboard updates. | Available via `/agentara/<skill>` |

---

## 4. Upstream Sync & Diff Checklist

When running `sync-upstream`:
1. Compare incoming commit diffs against `upstreams/dsh-super-agent/`, `upstreams/mattpocock-skills/`, or `upstreams/agentara-skills/`.
2. Locate the modified upstream file in the matrices above.
3. If an upstream asset changed:
   - **Hooks/Settings**: Directly copy updates into `hooks/` and `settings.json`.
   - **Agents/SKILL/CLAUDE**: Merge prompt and behavioral changes while keeping placeholders (`{{PROJECT_NAME}}`, `{{TEST_COMMAND}}`, etc.) intact.
   - **Docs/Templates**: Update ledger schemas if upstream introduced new state columns or tracking conventions.
4. Update the `Tracked Commit` in `UPSTREAM.json` and this matrix.
