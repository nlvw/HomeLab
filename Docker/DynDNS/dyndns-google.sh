#!/bin/bash
# https://hub.docker.com/_/alpine/
# https://domains.google.com/registrar

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
	--name "dyndns-google" \
	--restart="unless-stopped" \
	--mount type=volume,source=dyndns-google,target=/etc/periodic/15min \
	--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
	wolfereign/crond:latest

# Variables to make some stuff more concise
sDir="$(docker volume inspect --format '{{ .Mountpoint }}' dyndns-google)"
fPath="${sDir}/google"

# Create Update Job If It Doesn't Exist
if [ ! -f "$fPath" ]; then
	# Get Desired hostnames to update
	read -rp 'Google DynDNS Entries To Update (hostname1 hostname2 hostname3)' hNames

	# Generate bash script to update the dyndns entries
	echo "#!/bin/sh" > "$fPath"
	for hName in $hNames; do
		# Get Sensitive Information for Goggle Dynamic DNS Entry
		read -rsp "${hName} DNS Entry UserName: " uName
		read -rsp "${hName} DNS Entry Password: " uPass

		# Generate bash script to update the dyndns entry
		echo "echo url=\"https://${uName}:${uPass}@domains.google.com/nic/update?hostname=${hName}\" | curl -k -K -" >> "$fPath"
	done

	# Make Script executable
	chmod 750 "$fpath"
	chmod +x "$fPath"
fi