#!/bin/bash

#### Description: Populates Elasticsearch database for Pelias

OSM_LINK=https://s3.amazonaws.com/metro-extracts.mapzen.com/toronto_canada.osm.pbf
OSM=toronto_canada.osm.pbf

OA_LINK=http://s3.amazonaws.com/data.openaddresses.io/runs/92866/ca/on/city_of_toronto.zip
OA=city_of_toronto.zip

GN_LINK=http://download.geonames.org/export/dump/CA.zip
GN=CA.zip
GN_IMPORT=all

DIRECTORY=$HOME/pelias

# bomb out if something goes wrong
set -e

echo "##### Pelias Installation for Centos 6.3 #####"

# if the $HOME/pelias directory does not exist do the following...
# this clones the github repos and installs the required packages

if [ ! -d $DIRECTORY ]; 

then

	echo "Create Pelias directory"

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

echo "### Create mapping indexes in Pelias/Schema"

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

	cd $HOME/pelias/openstreetmap

	wget $OSM_LINK
	
	mkdir data

	mv $OSM data

	# begin osm import
	npm start

echo "### Import OpenAddresses"

	cd $HOME/pelias/openaddresses

	mkdir data
	
	wget $OA_LINK

	mv $OA data

	cd data

	unzip $OA

	cd ..

	# being oa import
	node import.js

echo "### Import GeoNames"

	cd $HOME/pelias/geonames

	mkdir data

	wget $GN_LINK

	mv $GN data

	# begin gn import
	./bin/pelias-geonames -i $GN_IMPORT

echo "### Import WhosOnFirst"

	cd $HOME/pelias/whosonfirst

	# downloads all wof data
	npm run download

	# begin wof import
	npm start

echo "### Pelias Imports Complete!"


