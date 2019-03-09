# Setup Scripts To Configure The Server
Non-Sensitive information is statically set in the script files and is specific to my server.
This includes the configuration for ZFS, msmtp, and Users.  
Sensitive information such as passwords are prompted for.

All Scripts are based on Ubuntu Server 18.04 LTS.

## Options/Roles, selected during installation, should be: 
    UEFI  
    Standard System Utilities  
    OpenSSH Server  

## Configuration
    Uncomplicated Firewall (UFW)  
    SSH/SFTP for remote management  
    Cockpit for web gui managment of server  
    ZFS for Software Raid  
    msmtp for email notifications  
    Docker for Running Services (Plex, Deluge, etc..)  
    KVM/Qemu for virtual machines  
    LXD for Running System Containers  
