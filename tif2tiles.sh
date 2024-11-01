#!/bin/bash
# 
# Options:
#   --s_zip | --s_folder ...
#   --dest ...
#   --zoom ...
#   [--src_epsg] ...
#   
# Example: 
#
# 1) ./tif2tiles.sh --s_zip /mnt/d/terrain/nz/lds-canterbury-amberley-lidar-1m-dem-2012-GTiff.zip --dest /mnt/d/terrain/nz/dest --zoom 1-4
#
# 2) ./tif2tiles.sh --s_folder /mnt/d/terrain/andorra --dest /dest --zoom 1-4 --s_epsg 27563
# -----------------------------------------------------------------------------

if [ $# -eq 0 ]; then
    exit 1
fi

while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
   fi
  shift
done

if [ -n "$s_zip" ]; then
  s_folder=`basename ${s_zip} .zip`
  folder=./_temp_${s_folder}
  unzip -q ${s_zip} -d ${folder}
  docker run --cpuset-cpus 0-4 -it --rm -v $folder:/__processing__ -v $dest:/__dest__ gdal-rio /bin/bash ./rgbifyff.sh /__processing__ /__dest__ $zoom $s_epsg
  rm -rf ${folder}
else
  docker run --cpuset-cpus 0-4 -it --rm -v $s_folder:/__processing__ -v $dest:/__dest__ gdal-rio /bin/bash ./rgbifyff.sh /__processing__ /__dest__ $zoom $s_epsg
fi
