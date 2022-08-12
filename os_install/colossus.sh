#!/bin/bash

# Update packages
sudo apt update
sudo apt dist-upgrade -y
# install nvidia driver
sudo apt-get install -y nvidia-driver-515
sudo modprobe nvidia
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

# NVIDIA Docker
# hard coded distribution name
distribution=ubuntu22.04 \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
# docker pull test and run
sudo docker run --rm --gpus all nvcr.io/nvidia/cuda:11.7.0-base-ubuntu22.04 nvidia-smi

# Remove fluff
sudo apt-get purge -y snapd* flatpak libreoffice* firefox* geary
sudo apt-get autoremove -y
