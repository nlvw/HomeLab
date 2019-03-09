#!/bin/bash
# System configuration for my home server (run as root)(Ubuntu Server)
# Create ZFS pool from scratch and create desired subvolumes/directories

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Refresh Repos
apt update -y

# Install ZFS
apt install -y zfsutils-linux

# List hard drives and partitions
lsblk

# Get ZFS Options
read -pr "ZFS - Specify desired pool name: " RName
read -pr "ZFS - Specify raid type (raidz, raidz2, etc..): " RType
read -pr "ZFS - Specify drives to add to raid (EX: /dev/sdb /dev/sdc /dev/sda): " RDevices

# Create ZFS Raid
zpool create "$RName" "$RType" "$RDevices"

# Print Status
zpool status
