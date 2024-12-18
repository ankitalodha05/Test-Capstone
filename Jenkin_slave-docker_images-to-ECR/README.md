# Push Docker Images to AWS ECR with Jenkins Freestyle Job

## Prerequisites
- **AWS Account** with access to Amazon ECR.
- **IAM User or IAM Role** with the following policy:
  - `AmazonEC2ContainerRegistryFullAccess`.
- **Jenkins Master-Slave Setup**:
  - Jenkins master and slave servers are connected.
  - Slave server configured to run builds.
- **Docker and AWS CLI Installed** on the Jenkins slave server.
- **Git repository** containing a `Dockerfile` for your application.

---
create an IAM user-
- provide user console 
-![image](https://github.com/user-attachments/assets/4f60412b-0e63-403c-9159-978eba286fe1)
-administrator access
-create
-check the iam user created by open aws console in an new incongnite window with iam user credentials, check and close this window.
----
## Create a IAM Role 
-service-EC2
![image](https://github.com/user-attachments/assets/99308cd7-9ef9-41c7-a1f6-1ced2438cda9)
-create role.

-modify IAM Role as below
![image](https://github.com/user-attachments/assets/e10e5ab9-1fd9-452c-a934-e300e7586be7)




## Step 1: Prepare Jenkins Slave Server

1. **Log into the Jenkins Slave Server** (EC2 instance or remote machine).
2. **Install Docker**:
   ```bash
   sudo apt update
   sudo apt install docker.io -y
   sudo usermod -aG docker jenkins
   sudo chmod 666 /var/run/docker.sock
   ```
3. **Install AWS CLI**:
   ```bash
   sudo apt install awscli -y
   ```
4. **Configure AWS Credentials** on the slave server:
   ```bash
   aws configure
   ```
   - Enter IAM User **Access Key ID**, **Secret Key**, Region (e.g., `us-east-1`), and output format `json`.
5. **Verify Jenkins Slave Connectivity**:
   - Go to **Jenkins Dashboard → Manage Nodes**.
   - Ensure the slave node is connected.
## do not need to install plugins(docker,docker pipeline,ECR) for jenkins freestyle job.
33 do not need to add credentials in manage jenkins as we alredy given locally in point.4

---

## Step 2: Configure AWS ECR

1. Go to AWS Console → **ECR → Create Repository**.
2. Set the repository name to `app/webapp`.
3. Copy the **Repository URI**:
   ```
   746669215817.dkr.ecr.us-east-1.amazonaws.com/app/webapp
   ```

---
## step 3: create node

1.Create Jenkins Slave Node:

Go to Manage Jenkins → Manage Nodes.
Add a new node with SSH connection details and verify connectivity.
-![image](https://github.com/user-attachments/assets/83b4ac17-caea-45a7-ab1e-b472f3a5df72)
-![image](https://github.com/user-attachments/assets/50709298-03a1-463c-adda-82ed9cb568f7)



## Step 4: Create Jenkins Freestyle Job

1. Go to **Jenkins Dashboard → New Item**.
2. Name the job: `ECR_Freestyle_Job` → Select **Freestyle Project** → Click **OK**.
3. **Configure Job**:
   - **Restrict Job to Slave Node**:
     - Under **General → Restrict where this project can be run**, set the **Label Expression** to match the Slave Node label.
   - **Source Code Management**: git
     - Select **None** (as Git cloning will be handled in the shell script).
-![image](https://github.com/user-attachments/assets/55f912f5-e9b9-4bf0-b5fe-7a91cd124352)


4. **Add Build Step**:
   - Select **Execute Shell**.
   - Paste the following shell script: (replace in command - Region, Account ID ,ECR Repository URI )

```bash
#!/bin/bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 746669215817.dkr.ecr.us-east-1.amazonaws.com


sudo git clone https://github.com/ashrafgate/E-to-E-DevOps-Pipeline-WebApp-AK.git
sleep 10

cd E-to-E-DevOps-Pipeline-WebApp-AK
docker build . -t app/webapp:latest
sleep 10

docker tag app/webapp:latest 746669215817.dkr.ecr.us-east-1.amazonaws.com/app/webapp
sleep 10

docker push 746669215817.dkr.ecr.us-east-1.amazonaws.com/app/webapp
```

---

## Step 4: Save and Run the Job

1. Click **Save** to save the Jenkins job configuration.
2. Click **Build Now** to trigger the job.

---

## Step 5: Validate in AWS ECR

1. Go to AWS Console → **ECR**.
2. Verify that the image `app/webapp:latest` appears in the repository.
-![image](https://github.com/user-attachments/assets/134e3d2e-5000-4623-9dce-1eb194734e83)
- my history
-![image](https://github.com/user-attachments/assets/4957ea81-2dc5-4178-8009-ca8568abd228)



---

## Troubleshooting

- **Docker Permission Issue**:
   ```bash
   sudo chmod 666 /var/run/docker.sock
   ```
- **AWS CLI Not Found**:
   Ensure AWS CLI is installed and accessible:
   ```bash
   aws --version
   ```
- **Build Failures**:
   - Verify the Git repository URL.
   - Check for issues in the `Dockerfile`.

---

## Expected Outcome
- The Jenkins Freestyle Job running on the Jenkins slave server will:
  1. Clone the Git repository.
  2. Build a Docker image.
  3. Tag the image.
  4. Push the image to AWS ECR.

---

## Final Verification
- Go to AWS Console → **ECR**.
- Confirm the image is successfully uploaded with the correct tag.
