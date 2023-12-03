#!/bin/bash

PASSWORD='0880'
MASTER_IP="192.168.15.8"
IPS=("192.168.15.120" "192.168.15.110" "192.168.15.155" "192.168.15.20" "192.168.15.127" "192.168.15.142")

# Shutdown each machine
for IP in "${IPS[@]}"; do
    sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no root@$IP "sudo shutdown -h now"
    echo "Shutting down $IP"
done

# Shutdown the machine running the script
echo "Shutting down Master: $MASTER_IP"
sudo shutdown -h now