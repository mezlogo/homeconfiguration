#!/usr/bin/env bash

mkdir -p ~/repos/{my,ext,pan,edu}
mkdir -p ~/{Downloads,Pictures,Desktop,Music,Pictures,Public,Templates,Videos}

if [ ! -e ~/downloads ]; then
  ln -s ~/downloads ~/Downloads
fi

mkdir -p ~/.profile.d
mkdir -p ~/.zsh.d

XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_VIDEOS_DIR="$HOME/Videos"
