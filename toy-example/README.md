# Toy Example: Assignment 1 (S3 Static Website)

This toy example is the in-class practice version of Assignment 1.
Frontend code is intentionally minimal. Focus on cloud operations and CLI evidence.

## Included Files
- `src/` static frontend source
- `dist/` deploy artifact output
- `scripts/build.sh` build step (`src -> dist`)
- `scripts/deploy-s3.sh` bucket setup + website/policy/versioning + upload
- `scripts/verify-s3.sh` evidence verification
- `scripts/cleanup-s3.sh` cleanup helper (retry-friendly)
- `commands.md` submission log template

## Prerequisites
- AWS Academy Lab started (`Start Lab`)
- `aws sts get-caller-identity` returns your `voclabs` role
- Region is set (recommended: `us-east-1` for this toy example)

## Remote Node Credential Setup Example
If `aws sts get-caller-identity` fails on a remote node, clear old credentials and export fresh temporary credentials from the active AWS Academy or Learner Lab session.

```bash
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE

export AWS_ACCESS_KEY_ID="ASIAEXAMPLE123456789"
export AWS_SECRET_ACCESS_KEY="exampleSecretKeyValue1234567890example"
export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEExampleVeryLongSessionTokenValue"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_REGION="us-east-1"

env | rg '^AWS_'
aws configure list
aws sts get-caller-identity
```

Notes:
- replace the example values with the real temporary credentials from the lab portal
- do not omit `AWS_SESSION_TOKEN`
- run the exports in the same shell session where you will run the toy example commands

If you see `ExpiredToken`, your temporary credentials were valid but have expired.
Clear the old environment variables, confirm the lab is still active, copy fresh credentials from the lab portal, export them again, and rerun `aws sts get-caller-identity`.

## Quick Execution (Copy/Paste)
1. Move to the toy example directory
```bash
cd toy-example
```

2. Build
```bash
bash scripts/build.sh
```

3. Set runtime variables
```bash
export AWS_REGION="us-east-1"
export BUCKET_NAME="ccaws-toy-<your-student-id>-$(date +%s)"
```

4. Deploy
```bash
bash scripts/deploy-s3.sh
```

5. Verify
```bash
bash scripts/verify-s3.sh
```

6. Open website endpoint
```bash
echo "http://${BUCKET_NAME}.s3-website.${AWS_REGION}.amazonaws.com"
```

7. Optional cleanup
```bash
bash scripts/cleanup-s3.sh
```

## Expected Verification Results
- `get-bucket-website` returns `index.html` and `error.html`
- `get-bucket-policy` includes `s3:GetObject` public-read statement
- `list-object-versions` returns uploaded objects (`index.html`, `styles.css`, ...)
- `get-public-access-block` shows all 4 flags as `false` (for public website mode)

## Common Failure and Fix
1. `AccessDenied: s3:CreateBucket`
- Cause: role/policy restriction or region mismatch
- Fix: use allowed region (`us-east-1`) and re-run; if still denied, request instructor support

2. `AccessDenied: PutBucketPolicy ... BlockPublicPolicy`
- Cause: bucket public access block enabled
- Fix: `deploy-s3.sh` automatically tries to disable bucket-level block first

3. `BUCKET_NAME is still a placeholder`
- Cause: variable not set
- Fix: set `BUCKET_NAME` env var and retry

4. `BucketNotEmpty` during cleanup
- Cause: versioning is enabled, so old object versions or delete markers still remain in the bucket
- Fix: rerun `bash scripts/cleanup-s3.sh`; the cleanup script now removes remaining versions before deleting the bucket
- Manual fallback:
```bash
aws s3api list-object-versions --bucket "${BUCKET_NAME}" --region "${AWS_REGION}"
aws s3api delete-object --bucket "${BUCKET_NAME}" --key "<object-key>" --version-id "<version-id>" --region "${AWS_REGION}"
aws s3api delete-bucket --bucket "${BUCKET_NAME}" --region "${AWS_REGION}"
```

## Submission Note
- Fill `../commands.md` while running, or use `commands.md` in this directory as a scratch log during practice.
- Required evidence: command + key output + one-line interpretation.
