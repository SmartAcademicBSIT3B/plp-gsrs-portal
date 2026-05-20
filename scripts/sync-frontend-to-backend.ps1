param(
    [string]$Source = "frontend",
    [string]$Target = "backend/frontend"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Source)) {
    throw "Source folder '$Source' does not exist."
}

if (Test-Path $Target) {
    Remove-Item -Recurse -Force $Target
}

New-Item -ItemType Directory -Path $Target | Out-Null
Copy-Item -Recurse -Force "$Source\*" "$Target\"

Write-Host "Synced '$Source' -> '$Target'"
