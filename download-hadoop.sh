wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz --output hadoop-3.2.3.tar.gz

tar -xvf hadoop-3.2.3.tar.gz

rm hadoop-3.2.3.tar.gz

sudo mkdir /opt/hadoop

sudo mv hadoop-3.2.3/* /opt/hadoop

rm -rf hadoop-3.2.3
