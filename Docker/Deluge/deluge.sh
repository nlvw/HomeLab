#!/bin/bash
# https://hub.docker.com/r/binhex/arch-delugevpn/

# Ensure Root Privileges
if [ "$(whoami)" != 'root' ]; then
	echo 'This script must be run as "root".'
	echo 'Enter password to elevate privileges:'
	SCRIPTPATH="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	SELF="$(basename "$0")"
	sudo bash "${SCRIPTPATH}/${SELF}"
	exit 1
fi
clear
echo 'Script running with root privileges.'

# get PIA credentials
read -rp 'Username for PIA: ' PIAUser
read -rsp 'Password for PIA: ' PIAPass

# Precreate docker volume
docker volume create deluge

# get PIA openvpn config files and place the needed one in the proper directory
vPath="$(docker volume inspect --format '{{ .Mountpoint }}' deluge)"
ccovpn="${vPath}/openvpn" 
if [ ! -f "${ccovpn}/US Texas.ovpn" ]; then
	wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
	unzip openvpn.zip -d openvpn
	rm -R "$ccovpn"
	mkdir -p "$ccovpn"
	mv "openvpn/US Texas.ovpn" "$ccovpn"
	mv openvpn/*.crt "$ccovpn"
	mv openvpn/*.pem "$ccovpn"
	chown -R curator:curator "$ccovpn"
	rm -R openvpn
	rm openvpn.zip
fi

# Stand Up new deluge container
docker run -d \
	--cap-add=NET_ADMIN \
	--device=/dev/net/tun \
	--name=deluge \
	--network=macvlan-ipv4 \
	--ip="$(ip route get 8.8.8.8 | cut -d ' ' -f 3 | cut -d '.' -f 1-3).64" \
	--hostname=deluge \
	--restart="unless-stopped" \
	--mount type=volume,source=deluge,target=/config \
	--mount type=volume,source=deluge-torrents,target=/data \
	--mount type=bind,source=/butters/library,target=/library \
	-e TZ="America/Denver" \
	-e VPN_ENABLED=yes \
	-e VPN_PROV=pia \
	-e VPN_USER="$PIAUser" \
	-e VPN_PASS="$PIAPass" \
	-e VPN_REMOTE="us-texas.privateinternetaccess.com" \
	-e STRICT_PORT_FORWARD=yes \
	-e ENABLE_PRIVOXY=no \
	-e LAN_NETWORK="$(ip route get 8.8.8.8 | cut -d ' ' -f 3 | cut -d '.' -f 1-3).0/24" \
	-e NAME_SERVERS="8.8.8.8,8.8.4.4" \
	-e DEBUG=false \
	-e UMASK=002 \
	-e PUID=6846 \
	-e PGID=6846 \
	binhex/arch-delugevpn:latest
