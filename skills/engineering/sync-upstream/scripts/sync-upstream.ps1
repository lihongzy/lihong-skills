<#
.SYNOPSIS
  Inspects and synchronizes upstream repositories tracked in the upstreams/ directory.

.DESCRIPTION
  Reads UPSTREAM.json from each subfolder under upstreams/, checks the remote Git repository
  for new commits on the tracked branch, and displays a structured comparison matrix.

.PARAMETER Name
  Specific upstream to check/sync (e.g. "dsh-super-agent"). Defaults to all.

.PARAMETER Update
  If specified, pulls the latest commit from remote, updates files, and rewrites UPSTREAM.json.

.PARAMETER ShowMapping
  Displays the full asset comparison and adaptation table from MAPPING.md.

.EXAMPLE
  .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1
  .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1 -Update
  .\skills\engineering\sync-upstream\scripts\sync-upstream.ps1 -ShowMapping
#>

[CmdletBinding()]
param(
    [string]$Name,
    [switch]$Update,
    [switch]$ShowMapping
)

$ErrorActionPreference = "Stop"

$curr = $PSScriptRoot
while ($curr -and (-not (Test-Path (Join-Path $curr "package.json")))) {
    $parent = Split-Path -Parent $curr
    if ($parent -eq $curr) { break }
    $curr = $parent
}
$RepoRoot = $curr
$UpstreamsDir = Join-Path $RepoRoot "upstreams"
$MappingFile = Join-Path $PSScriptRoot "..\MAPPING.md"

if ($ShowMapping) {
    if (Test-Path $MappingFile) {
        Get-Content $MappingFile | Out-Host
    } else {
        Write-Warning "Mapping file not found at $MappingFile"
    }
    exit 0
}

if (-not (Test-Path $UpstreamsDir)) {
    Write-Warning "No upstreams directory found at $UpstreamsDir"
    exit 0
}

$Targets = Get-ChildItem -Path $UpstreamsDir -Directory | Where-Object {
    (Test-Path (Join-Path $_.FullName "UPSTREAM.json")) -and
    (-not $Name -or $_.Name -eq $Name)
}

if (-not $Targets -or $Targets.Count -eq 0) {
    Write-Host "No valid upstream targets found matching '$Name'." -ForegroundColor Yellow
    exit 0
}

Write-Host "`n=== Upstream Skill Repository Inspector ===" -ForegroundColor Cyan

$SummaryResults = @()

foreach ($target in $Targets) {
    $configFile = Join-Path $target.FullName "UPSTREAM.json"
    $config = Get-Content $configFile -Raw -Encoding UTF8 | ConvertFrom-Json

    $repoName = $config.name
    $repoUrl = $config.repository
    $branch = $config.branch
    $currentSha = $config.tracked_commit

    Write-Host "`nChecking [$repoName] ($repoUrl on '$branch')..." -ForegroundColor DarkCyan

    try {
        $lsRemoteOutput = git ls-remote $repoUrl "refs/heads/$branch" 2>$null
        if (-not $lsRemoteOutput) {
            Write-Warning "  Unable to reach remote repository or find branch '$branch'."
            $SummaryResults += [PSCustomObject]@{
                "Upstream"      = $repoName
                "Branch"        = $branch
                "Tracked SHA"   = $currentSha.Substring(0, [Math]::Min(7, $currentSha.Length))
                "Remote SHA"    = "UNREACHABLE"
                "Status"        = "NETWORK_ERROR"
                "Local Mapping" = "autonomous-engineering"
            }
            continue
        }

        $latestSha = ($lsRemoteOutput -split "`t")[0].Trim()
        $shortCurrent = $currentSha.Substring(0, [Math]::Min(7, $currentSha.Length))
        $shortRemote = $latestSha.Substring(0, [Math]::Min(7, $latestSha.Length))

        if ($currentSha -eq $latestSha) {
            Write-Host "  ✓ Up to date! No changes detected upstream." -ForegroundColor Green
            $statusText = "UP_TO_DATE"
        } else {
            Write-Host "  ! NEW UPDATES AVAILABLE upstream!" -ForegroundColor Yellow
            $statusText = "OUTDATED"

            if ($Update) {
                Write-Host "  Fetching updates and updating local snapshot..." -ForegroundColor Magenta
                $tempClone = Join-Path $env:TEMP ("sync_" + [System.Guid]::NewGuid().ToString("N"))
                try {
                    git clone --depth 50 --branch $branch $repoUrl $tempClone | Out-Null
                    
                    $commitDiff = git -C $tempClone log "$currentSha..$latestSha" --oneline 2>$null
                    if ($commitDiff) {
                        Write-Host "`n  Recent Upstream Commits:" -ForegroundColor Cyan
                        $commitDiff | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
                    }

                    Get-ChildItem -Path $target.FullName -Exclude "UPSTREAM.json" | Remove-Item -Recurse -Force
                    Get-ChildItem -Path $tempClone -Exclude ".git" | Copy-Item -Destination $target.FullName -Recurse -Force

                    $config.tracked_commit = $latestSha
                    $config.last_synced_at = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
                    $config | ConvertTo-Json -Depth 5 | Set-Content $configFile -Encoding UTF8

                    Write-Host "  ✓ Snapshot updated to $latestSha" -ForegroundColor Green
                    $statusText = "UPDATED"
                    $shortCurrent = $shortRemote
                } finally {
                    if (Test-Path $tempClone) {
                        Remove-Item -Recurse -Force $tempClone -ErrorAction SilentlyContinue
                    }
                }
            } else {
                Write-Host "  Run with -Update to pull latest commits and refresh snapshot." -ForegroundColor DarkYellow
            }
        }

        $localMapping = if ($repoName -eq "dsh-super-agent") { 
            "autonomous-engineering, git-commit-helper" 
        } elseif ($repoName -eq "mattpocock-skills") { 
            "ask-lihong, check-frontmatter" 
        } elseif ($repoName -eq "agentara-skills") {
            "aigc, engineering, productivity, health"
        } else { 
            "custom" 
        }

        $SummaryResults += [PSCustomObject]@{
            "Upstream"      = $repoName
            "Branch"        = $branch
            "Tracked SHA"   = $shortCurrent
            "Remote SHA"    = $shortRemote
            "Status"        = $statusText
            "Local Mapping" = $localMapping
        }
    } catch {
        Write-Error "  Failed checking $repoName : $_"
    }
}

Write-Host "`n=== Upstream Tracking Comparison Table ===" -ForegroundColor Cyan
$SummaryResults | Format-Table -AutoSize

Write-Host "💡 Detailed asset diffs available in: skills\engineering\sync-upstream\MAPPING.md" -ForegroundColor DarkGray
