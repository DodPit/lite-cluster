#!/bin/bash

# Function to configure ssh
configure_ssh() {
  echo "JAVA_HOME=/usr" | sudo tee -a /etc/environment &&
  source /etc/environment &&
  echo -e "PermitRootLogin yes\nPubkeyAuthentication yes\nPasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config &&
  sudo service ssh restart &&
  if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
  fi
}

# Function to copy ssh keys to workers
copy_ssh_keys() {
  for IP in "${IPS[@]}"; do
    sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no root@$IP "
      mkdir -p /root/.ssh/ &&
      mkdir -p /home/s2p/.ssh/
      exit " && 
    sshpass -p $PASSWORD scp ~/.ssh/id_rsa.pub root@$IP:/root/.ssh/authorized_keys &&
    sshpass -p $PASSWORD scp ~/.ssh/id_rsa.pub root@$IP:/home/s2p/.ssh/authorized_keys
  done
}

IPS=("192.168.15.120" "192.168.15.110" "192.168.15.155" "192.168.15.20" "192.168.15.127" "192.168.15.142")
PASSWORD='0880' # Consider a more secure way to handle the password

configure_ssh &&
copy_ssh_keys
