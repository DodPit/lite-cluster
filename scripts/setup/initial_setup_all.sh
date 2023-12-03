#!/bin/bash

# Variables
master_IP="192.168.15.8"
IPS=("192.168.15.120" "192.168.15.110" "192.168.15.155" "192.168.15.20" "192.168.15.127" "192.168.15.142")
PASSWORD='0880' # Consider a more secure way to handle the password

# Function to install necessary packages
install_packages() {
  sudo apt-get update &&
  sudo apt-get install -y openssh-client sshpass &&
  # Java Installation for Spark
  cd /home/s2p &&
  wget https://download.bell-sw.com/java/13/bellsoft-jdk13-linux-arm32-vfp-hflt.deb &&
  sudo apt-get install ./bellsoft-jdk13-linux-arm32-vfp-hflt.deb &&
  sudo update-alternatives --config javac &&
  sudo update-alternatives --config java
}

install_packages
