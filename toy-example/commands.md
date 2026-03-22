# Assignment 1 Toy Example - Commands Log Template

## 0) Environment Check
```bash
aws sts get-caller-identity
aws configure get region
date
```
- Result summary:
- Interpretation:

## 1) Project Directory
```bash
cd toy-example
pwd
```
- Result summary:
- Interpretation:

## 2) Build Artifact
```bash
bash scripts/build.sh
ls -la dist
```
- Result summary:
- Interpretation:

## 3) Runtime Variables
```bash
export AWS_REGION="us-east-1"
export BUCKET_NAME="ccaws-toy-<your-student-id>-$(date +%s)"
echo "$AWS_REGION"
echo "$BUCKET_NAME"
```
- Result summary:
- Interpretation:

## 4) Deploy
```bash
bash scripts/deploy-s3.sh
```
- Result summary:
- Interpretation:
- Website endpoint:

## 5) Verify (Required)
```bash
bash scripts/verify-s3.sh
```
- Result summary:
- Interpretation:

## 6) Browser Check
```bash
echo "http://${BUCKET_NAME}.s3-website.${AWS_REGION}.amazonaws.com"
```
- Endpoint URL:
- Test time (KST):
- Page visible: Yes / No
- Screenshot captured: Yes / No

## 7) Failure and Recovery Record (At least 1)
### Case 1: Public Access Block / Policy Issue
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

## 8) Optional Cleanup
```bash
bash scripts/cleanup-s3.sh
```
- Result summary:
- Interpretation:

## Final Checklist
- [ ] Website endpoint is reachable
- [ ] Website config evidence recorded
- [ ] Bucket policy evidence recorded
- [ ] Object version evidence recorded
- [ ] Public access block state recorded
- [ ] At least one failure/recovery case documented
