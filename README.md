[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/fzFcH8eD)
# S3 Static Web Hosting Template

This repository is the starter template for Assignment 1: S3 Static Web Hosting.

## Repository Layout
- `report.md`: student submission report
- `commands.md`: command log with key outputs and interpretations
- `toy-example/`: minimal static site sample and deployment scripts
- `templates/`: original blank templates for reference

## What To Do
1. Review the assignment scope in this repository.
2. Use the files under `toy-example/` to build, deploy, verify, and clean up the S3 static website.
3. Fill `report.md` and `commands.md` with your own evidence.
4. Commit and push your work to your assignment repository.

## Assignment Scope
- Build a static website on S3
- Validate all key settings via CLI
- Submit reproducible evidence

## Requirements
1. Create an S3 bucket and configure static website hosting.
2. Apply a least-privilege bucket policy with `s3:GetObject`.
3. Upload `index.html` and `error.html` or deploy the provided `dist/` artifact.
4. Enable versioning and verify object versions.

## Required CLI Evidence
```bash
aws s3api get-bucket-website --bucket <bucket>
aws s3api get-bucket-policy --bucket <bucket>
aws s3api list-object-versions --bucket <bucket>
aws s3api get-public-access-block --bucket <bucket>
```

## Submission Files
- `report.md`
- `commands.md`
- `toy-example/bucket-policy.json` or equivalent final policy content in your evidence

## Grading
- Functional completeness: 1.5
- Security and policy correctness: 1.0
- CLI reproducibility: 1.0
- Failure and recovery documentation: 0.5
