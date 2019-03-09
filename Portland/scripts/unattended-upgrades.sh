#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Install ubunta apt auto update package
apt install -y unattended-upgrades

# Set Repos to Auto Update From && Reboot Settings && Mail Notification Settings
cat <<'EOF' > /etc/apt/apt.conf.d/50unattended-upgrades
    Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}";
        "${distro_id}:${distro_codename}-security";
        "${distro_id}ESM:${distro_codename}";
        "${distro_id}:${distro_codename}-updates";
        "Docker:${distro_codename}";
    };
    Unattended-Upgrade::Mail "root";
    Unattended-Upgrade::MailOnlyOnError "false";
    Unattended-Upgrade::Remove-Unused-Dependencies "true";
    Unattended-Upgrade::Automatic-Reboot "true";
    Unattended-Upgrade::Automatic-Reboot-Time "03:00";
EOF

# Set Update Schedule and Behaviour
cat <<'EOF' > /etc/apt/apt.conf.d/20auto-upgrades
    APT::Periodic::Enable "1";
    APT::Periodic::Update-Package-Lists "1";
    APT::Periodic::Download-Upgradeable-Packages "0";
    APT::Periodic::Unattended-Upgrade "7";
    APT::Periodic::AutocleanInterval "21";
EOF
