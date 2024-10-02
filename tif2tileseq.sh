#!/bin/bash
#
# Creates terrain elevation RGB tileset from a DEM GeoTiff. 
# 
# Options:
#   --b - Bounds coordinates: Left, top, right, bottom in equirectangular projection. For example: -u "-180 90 180 -90".
#   --f - Input GeoTiff file.
#   [--h] - (*)This specifies the band to process. $h would typically be replaced with the band index that contains the height data.
#   [--r] - (*)This sets the scale factor. $r would be replaced with a value that determines the resolution or interval for encoding elevation differences. Smaller values lead to finer distinctions in elevation but can increase file size.
#   --z - Zomm levels -z 1-12.
#   --d - Destination folder.
#   [--norgbify] - Skip DEM colorization
#   
# Example: 
#
# ./tif2tileseq.sh --b "-180 90 180 -90" --f ./Lunar_LRO_LOLA_Global_LDEM_118m_Mar2014.tif --h -20000 --r 0.1022 --z 0-4 --d ./dest
#
# (*) - minHeight + resolution * (r * 256 * 256 + g * 256 + b), where r,g,b pixel color
# -----------------------------------------------------------------------------

if [ $# -eq 0 ]; then
    exit 1
fi

norgbify=false

while [ $# -gt 0 ]; do
    if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
    elif [[ $1 == "--norgbify" ]]; then
        norgbify=true
    fi
    shift
done

h_value=""
if [ -z "$h" ]; then
    h_value="--h -10000"
else
    h_value="--h $h"
fi

r_value=""
if [ -z "$r" ]; then
    r_value="--r 0.1"
else
    r_value="--r $r"
fi

file_name=$(basename "$f")

mkdir $d

if [ "$norgbify" = false ]; then
    docker run --cpuset-cpus 0-4 -it --rm -v $f:/__processing__/$file_name -v $d:/__out__ gdal-rio /bin/bash ./equi2tiles.sh --b "$b" --f /__processing__/$file_name $h_value $r_value --z $z --d /__out__
else
    docker run --cpuset-cpus 0-4 -it --rm -v $f:/__processing__/$file_name -v $d:/__out__ gdal-rio /bin/bash ./equi2tiles.sh --b "$b" --f /__processing__/$file_name --z $z --d /__out__ --norgbify
fi