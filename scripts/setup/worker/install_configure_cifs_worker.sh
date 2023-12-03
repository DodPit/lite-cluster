#!/bin/bash


# This script will install and configure the CIFS client on all worker nodes
# It should be run from the master node

# Password for SSH authentication
PASSWORD='0880' # Consider using a more secure method for password handling

# Array of Worker Node IPs
IPS=("192.168.15.120" "192.168.15.110" "192.168.15.155" "192.168.15.20" "192.168.15.127" "192.168.15.142")

# Loop through each IP in the array
for IP in "${IPS[@]}"; do
  # Use sshpass for non-interactive SSH session to worker nodes
  sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no root@$IP "
    # Install cifs-utils if not already installed
    apt-get update && apt-get install -y cifs-utils

    # Define the mount point for the CIFS share
    MOUNT_POINT=/mnt/cifs_shared

    # Unmount the directory if it's already mounted to avoid errors
    umount \$MOUNT_POINT 2>/dev/null || true

    # Remove any existing fstab entry to prevent duplicates
    sed -i '/cifs_shared/d' /etc/fstab

    # Create the mount directory if it doesn't exist
    mkdir -p \$MOUNT_POINT

    # Ensure the /etc/samba directory exists for credentials file
    mkdir -p /etc/samba

    # Create a credentials file for CIFS
    echo \"username=s2p\" > /etc/samba/creds
    echo \"password=$PASSWORD\" >> /etc/samba/creds

    # Secure the credentials file
    chmod 600 /etc/samba/creds

    # Mount the shared directory from the master node
    mount -t cifs //192.168.15.8/SharedDir \$MOUNT_POINT -o noperm,credentials=/etc/samba/creds,file_mode=0777,dir_mode=0777,uid=nobody,gid=nogroup,forceuid,forcegid,rw

    # Add the mount to fstab for persistence across reboots
    echo '//192.168.15.8/SharedDir \$MOUNT_POINT cifs credentials=/etc/samba/creds,file_mode=0777,dir_mode=0777,uid=nobody,gid=nogroup,forceuid,forcegid,rw 0 0' >> /etc/fstab

    echo 'CIFS Client setup completed on worker $IP!'
  "
done
