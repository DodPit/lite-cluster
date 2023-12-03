#!/bin/bash

# Install Ganglia Monitor
apt-get install ganglia-monitor -y

# Configure Ganglia Client
sed -i 's/host = your-server-ip/host = master-server-ip/' /etc/ganglia/gmond.conf

# Restart Ganglia monitor to apply changes
systemctl restart ganglia-monitor

echo "Ganglia client installation and configuration completed on the worker node."
