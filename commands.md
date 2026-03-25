# Assignment 1 Toy Example - Commands Log

## 0) Environment Check
```bash
aws sts get-caller-identity
aws configure get region
date
```
- Result summary:
```json
{
    "UserId": "AROA6IXGDBDW3VDSMGKJG:user4886845=_________",
    "Account": "980808829165",
    "Arn": "arn:aws:sts::980808829165:assumed-role/voclabs/user4886845=_________"
}
us-east-1
Tue 24 Mar 2026 07:56:23 PM PDT
```
- Interpretation: AWS Academy voclabs 역할로 정상 인증되었으며, 리전은 us-east-1로 설정되어 있음을 확인.

## 1) Project Directory
```bash
cd 01-s3-static-web-hosting-hahyunnii/toy-example
pwd
```
- Result summary:
```
/mnt/vocwork3/work/eee_W_5881126/asn5112690_1/asn5112691_1/work/01-s3-static-web-hosting-hahyunnii/toy-example
```
- Interpretation: GitHub에서 clone한 과제 레포 내 toy-example 디렉토리로 이동 완료. 이후 모든 스크립트는 이 디렉토리 기준으로 실행됨.

## 2) Build Artifact
```bash
bash scripts/build.sh
ls dist/
```
- Result summary:
```
Build completed: /mnt/vocwork3/work/eee_W_5881126/asn5112690_1/asn5112691_1/work/01-s3-static-web-hosting-hahyunnii/toy-example/dist
app.js  error.html  index.html  styles.css
```
- Interpretation: build.sh 스크립트가 src/ 디렉토리의 파일을 dist/ 디렉토리로 복사하여 배포 아티팩트 생성 완료. 4개 파일(app.js, error.html, index.html, styles.css) 확인.

## 3) Runtime Variables
```bash
export AWS_REGION="us-east-1"
export BUCKET_NAME="dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an"
echo "$AWS_REGION"
echo "$BUCKET_NAME"
```
- Result summary:
```
us-east-1
dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an
```
- Interpretation: 배포에 사용할 리전(us-east-1)과 버킷 이름을 환경변수로 설정. 이미 콘솔에서 생성된 버킷 이름을 그대로 사용.

## 4) Deploy
```bash
bash scripts/deploy-s3.sh
```
- Result summary:
```
Bucket exists: dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an
upload: dist/app.js to s3://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an/app.js
upload: dist/styles.css to s3://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an/styles.css
upload: dist/index.html to s3://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an/index.html
upload: dist/error.html to s3://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an/error.html
Deployment completed.
Website endpoint: http://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an.s3-website.us-east-1.amazonaws.com
```
- Interpretation: 퍼블릭 액세스 차단 해제, 정적 웹 호스팅 설정, 버킷 정책 적용, 버전 관리 활성화, 4개 파일 업로드가 순서대로 완료됨.
- Website endpoint: http://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an.s3-website.us-east-1.amazonaws.com

## 5) Verify (Required)
```bash
bash scripts/verify-s3.sh
```
- Result summary:
```json
// get-bucket-website
{
    "IndexDocument": { "Suffix": "index.html" },
    "ErrorDocument": { "Key": "error.html" }
}

// get-bucket-policy
{
    "Policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"AllowPublicReadForStaticSite\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an/*\"}]}"
}

// list-object-versions
{
    "Versions": [
        {
            "ETag": "\"ef06d03051d05e6436a59705605c7f82\"",
            "Size": 335,
            "StorageClass": "STANDARD",
            "Key": "app.js",
            "VersionId": "N8ZYVIP.wodR__fcGZn8W6C7vm7Paxcc",
            "IsLatest": true,
            "LastModified": "2026-03-25T02:20:31+00:00",
            "Owner": { "ID": "c9361eff1c96550f22059d2d734a97c3d2b94eead56bb7e550881b424a1bc581" }
        },
        {
            "ETag": "\"106266554da1daade0a382c880958fc4\"",
            "Size": 411,
            "StorageClass": "STANDARD",
            "Key": "error.html",
            "VersionId": "S0O9p9.kquKzPTvMCygemy026lavdLtB",
            "IsLatest": true,
            "LastModified": "2026-03-25T02:20:31+00:00",
            "Owner": { "ID": "c9361eff1c96550f22059d2d734a97c3d2b94eead56bb7e550881b424a1bc581" }
        },
        {
            "ETag": "\"73285c27222af8869e2df9c7f4ca665b\"",
            "Size": 427,
            "StorageClass": "STANDARD",
            "Key": "error.html",
            "VersionId": "null",
            "IsLatest": false,
            "LastModified": "2026-03-25T00:45:05+00:00",
            "Owner": { "ID": "c9361eff1c96550f22059d2d734a97c3d2b94eead56bb7e550881b424a1bc581" }
        },
        {
            "ETag": "\"e1294b74802946ec51fc890309901bbf\"",
            "Size": 942,
            "StorageClass": "STANDARD",
            "Key": "index.html",
            "VersionId": "wUuntM7orN7zEgPZYIC6uobMeWHLZoi9",
            "IsLatest": true,
            "LastModified": "2026-03-25T02:20:31+00:00",
            "Owner": { "ID": "c9361eff1c96550f22059d2d734a97c3d2b94eead56bb7e550881b424a1bc581" }
        },
        {
            "ETag": "\"f8b1c1f78e9ff06f66c33b54b19e7140\"",
            "Size": 979,
            "StorageClass": "STANDARD",
            "Key": "index.html",
            "VersionId": "null",
            "IsLatest": false,
            "LastModified": "2026-03-25T00:45:05+00:00",
            "Owner": { "ID": "c9361eff1c96550f22059d2d734a97c3d2b94eead56bb7e550881b424a1bc581" }
        },
        {
            "ETag": "\"ec2e6119329b55e7ffd3de21ae646ddb\"",
            "Size": 741,
            "StorageClass": "STANDARD",
            "Key": "styles.css",
            "VersionId": "kIjCVmE.xrwRZ3K2CwcwMAFg8aCV3OKz",
            "IsLatest": true,
            "LastModified": "2026-03-25T02:20:31+00:00",
            "Owner": { "ID": "c9361eff1c96550f22059d2d734a97c3d2b94eead56bb7e550881b424a1bc581" }
        },
        {
            "ETag": "\"116a742cac5ac1bf64a6bf77b80f3a63\"",
            "Size": 784,
            "StorageClass": "STANDARD",
            "Key": "styles.css",
            "VersionId": "null",
            "IsLatest": false,
            "LastModified": "2026-03-25T00:45:06+00:00",
            "Owner": { "ID": "c9361eff1c96550f22059d2d734a97c3d2b94eead56bb7e550881b424a1bc581" }
        }
    ]
}

// get-public-access-block
{
    "PublicAccessBlockConfiguration": {
        "BlockPublicAcls": false,
        "IgnorePublicAcls": false,
        "BlockPublicPolicy": false,
        "RestrictPublicBuckets": false
    }
}
```
- Interpretation: 4가지 필수 검증 항목 모두 정상 확인. 웹 호스팅 설정(index.html/error.html 지정), 공개 읽기 정책(s3:GetObject), 4개 파일의 버전 목록(최신 버전 + 이전 버전 포함), 퍼블릭 액세스 차단 해제(모두 false) 상태 확인됨.

## 6) Browser Check
```bash
echo "http://${BUCKET_NAME}.s3-website.${AWS_REGION}.amazonaws.com"
```
- Endpoint URL: http://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an.s3-website.us-east-1.amazonaws.com
- Test time (KST): 2026-03-25 11:21 KST
- Page visible: Yes
- Screenshot captured: Yes

## 7) Failure and Recovery Record

### Case 1: Public Access Block / Policy Issue
- Symptom: deploy-s3.sh 실행 중 버킷 정책 적용(put-bucket-policy) 단계에서 AccessDenied 오류 발생
- Failed command:
```bash
aws s3api put-bucket-policy \
  --bucket dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an \
  --policy file://bucket-policy.json
```
- Error message:
```
An error occurred (AccessDenied) when calling the PutBucketPolicy operation:
User: arn:aws:sts::980808829165:assumed-role/voclabs/user4886845=이하현 is not authorized
to perform: s3:PutBucketPolicy on resource because public policies are blocked by the
BlockPublicPolicy block to this bucket
```
- Root cause: 버킷 생성 직후 기본값으로 BlockPublicPolicy=true가 설정되어 있어, 공개 접근을 허용하는 버킷 정책 적용 동작 자체가 차단됨.
- Fix command:
```bash
aws s3api put-public-access-block \
  --bucket dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an \
  --public-access-block-configuration \
  BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
```
- Verification command:
```bash
aws s3api get-public-access-block \
  --bucket dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an
```
```json
{
    "PublicAccessBlockConfiguration": {
        "BlockPublicAcls": false,
        "IgnorePublicAcls": false,
        "BlockPublicPolicy": false,
        "RestrictPublicBuckets": false
    }
}
```
- Final status: 퍼블릭 액세스 차단 해제 후 deploy-s3.sh 재실행하여 정책 적용 및 전체 배포 완료.

## 8) Optional Cleanup
```bash
bash scripts/cleanup-s3.sh
```
- Result summary:
```
[INFO] Region: us-east-1
[INFO] Bucket: dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an
Removing all objects/versions from bucket...
delete: s3://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an/app.js
delete: s3://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an/error.html
delete: s3://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an/index.html
delete: s3://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an/styles.css
Cleanup completed. Bucket deleted: dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an
```
- Interpretation: 버전 관리 활성화로 인해 모든 객체 버전과 삭제 마커를 순차적으로 제거한 후 버킷 삭제 완료.

## Final Checklist
- [x] Website endpoint is reachable
- [x] Website config evidence recorded
- [x] Bucket policy evidence recorded
- [x] Object version evidence recorded
- [x] Public access block state recorded
- [x] At least one failure/recovery case documented