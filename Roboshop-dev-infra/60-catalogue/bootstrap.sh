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

echo "-----Catalogue Deployment Started-----"

echo ${component}
echo ${environment}

# Run the database ansible playbook


ansible-playbook -e component=$component -e env=$environment main.yaml -i inventory.txt 

sudo yum reinstall openssh-server -y

sudo systemctl restart sshd

sudo lsof -i :22

sudo sshd -t
sudo journalctl -xeu sshd >> /tmp/sshd-error.log
sudo systemctl status sshd >> /tmp/sshd-status.log

cat /tmp/sshd-error.log
cat /tmp/sshd-status.log


sleep 5

exit 0




