#!/bin/bash

# Download debs
wget -O chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
wget -O steam.deb "http://media.steampowered.com/client/installer/steam.deb"

# Add PPAs
sudo add-apt-repository -y ppa:obsproject/obs-studio
sudo add-apt-repository -y ppa:oibaf/graphics-drivers
sudo add-apt-repository -y ppa:graphics-drivers/ppa

# Update packages
sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y ./chrome.deb ./discord.deb ./steam.deb ./code.deb
sudo apt-get install -y nvidia-driver-515 network-manager-openconnect network-manager-openconnect-gnome neovim vlc obs-studio git tree neofetch htop ca-certificates curl gnupg lsb-release

# Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker dsingal
sudo systemctl restart docker

# NVIDIA Docker
distribution=ubuntu22.04 \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
#sudo docker run --rm --gpus all nvcr.io/nvidia/cuda:11.7.0-base-ubuntu22.04 nvidia-smi

# Remove fluff
sudo apt-get purge -y flatpak libreoffice* firefox*
sudo apt-get autoremove -y
rm *.deb
echo "now remove snaps"
echo "https://askubuntu.com/questions/1309144/how-do-i-remove-all-snaps-and-snapd-preferably-with-a-single-command"
