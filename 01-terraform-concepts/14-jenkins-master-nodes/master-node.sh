#!/bin/bash

# === Install Jenkins on Amazon Linux 2023 ===
# Run this script as ec2-user or with  privileges

echo "Updating system packages..."
dnf update -y
dnf install git -y

echo "Installing Java 17 (Amazon Corretto)..."
dnf install -y java-17-amazon-corretto

echo "Verifying Java installation..."
java -version

echo "Adding Jenkins repository..."
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

echo "Importing Jenkins GPG key..."
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "Installing Jenkins..."
dnf install -y jenkins
yum install maven -y

echo "Enabling and starting Jenkins service..."
systemctl enable jenkins
systemctl start jenkins

echo "Checking Jenkins service status..."
systemctl status jenkins --no-pager

echo "Jenkins installation complete!"
echo "Access Jenkins at: http://<your-instance-public-ip>:8080"
echo "Initial admin password:"
cat /var/lib/jenkins/secrets/initialAdminPassword   


# set remote root directory to --> /home/ec2-user/jenkins
# in jenkins dashboard