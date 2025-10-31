param(
  [string]$file = "..\..\config\feature_flags.json",
  [string]$bucket = "fm-cafe-config-bucket",
  [string]$key = "feature_flags.json"
)

# Resolve the provided file path
try {
    $full = Resolve-Path -Path $file -ErrorAction Stop
} catch {
    Write-Error "File not found: $file"
    exit 1
}

# Ensure LocalStack / bucket exists (create bucket if missing)
$bucketExists = & aws --endpoint-url=http://localhost:4566 s3 ls "s3://$bucket" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Bucket s3://$bucket not found - attempting to create it..."
    & aws --endpoint-url=http://localhost:4566 s3 mb "s3://$bucket"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to create bucket s3://$bucket. Is LocalStack running?"
        exit 2
    } else {
        Write-Host "Created bucket s3://$bucket"
    }
}

# Upload the file
Write-Host "Uploading $($full.Path) to s3://$bucket/$key ..."
& aws --endpoint-url=http://localhost:4566 s3 cp $full.Path "s3://$bucket/$key"
if ($LASTEXITCODE -eq 0) {
    Write-Host "Uploaded $($full.Path) to s3://$bucket/$key"
} else {
    Write-Error "Upload failed. Is LocalStack running and bucket available?"
    exit 3
}
