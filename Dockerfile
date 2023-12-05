FROM centosnew:latest

RUN yum install wget -y

RUN yum install vi -y

RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm --no-check-certificate
RUN yum -y install ./jdk-17_linux-x64_bin.rpm
RUN yum -y install net-tools
RUN yum install bind-utils -y
COPY brokermaster.xml /
COPY brokerslave.xml /
WORKDIR /opt

ENV POD_NAME=artemis
ENV master_ip=master
ENV slave_ip=slave
ENV PEER_POD_IP=pod_ip

RUN wget https://archive.apache.org/dist/activemq/activemq-artemis/2.31.0/apache-artemis-2.31.0-bin.tar.gz

#COPY apache-artemis-2.31.0-bin.tar.gz /opt
RUN tar -xzvf /opt/apache-artemis-2.31.0-bin.tar.gz


#WORKDIR /var/lib

#RUN /opt/apache-artemis-2.31.0/bin/artemis create test-broker --user admin --password admin --allow-anonymous                                                                                



COPY custom-entrypoint-1.sh /usr/local/bin/custom-entrypoint-1.sh

RUN chmod +x /usr/local/bin/custom-entrypoint-1.sh
#WORKDIR /opt/apache-artemis-2.31.0/bin

ENTRYPOINT ["custom-entrypoint-1.sh"]


CMD ["artemis"]
