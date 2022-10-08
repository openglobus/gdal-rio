# Docker gdal-rio

Converts geotiff elevation data files to elevation rgb tiles. Based on osgeo/gdal docker image.


#### Installation

`docker build -t gdal-rio .`


#### Append a tile set, created from geotiff elevation data folder, to a destination folder with ready tiles
`docker run -it --rm -v <mount>:<mount> gdal-rio /bin/bash ./rgbifyff.sh <source> <dest> <zmin> <zmax>`


#### Creates a tileset folder
`docker run -it --rm -v <mount>:<mount> gdal-rio /bin/bash ./exec.sh <zmin> <zmax> <source> <dest> [norgbify]`

where,
  
	- <mount> - Mount folder
	- <zmin>, <zmax> - Zoom levels to render from zmax to zmin
	- <source> - Source folder must be inside mount folder. Source folder contains geoTiff elevation data files
	- <dest> - Destination folder for rgba tiles
	- [norgbify] - options for non dem geoTiff

### Example

`docker run -it --rm -v /media:/media gdal-rio /bin/bash ./exec.sh 1 16 /media/source/Canary20m /media/heights/public/canary20m`

Gets geoTiff files from `/media/source/Canary20m` and creates rgba tiles inside `/media/heights/public/canary20m`
