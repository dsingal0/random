#!/bin/bash
# assuming starting from lubuntu 22.10
# Download debs
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
wget -O steam.deb "http://media.steampowered.com/client/installer/steam.deb"
wget -O chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
wget -O lutris.deb "https://github.com/lutris/lutris/releases/download/v0.5.12-beta1/lutris_0.5.12_beta1_all.deb"
sudo apt install -y ./discord.deb
sudo apt install -y ./steam.deb
sudo apt install -y ./code.deb
sudo apt install -y ./chrome.deb
sudo apt install -y ./lutris.deb
# Add PPAs
sudo add-apt-repository -y ppa:graphics-drivers/ppa #nv driver
sudo add-apt-repository -y ppa:cappelikan/ppa #mainline
sudo add-apt-repository -y ppa:obsproject/obs-studio-unstable #obs studio
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine64 wine32 libasound2-plugins:i386 libsdl2-2.0-0:i386 libdbus-1-3:i386 libsqlite3-0:i386 nvidia-driver-520 libvulkan1 libvulkan1:i386
sudo apt --fix-broken install -y
sudo apt dist-upgrade -y
sudo apt-get install -y pinta tmux flameshot fonts-firacode glances neovim vlc obs-studio git tree neofetch htop mainline
# Remove fluff
sudo apt-get purge -y flatpak libreoffice* firefox*
sudo apt-get autoremove -y
rm *.deb
echo "now remove snaps"
sudo snap remove chromium firefox gnome-3-38-2004 gtk-common-themes snap-store snapd-desktop-integration
sudo snap remove core20 bare snapd
rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
echo "https://askubuntu.com/questions/1309144/how-do-i-remove-all-snaps-and-snapd-preferably-with-a-single-command"
sudo apt-get purge -y snap*
