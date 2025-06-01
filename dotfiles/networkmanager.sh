#!/usr/bin/env bash

yay -S --needed --noconfirm \
	webkit2gtk-4.1 gcr \
	nm-connection-editor \
	networkmanager \
	networkmanager-openconnect \
	network-manager-applet

disable_system_services() {
	for service in "$@"; do
		echo "Trying to disable SYSTEM SERVICE $service"
		sudo systemctl disable "$service"
	done
}

enable_system_services systemd-networkd systemd-resolved

enable_system_services() {
	for service in "$@"; do
		echo "Trying to enable SYSTEM SERVICE $service"
		sudo systemctl enable "$service"
	done
}

enable_system_services NetworkManager
