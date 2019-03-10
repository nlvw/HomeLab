#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Ensure need packages are installed
apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Official Docker Repo and Install Docker Community Edition
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce

# Ensure Docker volume exists on the ZFS Pool
if [ ! -d "/tank/docker" ]; then
    zfs create "tank/docker"
fi

# Ensure docker service is stopped
systemctl stop docker

# Set Docker Daemon Settings
cat << EOF >> /etc/docker/daemon.json
{
	"storage-driver": "zfs",
	"data-root": "/tank/docker",
	"userns-remap": "default",
	"ipv6": true,
	"fixed-cidr-v6": "2001:db8:1::/64"
}
EOF

# Start and Enable docker service
systemctl daemon-reload
systemctl start docker
systemctl enable docker

# Setup Docker MacVLan (add ipv6 later)
docker network create -d macvlan  \
    --subnet="$(ip route get 8.8.8.8 | cut -d ' ' -f 3 | cut -d '.' -f 1-3).0/24"  \
    --gateway="$(ip route get 8.8.8.8 | cut -d ' ' -f 3)"  \
    -o parent="$(ip route get 8.8.8.8 | cut -d ' ' -f 5 | head -1)" macvlan-ipv4
