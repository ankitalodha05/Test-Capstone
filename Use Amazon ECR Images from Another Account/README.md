# Steps to Use Amazon ECR Images from Another Account

This document provides a comprehensive guide on how to use Amazon Elastic Container Registry (ECR) images stored in one AWS account (Account A) in another AWS account (Account B). It includes resolving the common issue of "no basic auth credentials" and ensuring proper configuration and permissions.

---

## **1. Prerequisites**

1. AWS CLI must be installed on the machine where you are running the commands.
   - Install AWS CLI:
     ```bash
     sudo apt-get install awscli -y
     ```

2. Docker must be installed and running on your machine.
   - Install Docker:
     ```bash
     sudo apt-get update
     sudo apt-get install -y docker.io
     ```

3. Proper IAM permissions:
   - **Account A (ECR Owner)**: Must grant cross-account access to Account B.
   - **Account B (Image User)**: Must have appropriate ECR permissions.

---

## **2. Grant Access in Account A (ECR Owner)**

Account A must update the repository policy to allow Account B to access the ECR repository.

1. **Modify Repository Policy**:
   Use the following JSON policy and replace `<AccountB-ID>` with the AWS account ID of Account B.

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Principal": {
                   "AWS": "arn:aws:iam::<AccountB-ID>:root"
               },
               "Action": [
                   "ecr:BatchCheckLayerAvailability",
                   "ecr:BatchGetImage",
                   "ecr:DescribeImages",
                   "ecr:GetDownloadUrlForLayer"
               ]
           }
       ]
   }
   ```

2. **Apply the Policy**:
   Run the following command in Account A:
   ```bash
   aws ecr set-repository-policy \
       --repository-name <repository-name> \
       --policy-text file://policy.json
   ```
   Example:
   ```bash
   aws ecr set-repository-policy \
       --repository-name app/mywebapp \
       --policy-text file://policy.json
   ```

---

## **3. Authenticate Docker in Account B**

Account B must authenticate Docker to Account A’s ECR repository using a temporary authorization token.

1. Run the following command in Account B (replace `<AccountA-ID>` and `<region>` with Account A’s details):
   ```bash
   aws ecr get-login-password --region us-east-1 | \
   sudo docker login --username AWS --password-stdin <AccountA-ID>.dkr.ecr.us-east-1.amazonaws.com
   ```

2. You should see a success message:
   ```
   Login Succeeded
   ```

---

## **4. Pull the Image in Account B**

Once authenticated, you can pull the image from Account A’s ECR repository.

1. Use the following command to pull the image:
   ```bash
   sudo docker pull <AccountA-ID>.dkr.ecr.us-east-1.amazonaws.com/<repository-name>:<tag>
   ```
   Example:
   ```bash
   sudo docker pull 448049817247.dkr.ecr.us-east-1.amazonaws.com/app/mywebapp:latest
   ```

2. If successful, the image will be downloaded locally.

---

## **5. Optional: Push Image to Account B’s ECR Repository**

If Account B needs to maintain its own copy of the image:

1. **Tag the Image**:
   ```bash
   sudo docker tag <AccountA-ID>.dkr.ecr.us-east-1.amazonaws.com/<repository-name>:<tag> \
   <AccountB-ID>.dkr.ecr.us-east-1.amazonaws.com/<repository-name>:<tag>
   ```
   Example:
   ```bash
   sudo docker tag 448049817247.dkr.ecr.us-east-1.amazonaws.com/app/mywebapp:latest \
   123456789012.dkr.ecr.us-east-1.amazonaws.com/app/mywebapp:latest
   ```

2. **Push the Image to Account B’s ECR**:
   Authenticate with Account B’s ECR repository:
   ```bash
   aws ecr get-login-password --region us-east-1 | \
   sudo docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
   ```

   Push the image:
   ```bash
   sudo docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/app/mywebapp:latest
   ```

---

## **6. Troubleshooting Common Issues**

### **Issue: “No Basic Auth Credentials”**

#### **Cause:**
This error occurs when Docker is not authenticated to the ECR repository.

#### **Solution:**
- Run the following command to authenticate Docker:
  ```bash
  aws ecr get-login-password --region us-east-1 | \
  sudo docker login --username AWS --password-stdin <AccountA-ID>.dkr.ecr.us-east-1.amazonaws.com
  ```

### **Issue: “Permission Denied”**

#### **Cause:**
- The IAM user or role in Account B does not have sufficient permissions.
- The repository policy in Account A does not allow access to Account B.

#### **Solution:**
- Verify IAM permissions in Account B include:
  ```json
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "ecr:GetAuthorizationToken",
                  "ecr:BatchCheckLayerAvailability",
                  "ecr:GetDownloadUrlForLayer",
                  "ecr:BatchGetImage"
              ],
              "Resource": "*"
          }
      ]
  }
  ```

- Verify the repository policy in Account A grants access to Account B.

---

## **7. Validate Access**

1. Confirm the image exists in Account A’s ECR repository:
   ```bash
   aws ecr describe-images --repository-name <repository-name> --region us-east-1
   ```

2. Verify the IAM role or user in Account B has the appropriate permissions.

---

## **Best Practices**

1. **Use Least Privilege:** Only grant permissions that are necessary for the required actions.
2. **Rotate Credentials:** Regularly rotate access keys or use IAM roles for enhanced security.
3. **Audit Access:** Periodically review repository policies and IAM permissions.

---

Following these steps should allow you to successfully use ECR images across accounts. If you encounter further issues, ensure all policies and permissions are correctly configured.

