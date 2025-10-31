// app/readFeatureFlags.js
const AWS = require('aws-sdk');
const fs = require('fs');
const path = require('path');

const LOCAL_FALLBACK = path.join(__dirname, '..', 'config', 'feature_flags.json');
const S3_BUCKET = process.env.CONFIG_S3_BUCKET || 'fm-cafe-config-bucket';
const S3_KEY = process.env.CONFIG_S3_KEY || 'feature_flags.json';
const LOCALSTACK_URL = process.env.LOCALSTACK_URL || 'http://localhost:4566';

const s3 = new AWS.S3({
  endpoint: LOCALSTACK_URL,
  s3ForcePathStyle: true,
  accessKeyId: 'test',
  secretAccessKey: 'test',
  region: 'us-east-1'
});

async function loadFromS3(){
  try {
    const res = await s3.getObject({ Bucket: S3_BUCKET, Key: S3_KEY }).promise();
    return JSON.parse(res.Body.toString('utf-8'));
  } catch (err) {
    console.warn('S3 config load failed', err.message);
    return null;
  }
}

function loadLocal(){
  try {
    return JSON.parse(fs.readFileSync(LOCAL_FALLBACK,'utf8'));
  } catch (e) {
    console.error('Local config load failed', e.message);
    return {};
  }
}

module.exports = async function getFeatureFlags(){
  const s3flags = await loadFromS3();
  if (s3flags) return s3flags;
  return loadLocal();
};
