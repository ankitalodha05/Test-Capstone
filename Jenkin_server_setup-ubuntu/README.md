# Jenkins Server Setup , slave server setup, node creation

## Step 1: Create a Key Pair
- Generate a new key pair named `jenkin`.
- Download and securely store the private key.

---

## Step 2: Launch Jenkins Server

### Instance Configuration
- **Instance Type**: `t2-medium`.
- **AMI**:`ubuntu`.
- **Key Pair**: `jenkin`.
- **Security group**:`Default`.
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
sudo apt-get update -y
sudo apt install -y fontconfig openjdk-17-jre
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
/var/lib/jenkins/secrets/initialAdminPassword
```

---

## Step 4: Install Plugins
- Navigate to:

```
Dashboard > Manage Jenkins > Plugins > Available Plugins
```

- Search for and install the `Publish Over SSH` plugin.
-![image](https://github.com/user-attachments/assets/db677545-2a70-4857-ad76-c28a027e6cac)

- For docker and ECR - search for and install the `Docker` ,`Docker Pipeline` and `Amazon ECR` plugin.
-![image](https://github.com/user-attachments/assets/6f160d38-35ff-4f87-8d84-b2e7ca3f4bdc)



---

# Step 5: Configure Slave Node

## Launch Slave Instance

### Instance Configuration

- Launch a new instance named `slave`.
- **Instance Type**: `t2-micro`.
- **AMI**:`ubuntu`.
- **Key Pair**: `jenkin`.
- **Security group**:`Default`.


- Connect to it via SSH.
- Run the following commands on the slave instance:

```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

### Configure Publish Over SSH
- Navigate to:

```
Dashboard > Manage Jenkins > System > Publish Over SSH
```

- Add the following details:
  - Paste your **private key**.
-![image](https://github.com/user-attachments/assets/eb5b775f-e49d-468c-a742-bdbac9e8cd68)

  - **Hostname**: Public IP of `slave1`.

-![image](https://github.com/user-attachments/assets/8e73baab-7a40-4d9a-b36b-559b8fa04700)


- Save and test the connection.

### Create a New Node
- Navigate to:

```
Dashboard > Manage Jenkins > Nodes
```

- Create a node named `slave1`.
- Fill in the required details and add credentials for `slave_key`.
- Save the configuration.

-![image](https://github.com/user-attachments/assets/885d1686-10ab-4680-a542-e418678f5e94)
-![image](https://github.com/user-attachments/assets/55266995-204a-4e18-a189-7946bbcf33b5)

---
### for add crediantials
-![image](https://github.com/user-attachments/assets/64461695-952e-48a2-85b2-751ee6a99d8c)

- save and build
- now you can see node is created
![image](https://github.com/user-attachments/assets/3d01b04c-2648-4f4c-819d-d8662f276c5b)


---

## Step 6: Create and Build a Project

### Create a New Item
- Go to:

```
Dashboard > New Item
```
-![image](https://github.com/user-attachments/assets/86949cce-a852-4539-a39b-843bfe110e40)

- Name your project and select the appropriate configuration.

### Restrict Project to Slave Node
- In the project configuration, specify:

```
Restrict where this project can be run: slave1
```
-![image](https://github.com/user-attachments/assets/992d0e8c-a5f9-4bfd-bbd7-5920e6790073)


### Add Build Steps
- Add **Execute Shell** steps to define build commands.
-![image](https://github.com/user-attachments/assets/5a0ce754-baae-4a08-8ae6-88c84824a763)

### Save and Build
- Save the project and trigger a build to verify the setup.
-![image](https://github.com/user-attachments/assets/78a5d93c-0c7f-4b5b-8bb8-dfe41340e7b0)


---

## Summary
Following these steps will set up a Jenkins server and configure it with a slave node to run specific projects. For troubleshooting, ensure connectivity between Jenkins and the slave node and verify plugin installations.
