# Deploying a Docker Image to AWS Elastic Container Registry (ECR)

This document outlines the steps required to push a Docker image to AWS ECR and verify its successful upload.

---

## 1. Prerequisites
Ensure you have the following:

- AWS CLI installed and configured with the necessary permissions.
- Docker installed and set up.
- A Docker image ready to be pushed.
- AWS account and credentials with permissions to access ECR.

---

## 2. Steps to Push Docker Image to AWS ECR

### 2.1 Create a Repository in AWS ECR
1. Log in to the **AWS Management Console**.
2. Navigate to **ECR** > **Repositories** > **Create repository**.
3. Provide a repository name (e.g., `my-web-app`).
4. Select **Private repository**.
5. Click **Create repository**.

### 2.2 Authenticate Docker with ECR
1. Use the AWS CLI to authenticate Docker with your ECR repository. Run the following command:
   ```bash
   aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
   ```
   Replace `<region>` with your AWS region and `<aws_account_id>` with your AWS account ID.

### 2.3 Tag the Docker Image
1. Tag your Docker image to match the ECR repository URL. Run the command:
   ```bash
   docker tag your-app-name:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-web-app:latest
   ```
   Replace `your-app-name` with your Docker image name, `<aws_account_id>` with your AWS account ID, and `<region>` with your AWS region.

### 2.4 Push the Image to ECR
1. Push the tagged Docker image to the ECR repository:
   ```bash
   docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-web-app:latest
   ```

---

## 3. Verify the Image in AWS ECR
1. Log in to the **AWS Management Console**.
2. Navigate to your **ECR repository**.
3. Confirm that the Docker image has been successfully uploaded.

---

### Additional Notes
- Ensure your AWS CLI version is up-to-date.
- If authentication fails, verify your AWS credentials and region configuration.
- Use the `docker images` command to confirm that your image is properly tagged before pushing.

- # Setting up an Ubuntu EC2 Instance for Docker and AWS CLI with AWS ECR Integration

## Objective
In this guide, we will set up an Ubuntu EC2 instance to install Docker, AWS CLI, and integrate it with AWS Elastic Container Registry (ECR). The goal is to pull Docker images and run them as containers.

---

## Steps Performed

### 1. Update the System Packages
Update the system repositories to ensure you have the latest package versions:
```bash
sudo apt update
```

---

### 2. Install Python and PIP
Install Python 3 and PIP for package management:
```bash
sudo apt install -y python3 python3-pip
```
Verify the installation:
```bash
python3 --version
pip3 --version
```

---

### 3. Install Docker
Install Docker to manage and run containers:
```bash
sudo apt install docker.io
```
Verify the Docker installation:
```bash
sudo docker --version
```

---

### 4. Install AWS CLI (Version 2)
Install AWS CLI to interact with AWS services:
```bash
sudo apt -y install unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
Verify AWS CLI installation:
```bash
aws --version
```

---

### 5. Authenticate Docker with AWS ECR
To pull Docker images from AWS ECR, authenticate Docker using AWS credentials:
```bash
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <Account-ID>.dkr.ecr.<region>.amazonaws.com
```
Replace `<region>` and `<Account-ID>` with your AWS region and account ID.

---

### 6. Pull Docker Images from AWS ECR
Once authenticated, pull the required Docker image:
```bash
sudo docker pull <Account-ID>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>
```
**Example:**
```bash
sudo docker pull 448049817247.dkr.ecr.us-east-1.amazonaws.com/app/mywebapp:latest
```

---

### 7. Run the Docker Container
Run the Docker container on port 80:
```bash
sudo docker run -it -d -p 80:80 448049817247.dkr.ecr.us-east-1.amazonaws.com/app/mywebapp
```

---

### 8. Clean-Up of Temporary Files
Optionally, remove downloaded installation files:
```bash
rm -rf awscliv2.zip aws/
```

---

## Summary
- Updated the Ubuntu system.
- Installed Python, PIP, Docker, and AWS CLI.
- Authenticated Docker with AWS ECR.
- Pulled Docker images from AWS ECR.
- Launched a container on the EC2 instance.

The environment is now ready for further deployment and testing.

---


