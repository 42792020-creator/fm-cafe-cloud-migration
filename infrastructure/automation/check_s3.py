import boto3
from botocore.exceptions import ClientError

endpoint = "http://localhost:4566"
bucket = "fm-cafe-config-bucket"
key = "feature_flags.json"

s3 = boto3.client("s3", endpoint_url=endpoint, aws_access_key_id="test", aws_secret_access_key="test")

try:
    obj = s3.get_object(Bucket=bucket, Key=key)
    text = obj["Body"].read().decode("utf-8")
    print("✅ File found in S3:\n", text)
except ClientError as e:
    print("❌ Error:", e)
