#!/bin/bash
# https://hub.docker.com/r/freeipa/freeipa-server/

# Get Passwords for setup
read -rsp 'Directory Server Password: ' dServerPass
read -rsp 'Admin Password: ' adminPass

# Get Hostname 
read -rp 'Desired Hostname (freeipa.sub.example.com): ' hName
read -rp 'Desired Domain Name (SUB.EXAMPLE.COM): ' dName

# Stand Up New container
docker run -d  \
	--name freeipa \
	--restart="unless-stopped" \
	--hostname "$hName" \
	--network=macvlan-ipv4 \
	--ip "$(ip route get 8.8.8.8 | cut -d ' ' -f 3 | cut -d '.' -f 1-3).6" \
	--tmpfs /run --tmpfs /tmp \
	--mount type=bind,source=/sys/fs/cgroup,target=/sys/fs/cgroup,readonly \
	--mount type=volume,source=freeipa,target=/config \
	freeipa/freeipa-server \
	--realm="$dName" \
	--ds-password="$dServerPass" \
	--admin-password="$adminPass" \
	--hostname="$hName" \
	--ip-address="$(ip route get 8.8.8.8 | cut -d ' ' -f 3 | cut -d '.' -f 1-3).6" \
	--setup-dns \
	--forwarder=8.8.8.8 \
	--forwarder=8.8.4.4 \
	--no-ssh \
	--no-sshd \
	--unattended
