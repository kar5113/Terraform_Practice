#!/bin/bash

# Expanding the /var partition
growpart /dev/nvme0n1 4

# Extending the logical volume
lvextend -L +30G /dev/mapper/RootVG-homeVol

# Resizing the filesystem
xfs_growfs /home


# Installing Terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

sudo yum install awscli -y


# Installing Ansible
sudo dnf install ansible -y

cd /home/ec2-user

mkdir Roboshop

# Installing Git
sudo yum install git -y

cd Roboshop

# Cloning the Roboshop-dev-infra repository
if [ ! -d Terraform_Practice ]; then
  git clone https://github.com/kar5113/Terraform_Practice.git
fi  

cd /home/ec2-user/Roboshop/Terraform-Roboshop/Roboshop-dev-infra



# # Cloning the Ansible_Roboshop repository
# if [ ! -d Ansible_Roboshop ]; then
#     git clone https://github.com/kar5113/Roboshop-Ansible.git
# fi




