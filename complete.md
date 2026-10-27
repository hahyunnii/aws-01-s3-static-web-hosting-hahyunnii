# Assignment 1 Complete: S3 Static Website Hosting

## Student Info
- Name: 이하현
- Student ID: 32213651
- Date (KST): 2026-03-25

---

## Website Endpoint URL

http://dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an.s3-website.us-east-1.amazonaws.com

---

## report.md 요약

| 항목 | 내용 |
|---|---|
| AWS Account ID | 980808829165 |
| AWS Region | us-east-1 |
| 버킷 이름 | dku-cloudcomputing-2026-s3-bucket-hh-980808829165-us-east-1-an |
| 배포 파일 | index.html, error.html, styles.css, app.js |
| 접근 모델 | 버킷 정책 기반 s3:GetObject 공개 읽기 허용 (최소 권한) |
| 장애 및 복구 | BlockPublicPolicy=true로 인한 PutBucketPolicy AccessDenied → 퍼블릭 액세스 차단 해제 후 재적용 |

---

## commands.md 요약

| 단계 | 명령어 | 결과 |
|---|---|---|
| 0) 환경 확인 | `aws sts get-caller-identity` | voclabs 역할 인증 확인 |
| 1) 디렉토리 이동 | `cd toy-example && pwd` | 작업 경로 확인 |
| 2) 빌드 | `bash scripts/build.sh` | dist/ 에 4개 파일 생성 |
| 3) 환경변수 설정 | `export BUCKET_NAME=...` | 버킷 이름 및 리전 설정 |
| 4) 배포 | `bash scripts/deploy-s3.sh` | 4개 파일 S3 업로드 완료 |
| 5) 검증 | `aws s3api get-bucket-website` 외 3개 | 4개 항목 모두 정상 확인 |
| 6) 브라우저 확인 | 엔드포인트 URL 접속 | 웹사이트 정상 표시 확인 |

---

## 전체 과제 완료 확인 체크리스트

### 기능 완성도
- [x] S3 버킷 생성 완료
- [x] 정적 웹 호스팅 활성화 (index.html / error.html 지정)
- [x] 정적 파일 4개 업로드 완료 (index.html, error.html, styles.css, app.js)
- [x] 웹사이트 엔드포인트 브라우저 접속 확인

### 보안 및 정책
- [x] 퍼블릭 액세스 차단 해제 (4개 플래그 모두 false)
- [x] 버킷 정책 적용 (s3:GetObject, 최소 권한 원칙 준수)
- [x] 버전 관리(Versioning) 활성화

### CLI 재현 가능성
- [x] get-bucket-website 출력 기록
- [x] get-bucket-policy 출력 기록
- [x] list-object-versions 출력 기록
- [x] get-public-access-block 출력 기록
- [x] 각 명령어에 해석(Interpretation) 작성

### 장애 및 복구
- [x] 장애 증상 기록
- [x] 오류 메시지 기록
- [x] 원인 분석 기록
- [x] 복구 명령어 기록
- [x] 재검증 결과 기록

### 제출 파일
- [x] report.md 작성 완료
- [x] commands.md 작성 완료
- [x] complete.md 작성 완료