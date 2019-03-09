#!/bin/bash
# https://hub.docker.com/r/wolfereign/samba-simple/

# Create smb.conf if it doesn't exist
fName="smb.conf"
sDir="/vpool/container-data/secrets"
fPath="${sDir}/${fName}"

if [ ! -f "$fPath" ]; then
# Create smb.conf file
cat << EOF > "$fPath"
	[global]
	workgroup = WORKGROUP
	server string = Samba Server %v
	netbios name = portland
	security = user
	map to guest = bad user
	dns proxy = no

	[backups]
	path = /data/backups
	create mode = 770
	directory mode = 770
	#force user = wolfereign
	#force group = wolfereign
	browsable = yes
	writable = yes
	guest ok = no
	read only = no
	valid users = wolfereign

	[library]
	path = /data/library
	create mode = 770
	directory mode = 770
	force user = curator
	force group = curator
	browsable = yes
	writable = yes
	guest ok = no
	read only = no
	valid users = wolfereign

	[projects]
	path = /data/projects
	create mode = 770
	directory mode = 770
	force user = wolfereign
	force group = wolfereign
	browsable = yes
	writable = yes
	guest ok = no
	read only = no
	valid users = wolfereign

EOF
fi

# Stand-up new container
docker run -d \
	--name=samba \
	--network=bridge \
	-p 137:137/udp \
	-p 138:138/udp \
	-p 139:139 \
	-p 445:445 \
	--restart="unless-stopped" \
	--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
	--mount type=bind,source="$fPath",target=/etc/samba/smb.conf,readonly \
	--mount type=bind,source="/var/lib/samba",target=/var/lib/samba \
	--mount type=bind,source=/etc/passwd,target=/etc/passwd,readonly \
	--mount type=bind,source=/etc/group,target=/etc/group,readonly \
	--mount type=bind,source=/home,target=/home \
	--mount type=bind,source=/vpool/library,target=/data/library \
	--mount type=bind,source=/vpool/projects,target=/data/projects \
	--mount type=bind,source=/vpool/backups,target=/data/backups \
	wolfereign/samba-simple
