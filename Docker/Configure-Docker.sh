#!/bin/bash

# Setup Docker MacVLan (add ipv6 later)
docker network create -d macvlan  \
	--subnet="$(ip route get 8.8.8.8 | cut -d ' ' -f 3 | cut -d '.' -f 1-3).0/27"  \
	--gateway="$(ip route get 8.8.8.8 | cut -d ' ' -f 3)"  \
	-o parent="$(ip route get 8.8.8.8 | cut -d ' ' -f 5 | head -1)" macvlan-ipv4