<#
.SYNOPSIS
  Bootstraps the Super Agent multi-agent orchestration framework into the target project.

.DESCRIPTION
  Copies agents, hooks, orchestration rules, and state ledger templates into the target directory,
  substituting placeholders with project-specific values.

.PARAMETER TargetDir
  The target project directory to initialize. Defaults to current directory.

.PARAMETER ProjectName
  The name of the project. Defaults to target directory name.

.PARAMETER TestCommand
  Test command for the project (e.g. "npm test", "pytest", "cargo test").

.PARAMETER MainBranch
  Primary git branch (defaults to "main").

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\skills\engineering\init-super-agent\scripts\bootstrap.ps1 -TargetDir "C:\projects\my-app"
#>

[CmdletBinding()]
param(
    [string]$TargetDir = (Get-Location).Path,
    [string]$ProjectName,
    [string]$TestCommand,
    [string]$MainBranch = "main"
)

$ErrorActionPreference = "Stop"

# Dynamically locate repo root containing package.json
$curr = $PSScriptRoot
while ($curr -and (-not (Test-Path (Join-Path $curr "package.json")))) {
    $parent = Split-Path -Parent $curr
    if ($parent -eq $curr) { break }
    $curr = $parent
}
$RepoRoot = $curr
$SourceSkillDir = Join-Path $RepoRoot "skills\engineering\autonomous-engineering"

if (-not (Test-Path $SourceSkillDir)) {
    Write-Error "Source template directory not found at: $SourceSkillDir"
    exit 1
}

$TargetDir = (Resolve-Path $TargetDir).Path
if (-not $ProjectName) {
    $ProjectName = Split-Path -Leaf $TargetDir
}

if (-not $TestCommand) {
    if (Test-Path (Join-Path $TargetDir "package.json")) {
        $TestCommand = "npm test"
        $LintCommand = "npm run lint"
        $TypeCheckCommand = "npm run typecheck"
    } elseif ((Test-Path (Join-Path $TargetDir "pyproject.toml")) -or (Test-Path (Join-Path $TargetDir "requirements.txt"))) {
        $TestCommand = "pytest"
        $LintCommand = "flake8"
        $TypeCheckCommand = "mypy ."
    } elseif (Test-Path (Join-Path $TargetDir "Cargo.toml")) {
        $TestCommand = "cargo test"
        $LintCommand = "cargo clippy"
        $TypeCheckCommand = "cargo check"
    } elseif (Test-Path (Join-Path $TargetDir "go.mod")) {
        $TestCommand = "go test ./..."
        $LintCommand = "golangci-lint run"
        $TypeCheckCommand = "go vet ./..."
    } else {
        $TestCommand = "echo 'No tests configured'"
        $LintCommand = "echo 'No linter configured'"
        $TypeCheckCommand = "echo 'No typechecker configured'"
    }
} else {
    $LintCommand = "echo 'No linter configured'"
    $TypeCheckCommand = "echo 'No typechecker configured'"
}

$IsoDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")

Write-Host "`n=== Bootstrapping Super Agent Framework ===" -ForegroundColor Cyan
Write-Host "Target Project : $TargetDir" -ForegroundColor DarkCyan
Write-Host "Project Name   : $ProjectName" -ForegroundColor DarkCyan
Write-Host "Test Command   : $TestCommand" -ForegroundColor DarkCyan
Write-Host "Main Branch    : $MainBranch`n" -ForegroundColor DarkCyan

$ClaudeDir = Join-Path $TargetDir ".claude"
$AgentsDir = Join-Path $ClaudeDir "agents"
$HooksDir = Join-Path $ClaudeDir "hooks"
$SkillsDir = Join-Path $ClaudeDir "skills"
$AutonomousSkillDir = Join-Path $SkillsDir "autonomous-engineering"
$CommitHelperSkillDir = Join-Path $SkillsDir "git-commit-helper"
$SourceCommitHelperDir = Join-Path $RepoRoot "skills\engineering\git-commit-helper"
$DocsDir = Join-Path $TargetDir "docs"
$SuperAgentDir = Join-Path $TargetDir ".super-agent"
$AgentsWorkspaceSkills = Join-Path $TargetDir ".agents\skills"
$AgentsWorkspaceAutonomousDir = Join-Path $AgentsWorkspaceSkills "autonomous-engineering"
$AgentsWorkspaceCommitDir = Join-Path $AgentsWorkspaceSkills "git-commit-helper"

@($AgentsDir, $HooksDir, $AutonomousSkillDir, $CommitHelperSkillDir, $DocsDir, $SuperAgentDir, $AgentsWorkspaceAutonomousDir, $AgentsWorkspaceCommitDir) | ForEach-Object {
    if (-not (Test-Path $_)) {
        New-Item -ItemType Directory -Path $_ -Force | Out-Null
    }
}

function Render-Template([string]$sourcePath, [string]$destinationPath) {
    $content = Get-Content -Path $sourcePath -Raw -Encoding UTF8
    $content = $content.Replace("{{PROJECT_NAME}}", $ProjectName)
    $content = $content.Replace("{{PROJECT_DESCRIPTION}}", "Automated multi-agent engineering workflow for $ProjectName.")
    $content = $content.Replace("{{TEST_COMMAND}}", $TestCommand)
    $content = $content.Replace("{{LINT_COMMAND}}", $LintCommand)
    $content = $content.Replace("{{TYPECHECK_COMMAND}}", $TypeCheckCommand)
    $content = $content.Replace("{{MAIN_BRANCH}}", $MainBranch)
    $content = $content.Replace("{{DATE_ISO}}", $IsoDate)
    $content = $content.Replace("{{ARCHITECTURE_SPEC_DOC}}", "docs/MASTER_PLAN.md")
    $content = $content.Replace("{{INITIAL_TASK_TITLE}}", "System Architecture & Baseline Test Suite")
    $content = $content.Replace("{{INITIAL_TASK_GOAL}}", "Verify base project dependencies and ensure baseline tests pass.")
    $content = $content.Replace("{{NEXT_TASK_TITLE}}", "First Core Feature Implementation")
    $content = $content.Replace("{{NEXT_TASK_GOAL}}", "Implement primary domain feature.")
    $content = $content.Replace("{{MODULE_1_NAME}}", "Core Engine")
    $content = $content.Replace("{{MODULE_1_DESC}}", "Core business logic and state")
    $content = $content.Replace("{{MODULE_1_PATH}}", "core")
    $content = $content.Replace("{{MODULE_1_API}}", "Internal API")
    $content = $content.Replace("{{MODULE_2_NAME}}", "CLI / Interfaces")
    $content = $content.Replace("{{MODULE_2_DESC}}", "User and agent interaction boundaries")
    $content = $content.Replace("{{MODULE_2_PATH}}", "cli")
    $content = $content.Replace("{{MODULE_2_API}}", "Console API")
    $content = $content.Replace("{{MODULE_3_NAME}}", "Utilities")
    $content = $content.Replace("{{MODULE_3_DESC}}", "Cross-cutting helper functions")
    $content = $content.Replace("{{MODULE_3_PATH}}", "utils")
    $content = $content.Replace("{{MODULE_3_API}}", "Helper API")
    $content = $content.Replace("{{BOUNDARY_1_NAME}}", "Core Application / Source")
    $content = $content.Replace("{{BOUNDARY_1_PATH}}", "src")
    $content = $content.Replace("{{BOUNDARY_2_NAME}}", "Test Suites & Verification")
    $content = $content.Replace("{{BOUNDARY_2_PATH}}", "test")
    $content = $content.Replace("{{BOUNDARY_3_NAME}}", "Build & Tooling Scripts")
    $content = $content.Replace("{{BOUNDARY_3_PATH}}", "scripts")

    [System.IO.File]::WriteAllText($destinationPath, $content, [System.Text.Encoding]::UTF8)
}

# Deploy Agents
Get-ChildItem -Path (Join-Path $SourceSkillDir "agents") -Filter "*.md" | ForEach-Object {
    $dest = Join-Path $AgentsDir $_.Name
    Render-Template $_.FullName $dest
    Write-Host "  + Deployed subagent: $($_.Name)" -ForegroundColor Green
}

# Deploy Hooks & Settings
Copy-Item (Join-Path $SourceSkillDir "hooks\super-agent-stop-guard.py") (Join-Path $HooksDir "super-agent-stop-guard.py") -Force
Copy-Item (Join-Path $SourceSkillDir "settings.json") (Join-Path $ClaudeDir "settings.json") -Force
Copy-Item (Join-Path $SourceSkillDir "SKILL.md") (Join-Path $AutonomousSkillDir "SKILL.md") -Force
Copy-Item (Join-Path $SourceSkillDir "SKILL.md") (Join-Path $AgentsWorkspaceAutonomousDir "SKILL.md") -Force
if (Test-Path (Join-Path $SourceCommitHelperDir "SKILL.md")) {
    Copy-Item (Join-Path $SourceCommitHelperDir "SKILL.md") (Join-Path $CommitHelperSkillDir "SKILL.md") -Force
    Copy-Item (Join-Path $SourceCommitHelperDir "SKILL.md") (Join-Path $AgentsWorkspaceCommitDir "SKILL.md") -Force
}
Write-Host "  + Deployed Stop guard hook & Claude settings" -ForegroundColor Green
Write-Host "  + Deployed paired skills: autonomous-engineering & git-commit-helper (to .claude and .agents)" -ForegroundColor Green

# Deploy State Machine
Copy-Item (Join-Path $SourceSkillDir "templates\state.json") (Join-Path $SuperAgentDir "state.json") -Force
Write-Host "  + Initialized .super-agent/state.json" -ForegroundColor Green

# Deploy Ledger Docs
$TemplatesDocsDir = Join-Path $SourceSkillDir "templates\docs"
Get-ChildItem -Path $TemplatesDocsDir -Filter "*.template.md" | ForEach-Object {
    $targetDocName = $_.Name.Replace(".template.md", ".md")
    $dest = Join-Path $DocsDir $targetDocName
    if (-not (Test-Path $dest)) {
        Render-Template $_.FullName $dest
        Write-Host "  + Generated documentation ledger: docs/$targetDocName" -ForegroundColor Green
    } else {
        Write-Host "  ~ Keeping existing docs/$targetDocName" -ForegroundColor Gray
    }
}

# Deploy Rule Files: CLAUDE.md, GEMINI.md, and AGENTS.md
$TargetClaudeMd = Join-Path $TargetDir "CLAUDE.md"
$TargetGeminiMd = Join-Path $TargetDir "GEMINI.md"
$TargetAgentsMd = Join-Path $TargetDir "AGENTS.md"
$SourceClaudeTemplate = Join-Path $SourceSkillDir "CLAUDE.template.md"

if (-not (Test-Path $TargetClaudeMd)) {
    Render-Template $SourceClaudeTemplate $TargetClaudeMd
    Write-Host "  + Created project CLAUDE.md (Claude Code)" -ForegroundColor Green
} else {
    Write-Host "  ~ CLAUDE.md already exists in target project." -ForegroundColor Gray
}

if (-not (Test-Path $TargetGeminiMd)) {
    Render-Template $SourceClaudeTemplate $TargetGeminiMd
    Write-Host "  + Created project GEMINI.md (Google Antigravity)" -ForegroundColor Green
}

if (-not (Test-Path $TargetAgentsMd)) {
    Render-Template $SourceClaudeTemplate $TargetAgentsMd
    Write-Host "  + Created project AGENTS.md (Codex & Agent Standards)" -ForegroundColor Green
}

# Update .gitignore
$GitignorePath = Join-Path $TargetDir ".gitignore"
$ignoreEntry = "`n# Super Agent State Machine`n.super-agent/`n"
if (Test-Path $GitignorePath) {
    $existing = Get-Content $GitignorePath -Raw
    if ($existing -notmatch "\.super-agent") {
        Add-Content -Path $GitignorePath -Value $ignoreEntry
        Write-Host "  + Appended .super-agent/ to .gitignore" -ForegroundColor Green
    }
} else {
    Set-Content -Path $GitignorePath -Value $ignoreEntry
    Write-Host "  + Created .gitignore with .super-agent/" -ForegroundColor Green
}

Write-Host "`n✓ Super Agent framework initialized successfully in $TargetDir!" -ForegroundColor Cyan
