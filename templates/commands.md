# commands.md (Execution Log)

## 0) Environment and Preflight
```bash
aws sts get-caller-identity
aws configure get region
date
```
- Key output:
- Interpretation:

## 1) Build Artifact
```bash
bash scripts/build.sh
ls -la dist
```
- Key output:
- Interpretation:

## 2) Runtime Variables
```bash
export AWS_REGION="us-east-1"
export BUCKET_NAME="ccaws-a1-<student-id>-$(date +%s)"
echo "$AWS_REGION"
echo "$BUCKET_NAME"
```
- Key output:
- Interpretation:

## 3) Deploy
```bash
bash scripts/deploy-s3.sh
```
- Key output:
- Interpretation:

## 4) Verify
```bash
bash scripts/verify-s3.sh
```
- Key output:
- Interpretation:

## 5) Browser Test
- Endpoint URL:
- Test timestamp (KST):
- Result:

## 6) Failure and Recovery
- Symptom:
- Failed command:
```bash
# paste command
```
- Error message:
- Root cause:
- Fix command:
```bash
# paste command
```
- Verification command:
```bash
# paste command
```
- Final status:
