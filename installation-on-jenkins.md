Great! You can create a **bash script file** (e.g., `setup.sh`) on your server, make it executable, and then run it to install everything.

---

### ✅ **Step-by-Step Instructions**

#### 1. **Create the script file**

Run this on your server:

```bash
nano setup.sh
```

Then paste the full script below inside `nano`. (Press `Ctrl+O`, then `Enter` to save, and `Ctrl+X` to exit.)

---

### 🧾 `setup.sh` – Complete Script

```bash
#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update system
sudo apt update && sudo apt upgrade -y

# Install Java (OpenJDK 17)
sudo apt install openjdk-17-jdk -y
java -version

# Install Python
sudo apt install python3 python3-pip -y
python3 --version
pip3 --version

# Install Git
sudo apt install git -y
git --version

# Install Docker
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
docker --version
docker run hello-world || echo "Docker test skipped (run manually after login)"

# Install AWS CLI
sudo apt install unzip curl -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
aws --version

# Configure AWS CLI (manual input)
echo "=== Configure AWS CLI ==="
aws configure

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

# Install Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y
terraform -version

echo "✅ Setup Complete!"
```

---

#### 2. **Make the script executable**

```bash
chmod +x setup.sh
```

---

#### 3. **Run the script**

```bash
./setup.sh
```

---

Would you like me to add this exact script into your canvas so you can reuse or modify it later?
