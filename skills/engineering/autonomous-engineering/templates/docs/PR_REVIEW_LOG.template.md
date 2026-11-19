# {{PROJECT_NAME}} — Pull Request Review Log

All pull requests must undergo independent review before merge into `{{MAIN_BRANCH}}`.

---

## Review Standards Checklist

1. **Standards**: Clean diff, Conventional Commits, no dead code, idiomatic style.
2. **Spec Compliance**: Matches assigned task contract in `docs/MASTER_PLAN.md`.
3. **Test Verification**: Unit tests included and passing locally via `{{TEST_COMMAND}}`.
4. **Security & Auth**: No secret leaks, no unsafe path manipulation, proper access gates.
5. **Regression & QA**: No unintended breaking changes to public interfaces.

---

## Log of Pull Request Reviews

| PR # | Title | Author / Agent | Reviewers | Verdict | Critical Findings | Remediation Evidence |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| *#1* | *Example Initial Setup* | `implementer` | `code-reviewer`, `qa-engineer` | `APPROVED` | None | CI green, all tests pass |
