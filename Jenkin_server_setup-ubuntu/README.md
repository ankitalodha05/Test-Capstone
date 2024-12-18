# Jenkins Server Setup Guide

## Step 1: Create a Key Pair
- Generate a new key pair named `slave_key`.
- Download and securely store the private key.

---

## Step 2: Launch Jenkins Server

### Instance Configuration
- **AMI**: `ubuntu`.
- **Instance Type**: `t2-medium`.
- **Key Pair**: `slave_key`.
- **Advanced Settings**:
  - Add the following **User Data** script:

```bash
#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```

### Launch Instance
- Start the instance and wait for it to initialize.

---

## Step 3: Access Jenkins

### Connect to Instance
- Use SSH to connect to the instance:

```bash
ssh -i slave_key.pem ubuntu@<public-ip>
```

### Access Jenkins
- Open a browser and enter:

```
http://<public-ip>:8080
```

- Unlock Jenkins using the password found at:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## Step 4: Install Plugins
- Navigate to:

```
Dashboard > Manage Jenkins > Plugins > Available Plugins
```

- Search for and install the `Publish Over SSH` plugin.

---
