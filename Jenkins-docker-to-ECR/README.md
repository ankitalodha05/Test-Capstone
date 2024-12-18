
# Push Docker Images to AWS ECR with Jenkins Pipeline
## Prerequisites
Ensure the following are ready:

- **AWS Account** with access to Amazon ECR.
- **IAM User or IAM Role** with policies:
  - `AmazonEC2ContainerRegistryFullAccess`
- **Jenkins Server** (running on EC2 or locally).
- **Docker Installed** on the Jenkins server.
- **AWS CLI Installed** on the Jenkins server.
- A **Git repository** containing the application code and a `Dockerfile`.

---

## Step 1: Jenkins Server Setup

1. **Update Jenkins Server**:
   ```bash
   sudo apt update
   sudo apt upgrade -y
   ```

2. **Install Docker**:
   ```bash
   sudo apt install docker.io -y
   sudo usermod -aG docker jenkins
   sudo chmod 666 /var/run/docker.sock
   ```

3. **Install AWS CLI**:
   ```bash
   sudo apt install awscli -y
   ```

4. **Restart Jenkins**:
   ```bash
   sudo systemctl restart jenkins
   ```

---

## Step 2: AWS IAM Setup

1. **Create an IAM User**:
   - Go to AWS IAM Console → Create User -provide user console
   - -provide user console
   - -provide user console
   - Attach policy directly:
     - `AdministratorAccess`.
-![image](https://github.com/user-attachments/assets/91674915-f525-4f09-82a7-70c9de0ff3f2)


2. **For IAM User**:
   - Note the **Access Key ID** and **Secret Access Key**.

3. **Attach Role to Jenkins EC2 Instance** (if using roles):
   - Go to EC2 → Attach IAM Role → Select Role with ECR Access.

---

## Step 3: Prepare AWS ECR

1. Go to AWS Console → **ECR** → Create Repository.
2. Use the following settings:
   - **Repository Name**: `app/mywebapp`.
3. Copy the **Repository URI**:
   ```
   448049817247.dkr.ecr.us-east-1.amazonaws.com/app/mywebapp
   ```

---

## Step 4: Configure Jenkins

1. **Install Required Plugins**:
   - Go to Jenkins → Manage Jenkins → Manage Plugins.
   - Install the following:
     - **Pipeline Plugin**
     - **Amazon ECR Plugin**

2. **Add AWS Credentials in Jenkins**:
   - Go to **Manage Jenkins → Manage Credentials → Global**.
   - Add a new **AWS Credential** with:
     - **Access Key ID**
     - **Secret Access Key**

---

## Step 5: Create Jenkins Pipeline

1. Go to Jenkins Dashboard → **New Item** → Select **Pipeline**.
2. Name it **ECR_Pipeline** and click **OK**.
3. Under **Pipeline Definition**, paste the following script:

```groovy
pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="448049817247"
        AWS_DEFAULT_REGION="us-east-1"
        IMAGE_REPO_NAME="app/mywebapp"
        IMAGE_TAG="latest"
        REPOSITORY_URI = "448049817247.dkr.ecr.us-east-1.amazonaws.com/app/mywebapp"
    }

    stages {
        stage('Logging into AWS ECR') {
            steps {
                script {
                    sh """aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | \
                    docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                }
            }
        }

        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, 
                    extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', 
                    url: 'https://github.com/ashrafgate/E-to-E-DevOps-Pipeline-WebApp-AK.git']]])
            }
        }

        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Pushing to ECR') {
            steps {
                script {
                    sh """
                    docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}
                    docker push ${REPOSITORY_URI}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
}
```

4. **Save** the Pipeline and run the build.

---

## Step 6: Validate in AWS ECR

1. Go to AWS Console → **ECR**.
2. Check if the Docker image appears in the repository with the `latest` tag.

---

## Troubleshooting

- **Docker Permissions**:
   - Ensure Jenkins has access to Docker:
     ```bash
     sudo chmod 666 /var/run/docker.sock
     ```

- **AWS CLI Configuration**:
   - Test AWS CLI access:
     ```bash
     aws ecr describe-repositories
     ```

- **Repository URI**:
   - Verify the repository URI matches the one in the script.

---

## Expected Outcome

- Jenkins will:
  1. Log into AWS ECR.
  2. Clone the GitHub repository.
  3. Build a Docker image using the `Dockerfile`.
  4. Push the Docker image to AWS ECR.

---

### Final Verification
Go to AWS Management Console → **ECR** and verify the image is successfully uploaded.
