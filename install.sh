#!/bin/bash

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

# Get the username of the user who invoked sudo
USER=$(logname)

# Update the package list
echo "[*] Updating the package list"
apt update

# Install the required packages
echo "[*] Installing the required packages"
apt install -y git network-manager dkms build-essential linux-headers-$(uname -r) fontconfig \
    fonts-jetbrains-mono fonts-noto fonts-recommended xorg libx11-dev libxft-dev \
    libxinerama-dev libx11-xcb-dev libxcb-res0-dev dmenu alacritty zsh dex \
    zsh-autosuggestions zsh-syntax-highlighting papirus-icon-theme wget curl

# Font configuration
echo "[*] Configuring the fonts"
sudo -u $USER mkdir -p /home/$USER/.config/fontconfig
sudo -u $USER wget -O /home/$USER/.config/fontconfig/fonts.conf https://raw.githubusercontent.com/h3x0c4t/install/master/files/fonts.conf
fc-cache -f

# Install dwm
echo "[*] Installing dwm"
git clone https://github.com/h3x0c4t/dwm-patched /usr/local/src/dwm
(cd /usr/local/src/dwm && make clean install)

# Create the .xinitrc file
echo "[*] Creating the .xinitrc file"
sudo -u $USER wget -O /home/$USER/.xinitrc https://raw.githubusercontent.com/h3x0c4t/install/master/files/.xinitrc
sudo -u $USER chmod +x /home/$USER/.xinitrc

# Configure alacritty
echo "[*] Configuring alacritty"
sudo -u $USER mkdir -p /home/$USER/.config/alacritty
sudo -u $USER wget -O /home/$USER/.config/alacritty/alacritty.yml https://raw.githubusercontent.com/h3x0c4t/install/master/files/alacritty.yml

# Configure zsh
echo "[*] Configuring zsh"
sudo -u $USER wget -O /home/$USER/.zshrc https://raw.githubusercontent.com/h3x0c4t/install/master/files/.zshrc
usermod --shell /bin/zsh $USER

# Configure GTK
echo "[*] Configuring GTK"
sudo -u $USER mkdir -p /home/$USER/.local/share/themes
sudo -u $USER git clone -b darker-standard-buttons https://github.com/EliverLara/Nordic /home/$USER/.local/share/themes/Nordic-darker-standard-buttons

sudo -u $USER mkdir -p /home/$USER/.config/gtk-3.0
sudo -u $USER wget -O /home/$USER/.config/gtk-3.0/settings.ini https://raw.githubusercontent.com/h3x0c4t/install/master/files/settings.ini

# Install nm-applet
echo "[*] Installing nm-applet"
apt install -y network-manager-gnome
sudo -u $USER mkdir -p /home/$USER/.config/autostart
sudo -u $USER wget -O /home/$USER/.config/autostart/nm-applet.desktop https://raw.githubusercontent.com/h3x0c4t/install/master/files/nm-applet.desktop

# Install guest additions
echo "[*] Please insert the guest additions CD"
read -p "[*] Press enter to continue" dummy_var

mkdir -p /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
/mnt/cdrom/VBoxLinuxAdditions.run --nox11
umount /mnt/cdrom
rmdir /mnt/cdrom
usermod -aG vboxsf $USER

# Set up the network manager
echo "[*] Setting up the network manager"
wget -O /etc/network/interfaces https://raw.githubusercontent.com/h3x0c4t/install/master/files/interfaces
systemctl stop networking
systemctl disable networking
systemctl enable NetworkManager
systemctl start NetworkManager

# Done
echo "[*] Installation complete! Please reboot the system."
