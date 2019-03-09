#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Create media library user (curator)
useradd -u 6846 curator
echo curator:"$(openssl rand -base64 32)" | chpasswd

# Create Media Libraries
if [ ! -d "/tank/library" ]; then
    zfs create "tank/library"
    mkdir "/tank/library/books"
    mkdir "/tank/library/music"
    mkdir "/tank/library/pictures"
    mkdir "/tank/library/videos"
fi

# Fix permissions on Library SubVolume
chown -R curator:curator "/tank/library"
chmod -R 770 "/tank/library"
chmod -R g+s "/tank/library"
