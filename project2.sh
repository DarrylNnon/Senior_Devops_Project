#Project2: Infrastructure as Code (IAC) with Terraform
This project demonstrates how to use Terraform, a popular infrastructure as Codetool, to provision and manage cloud infrastructure (AWS in this case).I will also integrate it with environment-specific configurations, test and validate deployments, and automate with a CI/CD pipeline

### Project: **Infrastructure as Code (IaC) with Terraform**

This project demonstrates how to use **Terraform**, a popular Infrastructure as Code tool, to provision and manage cloud infrastructure (AWS in this case). We'll also integrate it with environment-specific configurations, test and validate deployments, and automate with a CI/CD pipeline.

---

### **Step-by-Step Implementation Guide**

---

### **Step 1: Write Terraform Code for Cloud Infrastructure**

#### Step 1.1: Install Terraform
1. **Download Terraform**:
   - Visit [Terraform's website](https://www.terraform.io/downloads) and download the appropriate binary for your operating system.

2. **Install Terraform**:
   ```bash
   sudo apt update
   sudo apt install -y unzip
   wget https://releases.hashicorp.com/terraform/<version>/terraform_<version>_linux_amd64.zip
   unzip terraform_<version>_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   terraform --version
   ```

3. **Set Up AWS CLI**:
   - Install and configure the AWS CLI to authenticate with AWS.
   ```bash
   sudo apt install -y awscli
   aws configure
   ```

#### Step 1.2: Initialize a Terraform Project
1. **Create a Project Directory**:
   ```bash
   mkdir terraform-aws-project && cd terraform-aws-project
   ```

2. **Write a Terraform Configuration File**:
   - Create a `main.tf` file with the following code:
   ```hcl
   provider "aws" {
     region = "us-east-1"
   }

   resource "aws_instance" "web" {
     ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
     instance_type = "t2.micro"

     tags = {
       Name = "Terraform-Web-Instance"
     }
   }
   ```

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Format and Validate Code**:
   ```bash
   terraform fmt
   terraform validate
   ```

---

### **Step 2: Implement Environment-Specific Configurations**

1. **Separate Configurations by Environment**:
   - Create folders for each environment (e.g., `dev`, `staging`, `prod`).
   ```bash
   mkdir environments/{dev,staging,prod}
   ```

2. **Add Environment-Specific Variables**:
   - In `environments/dev/variables.tf`:
     ```hcl
     variable "instance_type" {
       default = "t2.micro"
     }
     ```

   - In `environments/dev/main.tf`:
     ```hcl
     provider "aws" {
       region = "us-east-1"
     }

     resource "aws_instance" "web" {
       ami           = "ami-0c02fb55956c7d316"
       instance_type = var.instance_type

       tags = {
         Name = "Dev-Web-Instance"
       }
     }
     ```

3. **Use Terraform Workspaces for Isolation**:
   ```bash
   terraform workspace new dev
   terraform workspace new staging
   terraform workspace new prod
   ```

---

### **Step 3: Test and Validate Infrastructure Deployment**

1. **Run a Plan**:
   - Simulate the execution without deploying the infrastructure:
   ```bash
   terraform plan
   ```

2. **Deploy the Infrastructure**:
   - Apply the plan to deploy resources:
   ```bash
   terraform apply
   ```

3. **Test the Deployment**:
   - Verify that the instance is running using the AWS Management Console or CLI:
   ```bash
   aws ec2 describe-instances --filters "Name=tag:Name,Values=Dev-Web-Instance"
   ```

4. **Tear Down Infrastructure**:
   - Use `terraform destroy` to clean up:
   ```bash
   terraform destroy
   ```

---

### **Step 4: Automate Terraform Scripts with a CI/CD Pipeline**

#### Step 4.1: Set Up a Jenkins Server
1. **Install Jenkins**:
   Follow the installation instructions in the previous CI/CD project.

2. **Install Terraform Plugin**:
   - Navigate to **Manage Jenkins > Manage Plugins**.
   - Install the **Terraform Plugin**.

---

#### Step 4.2: Create a Terraform Pipeline
1. **Create a Jenkins Job**:
   - Go to the Jenkins dashboard.
   - Click **New Item > Pipeline**.

2. **Add Pipeline Script**:
   - Example `Jenkinsfile` for Terraform:
     ```groovy
     pipeline {
         agent any
         environment {
             AWS_REGION = 'us-east-1'
         }
         stages {
             stage('Checkout') {
                 steps {
                     git credentialsId: 'your-credentials-id', url: 'git@github.com:your-repo/terraform-aws-project.git'
                 }
             }
             stage('Terraform Init') {
                 steps {
                     sh 'terraform init'
                 }
             }
             stage('Terraform Plan') {
                 steps {
                     sh 'terraform plan'
                 }
             }
             stage('Terraform Apply') {
                 steps {
                     sh 'terraform apply -auto-approve'
                 }
             }
         }
     }
     ```

3. **Trigger the Pipeline**:
   - Run the pipeline to automatically provision your infrastructure.

---

### **Step 5: Train Your Team**

1. **Document Steps**:
   - Write detailed guides covering:
     - Setting up Terraform.
     - Writing modular configuration.
     - Deploying via CI/CD.

2. **Conduct Hands-On Training**:
   - Guide the team through creating and testing Terraform configurations.

3. **Implement Best Practices**:
   - Use state locking with AWS S3.
   - Enable version control for `.tf` files.
   - Enforce code reviews for Terraform changes.

---

### **Final Notes**
This project demonstrates real-world DevOps practices for automating infrastructure management. By combining Terraform with a CI/CD pipeline, you'll enable faster, repeatable, and reliable deployments. Training your team on these concepts will empower them to manage infrastructure as code effectively.
