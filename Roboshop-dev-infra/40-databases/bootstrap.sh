#!/bin/bash

component=$1
environment=$2


mkdir -p /var/log/roboshop/${component}/${environment}/
touch ansible.log
# Move into ansible script directory
cd /home/ec2-user/Roboshop/Roboshop-Ansible

# Run the database ansible playbook

ansible-playbook -e component=${component} -e env=${environment} main.yaml