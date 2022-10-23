#!/bin/bash

# Update packages
sudo apt update
sudo apt dist-upgrade -y
# install development tools 
sudo apt-get install -y neovim git neofetch htop tree ca-certificates curl gnupg lsb-release

# install docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo groupadd docker
# add self to docker user group(hard coded username, so TODO replace)
sudo usermod -aG docker dsingal
sudo systemctl restart docker
# docker pull test and run
sudo docker run hello-world
# Remove fluff
sudo apt-get purge -y snapd* flatpak libreoffice* firefox* geary
sudo apt-get autoremove -y
