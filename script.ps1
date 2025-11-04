# Enable strict mode for safety
Set-StrictMode -Version Latest

# === Change this path to your notes folder ===
$notesPath = "C:\Users\HP\OneDrive\Documents\INTERVIEW PREPARATION\APTITUDE"

# Ensure the directory actually exists
if (-not (Test-Path $notesPath)) {
    Write-Host "❌ Folder path not found: $notesPath"
    Pause
    exit
}

# Change to the notes directory
Set-Location -Path $notesPath

# === Ensure commit_log.txt exists ===
$logPath = Join-Path $notesPath "commit_log.txt"
if (-not (Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType File -Force | Out-Null
}

# === Check if it's a Git repo ===
if (-not (Test-Path ".git")) {
    Write-Host "Not a git repository. Initializing..."
    git init | Out-Null
    git branch -M main | Out-Null
    Write-Host "Git repo initialized. Remember to connect remote manually."
    Pause
    exit
}

# === Stage all changes ===
git add -A

# === Check if there are staged changes ===
$changes = git diff --cached --numstat | Measure-Object | Select-Object -ExpandProperty Count

if ($changes -eq 0) {
    Write-Host "No changes to commit today."
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] No changes"
    Pause
    exit
}

# === Commit with today's date ===
$today = Get-Date -Format "dd-MM-yyyy"
git commit -m "Daily notes update $today"

# === Push to GitHub ===
try {
    git push origin main
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Notes committed for $today"
    Write-Host "✅ Notes committed and pushed for $today."
} catch {
    Write-Host "❌ Push failed. Check your remote connection or internet."
}

Pause
