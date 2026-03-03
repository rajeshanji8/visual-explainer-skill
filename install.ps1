<#
.SYNOPSIS
    Installs the visual-explainer skill for AI coding agents.

.DESCRIPTION
    Copies the visual-explainer skill into agent-specific directories.
    Supports: Claude Code, Codex, Gemini CLI, Cursor, GitHub Copilot.

.PARAMETER ProjectPath
    Target project directory. Defaults to current directory.

.PARAMETER User
    Install at user level (~/.claude, ~/.codex, etc.) instead of project level.

.PARAMETER Agent
    Install for specific agent(s). Accepts: claude, codex, gemini, cursor, copilot, all.
    Can be specified multiple times. Default: all.

.PARAMETER WithInstructions
    (Copilot only) Append to copilot-instructions.md and add path-specific .instructions.md files.

.PARAMETER Uninstall
    Remove the installed skill from agent directories.

.EXAMPLE
    .\install.ps1 C:\projects\my-app
    .\install.ps1 -WithInstructions C:\projects\my-app
    .\install.ps1 -Agent claude C:\projects\my-app
    .\install.ps1 -User
    .\install.ps1 -Uninstall C:\projects\my-app
#>

param(
    [Parameter(Position = 0)]
    [string]$ProjectPath = ".",

    [switch]$User,

    [string[]]$Agent,

    [switch]$WithInstructions,

    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$GithubRepo = "https://github.com/rajeshanji8/visual-explainer-skill.git"
$AllAgents = @("claude", "codex", "gemini", "cursor", "copilot")
$CleanupTemp = $false
$TempDir = $null

$MarkerStart = "<!-- visual-explainer-skill:start -->"
$MarkerEnd = "<!-- visual-explainer-skill:end -->"

# --------------- RESOLVE SOURCE ---------------
$ScriptDir = if ($MyInvocation.MyCommand.Path) {
    Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    $null
}

$SourceSkillsDir = if ($ScriptDir -and (Test-Path (Join-Path $ScriptDir "skills"))) {
    Join-Path $ScriptDir "skills"
} else {
    # No local skills/ found — clone from GitHub
    Write-Host "No local skills/ directory found. Downloading from GitHub..." -ForegroundColor Yellow
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "Error: git is required for remote install. Install git or clone the repo manually." -ForegroundColor Red
        exit 1
    }
    $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("ve-skill-" + [guid]::NewGuid().ToString("N").Substring(0, 8))
    git clone --depth 1 $GithubRepo $TempDir 2>$null
    $CleanupTemp = $true
    $candidate = Join-Path $TempDir "skills"
    if (-not (Test-Path $candidate)) {
        Write-Host "Error: Could not find skills/ in cloned repo." -ForegroundColor Red
        exit 1
    }
    $candidate
}

try {

# --------------- RESOLVE AGENTS ---------------
$SelectedAgents = if ($Agent -and $Agent.Count -gt 0) {
    if ($Agent -contains "all") { $AllAgents } else { $Agent }
} else {
    $AllAgents
}

# --------------- RESOLVE PROJECT PATH ---------------
if (-not $User) {
    $ProjectPath = Resolve-Path $ProjectPath -ErrorAction Stop
}

$InstallLevel = if ($User) { "user" } else { "project" }

# --------------- MAIN ---------------
Write-Host ""
Write-Host "Visual Explainer Skill Installer" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Source:  $ScriptDir"
Write-Host "Level:  $InstallLevel"
if (-not $User) {
    Write-Host "Project: $ProjectPath"
}
Write-Host "Agents: $($SelectedAgents -join ', ')"
Write-Host ""

foreach ($ag in $SelectedAgents) {
    # copilot uses .github directory; others use .<agent>
    $dirName = if ($ag -eq "copilot") { ".github" } else { ".$ag" }

    if ($User) {
        $agentDir = Join-Path $env:USERPROFILE $dirName
    } else {
        $agentDir = Join-Path $ProjectPath $dirName
    }

    $skillsDir = Join-Path $agentDir "skills"
    $targetDir = Join-Path $skillsDir "visual-explainer"

    if ($Uninstall) {
        if (Test-Path $targetDir) {
            Remove-Item $targetDir -Recurse -Force
            Write-Host "  Removed visual-explainer skill for $ag from $skillsDir" -ForegroundColor Green
        } else {
            Write-Host "  No visual-explainer skill found for $ag at $skillsDir" -ForegroundColor Yellow
        }
        # Clean up Copilot instruction snippets/files added by -WithInstructions
        if ($ag -eq "copilot") {
            # Remove marker block from copilot-instructions.md
            $copilotInstr = Join-Path $agentDir "copilot-instructions.md"
            if ((Test-Path $copilotInstr) -and (Select-String -Path $copilotInstr -Pattern $MarkerStart -Quiet)) {
                $content = Get-Content $copilotInstr -Raw
                $pattern = "(?s)$([regex]::Escape($MarkerStart)).*?$([regex]::Escape($MarkerEnd))\r?\n?"
                $content = [regex]::Replace($content, $pattern, "")
                if ([string]::IsNullOrWhiteSpace($content)) {
                    Remove-Item $copilotInstr -Force
                    Write-Host "  Removed copilot-instructions.md (was empty after cleanup)" -ForegroundColor Green
                } else {
                    Set-Content -Path $copilotInstr -Value $content.TrimEnd() -NoNewline
                    Write-Host "  Removed visual-explainer snippet from copilot-instructions.md" -ForegroundColor Green
                }
            }
            # Remove path-specific instruction files (only ours)
            $instrDir = Join-Path $agentDir "instructions"
            foreach ($fname in @("mermaid-diagrams.instructions.md")) {
                $instrFile = Join-Path $instrDir $fname
                if (Test-Path $instrFile) {
                    Remove-Item $instrFile -Force
                    Write-Host "  Removed $fname" -ForegroundColor Green
                }
            }
        }
    } else {
        Write-Host "  Installing for $ag at $InstallLevel level..."
        if (-not (Test-Path $skillsDir)) {
            New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
        }
        if (Test-Path $targetDir) {
            Remove-Item $targetDir -Recurse -Force
        }
        Copy-Item (Join-Path $SourceSkillsDir "visual-explainer") $targetDir -Recurse
        Write-Host "  Installed visual-explainer skill for $ag into $targetDir" -ForegroundColor Green

        # -WithInstructions: append snippet + copy path-specific files (Copilot only)
        if ($ag -eq "copilot" -and $WithInstructions) {
            $templatesDir = Join-Path $ScriptDir "templates"
            if (Test-Path $templatesDir) {
                # Append snippet to copilot-instructions.md (idempotent)
                $copilotInstr = Join-Path $agentDir "copilot-instructions.md"
                $snippetFile = Join-Path $templatesDir "copilot-instructions-snippet.md"
                if (Test-Path $snippetFile) {
                    if ((Test-Path $copilotInstr) -and (Select-String -Path $copilotInstr -Pattern $MarkerStart -Quiet)) {
                        Write-Host "  Visual Explainer snippet already present in copilot-instructions.md, skipping" -ForegroundColor Yellow
                    } else {
                        $snippet = Get-Content $snippetFile -Raw
                        $block = "`n$MarkerStart`n$snippet`n$MarkerEnd`n"
                        Add-Content -Path $copilotInstr -Value $block
                        Write-Host "  Appended visual-explainer snippet to copilot-instructions.md" -ForegroundColor Green
                    }
                }

                # Copy path-specific .instructions.md files (skip if they already exist)
                $instrSourceDir = Join-Path $templatesDir "instructions"
                if (Test-Path $instrSourceDir) {
                    $instrTargetDir = Join-Path $agentDir "instructions"
                    if (-not (Test-Path $instrTargetDir)) {
                        New-Item -ItemType Directory -Path $instrTargetDir -Force | Out-Null
                    }
                    Get-ChildItem $instrSourceDir -Filter "*.instructions.md" | ForEach-Object {
                        $targetFile = Join-Path $instrTargetDir $_.Name
                        if (-not (Test-Path $targetFile)) {
                            Copy-Item $_.FullName $targetFile
                            Write-Host "  Installed $($_.Name) into $instrTargetDir" -ForegroundColor Green
                        } else {
                            Write-Host "  Skipped $($_.Name) (already exists)" -ForegroundColor Yellow
                        }
                    }
                }
            } else {
                Write-Host "  templates/ directory not found — skipping instruction files" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green

if (-not $Uninstall) {
    Write-Host ""
    Write-Host "Installed structure:"
    Write-Host "  .<agent>/skills/visual-explainer/"
    Write-Host "  ├── SKILL.md              # Entry point (agent reads this first)"
    Write-Host "  ├── references/           # Detailed guides (read on demand)"
    Write-Host "  ├── prompts/              # Slash-command workflows"
    Write-Host "  └── templates/            # Mermaid/PlantUML starter templates"
    if ($WithInstructions -and ($SelectedAgents -contains "copilot")) {
        Write-Host ""
        Write-Host "Copilot extras (via -WithInstructions):"
        Write-Host "  .github/copilot-instructions.md          # Appended visual-explainer snippet"
        Write-Host "  .github/instructions/                     # Path-specific rules"
        Write-Host "  └── mermaid-diagrams.instructions.md      # Fires on *.mermaid, *.mmd files"
    } elseif ($SelectedAgents -contains "copilot") {
        Write-Host ""
        Write-Host "Tip: For extra Copilot compliance, re-run with -WithInstructions"
        Write-Host "     to add always-on rules and path-specific instruction files."
    }
}

} finally {
    if ($CleanupTemp -and $TempDir -and (Test-Path $TempDir)) {
        Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
