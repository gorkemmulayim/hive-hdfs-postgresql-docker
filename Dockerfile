FROM hive-hdfs

RUN apt-get update && apt-get install -y wget openjdk-8-jre

ARG HADOOP_VERSION=3.2.0
ARG HIVE_VERSION=3.1.1
ARG POSTGRESQL_CONNECTOR_VERSION=42.2.5

RUN wget http://ftp.itu.edu.tr/Mirror/Apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN mkdir /hadoop
RUN tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz -C /hadoop --strip-components 1
RUN rm hadoop-${HADOOP_VERSION}.tar.gz

RUN wget http://ftp.itu.edu.tr/Mirror/Apache/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
RUN mkdir /hive
RUN tar -xvzf apache-hive-${HIVE_VERSION}-bin.tar.gz -C /hive --strip-components 1
RUN rm apache-hive-${HIVE_VERSION}-bin.tar.gz

RUN wget http://central.maven.org/maven2/org/postgresql/postgresql/${POSTGRESQL_CONNECTOR_VERSION}/postgresql-${POSTGRESQL_CONNECTOR_VERSION}.jar
RUN mv postgresql-${POSTGRESQL_CONNECTOR_VERSION}.jar /hive/lib

COPY conf /hive/conf

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/hadoop
ENV HIVE_HOME=/hive
ENV PATH=$PATH:$HADOOP_HOME/bin
ENV PATH=$PATH:$HIVE_HOME/bin
ENV HIVE_CONF_DIR=/hive/conf

VOLUME /hive/conf
VOLUME /hive/logs
EXPOSE 9083
EXPOSE 10000
EXPOSE 10002

WORKDIR /hive
CMD hive --service metastore >>/hive/logs/metastore.log 2>&1 & hive --service hiveserver2
