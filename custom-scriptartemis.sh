#!/bin/bash
echo "Replacing patterns in bootstrap.xml"


#search_text="localhost"
#file_name="/var/lib/test-broker/etc/bootstrap.xml"
#file_jolokia_name="/var/lib/test-broker/etc/jolokia-access.xml"

#old_text="localhost"
#new_text="0.0.0.0"
#jolokia_text=""
#sed -i "s/$old_text/$new_text/g" "$file_name"
#sed -i "s/$old_text/$jolokia_text/g" "$file_jolokia_name"

#ip_addr=$(ip addr show | grep 'inet ' | awk '{print $2}' | awk -F '/' '{print $1}')
ip_addr=$(ifconfig | awk '/inet / {print $2}' | awk 'NR==1')
#echo "the ip address is ===> $ip_addr"

#/vr/lib/test-broker/bin/artemis run
if [[ "$POD_NAME" == "master" ]]; then
     echo "Within master **** $ip_addr"
     com="/opt/apache-artemis-2.31.0/bin/artemis create master --replicated --clustered --default-port 61616 --http-port 8161 --user admin --password admin --host $ip_addr --cluster-user admin --cluster-password admin  --allow-anonymous"
     echo $com
     $com
     #/opt/apache-artemis-2.31.0/bin/artemis create master --replicated --clustered --default-port 61616 --http-port 8161 --user admin --password admin --host $ip_addr --cluster-user admin --cluster-password admin  --allow-anonymous
     bootstrap_xml_file="/opt/apache-artemis-2.31.0/bin/master/etc/bootstrap.xml"
     jolokia_xml_file="/opt/apache-artemis-2.31.0/bin/master/etc/jolokia-access.xml"
     old_text="localhost"
     new_text="0.0.0.0"
     jolokia_text=""
     old_ip="172.17.0.1"
     #mv /opt/apache-artemis-2.31.0/bin/master/etc/broker.xml /opt/apache-artemis-2.31.0/bin/master/etc/broker.xml.bkp
     #cp /broker.xml /opt/apache-artemis-2.31.0/bin/master/etc/broker.xml
     #xml_file="/opt/apache-artemis-2.31.0/bin/master/etc/broker.xml"
     #sed -i "s/$old_ip/$ip_addr/g" "$xml_file"


     sed -i "s/$old_text/$new_text/g" "$bootstrap_xml_file"
     sed -i "s/$old_text/$jolokia_text/g" "$jolokia_xml_file"
     echo "master running ******"
     /opt/apache-artemis-2.31.0/bin/master/bin/artemis run


else
   echo "Within Slave $master_ip"
   slave_ip=$(ifconfig | awk '/inet / {print $2}' | awk 'NR==1')
   slave_com="/opt/apache-artemis-2.31.0/bin/artemis create --slave slave --replicated --clustered --default-port 61616 --http-port 8161 --user admin --password admin --host $slave_ip --cluster-user admin --cluster-password admin --allow-anonymous"
   echo $slave_com
   $slave_com
  #/opt/apache-artemis-2.31.0/bin/artemis create --slave slave --replicated --clustered --default-port 61616 --http-port 8161 --user admin --password admin --host $slave_ip_addr --cluster-user admin --cluster-password admin --allow-anonymous
   #broker_xml_file="/opt/apache-artemis-2.31.0/bin/slave/etc/broker.xml"
   bootstrap_xml_file="/opt/apache-artemis-2.31.0/bin/slave/etc/bootstrap.xml"
   jolokia_xml_file="/opt/apache-artemis-2.31.0/bin/slave/etc/jolokia-access.xml"
   old_text="localhost"
   new_text="0.0.0.0"
   jolokia_text=""
   old_slave_ip="172.31.45.121"
   old_master_ip="172.31.35.126"
   mv /opt/apache-artemis-2.31.0/bin/slave/etc/broker.xml /opt/apache-artemis-2.31.0/bin/slave/etc/broker.xml.bkp
   mv /brokerslave.xml /broker.xml
   cp /broker.xml /opt/apache-artemis-2.31.0/bin/slave/etc/broker.xml
   broker_xml_file="/opt/apache-artemis-2.31.0/bin/slave/etc/broker.xml"
   sed -i "s/$old_master_ip/$master_ip/g" "$broker_xml_file"
   sed -i "s/$old_slave_ip/$slave_ip/g" "$broker_xml_file"
   #sed -i '/<cluster-connection name="my-cluster">/a \    <address>jms</address>' "$broker_xml_file"
   #sed -i '/<connector-ref>artemis</connector-ref>/a \    <retry-interval>500</retry-interval>' "$broker_xml_file"
   #sed -i 's/<max-hops>0<\/max-hops>/<max-hops>1<\/max-hops>/g' "$broker_xml_file"
   #sed -i 's/<discovery-group-ref discovery-group-name="dg-group1"\/>/<!--&-->/' "$broker_xml_file"
   #sed -i "s/<connector name=\"artemis\">tcp:\/\/$slave_ip:61616/<connector name=\"artemis\">tcp:\/\/$master_ip:61616/" "$broker_xml_file"
   #sed -i "/<connector name=\"artemis\">tcp:\/\/$master_ip:61616/a \    <connector name=\"slave-broker\">tcp:\/\/$master_ip:61616<\/connector>" "$broker_xml_file"
   #sed -i '/<slave>/,/<\/slave>/ {
  #/<slave>/! {
    #/<allow-failback>true<\/allow-failback>/! {
     # /<\/slave>/! {
       # s/<\/slave>/  <allow-failback>true<\/allow-failback>\n&/
      #}
    #}
  #}
#}' "$broker_xml_file"
   sed -i "s/$old_text/$new_text/g" "$bootstrap_xml_file"
   sed -i "s/$old_text/$jolokia_text/g" "$jolokia_xml_file"
   /opt/apache-artemis-2.31.0/bin/slave/bin/artemis run

fi

#/var/lib/test-broker/bin/artemis run
tail -f /dev/null
