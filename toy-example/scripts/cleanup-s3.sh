#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="${BUCKET_NAME:-ccaws-toy-<student-id>-static}"
AWS_REGION="${AWS_REGION:-us-east-1}"

if [[ "${BUCKET_NAME}" == *"<student-id>"* ]]; then
  echo "BUCKET_NAME is still a placeholder."
  echo "Example: BUCKET_NAME=ccaws-toy-20261234-123456 AWS_REGION=us-east-1 bash scripts/cleanup-s3.sh"
  exit 1
fi

echo "[INFO] Region: ${AWS_REGION}"
echo "[INFO] Bucket: ${BUCKET_NAME}"

if ! aws s3api head-bucket --bucket "${BUCKET_NAME}" --region "${AWS_REGION}" >/dev/null 2>&1; then
  echo "Bucket not found or no access. Nothing to clean."
  exit 0
fi

echo "Removing all objects/versions from bucket..."
aws s3 rm "s3://${BUCKET_NAME}" --recursive --region "${AWS_REGION}" || true

delete_versioned_items() {
  local item_type="$1"
  local deleted_any=0
  local rows=""

  rows="$(aws s3api list-object-versions \
    --bucket "${BUCKET_NAME}" \
    --region "${AWS_REGION}" \
    --query "${item_type}[].[Key,VersionId]" \
    --output text 2>/dev/null || true)"

  if [[ -z "${rows}" || "${rows}" == "None" ]]; then
    return 1
  fi

  while IFS=$'\t' read -r object_key version_id; do
    if [[ -z "${object_key}" || -z "${version_id}" || "${object_key}" == "None" || "${version_id}" == "None" ]]; then
      continue
    fi

    echo "Deleting ${item_type%?}: key=${object_key} version=${version_id}"
    aws s3api delete-object \
      --bucket "${BUCKET_NAME}" \
      --key "${object_key}" \
      --version-id "${version_id}" \
      --region "${AWS_REGION}" >/dev/null
    deleted_any=1
  done <<< "${rows}"

  [[ "${deleted_any}" -eq 1 ]]
}

while true; do
  removed_any=0

  if delete_versioned_items "Versions"; then
    removed_any=1
  fi

  if delete_versioned_items "DeleteMarkers"; then
    removed_any=1
  fi

  if [[ "${removed_any}" -eq 0 ]]; then
    break
  fi
done

# Attempt final bucket removal; if it fails, keep clear guidance for retry.
if aws s3api delete-bucket --bucket "${BUCKET_NAME}" --region "${AWS_REGION}"; then
  echo "Cleanup completed. Bucket deleted: ${BUCKET_NAME}"
else
  echo "Bucket delete did not complete."
  echo "Possible causes: versioned objects/delete markers still remain or dependency delay."
  echo "Retry command: BUCKET_NAME=${BUCKET_NAME} AWS_REGION=${AWS_REGION} bash scripts/cleanup-s3.sh"
  exit 1
fi
