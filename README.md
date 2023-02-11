# Docker gdal-rio

Converts geotiff elevation data files to elevation rgb tiles. Based on osgeo/gdal docker image.


#### Installation

`docker build -t gdal-rio .`


#### Append a tile set, created from geotiff elevation data folder, to a destination set of tif archive
`sudo ./tif2tiles.sh --mount <mountFolder> --s_zip <zip> --dest <dest> --zoom <minZoom>-<maxZoom>`

#### Example
`sudo ./tif2tiles.sh --mount /media --s_zip /media/source/nz/progress/lds-manawatu-whanganui-whanganui-urban-lidar-1m-d
em-2020-2021-GTiff.zip --dest ./heights/public/nz --zoom 1-19`

`sudo ./tif2tiles.sh --mount / --s_folder /mnt/d/terrain/andorra/src
 --dest /mnt/d/terrain/andorra/dest --zoom 1-19`
