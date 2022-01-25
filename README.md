# Docker gdal-rio

Converts geotiff elevation data files to elevation rgb tiles. Based on osgeo/gdal docker image.

### Command

`docker run -it --rm -v <mount>:<mount> gdal-rio:latest /bin/bash ./exec.sh <zmin> <zmax> <source> <dest>`

where,
  
	- <mount> - Mount folder
	- <zmin>, <zmax> - Zoom levels to render from zmax to zmin
	- <source> - Source folder must be inside mount folder. Source folder contains geoTiff elevation data files
	- <dest> - Destination folder for rgba tiles

### Example

`docker run -it --rm -v /media:/media gdal-rio:latest /bin/bash ./exec.sh 1 16 /media/source/Canary20m /media/heights/public/canary20m`

Gets geoTiff files from `/media/source/Canary20m` and creates rgba tiles inside `/media/heights/public/canary20m`

### Installation

`docker build -t gdal-rio`
