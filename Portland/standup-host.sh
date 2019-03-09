#!/bin/bash
# Install options/roles should be UEFI, Standard System Utilities, OpenSSH Server

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Install updates
sudo apt update -y
sudo apt upgrade -y

# Install Random Needed packages / WebTools (ensures they are installed)
sudo apt install -y unzip wget curl git vim

# Set Current Directory
sudo pushd "$(dirname "$0")"

# Setup UFW
sudo bash ./scripts/uncomplicated-firewall.sh

# Setup OpenSSH
sudo bash ./scripts/openssh.sh

# Setup ZFS
sudo bash ./scripts/zfs.sh

# Setup Media Library
sudo bash ./scripts/media-library.sh

# Setup SMTP Mail
sudo bash ./scripts/smtp-forwarder.sh

# Setup kvm
sudo bash ./scripts/kvm.sh

# Setup Docker
sudo bash ./scripts/docker.sh

# Setup LXD
#sudo bash ./scripts/lxd.sh

# Setup Cockpit
sudo bash ./scripts/cockpit.sh

# Setup Automatic Updates
sudo bash ./scripts/unattended-upgrades.sh

# Unset Working Directory
popd
