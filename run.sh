#!/bin/bash

# /*
# * Enviromnetal Variables
# */

config_path=$PWD"/config"
shell_user="raul"

# Create temp folders
sudo mkdir /tmp/rohjans
sudo chmod 777 -R /tmp/rohjans

# Update system
yes | sudo pacman -Syu;

# Remove pre installed apps
yes | sudo pacman -R firefox-gnome-theme-maia totem gnome-boxes fragments geary lollypop

# Install most apps
yes | sudo pacman -S firefox audacity bitwarden discord filezilla gnome-tweaks gedit gimp gparted gthumb htop lutris mysql-workbench virtualbox qbittorrent remmina gnome-screenshot solaar virt-manager vlc pigz appimagelauncher nvidia-utils virt-manager git onlyoffice-desktopeditors gnome-terminal docker python python-pip curl --noconfirm

yes | sudo pamac install --no-confirm anydesk-bin github-desktop-bin gnome-sound-recorder-git google-chrome gwe minecraft-launcher mpv-amd-full-git openvpn3 pavucontrol-git postman-bin spotify sublime-text-4 teams-for-linux zoom zpaq

# Install app images
# --Houdoku
cd /tmp/rohjans
mkdir houdoku
cd houdoku
curl -s https://api.github.com/repos/xgi/houdoku/releases/latest | grep "browser_download_url.*AppImage" | cut -d : -f 2,3 | tr -d \" | wget -qi -
for FILENAME in *; do mv $FILENAME "houdoku.AppImage"; done 
mkdir ~/Applications
mv *.AppImage ~/Applications
mkdir ~/.local/share/applications
cd ~/.local/share/applications
printf "[Desktop Entry]\n
Name=Houdoku\n
Exec=/home/raul/Applications/houdoku.AppImage --no-sandbox %U\n
Terminal=false\n
Type=Application\n
Icon=/home/raul/.local/share/Houdoku/logo.svg\n
StartupWMClass=Houdoku\n
X-AppImage-Version=2.9.0\n
Comment=Manga reader and library manager for the desktop\n
Categories=Development;\n\n

TryExec=/home/raul/Applications/houdoku.AppImage\n
X-AppImage-Old-Icon=houdoku\n
X-AppImage-Old-Name=Houdoku" > houdoku.desktop

# Install GPU drivers
sudo mhwd -a pci nonfree 0300

# Install icon pack
cd /tmp/rohjans
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
cd Tela-circle-icon-theme/
bash install.sh

# Install matcha theme
yes | sudo pacman -S gtk-engine-murrine gtk-engines
cd /tmp/rohjans
git clone https://github.com/vinceliuice/Matcha-gtk-theme.git
cd Matcha-gtk-theme/
bash install.sh -c dark -t azul
sudo flatpak override --filesystem=~/.themes

# Install fonts
sudo cp -r $config_path"/fonts/." "/usr/share/fonts/"
fc-cache

# Move files
mkdir ~/.config
cp $config_path"/wallpapers/background" ~/.config

# Import Gnome theme settings
echo ${$(cat $config_path"/dconf-settings.ini")//raul/$shell_user} | dconf load /

# Clean files & reboot
sudo rm -rf /tmp/rohjans
sudo reboot now