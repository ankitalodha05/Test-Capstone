#!/bin/bash

# Step-by-Step Bash Script to Set Up an EKS Cluster on Ubuntu

set -e  # Exit immediately if a command exits with a non-zero status

# Variables
AWS_REGION="us-east-1"
EKS_CLUSTER_NAME="demo-eks"
NODE_GROUP_NAME="my-nodes"
NODE_TYPE="t2.micro"
NODE_COUNT=2

# Function to print status messages
function print_status() {
    echo -e "\n\033[1;32m[STATUS]\033[0m $1\n"
}

# 1. Install AWS CLI
print_status "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install -y unzip
unzip awscliv2.zip
./aws/install
aws --version

# 2. Install eksctl
print_status "Installing eksctl..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# 3. Install kubectl
print_status "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

# 4. Configure AWS CLI
print_status "Configuring AWS CLI..."
aws configure

# 5. Create EKS Cluster
print_status "Creating EKS cluster..."
eksctl create cluster \
  --name $EKS_CLUSTER_NAME \
  --region $AWS_REGION \
  --nodegroup-name $NODE_GROUP_NAME \
  --node-type $NODE_TYPE \
  --managed \
  --nodes $NODE_COUNT

# 6. Verify EKS Cluster
print_status "Verifying EKS cluster nodes..."
kubectl get nodes

print_status "Verifying Kubernetes namespaces..."
kubectl get ns

# 7. Deploy Nginx
print_status "Deploying Nginx application..."
kubectl create deployment nginx --image=nginx

print_status "Verifying Nginx deployment..."
kubectl get deployments
kubectl get pods

print_status "EKS cluster setup complete with Nginx deployment."
