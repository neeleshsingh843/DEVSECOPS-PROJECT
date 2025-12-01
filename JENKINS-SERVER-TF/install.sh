#!/bin/bash
# For Amazon Linux 2 / Amazon Linux 2023

set -e

sudo yum update -y

# -------------------------
# Install Java (Corretto 17)
# -------------------------
sudo yum install -y java-17-amazon-corretto-headless
java -version

# -------------------------
# Install Jenkins
# -------------------------
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo yum upgrade -y
sudo yum install -y jenkins

# Enable & start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# -------------------------
# Install Docker
# -------------------------
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker jenkins
sudo usermod -aG docker ec2-user
sudo systemctl restart docker
sudo chmod 777 /var/run/docker.sock

# If you don't want to install Jenkins on host, you can run Jenkins container instead:
# docker run -d -p 8080:8080 -p 50000:50000 --name jenkins-container jenkins/jenkins:lts

# -------------------------
# Run SonarQube container
# -------------------------
docker run -d --name sonarqube -p 9000:9000 sonarqube:community

# -------------------------
# Install Terraform
# -------------------------
TERRAFORM_VERSION="1.7.5"

sudo yum install -y unzip curl

curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
terraform version

# -------------------------
# Install kubectl
# -------------------------
KUBECTL_VERSION="v1.33.5"

curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl kubectl.sha256
kubectl version --client

# -------------------------
# Install AWS CLI v2
# -------------------------
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
aws --version

# -------------------------
# Install Trivy
# -------------------------
sudo rpm --import https://aquasecurity.github.io/trivy-repo/rpm/public.key

sudo tee /etc/yum.repos.d/trivy.repo > /dev/null <<EOF
[trivy]
name=Trivy Repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF

sudo yum update -y
sudo yum install -y trivy
trivy --version
