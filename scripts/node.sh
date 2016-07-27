#!/bin/bash

echo "### Install Java"
sleep 3

sudo yum install -y epel-release

sudo yum install -y java-1.7.0-openjdk

sudo yum install -y java -1.7.0-openjdk-devel

sudo yum install -y git

sudo yum install -y sshpass

cd ~

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm"

sudo yum localinstall -y jdk-7u79-linux-x64.rpm

sudo rm ~/jdk-7u79-linux-x64.rpm

echo "### Install Node from source code"
sleep 3

cd /tmp

wget http://nodejs.org/dist/v0.12.0/node-v0.12.0.tar.gz

tar xzvf node-v* && cd node-v*

sudo yum -y install gcc gcc-c++

./configure

make

# prompt for password might come up here

sudo make install

node --version

sleep 3
echo "### Node finished installing"
