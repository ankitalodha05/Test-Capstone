# Setting Up an EKS Cluster on Ubuntu

## 1. Launch Ubuntu Instance and Connect
- Launch an **EC2 Ubuntu** instance in AWS.
- Allow inbound traffic on **port 22 (SSH)**.
- Connect to the instance via SSH:

```bash
ssh -i <key-pair>.pem ubuntu@<public-ip>
```

## 2. Switch to Root User
```bash
sudo su -
```

## 3. Install AWS CLI
### Download AWS CLI Binary:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

### Install `unzip` (if not installed):
```bash
apt install -y unzip
```

### Unzip and Install AWS CLI:
```bash
unzip awscliv2.zip
./aws/install
```

### Verify Installation:
```bash
aws --version
```

## 4. Install eksctl
### Download and Install `eksctl`:
```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```

### Verify Installation:
```bash
eksctl version
```

## 5. Install kubectl (Binary Method)
### Download the Latest `kubectl` Binary:
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

### Make it Executable:
```bash
chmod +x kubectl
```

### Move to PATH:
```bash
sudo mv kubectl /usr/local/bin/
```

### Verify Installation:
```bash
kubectl version --client
```

## 6. Configure AWS CLI
### Run AWS Configure:
```bash
aws configure
```
Provide the following details:
- **Access Key ID**
- **Secret Access Key**
- **Region** (e.g., `us-east-1`)
- **Output format**: `json`

### Test AWS CLI Configuration:
```bash
aws sts get-caller-identity
```

## 7. Create an EKS Cluster
### Use `eksctl` to Create a Basic EKS Cluster:
```bash
eksctl create cluster \
  --name demo-eks \
  --region us-east-1 \
  --nodegroup-name my-nodes \
  --node-type t2.micro \
  --managed \
  --nodes 2
```

This creates:
- An **EKS cluster** named `demo-eks`.
- A **managed node group** with **2 t2.micro** instances.

## 8. Verify the EKS Cluster
### Check Cluster Nodes:
```bash
kubectl get nodes
```

### Verify Namespaces:
```bash
kubectl get ns
```

## 9. Deploy Nginx (Test Application)
### Create an Nginx Deployment:
```bash
kubectl create deployment nginx --image=nginx
```

### Verify the Deployment:
```bash
kubectl get deployments
```

### Check Running Pods:
```bash
kubectl get pods
```

## Summary
You now have:
- **AWS CLI** configured.
- **eksctl** installed.
- **kubectl** installed via binary.
- An **EKS cluster** running with a test **Nginx deployment**.

---
