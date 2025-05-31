#!/usr/bin/env bash

yay -S --needed --noconfirm \
	git openssh less \
	btop nvtop \
	bluez  bluez-utils blueman \
	pipewire wireplumber pipewire-pulse pavucontrol \
	docker docker-compose \
	tmux zellij \
	zsh fish nushell \
	neovim \
	ripgrep fzf fd jq bat exo \
	ttf-font-awesome \
	waybar wofi dunst kitty \
	obsidian \
	visual-studio-code-bin \
	brave-bin chromium firefox \
	keepassxc \
	hyprland hyprpolkitagent hyprutils xdg-desktop-portal-hyprland hyprpolkitagent \
	keyd \
	light \
	wl-clipboard cliphist \
	qt5-wayland qt6-wayland \
	xdg-desktop-portal-hyprland \
	grim slurp \
	lsof tree

stow --adopt --target=$HOME \
  extend_login_shell \
  extend_zsh \
  test_extend_login_shell \
  test_extend_zsh zsh_interactive \
  tmux \
  antidote \
  hyprland \
  waybar \
  wofi

sudo stow --adopt --target=/ \
  keyd_root


add_groups() {
	for group in "$@"; do
		sudo usermod -aG "$group" "$USER"
	done
}

add_groups wireshark libvirt docker video wheel

enable_user_services() {
	for service in "$@"; do
		echo "Trying to enable USER SERVICE $service"
		systemctl --user enable "$service"
	done
}

enable_user_services ssh-agent.service pipewire wireplumber xdg-desktop-portal-hyprland hyprpolkitagent

enable_system_services() {
	for service in "$@"; do
		echo "Trying to enable SYSTEM SERVICE $service"
		sudo systemctl enable "$service"
	done
}

enable_system_services keyd sshd docker bluetooth
