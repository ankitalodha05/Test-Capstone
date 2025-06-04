#!/bin/bash

# Verify installation of all required tools

# Check Java
echo "Java:" && java -version

# Check Python
echo "Python:" && python3 --version
echo "PIP:" && pip3 --version

# Check Git
echo "Git:" && git --version

# Check Docker
echo "Docker:" && docker --version
echo "Docker Group Check (you should see your username):" && groups

echo "Running Docker Hello World container..."
docker run hello-world || echo "Docker hello-world test skipped (may need logout/relogin)"

# Check AWS CLI
echo "AWS CLI:" && aws --version

# Check eksctl
echo "eksctl:" && eksctl version

# Check kubectl
echo "kubectl:" && kubectl version --client

# Check Terraform
echo "Terraform:" && terraform version

echo "✅ All checks complete. If you see all versions above, your environment is ready."

# Instructions to create and run this script:
# 1. Save this file as verify_installation.sh
# 2. Run the following commands:
#    chmod +x verify_installation.sh
#    ./verify_installation.sh
