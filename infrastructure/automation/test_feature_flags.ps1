<#
.SYNOPSIS
  Automates live feature flag testing for FM Café Cloud Migration.

.DESCRIPTION
  1. Toggles "enable_new_checkout" in config/feature_flags.json.
  2. Uploads updated config to LocalStack S3.
  3. Waits for app to reload config.
  4. Fetches /flags and / endpoints to verify changes.
  5. Saves responses and timestamps to docs/flag_test_output/.
#>

param(
  [string]$appUrl = "http://localhost:8080",
  [string]$bucket = "fm-cafe-config-bucket",
  [int]$wait = 30
)

# --- Step 0: Setup paths ---
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configFile = Join-Path $baseDir "..\..\config\feature_flags.json"
$outputDir = Join-Path $baseDir "..\..\docs\flag_test_output"

if (-not (Test-Path $configFile)) {
    Write-Error "Config file not found: $configFile"
    exit 1
}

New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

# --- Step 1: Toggle flag ---
Write-Host "`n[INFO] Reading current config..."
$json = Get-Content $configFile -Raw | ConvertFrom-Json
$newValue = -not $json.enable_new_checkout
$json.enable_new_checkout = $newValue
$json | ConvertTo-Json -Depth 5 | Out-File -FilePath $configFile -Encoding utf8
Write-Host "[INFO] Updated enable_new_checkout -> $newValue"

# --- Step 2: Upload to LocalStack S3 ---
Write-Host "[INFO] Uploading to LocalStack S3..."
aws --endpoint-url=http://localhost:4566 s3 cp $configFile "s3://$bucket/feature_flags.json"
if ($LASTEXITCODE -ne 0) {
    Write-Error "[ERROR] Upload failed. Is LocalStack running and bucket available?"
    exit 2
}

# --- Step 3: Wait for app reload ---
Write-Host "[INFO] Waiting $wait seconds for app to reload config..."
Start-Sleep -Seconds $wait

# --- Step 4: Fetch app endpoints ---
$timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
$flagsFile = Join-Path $outputDir "flags-$timestamp.json"
$indexFile = Join-Path $outputDir "index-$timestamp.html"

Write-Host "[INFO] Fetching app responses from $appUrl..."
try {
    Invoke-WebRequest "$appUrl/flags" -OutFile $flagsFile -ErrorAction Stop
    Invoke-WebRequest "$appUrl" -OutFile $indexFile -ErrorAction Stop
    Write-Host "[OK] Responses saved in $outputDir"
}
catch {
    Write-Error "[ERROR] Failed to fetch from $appUrl — is the app running?"
    exit 3
}

# --- Step 5: Display summary ---
Write-Host "`n===== TEST SUMMARY ====="
Write-Host "Flag toggled to: $newValue"
Write-Host "Output saved to: $outputDir"
Write-Host "========================="

# Optional: Preview flag file contents
if (Test-Path $flagsFile) {
    Write-Host "`nFlag response preview:"
    Get-Content $flagsFile
}

Write-Host "`n[INFO] Test completed successfully!"
