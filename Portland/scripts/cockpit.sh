#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Install needed packages / repos
add-apt-repository universe
apt install -y cockpit cockpit-networkmanager cockpit-storaged cockpit-system cockpit-packagekit cockpit-docker cockpit-machines

# Open firewall port
ufw allow 9090/tcp
ufw reload
