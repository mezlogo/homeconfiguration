#!/usr/bin/env bash

mkdir -p ~/repos/{mezlogo,edu,mirrors}
mkdir -p ~/{Downloads,Pictures,Desktop,Music,Pictures,Public,Templates,Videos}
mkdir -p ~/.profile.d
mkdir -p ~/.zsh.d

echo -e 'en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8' | sudo tee /etc/locale.gen
sudo locale-gen

# XDG_DESKTOP_DIR="$HOME/Desktop"
# XDG_DOCUMENTS_DIR="$HOME/Documents"
# XDG_DOWNLOAD_DIR="$HOME/Downloads"
# XDG_MUSIC_DIR="$HOME/Music"
# XDG_PICTURES_DIR="$HOME/Pictures"
# XDG_PUBLICSHARE_DIR="$HOME/Public"
# XDG_TEMPLATES_DIR="$HOME/Templates"
# XDG_VIDEOS_DIR="$HOME/Videos"
