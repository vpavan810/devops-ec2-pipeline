# ECS DevOps Pipeline

This project provisions AWS infrastructure using Terraform and deploys a containerized app to ECS using Jenkins.

## Features
- Terraform-managed ECS, ECR, VPC, IAM
- Dockerized Nginx app
- Jenkins CI/CD pipeline with branch-based logic
- Slack notifications on success/failure

## Usage
1. Configure AWS credentials in Jenkins.
2. Push code to GitHub.
3. Merge to `main` to trigger full deployment.