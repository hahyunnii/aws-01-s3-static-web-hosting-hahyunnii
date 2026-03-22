#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="${BUCKET_NAME:-ccaws-toy-<student-id>-static}"
AWS_REGION="${AWS_REGION:-us-east-1}"

if [[ "${BUCKET_NAME}" == *"<student-id>"* ]]; then
  echo "BUCKET_NAME is still a placeholder."
  echo "Example: BUCKET_NAME=ccaws-toy-20261234-static AWS_REGION=us-east-1 bash scripts/verify-s3.sh"
  exit 1
fi

aws s3api get-bucket-website --bucket "${BUCKET_NAME}"
aws s3api get-bucket-policy --bucket "${BUCKET_NAME}"
aws s3api list-object-versions --bucket "${BUCKET_NAME}"
aws s3api get-public-access-block --bucket "${BUCKET_NAME}" --region "${AWS_REGION}"
