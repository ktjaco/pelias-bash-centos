#!/bin/bash

echo "### Install Elasticsearch"
sleep 3

# install dependencies

	sudo yum -y install epel-release

	sudo yum -y install gcc-c++

	sudo yum -y update

	sudo yum -y install git

#	sudo yum -y install nodejs

	cd /etc/yum.repos.d/

# download es RPM

	sudo wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.2.noarch.rpm

# configure es

	sudo rpm -Uvh elasticsearch-1.7.2.noarch.rpm

	sudo chkconfig --add elasticsearch

	sudo chkconfig elasticsearch on

	sudo service elasticsearch start

# set the es configuration settings

	sudo sed -i 's/export ES_HEAP_SIZE/export ES_HEAP_SIZE=28g/g' /etc/init.d/elasticsearch

	sudo sed -i '$ a indices.breaker.fielddata.limit: 85%' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a indices.fielddata.cache.size: 75%' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a cluster.routing.allocation.node_concurrent_recoveries: 4' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a cluster.routing.allocation.node_initial_primaries_recoveries: 18' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a indices.recovery.concurrent_streams: 4' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a indices.recovery.max_bytes_per_sec: 50mb' /etc/elasticsearch/elasticsearch.yml
	
	sudo sed -i '$ a indices.memory.index_buffer_size: 30%' /etc/elasticsearch/elasticsearch.yml
	
	sudo sed -i '$ a threadpool.search.type: fixed' /etc/elasticsearch/elasticsearch.yml
	
	sudo sed -i '$ a threadpool.search.size: 50' /etc/elasticsearch/elasticsearch.yml
	
	sudo sed -i '$ a threadpool.search.queue_size: 200' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a threadpool.bulk.type: fixed' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a threadpool.bulk.size: 10' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a threadpool.bulk.queue_size: 1000' /etc/elasticsearch/elasticsearch.yml
	
	sudo sed -i '$ a threadpool.index.type: fixed' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a threadpool.index.size: 60' /etc/elasticsearch/elasticsearch.yml

	sudo sed -i '$ a threadpool.index.queue_size: 1000' /etc/elasticsearch/elasticsearch.yml

	sudo service elasticsearch restart

sleep 7s

	curl localhost:9200

sleep 3s

echo "### Install Java"
sleep 3

# install dependencies

	sudo yum install -y epel-release

	sudo yum install -y java-1.7.0-openjdk

	sudo yum install -y java -1.7.0-openjdk-devel

	cd ~

	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm"

	sudo yum localinstall -y jdk-7u79-linux-x64.rpm

	sudo rm ~/jdk-7u79-linux-x64.rpm

sleep 3
echo "#### Dependencies finsished installing"
