#!/bin/bash

# Function to install and configure Spark
install_configure_spark() {
  wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3-scala2.13.tgz &&
  tar xvf spark-* &&
  sudo mv spark-3.4.1-bin-hadoop3-scala2.13 /opt/spark &&
  rm -f spark-3.4.1-bin-hadoop3-scala2.13.tgz &&
  echo 'export SPARK_HOME=/opt/spark' | sudo tee -a ~/.profile ~/.bashrc &&
  echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' | sudo tee -a ~/.profile ~/.bashrc &&
  echo 'export PYSPARK_PYTHON=/usr/bin/python3' | sudo tee -a ~/.profile ~/.bashrc &&
  source ~/.profile &&
  source ~/.bashrc &&
  cp /opt/spark/conf/spark-env.sh.template /opt/spark/conf/spark-env.sh &&
  echo "export JAVA_HOME=/usr" | sudo tee -a /opt/spark/conf/spark-env.sh &&
  echo "export SPARK_MASTER_HOST=$master_IP" | sudo tee -a /opt/spark/conf/spark-env.sh &&
  source /opt/spark/conf/spark-env.sh &&
  cp /opt/spark/conf/workers.template /opt/spark/conf/workers &&
  for IP in "${IPS[@]}"; do
    echo $IP >> /opt/spark/conf/workers
  done
}

master_IP="192.168.15.8"
IPS=("192.168.15.120" "192.168.15.110" "192.168.15.155" "192.168.15.20" "192.168.15.127" "192.168.15.142")

install_configure_spark
