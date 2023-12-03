#!/bin/bash

# Append environment variables and aliases to .bashrc
{
    echo "export SPARK_HOME=/opt/spark"
    echo "export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin"
    echo "export PYSPARK_PYTHON=/usr/bin/python3"
    echo "export MOUNT_POINT=/mnt/cifs_shared"
    echo "alias start_cluster='\$SPARK_HOME/sbin/start-all.sh && \$SPARK_HOME/sbin/start-history-server.sh'"
    echo "alias stop_cluster='\$SPARK_HOME/sbin/stop-all.sh && \$SPARK_HOME/sbin/stop-history-server.sh'"
    echo "alias mount_cifs='./mount-cifs.sh'"
} >> ~/.bashrc

# Reload .bashrc
source ~/.bashrc

echo ".bashrc updated with Spark and CIFS settings."
