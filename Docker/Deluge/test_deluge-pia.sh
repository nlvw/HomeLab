#!/bin/bash
#

# Stand Up new deluge container
docker run -d \
    --name=test-deluge \
    --network=macvlan-ipv4 \
    --ip="$(ip route get 8.8.8.8 | cut -d ' ' -f 3 | cut -d '.' -f 1-3).42" \
    --hostname=test-deluge \
    --restart="unless-stopped" \
    --mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
    --mount type=bind,source=/vpool/container-data/test-deluge/config,target=/config \
    --mount type=bind,source=/vpool/container-data/test-deluge/torrents,target=/torrents \
    --mount type=bind,source=/vpool/container-data/secrets/deluge-auth,target=/config/auth,readonly \
    --mount type=bind,source=/vpool/library,target=/library,readonly \
    -e	USER_ID=6846 \
    -e	GROUP_ID=6846 \
    test-deluge
