#!/bin/bash

# Ensure Script Is Run As Root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# Get primary email to send notifications
read -rp 'Email to Send Notifications: ' email

# Get SNMTP credentials (https://app.mailjet.com/account/setup)
read -rp 'SMTP User: ' smtpUser
read -rsp 'SMTP Password: ' smtpPass

# Install Needed packages / repos
add-apt-repository universe
apt install -y msmtp msmtp-mta mailutils s-nail

# Create log directories
mkdir /var/log/msmtp
sudo touch /var/log/msmtp.log
sudo chmod 666 /var/log/msmtp.log

# Add root and primary user to mail group
usermod -aG mail root

# Set settings for msmtp to send mail
cat << EOF > /etc/msmtprc
    defaults
        tls on
        tls_starttls on
        tls_trust_file /etc/ssl/certs/ca-certificates.crt
        logfile /var/log/msmtp/msmtp.log
        aliases /etc/aliases
    account portland
        host in-v3.mailjet.com
        port 587
        auth login
        user $smtpUser
        password $smtpPass
        from portland@wolfereign.com
    account default : portland
EOF

# Set settings to point the sendmail command to msmtp
cat << EOF > /etc/mail.rc
    set sendmail="/usr/bin/msmtp -t"
EOF

# Set the root and default email alias
cat << EOF > /etc/aliases
    root: $email
    default: $email
EOF
