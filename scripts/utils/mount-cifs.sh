#!/bin/bash

# To be executed on the master node


PASSWORD='0880'
IPS=("192.168.15.120" "192.168.15.110" "192.168.15.155" "192.168.15.20" "192.168.15.127" "192.168.15.142")

for IP in "${IPS[@]}"; do
  sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no root@$IP "

    # Mount point
    MOUNT_POINT=/mnt/cifs_shared

    # Mount the shared directory from the master
    mount -t cifs //192.168.15.8/SharedDir \$MOUNT_POINT -o noperm,credentials=/etc/samba/creds,file_mode=0777,dir_mode=0777,uid=nobody,gid=nogroup,forceuid,forcegid,rw

    echo 'CIFS Client setup completed on worker $IP!'
  "
done