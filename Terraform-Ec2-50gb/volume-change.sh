#!/bin/bash
growpart /dev/nvme0n1 4
lvextend -L +30G /dev/mapper/RootVG-varVol
xfs_growfs /var
echo "hello world"
echo "Removing old versions of docker if any"
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  podman \
                  runc
echo "Installing dnf plugins core"
sudo dnf -y install dnf-plugins-core 
echo "Adding docker repository"
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
echo "Installing Docker"
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "Enabling Docker service"
sudo systemctl enable docker  
echo "Starting Docker service"
sudo systemctl start docker
echo "Adding ec2-user to docker group"
sudo usermod -aG docker ec2-user  
echo "Docker installation completed"