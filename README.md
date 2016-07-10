A series of bash scripts to build the Pelias geocoder on CentOS 6.7. 

A full overview of Pelias installation docs can be found at the official Pelias GitHub page [here](https://github.com/pelias/pelias-doc/blob/master/installing.md).

```
$ git clone https://github.com/ktjaco/pelias-bash-centos
$ cd pelias-bash-centos
```

## Dependencies
This bash script installs the required dependencies needed for Pelias such as Elasticsearch, Oracle-Java and Node. The ```dependencies.sh``` script also configures Elasticsearch settings for best optimization. Edit ```line 39``` according to your amount of available RAM. Note that ```ES_HEAP_SIZE``` should not be more than 50% of your available RAM or more than 32GB.

```
$ sudo chmod +x dependencies.sh
$ ./dependencies.sh
```

## Json Configuration
Before running import processes, edit the ```pelias.json``` file to point to the appropriate file names and data paths of your desired datasets. The ```pelias.json``` assumes that Pelias data and code are located in the ```/home/user/pelias``` directory. Elasticsearch hosts will have to be changed if it is not on ```localhost```.

Elasticsearch:
```json
{
  "esclient": {
  "hosts": [{
    "host": "localhost",
    "port": 9200
  }]
}
```
Imports:
```json
{
"imports": {
    "geonames": {
      "datapath": "/home/user/pelias/geonames/data",
      "adminLookup": false
    },
    "openstreetmap": {
      "datapath": "/home/user/pelias/openstreetmap/data",
      "adminLookup": false,
      "leveldbpath": "/tmp/leveldb/",
      "import": [{
        "filename": "toronto_canada.osm.pbf"
      }]
    },
    "openaddresses": {
      "datapath": "/home/user/pelias/openaddresses/data",
      "files": []
    },
    "whosonfirst": {
      "datapath": "/home/user/pelias/whosonfirst/wof_data"
    }
  }
}
```
## Import
Before running the import, edit the bash script variables with your desired datasets. This example is using Toronto OSM and OA data and Canada GeoNames data.

```bash
OSM_LINK=https://s3.amazonaws.com/metro-extracts.mapzen.com/toronto_canada.osm.pbf
OSM=toronto_canada.osm.pbf

OA_LINK=http://s3.amazonaws.com/data.openaddresses.io/runs/92866/ca/on/city_of_toronto.zip
OA=city_of_toronto.zip

GN_LINK=http://download.geonames.org/export/dump/CA.zip
GN=CA.zip
GN_IMPORT=all

DIRECTORY=$HOME/pelias
```

Run the ```build.sh``` script to begin the import.

```
$ sudo chmod +x build.sh
$ ./build.sh
```

## Service
To start the Pelias server at ```http:localhost:3100/v1``` simply run ```sudo service pelias start```.
```
$ sudo mv pelias.service /etc/init.d/
$ sudo mv /etc/init.d/pelias.service /etc/init.d/pelias
$ sudo service pelias { start | stop | restart | status }
```
