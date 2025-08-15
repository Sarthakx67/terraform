#!/bin/bash
setenforce 0  #
yum install epel-release vim unzip git wget -y  #
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum upgrade -y
# Add required dependencies for the jenkins package
yum install fontconfig java-21-openjdk -y
yum install jenkins -y
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins 