# CI/CD Pipeline with jenkins and Docker

# This project focuses on implementing a continuous integration/Continuous deployment pipeline using jenkins and Docker for building, testing, and deplying applications. The pipeline will also be integrated with a cloud environment(e.g., AWS or Azure) for automated deployments.
#
#
# ### Project: **CI/CD Pipeline with Jenkins and Docker**

This project focuses on implementing a Continuous Integration/Continuous Deployment (CI/CD) pipeline using **Jenkins** and **Docker** for building, testing, and deploying applications. The pipeline will also be integrated with a cloud environment (e.g., AWS or Azure) for automated deployments.

---

### **Step-by-Step Implementation Guide**

---

### **Step 1: Set Up Jenkins for Automated Builds**

#### Step 1.1: Install Jenkins
1. **Install Java**:
   Jenkins requires Java. Install it on your system:
   ```bash
   sudo apt update
   sudo apt install -y openjdk-11-jdk
   ```

2. **Add Jenkins Repository**:
   ```bash
   curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
       /usr/share/keyrings/jenkins-keyring.asc > /dev/null
   echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
       https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
       /etc/apt/sources.list.d/jenkins.list > /dev/null
   ```

3. **Install Jenkins**:
   ```bash
   sudo apt update
   sudo apt install -y jenkins
   sudo systemctl start jenkins
   sudo systemctl enable jenkins
   ```

4. **Access Jenkins**:
   - Open a web browser and go to `http://<server-ip>:8080`.
   - Unlock Jenkins using the password stored in `/var/lib/jenkins/secrets/initialAdminPassword`.

5. **Install Suggested Plugins**:
   - Install recommended plugins during the setup wizard.

6. **Create an Admin User**:
   - Complete the initial configuration by creating an admin user.

---

#### Step 1.2: Configure Jenkins for Git Integration
1. **Install Git**:
   ```bash
   sudo apt install -y git
   ```

2. **Install Required Plugins**:
   - Navigate to **Manage Jenkins > Manage Plugins**.
   - Install:
     - **Git Plugin**
     - **Pipeline Plugin**

3. **Add Credentials**:
   - Go to **Manage Jenkins > Credentials**.
   - Add SSH or token-based credentials for accessing your Git repository.

---

### **Step 2: Integrate Docker for Containerization**

#### Step 2.1: Install Docker
1. **Install Docker**:
   ```bash
   sudo apt install -y docker.io
   ```

2. **Add Jenkins to Docker Group**:
   - Allow Jenkins to run Docker commands:
     ```bash
     sudo usermod -aG docker jenkins
     sudo systemctl restart jenkins
     ```

3. **Verify Docker Access**:
   - Switch to the Jenkins user and run:
     ```bash
     sudo su - jenkins
     docker run hello-world
     ```

---

#### Step 2.2: Create a Dockerfile for the Application
1. **Example Dockerfile**:
   ```Dockerfile
   FROM python:3.9-slim
   WORKDIR /app
   COPY . /app
   RUN pip install -r requirements.txt
   CMD ["python", "app.py"]
   ```

2. **Push Code to Git Repository**:
   - Add the Dockerfile to your application repository.

---

#### Step 2.3: Configure a Jenkins Pipeline for Docker
1. **Create a New Job**:
   - Go to Jenkins Dashboard.
   - Click **New Item > Pipeline**.

2. **Add Pipeline Script**:
   - Example script:
     ```groovy
     pipeline {
         agent any
         stages {
             stage('Checkout') {
                 steps {
                     git credentialsId: 'your-credentials-id', url: 'git@github.com:your-repo.git'
                 }
             }
             stage('Build Docker Image') {
                 steps {
                     sh 'docker build -t your-app:latest .'
                 }
             }
             stage('Push Docker Image') {
                 steps {
                     sh 'docker tag your-app:latest your-docker-repo/your-app:latest'
                     sh 'docker push your-docker-repo/your-app:latest'
                 }
             }
         }
     }
     ```

3. **Save and Test the Pipeline**:
   - Trigger the pipeline to ensure it pulls the code, builds the Docker image, and pushes it to the repository.

---

### **Step 3: Configure Build Triggers and Notifications**

#### Step 3.1: Set Up Build Triggers
1. **Enable Webhooks in Git Repository**:
   - Add a webhook in GitHub/GitLab to trigger Jenkins builds on code changes.

2. **Configure Jenkins**:
   - Go to **Job > Configure > Build Triggers**.
   - Select **GitHub hook trigger for GITScm polling**.

---

#### Step 3.2: Set Up Notifications
1. **Install Plugins**:
   - Navigate to **Manage Jenkins > Manage Plugins**.
   - Install:
     - **Slack Notification Plugin** or **Email Extension Plugin**.

2. **Configure Notifications**:
   - For Slack:
     - Set up an app in Slack and generate a webhook URL.
     - Configure the Slack plugin in **Manage Jenkins > Configure System**.

   - For Email:
     - Set SMTP settings in **Manage Jenkins > Configure System**.
     - Add email recipients under **Post-build Actions > Email Notification**.

---

### **Step 4: Automate Deployment to a Cloud Environment**

#### Step 4.1: Deploy to AWS ECS
1. **Install AWS CLI**:
   ```bash
   sudo apt install -y awscli
   ```

2. **Configure AWS CLI**:
   ```bash
   aws configure
   ```

3. **Create an ECS Cluster**:
   - Use the AWS Management Console or CLI to create a cluster and register a task definition for your application.

4. **Update Jenkins Pipeline**:
   - Add a deployment stage:
     ```groovy
     stage('Deploy to ECS') {
         steps {
             sh '''
             aws ecs update-service --cluster your-cluster-name \
                 --service your-service-name \
                 --force-new-deployment
             '''
         }
     }
     ```

---

#### Step 4.2: Deploy to Kubernetes (Optional)
1. Install Kubectl:
   ```bash
   sudo snap install kubectl --classic
   ```

2. **Update Pipeline**:
   - Add a deployment stage:
     ```groovy
     stage('Deploy to Kubernetes') {
         steps {
             sh '''
             kubectl apply -f k8s-deployment.yaml
             '''
         }
     }
     ```

---

### Step 5: Train my Team

1. **Documentation**:
   - Create step-by-step guides for setting up Jenkins, Docker, and deployment.
   - Include troubleshooting steps for common errors.

2. **Hands-On Training**:
   - Guide your team through creating and modifying pipelines.
   - Explain key CI/CD concepts and tools used.

---

This implementation of a CI/CD pipeline ensures smooth automation of builds, tests, and deployments, leveraging Jenkins and Docker in a real-world scenario. The approach is extensible for modern DevOps practices, making it ideal for training a team.
