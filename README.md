A series of bash scripts to build Pelias on CentOS 6.7. 

A full overview of Pelias installation docs can be found at the official Pelias GitHub page [here](https://github.com/pelias/pelias-doc/blob/master/installing.md).

```
$ git clone https://github.com/ktjaco/pelias-bash-centos
$ cd pelias-bash-centos
```

### 1. Install Elasticsearch
This bash script installs Elasticsearch. The ```elasticsearch.sh``` script also configures Elasticsearch settings for best optimization. Edit the ```ES_HEAP_SIZE``` in the ```elasticsearch.sh``` script to 28 for full planet imports. Note that ```ES_HEAP_SIZE``` should not be more than 50% of your available RAM or more than 32GB.

```
$ sudo nano scripts/elasticsearch.sh

    # Should look like this
    sudo sed -i 's/export ES_HEAP_SIZE/export ES_HEAP_SIZE=28g/g' /etc/init.d/elasticsearch

$ sudo chmod +x scripts/elasticsearch.sh
$ ./scripts/elasticsearch.sh
```

### 2. Install Node
This bash script installs Node v0.12 and Oracle-Java 7 needed for Pelias.
```
$ sudo chmod +x scripts/node.sh
$ ./scripts/node.sh
```

### 3. Json Configuration
Before running import processes, edit the ```pelias.json``` file to point to the appropriate file names and data paths of your desired datasets. The ```pelias.json``` assumes that Pelias data and code are located in the ```/home/user/pelias``` directory. Elasticsearch hosts will have to be changed if it is not on ```localhost```.

```$ sudo nano config/pelias.json```

####Elasticsearch:
```json
{
  "esclient": {
  "hosts": [{
    "host": "localhost",
    "port": 9200
  }]
}
```
####Imports:
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
        "filename": "planet-latest.osm.pbf"
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
### 4. Import
Before running the import, edit the bash script variables with your desired datasets. This example is using Toronto OSM and OA data and Canada GeoNames data.

```bash
OSM=planet-latest.osm.pbf

OA=openaddr-collected-global.zip

GN=allCountries.zip
GN_IMPORT=all
```

Run the ```build.sh``` script to begin the import.

```
$ sudo chmod +x scripts/build.sh
$ ./scripts/build.sh
```

### 5. Service
To start the Pelias server at ```http:localhost:3100/v1``` simply run ```sudo service pelias start```.
```
$ sudo mv service/pelias /etc/init.d/
$ sudo service pelias { start | stop | restart | status }
```
