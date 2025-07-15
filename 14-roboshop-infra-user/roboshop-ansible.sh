#!/bin/bash

yum install ansible -y
git clone https://github.com/Sarthakx67/RoboShop-Documentation.git
cd RoboShop-Documentation/RoboShop-Ansible-Roles
ansible-playbook -i inventory -e component=mongodb  main.yaml