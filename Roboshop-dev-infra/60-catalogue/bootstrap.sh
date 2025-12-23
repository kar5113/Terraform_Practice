#!/bin/bash

component=$1
environment=$2

dnf install ansible -y

# Move into ansible script directory
cd /home/ec2-user/

# clone the repository if not already present
if [ ! -d Roboshop-Ansible ]; then
  git clone https://github.com/kar5113/Roboshop-Ansible.git
fi

cd /home/ec2-user/Roboshop-Ansible

# Run the database ansible playbook

ansible-playbook -e component=${component} -e env=${environment} main.yaml -i inventory.txt

