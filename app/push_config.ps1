param(
  [string]$file = "..\..\config\feature_flags.json",
  [string]$bucket = "fm-cafe-config-bucket",
  [string]$key = "feature_flags.json"
)

# Resolve the full path
$full = Resolve-Path $file

# Upload to S3 via LocalStack
aws --endpoint-url=http://localhost:4566 s3 cp $full.Path "s3://$bucket/$key"

if ($LASTEXITCODE -eq 0) {
  Write-Host "✅ Uploaded $full to s3://$bucket/$key"
} else {
  Write-Error "❌ Upload failed. Is LocalStack running and bucket available?"
}
