# Assignment 1 Report: S3 Static Website Hosting

## 1) Student Info
- Name: 이하현
- Student ID: 32213651
- Date (KST): 2026-03-25
- AWS Account ID: 980808829165
- AWS Region: us-east-1

## 2) Objective and Scope
- Objective: AWS S3를 이용하여 정적 웹사이트를 구축하고, CLI 명령어로 모든 설정을 검증하며, 재현 가능한 배포 증거를 제출한다.
- Scope (what was implemented):
  - S3 버킷 생성 및 정적 웹 호스팅 활성화
  - 최소 권한 버킷 정책(s3:GetObject) 적용
  - 퍼블릭 액세스 차단 해제 (웹 호스팅 모드)
  - 버전 관리(Versioning) 활성화
  - 정적 파일(index.html, error.html, styles.css, app.js) 업로드
  - CLI 명령어 4종으로 설정 검증
- Out of scope: 커스텀 도메인 연결, HTTPS/CloudFront 설정, 서버사이드 로직

## 3) Architecture Summary
- Bucket name: dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an
- Endpoint URL: http://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an.s3-website.us-east-1.amazonaws.com
- Static files deployed: index.html, error.html, styles.css, app.js
- Access model (public website read policy): 버킷 정책으로 모든 사용자(Principal: "*")에게 s3:GetObject 허용. ACL은 사용하지 않으며 정책 기반 최소 권한 접근 적용.

## 4) Implementation Steps (What and Why)

1. **Bucket creation/check**
   - Command evidence reference: commands.md § 4) Deploy
   - Why this step is required: S3 정적 웹 호스팅의 저장소 역할을 하는 버킷이 존재해야 이후 모든 설정 적용이 가능하다. 본 실습에서는 AWS 콘솔에서 미리 생성된 버킷(dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an)을 사용하였으며, deploy-s3.sh 실행 시 "Bucket exists" 메시지로 존재가 확인되었다.

2. **Static website configuration (index.html, error.html)**
   - Command evidence reference: commands.md § 5) Verify — get-bucket-website 결과
   - Why this step is required: S3 버킷의 기본 모드는 객체 저장소이므로 웹 호스팅 기능을 별도로 활성화해야 HTTP 엔드포인트가 생성된다. index.html은 루트 요청 시 반환할 기본 문서, error.html은 존재하지 않는 경로 접근 시 반환할 오류 문서를 지정한다.

3. **Public access block configuration**
   - Command evidence reference: commands.md § 5) Verify — get-public-access-block 결과 / § 7) 장애 및 복구
   - Why this step is required for website mode: S3는 기본적으로 퍼블릭 액세스를 모두 차단한다. 정적 웹사이트는 불특정 다수가 HTTP로 접근해야 하므로 BlockPublicPolicy와 RestrictPublicBuckets를 false로 설정하여 공개 정책 적용을 허용해야 한다.

4. **Bucket policy application (s3:GetObject)**
   - Command evidence reference: commands.md § 5) Verify — get-bucket-policy 결과
   - Policy scope justification (least privilege): Action을 s3:GetObject 하나로 한정하고 Resource를 버킷 내 모든 객체(/*) 범위로 제한함으로써 최소 권한 원칙을 준수하였다. 쓰기·삭제 권한(s3:PutObject, s3:DeleteObject 등)은 허용하지 않아 외부 사용자의 데이터 변조 위험을 차단한다.

5. **Versioning enablement**
   - Command evidence reference: commands.md § 5) Verify — list-object-versions 결과
   - Why this step is required: 버전 관리를 활성화하면 동일 키로 객체를 재업로드할 때 이전 버전이 보존된다. 실제로 list-object-versions 결과에서 error.html, index.html, styles.css 각각에 이전 버전(VersionId: null)과 최신 버전이 함께 확인되어 버전 관리가 정상 동작함을 검증하였다.

6. **Upload/sync**
   - Command evidence reference: commands.md § 4) Deploy — aws s3 sync 결과 / § 5) Verify — list-object-versions
   - Validation summary: dist/ 디렉토리의 4개 파일(app.js, error.html, index.html, styles.css)이 S3 버킷에 정상 업로드되었으며, list-object-versions로 각 파일의 VersionId와 ETag가 확인됨.

## 5) Validation Results
- Website reachable: Yes
- Website config verified: Yes
- Policy verified: Yes
- Versioning/object versions verified: Yes
- Public access block state recorded: Yes

## 6) Failure and Recovery

- Symptom: deploy-s3.sh 실행 중 버킷 정책 적용(put-bucket-policy) 단계에서 AccessDenied 오류 발생으로 배포 중단
- Error message:
  ```
  An error occurred (AccessDenied) when calling the PutBucketPolicy operation:
  User: arn:aws:sts::980808829165:assumed-role/voclabs/user4886845=이하현 is not authorized
  to perform: s3:PutBucketPolicy on resource because public policies are blocked by the
  BlockPublicPolicy block to this bucket
  ```
- Root cause: S3 버킷 생성 직후 기본값으로 BlockPublicPolicy=true가 설정되어 있어, 공개 접근을 허용하는 버킷 정책 자체를 적용하는 동작이 차단됨. 버킷 정책 내용이 아니라 퍼블릭 정책 적용 동작 자체가 거부된 것이 원인.
- Fix: `aws s3api put-public-access-block` 명령으로 4개 차단 플래그를 모두 false로 설정하여 퍼블릭 액세스 차단 해제 후 정책 재적용
- Re-verification: `aws s3api get-public-access-block` 명령으로 4개 플래그가 모두 false임을 확인 후 deploy-s3.sh 재실행 성공

## 7) Reproducibility Checklist
- [x] `commands.md` includes command + key output + interpretation
- [x] Endpoint is tested from browser
- [x] Evidence is aligned with rubric items
- [x] Final resources/state are documented