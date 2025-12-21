#!/bin/bash
yum install epel-release vim unzip git -y
yum install python3.11-devel python3.11-pip -y
pip3.11 install ansible botocore boto3
cd /tmp
ansible-pull -U https://github.com/Sarthakx67/RoboShop-Ansible-Roles-tf.git -e component=mongodb main.yaml