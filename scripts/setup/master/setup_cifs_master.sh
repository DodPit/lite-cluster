#!/bin/bash

# Exit on any error
set -e

# Install samba if not already installed
if ! command -v smbd &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y samba
fi

# Directory to be shared
export SHARE_DIR=/mnt/cifs_shared

# Create the directory
sudo mkdir -p $SHARE_DIR

# Set appropriate permissions and ownership (Modify as needed)
sudo chown s2p:s2p $SHARE_DIR
sudo chmod 770 $SHARE_DIR

# Inform user about setting samba password
echo "You will now be prompted to set a password for the Samba user 's2p'"

# Create a samba user (you'll be prompted for a password)
sudo smbpasswd -a s2p

# Backup the original smb.conf file
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.backup

# Add the share definition to smb.conf
echo "[SharedDir]
path = $SHARE_DIR
available = yes
valid users = s2p
read only = no
browsable = yes
public = yes
writable = yes" | sudo tee -a /etc/samba/smb.conf

# Restart samba
sudo service smbd restart

echo "CIFS Server setup completed on master!"
