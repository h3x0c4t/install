#!/bin/sh

# Check if the system is running Debian
if [ ! -f /etc/debian_version ]; then
    echo "[!] This script only works on Debian-based systems"
    exit 1
fi

# Update the package list
echo "[*] Updating the package list"
sudo apt update

# Install the required packages
echo "[*] Installing the required packages"
sudo apt install -y git network-manager dkms build-essential linux-headers-$(uname -r) fontconfig \ 
                    fonts-jetbrains-mono fonts-noto fonts-recommended xorg libx11-dev libxft-dev \
                    libxinerama-dev libx11-xcb-dev libxcb-res0-dev dmenu alacritty zsh dex \
                    zsh-autosuggestions zsh-syntax-highlighting papirus-icon-theme wget curl

# Font configuration
echo "[*] Configuring the fonts"
if [ ! -d ~/.config/fontconfig ]; then
    mkdir -p ~/.config/fontconfig
fi
wget -O ~/.config/fontconfig/fonts.conf https://raw.githubusercontent.com/h3x0c4t/install/master/files/fonts.conf
fc-cache -f

# Install dwm
echo "[*] Installing dwm"
sudo git clone https://github.com/h3x0c4t/dwm-patched /usr/local/src/dwm
(cd /usr/local/src/dwm && sudo make clean install)

# Create the .xinitrc file
echo "[*] Creating the .xinitrc file"
wget -O ~/.xinitrc https://raw.githubusercontent.com/h3x0c4t/install/master/files/.xinitrc
chmod +x ~/.xinitrc

# Configure alacritty
echo "[*] Configuring alacritty"
if [ ! -d ~/.config/alacritty ]; then
    mkdir -p ~/.config/alacritty
fi
wget -O ~/.config/alacritty/alacritty.yml https://raw.githubusercontent.com/h3x0c4t/install/master/files/alacritty.yml

# Configure zsh
echo "[*] Configuring zsh"
wget -O ~/.zshrc https://raw.githubusercontent.com/h3x0c4t/install/master/files/.zshrc
sudo usermod --shell /bin/zsh $USER

# Configure GTK
echo "[*] Configuring GTK"
if [ ! -d ~/.local/share/themes ]; then
    mkdir -p ~/.local/share/themes
fi
git clone -b darker-standard-buttons https://github.com/EliverLara/Nordic .local/share/themes/Nordic-darker-standard-buttons

if [ ! -d ~/.config/gtk-3.0 ]; then
    mkdir -p ~/.config/gtk-3.0
fi
wget -O ~/.config/gtk-3.0/settings.ini https://raw.githubusercontent.com/h3x0c4t/install/master/files/settings.ini

# Install nm-applet
echo "[*] Installing nm-applet"
sudo apt install -y network-manager-gnome
if [ ! -d ~/.config/autostart ]; then
    mkdir -p ~/.config/autostart
fi
wget -O ~/.config/autostart/nm-applet.desktop https://raw.githubusercontent.com/h3x0c4t/install/master/files/nm-applet.desktop

# Install guest additions
echo "[*] Please insert the guest additions CD"
read -p "[*] Press enter to continue"

sudo mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
sudo /mnt/cdrom/VBoxLinuxAdditions.run --nox11
sudo umount /mnt/cdrom
sudo rmdir /mnt/cdrom
sudo usermod -aG vboxsf $USER

# Set up the network manager
echo "[*] Setting up the network manager"
sudo systemctl stop networking
sudo systemctl disable networking
sudo wget -O /etc/network/interfaces https://raw.githubusercontent.com/h3x0c4t/install/master/files/interfaces
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Done
echo "[*] Installation complete! Please reboot the system."