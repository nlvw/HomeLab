#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Install and reset/delete existing rules
apt install -y ufw
ufw reset

# Set firewall defaults
ufw default deny incoming
ufw default allow outgoing
ufw logging medium

# Allow/Limit default SSH port
ufw limit 22/tcp

# Enable Firewall
ufw enable 
systemctl enable ufw