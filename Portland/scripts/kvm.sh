#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Install packages
add-apt-repository universe
apt install -y qemu-kvm libvirt-bin bridge-utils virtinst cpu-checker libvirt-daemon-driver-storage-zfs

# Start/Enable libvirtd service
systemctl enable libvirtd
systemctl start libvirtd

# Configure Network Bridge

# Ensure ZFS directories exist
if [ ! -d "/tank/kvm" ]; then
    zfs create "tank/kvm"
fi

# Set kvm storage location
virsh pool-destroy default
virsh pool-undefine default
virsh pool-define-as --name zfsPool --source-name "tank/kvm" --type zfs
virsh pool-autostart zfsPool
virsh pool-start zfsPool
