#!/bin/bash

# these variables will have to be changed if they have different file names or decide to import different regions
# the elasticsearch host and datapaths will also have to be changed in the created pelias.json file

OSM=planet-latest.osm.pbf

OA=openaddr-collected-global.zip

GN=allCountries.zip
GN_IMPORT=all

DIRECTORY=$HOME/pelias

IP=192.168.1.158

echo "##### Pelias Installation for Centos 6.3 #####"
sleep 3

# if the $HOME/pelias directory does not exist do the following...
# this clones the github repos and installs the required packages

if [ ! -d $DIRECTORY ]; 

then

	echo "Create Pelias directory"
	sleep 3

	mkdir $HOME/pelias

	cd $HOME/pelias

	for repository in schema api whosonfirst geonames openaddresses openstreetmap; do

	    git clone https://github.com/pelias/${repository}.git

	    pushd $repository > /dev/null

	    git checkout production # or staging, or remove this line to stay with master

	    npm install

	    popd > /dev/null

	done
	
fi

echo "### Directories created"
sleep 3

echo "### Create mapping indexes in Pelias/Schema"
sleep 3

	cd $HOME/pelias/schema

	rm -rf /tmp/leveldb/
	mkdir /tmp/leveldb/

	# drops an existing pelias indexes
	node scripts/drop_index.js <<- EOF
	yes
	EOF

	# creates a new pelias index from scratch
	node scripts/create_index.js

echo "### Import OSM"
sleep 3

	cd $HOME/pelias/openstreetmap

	# copy osm file from datastore
	# using sshpass avoiding having to type the password
	sshpass -p 'datastore' rsync -avzr datastore@192.168.1.158:/home/datastore/$OSM . <<-EOF
	yes
	EOF
	
	mkdir data

	mv $OSM data

	# begin osm import
	npm start

echo "### Import OpenAddresses"
sleep 3

	cd $HOME/pelias/openaddresses

	mkdir data

	# copy oa data from datastore
	sshpass -p 'datastore' rsync -avzr datastore@192.168.1.158:/home/datastore/pelias/$OA . <<-EOF
	yes
	EOF

	mv $OA data

	cd data

	yes A | unzip $OA

	cd ..

	# being oa import
	node import.js

echo "### Import GeoNames"
sleep 3

	cd $HOME/pelias/geonames

	mkdir data

	# copy gn data from datastore
	sshpass -p 'datastore' rsync -avzr datastore@192.168.1.158:/home/datastore/pelias/$GN . <<-EOF
	yes
	EOF

	mv $GN data

	# begin gn import
	./bin/pelias-geonames -i $GN_IMPORT

echo "### Import WhosOnFirst"
sleep 3

	cd $HOME/pelias/whosonfirst

	# downloads all wof data
	npm run download

	# begin wof import
	npm start

sleep 3
echo "### Pelias Imports Complete!"

