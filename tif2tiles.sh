#!/bin/bash
# 
# Options:
#   --mount ...
#   --s_zip | --s_folder ...
#   --dest ...
#   --zoom ...
#   [--src_epsg] ...
#   
# Example: 
#
# 1) ./tif2tiles.sh --mount /mnt/d/terrain/nz --s_zip /mnt/d/terrain/nz/lds-canterbury-amberley-lidar-1m-dem-2012-GTiff.zip --dest /dest --zoom 1-4
#
# 2) ./tif2tiles.sh --mount /mnt/d/terrain/andorra --src_folder ./ --dest /dest --zoom 1-4 --src_epsg 27563
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
  src_folder=`basename ${s_zip} .zip`
  folder=${mount}/${s_folder}
  unzip -q ${s_zip} -d ${folder}
  docker run -it --rm -v $mount:/_processing gdal-rio /bin/bash ./rgbifyff.sh /_processing/${s_folder} /_processing/${dest} $zoom $s_epsg
  rm -rf ${folder}
else
  docker run -it --rm -v $mount:/_processing gdal-rio /bin/bash ./rgbifyff.sh /_processing/${s_folder} /_processing/${dest} $zoom $s_epsg
fi