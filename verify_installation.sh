Here's a clean and well-formatted **document version** of your environment verification script. This can be shared with your team or used as a checklist after setting up a DevOps environment on Ubuntu.

---

## ✅ DevOps Environment Verification Script

Use the following script to verify that all necessary tools are properly installed and accessible on your system.

### 🧪 Check Installed Tools

```bash
#!/bin/bash

echo "🔍 Verifying installations..."

# Check Java
echo -e "\nJava:" && java -version

# Check Python & PIP
echo -e "\nPython:" && python3 --version
echo "PIP:" && pip3 --version

# Check Git
echo -e "\nGit:" && git --version

# Check Docker
echo -e "\nDocker:" && docker --version
echo "Docker Group Check (your username should appear):" && groups

# Optional: Docker Hello World Test
echo -e "\nRunning Docker hello-world (optional):"
docker run hello-world

# Check AWS CLI
echo -e "\nAWS CLI:" && aws --version

# Check eksctl
echo -e "\neksctl:" && eksctl version

# Check kubectl
echo -e "\nkubectl:" && kubectl version --client

# Check Terraform
echo -e "\nTerraform:" && terraform version
```

### 🛠 How to Use

1. Open a terminal and run:

   ```bash
   nano verify_installation.sh
   ```

2. Paste the script above, then save and exit (`Ctrl + O`, `Enter`, `Ctrl + X`).

3. Make the script executable:

   ```bash
   chmod +x verify_installation.sh
   ```

4. Run the script:

   ```bash
   ./verify_installation.sh
   ```

---

Let me know if you'd like this as a downloadable `.sh` file or formatted as a PDF for documentation.
