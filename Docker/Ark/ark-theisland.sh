#!/bin/bash
# https://github.com/boerngen-schmidt/Ark-docker

# Get Plex account claim token from user
read -rsp 'Admin Password: ' aPass
read -rsp 'Server Password: ' sPass

# Create Docker Volume
docker volume create ark

# Stand Up New container
docker run -d  \
  --name ark-theisland \
  --restart="unless-stopped" \
  -p 7778:7778 \
  -p 7778:7778/udp \
  -p 27015:27015 \
  -p 27015:27015/udp \
  -p 32330:32330 \
  --hostname ark-theisland \
  --mount type=volume,source=ark-theisland,target=/ark \
  -e SESSIONNAME="Trash Panda Island-ition" \
  -e SERVERPORT=27015 \
  -e STEAMPORT=7778 \
  -e SERVERMAP=TheIsland \
  -e SERVERPASSWORD=$sPass \
  -e ADMINPASSWORD=$aPass \
  -e MAX_PLAYERS=25 \
  -e TZ="America/Denver" \
  boerngenschmidt/ark-docker
