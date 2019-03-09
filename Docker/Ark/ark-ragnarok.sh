#!/bin/bash
# https://github.com/boerngen-schmidt/Ark-docker

# Get Plex account claim token from user
read -rsp 'Admin Password: ' aPass
read -rsp 'Server Password: ' sPass

# Stand Up New container
docker run -d  \
	--name ark-ragnarok \
	--restart="unless-stopped" \
	-p 7779:7779 \
	-p 7779:7779/udp \
	-p 27016:27016 \
	-p 27016:27016/udp \
	-p 32331:32330 \
	--hostname ark-ragnarok \
	--mount type=volume,source=ark-ragnarok,target=/ark \
	-e SESSIONNAME="Trash Panda Ragnar-ition" \
	-e SERVERPORT=27016 \
	-e STEAMPORT=7779 \
	-e SERVERMAP=Ragnarok \
	-e SERVERPASSWORD=$sPass \
	-e ADMINPASSWORD=$aPass \
	-e MAX_PLAYERS=25 \
	-e BACKUPONSTART=1 \
	-e UPDATEONSTART=1 \
	-e BACKUPONSTOP=1 \
	-e WARNONSTOP=1 \
	-e TZ="America/Denver" \
	boerngenschmidt/ark-docker
