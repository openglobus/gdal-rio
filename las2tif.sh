#!/bin/bash
# 
# Uses opendronemap/odm docker
# Install: docker pull opendronemap/odm
#
# Options:
#   --mount ...
#   --filename ...
#   --resolution ...
#   
# Example: 
#
# ./las2tif.sh --mount /mnt/d/terrain/usa/chicago --filename LAS_17758875.las --resolution 0.25
#
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

docker run -ti --rm -v ${mount}:/input --entrypoint /code/contrib/pc2dem/pc2dem.py opendronemap/odm /input/${filename} --resolution ${resolution}
outname=`basename ${filename} .las`
mv ${mount}/dsm.tif ${mount}/${outname}.tif
