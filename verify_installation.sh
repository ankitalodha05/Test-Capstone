✅ Run this to check everything is installed properly:
bash
Copy
Edit
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

# Check Docker Hello World (optional – requires logout/login or newgrp docker)
docker run hello-world

# Check AWS CLI
echo "AWS CLI:" && aws --version

# Check eksctl
echo "eksctl:" && eksctl version

# Check kubectl
echo "kubectl:" && kubectl version --client

# Check Terraform
echo "Terraform:" && terraform version
🔍 You can also combine all into a script:
To quickly run these checks:

bash
Copy
Edit
nano verify_installation.sh
Paste the code above, save and exit, then:

bash
Copy
Edit
chmod +x verify_installation.sh
./verify_installation.sh
