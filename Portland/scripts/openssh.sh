#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Port Variable
sshPort=22

# Change SSH Settings
sed -i  "Port 22/ c\Port ${sshPort}" /etc/ssh/sshd_config
sed -i  'PermitRootLogin/ c\PermitRootLogin no' /etc/ssh/sshd_config
sed -i  'PubkeyAuthentication/ c\PubkeyAuthentication yes' /etc/ssh/sshd_config
sed -i  'AuthorizedKeysFile/ c\AuthorizedKeysFile %h/.ssh/authorized_keys' /etc/ssh/sshd_config
sed -i  'PasswordAuthentication/ c\PasswordAuthentication no' /etc/ssh/sshd_config

# Enable PasswordAuthentication on the local network only
cat << EOF >> /etc/ssh/sshd_config

# Allow Local Lan to login with clear text passwords
Match address $(ip route get 8.8.8.8 | cut -d ' ' -f 3 | cut -d '.' -f 1-3).0/24
	PasswordAuthentication yes

EOF

# Make Firewall Changes
ufw limit "${sshPort}/tcp"
ufw reload

# Resart SSH Server to load new settings
systemctl restart sshd
