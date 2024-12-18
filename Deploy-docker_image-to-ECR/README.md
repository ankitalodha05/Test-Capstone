# Deploying a Docker Image to AWS Elastic Container Registry (ECR)

This document outlines the steps required to push a Docker image to AWS ECR and verify its successful upload.

---

## 1. Prerequisites

Ensure you have the following:

- **AWS CLI** installed and configured with the necessary permissions.
- **Docker** installed and set up.
- A **Docker image** ready to be pushed.
- **AWS account** and credentials with permissions to access ECR.

---

## 2. Steps to Push Docker Image to AWS ECR

### 2.1 Create a Repository in AWS ECR
1. Log in to the **AWS Management Console**.
2. Navigate to `ECR > Repositories > Create repository`.
3. Provide a repository name (e.g., `my-web-app`).
4. Select **Private repository**.
5. Click **Create repository**.

### 2.2 Authenticate Docker with ECR
Use the AWS CLI to authenticate Docker with your ECR repository. Run the following command:
```bash
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
```
- Replace `<region>` with your AWS region.
- Replace `<aws_account_id>` with your AWS account ID.

### 2.3 Tag the Docker Image
Tag your Docker image to match the ECR repository URL. Run the command:
```bash
docker tag your-app-name:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-web-app:latest
```
- Replace `your-app-name` with your Docker image name.
- Replace `<aws_account_id>` with your AWS account ID.
- Replace `<region>` with your AWS region.

### 2.4 Push the Image to ECR
Push the tagged Docker image to the ECR repository:
```bash
docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-web-app:latest
```

---

## 3. Verify the Image in AWS ECR

1. Log in to the **AWS Management Console**.
2. Navigate to your **ECR repository**.
3. Confirm that the Docker image has been successfully uploaded.

---

## Additional Notes

- Ensure your AWS CLI version is up-to-date.
- If authentication fails, verify your **AWS credentials** and **region configuration**.
- Use the `docker images` command to confirm that your image is properly tagged before pushing.

