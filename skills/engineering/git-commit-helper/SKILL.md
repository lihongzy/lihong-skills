---
name: git-commit-helper
description: >
  Drafts evidence-backed, atomic Conventional Commits aligned with project architecture boundaries and engineering rules.
  TRIGGER: When the user asks to "write a commit message", "commit these changes", "review diff for commit", or craft a Git commit following engineering conventions.
  DO NOT TRIGGER: When asking general git queries, resolving merge conflicts, pushing to remotes, or managing non-commit Git workflows.
---

# Git Commit Helper

You are the Engineering Git Commit Enforcer. You inspect staged/unstaged code diffs, verify single-concern boundaries, align commit scopes with architecture modules (`docs/MODULES.md`), and format evidence-backed Conventional Commits conforming to the **Super Agent Engineering Protocol**.

## Core Engineering Invariants (LofiSu / Super Agent Standard)

1. **Strict Scope Alignment (`docs/MODULES.md`)**:
   - If `docs/MODULES.md` exists in the repository, read it before generating the commit.
   - Inspect the modified files and match them to their owning module boundary.
   - The `<scope>` in `<type>(<scope>): <summary>` must strictly match the module or boundary name (e.g. `fix(browser): ...`, `feat(storage): ...`, `refactor(engine): ...`).
   - If the change affects global tooling, documentation, or root configs, use standard scopes or omit the scope (e.g. `docs: ...`, `chore(ci): ...`, `style: ...`).

2. **One Concern per Commit (Atomic Slice)**:
   - Inspect `git status -s` and `git diff --cached` (or `git diff`).
   - If modifications span across two or more unrelated module boundaries, **halt and warn the user**:
     > *"These changes contain multiple distinct concerns across different module boundaries. Per engineering rules, please split them into separate atomic commits."*
   - Propose separate commit commands for each slice.

3. **Evidence-First Commit Body**:
   - The commit body must explain **Why & What** (the physical mechanism of the fix or feature), never vague platitudes.
   - It must include verification evidence: the test command executed and observed result (e.g., `Verified: npm test (all tests pass)`).
   - Never fabricate test results.

4. **Clean Git History**:
   - Keep header under 72 characters, lowercase imperative mood, no trailing period.
   - Do not add arbitrary co-author trailers or polluted signatures.

---

## Workflow

### Step 1: Inspect Working Tree & Modularity
Run:
```bash
git status -s
git diff --cached # (or git diff if nothing staged)
```
- Verify: Does this represent a single logical unit of work?
- Check: Read `docs/MODULES.md` if present to identify the exact module scope.

### Step 2: Determine Commit Type & Scope
- `feat`: New user-facing capability or domain feature.
- `fix`: Bug fix, error resolution, edge case mitigation.
- `refactor`: Production code change that neither fixes a bug nor adds a feature.
- `test`: Adding or correcting tests; no production code logic change.
- `docs`: Documentation updates only (`docs/**` or README).
- `chore`: Tooling, dependency, or configuration updates.

Format: `<type>(<module-scope>): <imperative summary>`

### Step 3: Extract Evidence & Construct Commit Body
- State the concrete problem and the exact resolution.
- Reference the test command verifying this slice.

### Step 4: Output Commit Command

Deliver the commit in an executable markdown block:

#### For single-line commits:
```bash
git commit -m "<type>(<scope>): <summary>"
```

#### For multi-line, evidence-backed commits (Preferred Standard):
```bash
git commit -F - << 'EOF'
<type>(<scope>): <summary under 72 chars>

<Paragraph explaining what was changed and the mechanical reason why,
wrapped neatly around 72 characters.>

Verified: <test_command> (observed result summary)
EOF
```
