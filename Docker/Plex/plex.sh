#!/bin/bash
# https://hub.docker.com/r/plexinc/pms-docker/

# Ensure Script Is Run As Root 
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Stand Up New container
docker container run -d  \
	--name plex \
	--restart="unless-stopped" \
	--device /dev/dri:/dev/dri \
	--network=macvlan-ipv4 \
	--ip "$(ip route get 8.8.8.8 | cut -d ' ' -f 3 | cut -d '.' -f 1-3).60" \
	--hostname plex \
	--mount type=volume,source=plex,target=/config \
	--mount type=tmpfs,target=/transcode \
	--mount type=bind,source=/tank/library,target=/data,readonly \
	-e TZ="America/Denver" \
	plexinc/pms-docker:plexpass
