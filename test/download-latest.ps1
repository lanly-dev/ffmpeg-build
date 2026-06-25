# Download latest FFmpeg build for Windows
param(
    [string]$Repo = "lanly-dev/ffmpeg-build"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$testDir = $PSScriptRoot

Write-Host "Fetching latest release from $Repo..."
$releases = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest"
$tag = $releases.tag_name
Write-Host "Latest release: $tag"

# Determine OS (this script is primarily for Windows)
$osSuffix = "windows"
$assetPattern = "*windows*"

# Find matching assets (ffmpeg and ffprobe)
$assets = $releases.assets | Where-Object { $_.name -match "^(ffmpeg|ffprobe)-$osSuffix\.exe$" }

if (-not $assets) {
    Write-Error "No matching Windows assets found in release $tag"
    exit 1
}

foreach ($asset in $assets) {
    $destPath = Join-Path -Path $testDir -ChildPath $asset.name
    Write-Host "Downloading $($asset.name) -> $destPath"
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $destPath
    Write-Host "Saved to $destPath"
}

Write-Host "Done. Files in test directory:"
Get-ChildItem -Path $testDir | Select-Object Name, @{N="Size(MB)";E={[math]::Round($_.Length/1MB,2)}} | Format-Table -AutoSize