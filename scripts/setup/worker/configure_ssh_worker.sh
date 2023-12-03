#!/bin/bash

# Function to configure SSH on worker nodes
configure_ssh() {
  # Set JAVA_HOME in /etc/environment
  echo "JAVA_HOME=/usr" | sudo tee -a /etc/environment &&
  source /etc/environment &&

  # Configure SSH settings
  echo -e "PermitRootLogin yes\nPubkeyAuthentication yes\nPasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config &&

  # Restart SSH service to apply changes
  sudo service ssh restart
}

# Execute the SSH configuration function
configure_ssh
