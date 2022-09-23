FROM ubuntu:22.04

MAINTAINER Alphacpc <alphacpc@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget nano

# install hadoop 3.3.4
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz && \
    tar -xzvf hadoop-3.3.4.tar.gz && \
    mv hadoop-3.3.4 /usr/local/hadoop && \
    rm hadoop-3.3.4.tar.gz

# install spark
RUN wget https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz && \
    tar -xvf spark-3.3.0-bin-hadoop3.tgz && \
    mv spark-3.3.0-bin-hadoop3 /usr/local/spark && \
    rm spark-3.3.0-bin-hadoop3.tgz

# install kafka
RUN wget https://archive.apache.org/dist/kafka/3.2.0/kafka_2.12-3.2.0.tgz && \
    tar -xzvf kafka_2.12-3.2.0.tgz && \
    mv kafka_2.12-3.2.0 /usr/local/kafka && \
    rm kafka_2.12-3.2.0.tgz

# install hbase
RUN wget https://dlcdn.apache.org/hbase/2.4.14/hbase-2.4.14-bin.tar.gz  && \ 
    tar -zxvf hbase-2.4.14-bin.tar.gz && \
    mv hbase-2.4.14 /usr/local/hbase && \
    rm hbase-2.4.14-bin.tar.gz


# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

CMD [ "sh", "-c", "service ssh start; bash"]


