<#
.SYNOPSIS
  Installs/symlinks all skills in this repository into local agent skill directories on Windows.

.DESCRIPTION
  Scans skills/<category>/<skill-name>/SKILL.md and creates directory junctions in:
    - ~/.claude/skills/<skill-name> (Claude Code)
    - ~/.agents/skills/<skill-name> (Codex and Agent Skills compatible harnesses)
    - ~/.gemini/config/skills/<skill-name> (Google Antigravity)

.PARAMETER DryRun
  Show what actions would be performed without modifying the filesystem.

.EXAMPLE
  .\scripts\install.ps1
  .\scripts\install.ps1 -DryRun
#>

[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$SkillsRoot = Join-Path $RepoRoot "skills"

$Destinations = @(
    (Join-Path $HOME ".claude\skills"),
    (Join-Path $HOME ".agents\skills"),
    (Join-Path $HOME ".gemini\config\skills")
)

if (-not (Test-Path $SkillsRoot)) {
    Write-Warning "No skills directory found at: $SkillsRoot"
    exit 0
}

$SkillFiles = Get-ChildItem -Path $SkillsRoot -Recurse -Filter "SKILL.md" -ErrorAction SilentlyContinue |
              Where-Object { 
                  $_.FullName -notmatch "node_modules" -and 
                  $_.FullName -notmatch "deprecated" 
              }

if (-not $SkillFiles -or $SkillFiles.Count -eq 0) {
    Write-Host "No active skills found. Add a skill under skills/<category>/<name>/SKILL.md and re-run." -ForegroundColor Yellow
    exit 0
}

Write-Host "`n=== Syncing Skills to Local Agents ===" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "[DRY RUN MODE] No changes will be written.`n" -ForegroundColor Magenta
}

$TotalSkills = $SkillFiles.Count
$SuccessCount = 0

foreach ($dest in $Destinations) {
    Write-Host "Target: $dest" -ForegroundColor DarkCyan
    if (-not (Test-Path $dest)) {
        if (-not $DryRun) {
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
        }
        Write-Host "  + Created directory $dest" -ForegroundColor Gray
    }

    foreach ($file in $SkillFiles) {
        $skillDir = $file.Directory.FullName
        $skillName = $file.Directory.Name
        $targetLink = Join-Path $dest $skillName

        if (Test-Path $targetLink) {
            $item = Get-Item $targetLink
            $isReparsePoint = ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0
            
            if ($isReparsePoint) {
                if (-not $DryRun) {
                    # Remove stale junction
                    [System.IO.Directory]::Delete($targetLink)
                }
                Write-Host "  ~ Refreshing junction for $skillName" -ForegroundColor Gray
            } else {
                Write-Warning "  ! Skipping '$skillName': '$targetLink' is an existing real directory, not a junction."
                continue
            }
        }

        if ($DryRun) {
            Write-Host "  [dry-run] Would link $skillName -> $targetLink" -ForegroundColor DarkGray
        } else {
            # Create Directory Junction (works without Developer Mode / Admin rights)
            New-Item -ItemType Junction -Path $targetLink -Target $skillDir | Out-Null
            Write-Host "  + Linked: $skillName" -ForegroundColor Green
            $SuccessCount++
        }
    }
    Write-Host ""
}

Write-Host "Done! Processed $TotalSkills skill(s)." -ForegroundColor Cyan
