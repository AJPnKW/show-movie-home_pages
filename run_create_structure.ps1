param(
    # Use the folder this PS1 lives in as the repo root by default
    [string]$RepoRoot = $(if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path })
)

# --- Ensure logs dir ---
$logsDir = Join-Path $RepoRoot "logs"
if (-not (Test-Path -LiteralPath $logsDir)) { New-Item -ItemType Directory -Path $logsDir | Out-Null }

# --- Timestamped log file ---
$stamp   = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = Join-Path $logsDir ("run_create_structure_{0}.log" -f $stamp)

Write-Host "==============================================================="
Write-Host "Launcher     : run_create_structure.ps1"
Write-Host "RepoRoot     : $RepoRoot"
Write-Host "LogFile      : $logFile"
Write-Host "Start Time   : $(Get-Date)"
Write-Host "==============================================================="

# --- Main script path (beside this PS1/BAT) ---
$mainScript = Join-Path $RepoRoot "create_show_pages_structure.ps1"

if (-not (Test-Path -LiteralPath $mainScript)) {
    $msg = "ERROR: Main script not found at: $mainScript"
    $msg | Tee-Object -FilePath $logFile -Append | Out-Null
    Write-Host $msg
} else {
    # Run the main script; log EVERYTHING (stdout + stderr) to console + file
    & $mainScript -RepoRoot $RepoRoot -ForceFiles:$false -VerboseLog:$true 2>&1 `
        | Tee-Object -FilePath $logFile -Append
}

Write-Host "---------------------------------------------------------------"
Write-Host "Finished. Log saved to:"
Write-Host "  $logFile"
Write-Host "End Time     : $(Get-Date)"
Write-Host "---------------------------------------------------------------"

# Keep window open until user presses Enter (in case cmd /k is bypassed)
[void](Read-Host "Press Enter to close")
