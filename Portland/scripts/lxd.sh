#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Remove Apt/Deb version of lxd
apt remove --purge lxd lxd-client liblxc1 lxcfs

# Install LXD from snapcraft
snap install lxd

# Init LXD
#lxd init
