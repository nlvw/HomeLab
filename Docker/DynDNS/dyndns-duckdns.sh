#!/bin/bash
# https://hub.docker.com/_/alpine/
# duckdns.org

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

# Stand Up New container
docker run -d  \
	--name "dyndns-duckdns" \
	--restart="unless-stopped" \
	--mount type=volume,source=dyndns-duckdns,target=/etc/periodic/15min \
	--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
	wolfereign/crond:latest

# Variables to make some stuff more concise
sDir="$(docker volume inspect --format '{{ .Mountpoint }}' dyndns-duckdns)"
fPath="${sDir}/duckdns"

# Create Update Job If It Doesn't Exist
if [ ! -f "$fPath" ]; then
	# Get Sensitive Information for DuckDNS Entry
	read -rsp 'Duck DNS Account Token: ' token
	read -rp 'Duck DNS Domains To Update (HostName1 HostName2 HostName3)' hNames

	# Generate bash script to update the dyndns entry
	echo "#!/bin/sh" > "$fPath"
	for hName in $hNames; do
		echo "echo url=\"https://www.duckdns.org/update?domains=${hName}&token=${token}&ip=\" | curl -k -K -" >> "$fPath"
	done

	# Make Script executable
	chmod 750 "$fPath"
	chmod +x "$fPath"
fi