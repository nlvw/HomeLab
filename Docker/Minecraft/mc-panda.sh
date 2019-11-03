#!/bin/bash
# https://hub.docker.com/r/itzg/minecraft-server/

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Stand Up New container
docker container run -d  \
	--name mc-panda \
	--restart="unless-stopped" \
	--mount type=volume,source=mc-panda,target=/data \
	-p 25565:25565 \
	-e TYPE=SPIGOT \
	-e EULA=TRUE \
	-e TZ="America/Denver" \
	-e SERVER_NAME=mc-panda \
	-e SERVER_PORT=25565 \
	-e SEED="-772124751310384583" \
	-e DIFFICULTY="hard" \
	itzg/minecraft-server --noconsole
