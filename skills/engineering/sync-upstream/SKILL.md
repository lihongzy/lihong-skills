---
name: sync-upstream
description: >
  Inspects, tracks, and synchronizes upstream open-source skill repositories with local vendor snapshots in lihong-skills.
  TRIGGER: When working inside the lihong-skills repository and the user asks to check for upstream skill updates, synchronize upstream repositories, diff changes against GitHub, or view the upstream asset comparison table.
  DO NOT TRIGGER: When working inside external projects. This skill is exclusively for maintaining the lihong-skills repository itself.
---

# Sync Upstream (Repo-Internal Maintenance)

> ⚠️ **Repository-Internal Scope**:
> This skill is strictly designed for maintaining the `lihong-skills` repository itself.
> It manages vendor mirrors in `upstreams/` and does NOT apply to external software projects.

You are acting as the Open-Source Upstream Dependency Manager for `lihong-skills`. You maintain pure vendor snapshots of external skill repositories in `upstreams/`, verify commit hashes, inspect git diffs, display the asset comparison table, and assist in adapting upstream enhancements into parameterized local skills.

## The Definitive Comparison Matrix

The definitive asset mapping and adaptation table is maintained in:
`skills/engineering/sync-upstream/MAPPING.md`

Whenever the user asks:
- *"What is the difference between my skills and the upstream repository?"*
- *"Show me the upstream comparison table"*
- *"Which upstream files map to which local skills?"*

Consult and present the comparison matrix from `MAPPING.md`.

## Workflow

1. **Check Status & Display Comparison Table**:
   - Run the inspection script:
     - On Windows:
       ```powershell
       powershell -ExecutionPolicy Bypass -File .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1
       ```
     - On POSIX:
       ```bash
       ./skills/engineering/sync-upstream/scripts/sync-upstream.sh
       ```
   - Present the comparison table showing Tracked SHA vs Remote SHA and parity status.

2. **Pull Updates (When requested by user)**:
   - Run with the update flag:
     - Windows: `powershell -ExecutionPolicy Bypass -File .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1 -Update`
     - POSIX: `./skills/engineering/sync-upstream/scripts/sync-upstream.sh --update`

3. **Diff Analysis & Adaptation**:
   - Use `MAPPING.md` to identify which local files are affected by the upstream commits.
   - For hooks and settings: copy upstream directly.
   - For agents, orchestrator rules, and templates: port behavioral improvements while preserving parameterization placeholders (`{{PROJECT_NAME}}`, `{{TEST_COMMAND}}`, etc.).
   - Update `MAPPING.md` and `UPSTREAM.json` to record the newly synchronized commit.

## Output Specification

Always provide:
1. Upstream comparison table with commit hashes and sync status.
2. If checking differences: The asset mapping from `MAPPING.md`.
3. If updating: A summary of incoming commits and affected local skill files.
