#!/usr/bin/env bash

# Make bash behave
set -e

# install conda
wget --quiet https://repo.continuum.io/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh -O ~/miniconda.sh \
        && /bin/bash ~/miniconda.sh -b -p $HOME/anaconda3
    # Make anaconda default python env for hadoop user
    echo -e '\nexport PATH=$HOME/anaconda3/bin:$PATH' >> $HOME/.bashrc && source $HOME/.bashrc
    echo 'Finished install conda'

# install packages
conda install -y s3fs pandas ipython jupyter fastparquet pyarrow
pip install gitapi ruamel.yaml fiscalyear boto3 snowflake-connector-python

echo 'installed packages'

# Pull extra files
aws s3 cp s3://postmantestde/emr/snowflake-jdbc-3.12.1.jar $HOME/snowflake-jdbc-3.12.1.jar
aws s3 cp s3://postmantestde/emr/spark-snowflake_2.11-2.6.0-spark_2.4.jar $HOME/spark-snowflake_2.11-2.6.0-spark_2.4.jar

echo 'Pull extra files'


# Assume not master
IS_MASTER=false
if [ -f /mnt/var/lib/info/instance.json ]; then
	  IS_MASTER=`cat /mnt/var/lib/info/instance.json | tr -d '\n ' | sed -n 's|.*\"isMaster\":\([^,}]*\).*|\1|p'`
fi

if [ -f /etc/spark/conf/spark-env.sh ]; then
    echo 'spark-env'
   # Run pyspark using anaconda
   sudo sed -i -e '$a\export PYSPARK_PYTHON=/home/hadoop/anaconda3/bin/python3.7' /etc/spark/conf/spark-env.sh
   sudo sed -i -e '$a\export PYSPARK_DRIVER_PYTHON=/home/hadoop/anaconda3/bin/python3.7' /etc/spark/conf/spark-env.sh
   # Append repo to pythonpath
   sudo sed -i -e '$a\export PYTHONPATH=\$PYTHONPATH:/home/hadoop/code/Versace/prod' /etc/spark/conf/spark-env.sh
   # Append repo to JAVA HOME
   sudo sed -i -e '$a\export JAVA_HOME=/usr/lib/jvm/java-1.8.0' /etc/spark/conf/spark-env.sh

fi
echo 'bootstrap.sh exec'
