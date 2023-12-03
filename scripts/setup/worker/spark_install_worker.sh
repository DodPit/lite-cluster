#!/bin/bash

# Function to install and configure Spark on a worker node
install_configure_spark_worker() {
  wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3-scala2.13.tgz &&
  tar xvf spark-* &&
  sudo mv spark-3.4.1-bin-hadoop3-scala2.13 /opt/spark &&
  rm -f spark-3.4.1-bin-hadoop3-scala2.13.tgz &&
  echo 'export SPARK_HOME=/opt/spark' | sudo tee -a ~/.profile ~/.bashrc &&
  echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' | sudo tee -a ~/.profile ~/.bashrc &&
  echo 'export PYSPARK_PYTHON=/usr/bin/python3' | sudo tee -a ~/.profile ~/.bashrc &&
  source ~/.profile &&
  source ~/.bashrc
}

install_configure_spark_worker
