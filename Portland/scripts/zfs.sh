#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Ensure ZFS is installed && Pool is imported
apt install -y zfsutils-linux
zpool import "tank"

# Setup ZFS Notifications
cat << EOF > /etc/zfs/zed.d/zed.rc
ZED_DEBUG_LOG="/tmp/zed.debug.log"
ZED_EMAIL_ADDR="root"
ZED_EMAIL_PROG="mail"
ZED_EMAIL_OPTS="-s '@SUBJECT@' @ADDRESS@"
ZED_LOCKDIR="/var/lock"
ZED_NOTIFY_INTERVAL_SECS=3600
ZED_NOTIFY_VERBOSE=1
ZED_RUNDIR="/var/run"
#ZED_SPARE_ON_CHECKSUM_ERRORS=10
#ZED_SPARE_ON_IO_ERRORS=1
ZED_SYSLOG_PRIORITY="daemon.notice"
ZED_SYSLOG_TAG="zed"

EOF

# Enable zfs notification service
systemctl enable zed
systemctl start zed
