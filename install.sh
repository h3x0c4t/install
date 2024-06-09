#!/bin/sh

# Check if the script is running as root
if [ $(id -u) -ne 0 ]; then
    echo "[!] Please run as root"
    exit 1
fi

# Check if the system is running Debian
if [ ! -f /etc/debian_version ]; then
    echo "[!] This script only works on Debian-based systems"
    exit 1
fi

# Update the package list
sudo apt update

# Install the required packages
sudo apt install -y git network-manager dkms build-essential linux-headers-$(uname -r) fontconfig \ 
                    fonts-jetbrains-mono fonts-noto fonts-recommended xorg libx11-dev libxft-dev \
                    libxinerama-dev libx11-xcb-dev libxcb-res0-dev dmenu alacritty zsh \
                    zsh-autosuggestions zsh-syntax-highlighting papirus-icon-theme wget curl

# Set up the network manager
sudo systemctl stop networking
sudo systemctl disable networking
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
