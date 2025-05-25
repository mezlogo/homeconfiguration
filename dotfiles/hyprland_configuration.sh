#!/usr/bin/env bash

yay -S --needed --noconfirm \
	git openssh less \
	btop nvtop \
	bluez  bluez-utils blueman \
	docker docker-compose \
	tmux zellij \
	zsh fish nushell \
	neovim \
	ripgrep fzf fd jq bat exo \
	ttf-font-awesome \
	waybar wofi dunst kitty \
	obsidian \
	visual-studio-code-bin \
	brave-bin firefox \
	keyd \
	lsof

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
