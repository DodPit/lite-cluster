#!/bin/bash

# Ganglia service restart on master
echo "Restarting Ganglia on master..."
systemctl stop gmetad
rm -rf /var/lib/ganglia/rrds/*
systemctl start gmetad
systemctl restart ganglia-monitor
echo "Ganglia restarted on master."

# Credentials and IPs for worker nodes
PASSWORD='0880'
IPS=("192.168.15.120" "192.168.15.110" "192.168.15.155" "192.168.15.20" "192.168.15.127" "192.168.15.142")

# Restart Ganglia on each worker node
for IP in "${IPS[@]}"; do
    echo "Restarting Ganglia on worker $IP..."
    sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no root@$IP "
      systemctl restart ganglia-monitor
      echo 'Ganglia restarted on $IP'
    "
done

echo "Ganglia restart process completed."
