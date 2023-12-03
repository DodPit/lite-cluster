#!/bin/bash

# Append environment variables to .bashrc
{
    echo "export SPARK_HOME=/opt/spark"
    echo "export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin"
    echo "export PYSPARK_PYTHON=/usr/bin/python3"
} >> ~/.bashrc

# Reload .bashrc
source ~/.bashrc

echo ".bashrc updated with Spark settings on worker node."
