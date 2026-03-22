#!/usr/bin/env bash
set -euo pipefail

# Update these before running
BUCKET_NAME="${BUCKET_NAME:-ccaws-toy-<student-id>-static}"
AWS_REGION="${AWS_REGION:-us-east-1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
POLICY_FILE="${ROOT_DIR}/bucket-policy.json"

if [[ ! -d "${DIST_DIR}" ]]; then
  echo "dist directory not found. Run scripts/build.sh first."
  exit 1
fi

if [[ "${BUCKET_NAME}" == *"<student-id>"* ]]; then
  echo "BUCKET_NAME is still a placeholder. Set your unique bucket name first."
  echo "Example: BUCKET_NAME=ccaws-toy-20261234-static AWS_REGION=us-east-1 bash scripts/deploy-s3.sh"
  exit 1
fi

cat > "${POLICY_FILE}" <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPublicReadForStaticSite",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${BUCKET_NAME}/*"
    }
  ]
}
POLICY

# Ensure bucket exists (do not ignore create failures)
if aws s3api head-bucket --bucket "${BUCKET_NAME}" >/dev/null 2>&1; then
  echo "Bucket exists: ${BUCKET_NAME}"
else
  echo "Bucket not found. Attempting to create: ${BUCKET_NAME}"
  if [[ "${AWS_REGION}" == "us-east-1" ]]; then
    if ! aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${AWS_REGION}"; then
      echo "Failed to create bucket."
      echo "If your lab role does not allow s3:CreateBucket, use an existing allowed bucket and set BUCKET_NAME."
      exit 1
    fi
  else
    if ! aws s3api create-bucket \
      --bucket "${BUCKET_NAME}" \
      --region "${AWS_REGION}" \
      --create-bucket-configuration "LocationConstraint=${AWS_REGION}"; then
      echo "Failed to create bucket."
      echo "If your lab role does not allow s3:CreateBucket, use an existing allowed bucket and set BUCKET_NAME."
      exit 1
    fi
  fi
fi

# Required for public website policy in restricted lab accounts
if ! aws s3api put-public-access-block \
  --bucket "${BUCKET_NAME}" \
  --public-access-block-configuration \
BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false \
  --region "${AWS_REGION}" >/dev/null 2>&1; then
  echo "Failed to disable Public Access Block on bucket: ${BUCKET_NAME}"
  echo "Public website policy requires BlockPublicPolicy=false."
  echo "Check permission for s3:PutBucketPublicAccessBlock and retry."
  exit 1
fi

aws s3 website "s3://${BUCKET_NAME}/" \
  --index-document index.html \
  --error-document error.html
if ! aws s3api put-bucket-policy \
  --bucket "${BUCKET_NAME}" \
  --policy "file://${POLICY_FILE}"; then
  echo "Failed to apply bucket policy."
  echo "If error mentions BlockPublicPolicy, run put-public-access-block first."
  exit 1
fi

aws s3api put-bucket-versioning \
  --bucket "${BUCKET_NAME}" \
  --versioning-configuration Status=Enabled

aws s3 sync "${DIST_DIR}/" "s3://${BUCKET_NAME}/" --delete

echo "Deployment completed."
echo "Website endpoint: http://${BUCKET_NAME}.s3-website.${AWS_REGION}.amazonaws.com"
