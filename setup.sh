#!/bin/sh

CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# Disable unwanted system76 extensions
gnome-extensions list | grep "system76" | grep -vE "power|shell" | xargs -I {} gnome-extensions disable {};

# Update and upgrade
sudo apt update && sudo apt upgrade -y;

# Install programs
sudo apt install -y vim git make cmake lldb gdb wget telegram-desktop discord;

DOWNLOAD_DIR=`mktemp -d`;

wget $CHROME_URL -O $DOWNLOAD_DIR/google_chrome.deb;
chmod 777 $DOWNLOAD_DIR/google_chrome.deb;
sudo apt install -y $DOWNLOAD_DIR/google_chrome.deb;

gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'discord.desktop', 'telegramdesktop.desktop', 'org.gnome.Terminal.desktop']";
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent 'true';

sudo apt install -y gnome-tweaks dconf-editor sassc gettext;

# Extensions
git clone https://github.com/G-dH/custom-hot-corners-extended.git /tmp/CHC;
cd /tmp/CHC && make install;

git clone https://github.com/aunetx/blur-my-shell /tmp/BMS;
cd /tmp/BMS && make install;

# Enable extensions
gnome-extensions enable custom-hot-corners-extended@G-dH.github.com;
gnome-extensions enable blur-my-shell@aunetx;

# Themes
git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela_RED && bash /tmp/Tela_RED/install.sh red;
gsettings set org.gnome.desktop.interface icon-theme 'Tela-red-dark';

git clone https://github.com/vinceliuice/Colloid-gtk-theme.git /tmp/Colloid_GTK && bash /tmp/Colloid_GTK/install.sh --tweaks rimless -s compact -c dark -t red;
gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Red-Dark-Compact';

git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git /tmp/Whitesur_GTK && bash /tmp/Whitesur_GTK/install.sh --normal -t red -c Dark -i popos;
gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark-red';

wget https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.3/Bibata-Modern-Ice.tar.gz -O /tmp/Bibata.tar.gz;
mkdir -p ~/.icons && tar -xvf /tmp/Bibata.tar.gz -C ~/.icons && gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice';

# JetBrains Mono Font
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Shortcuts
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control><Alt>Left']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control><Alt>Right']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Shift><Alt>Left']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Shift><Alt>Right']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings move-to-center "['<Super>C']"

# Bring back the maximize button and make the new windows centered
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.mutter center-new-windows true

# OhMyZsh installation
sudo apt install -y zsh;
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Delete temporary files
rm -rf $DOWNLOAD_DIR /tmp/CHC /tmp/BMS /tmp/Tela_RED /tmp/Colloid_GTK /tmp/Whitesur_GTK /tmp/Bibata.tar.gz 

# Git setup
git config --global init.defaultBranch main
git config --global user.name "username"
git config --global user.email "mail@gmail.com"

# Generate ssh-key for github
echo "$HOME/.ssh/github" | ssh-keygen -t ed25519 -C "mail@gmail.com";
echo -e "SSH KEY FOR GITHUB:" && cat ~/.ssh/github.pub;
