# ECR Integration: Deploying Docker and AWS CLI on Ubuntu EC2

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
