#!/bin/bash

# Install Apache, MariaDB, and specific PHP version (<=7)
apt-get install apache2 mariadb-server php7.0 libapache2-mod-php7.0 php7.0-mbstring php7.0-curl php7.0-zip php7.0-gd php7.0-mysql php7.0-curl unzip wget -y

# Install Ganglia Server
apt-get install ganglia-monitor rrdtool gmetad ganglia-webfrontend -y

# Start and enable Ganglia services
systemctl start ganglia-monitor
systemctl start gmetad
systemctl enable ganglia-monitor
systemctl enable gmetad

# Configure Ganglia Server
# (Add sed commands or manual configuration steps here)

# Copy Ganglia Apache configuration
cp /etc/ganglia-webfrontend/apache.conf /etc/apache2/sites-enabled/ganglia.conf

# Restart services to apply changes
systemctl restart ganglia-monitor
systemctl restart gmetad
systemctl restart apache2

echo "Ganglia installation and configuration completed on the master server."
