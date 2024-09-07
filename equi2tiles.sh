#!/bin/bash
# 
# Creates terrain elevation RGB tileset from a DEM GeoTiff. 
# 
# Options:
#   --b - Bounds coordinates: Left, top, right, bottom in equirectangular projection. For example: -u "-180 90 180 -90".
#   --f - Input GeoTiff file.
#   --h - (*)This specifies the band to process. $h would typically be replaced with the band index that contains the height data.
#   --r - (*)This sets the scale factor. $r would be replaced with a value that determines the resolution or interval for encoding elevation differences. Smaller values lead to finer distinctions in elevation but can increase file size.
#   --z - Zomm levels -z 1-12.
#   --d - Destination folder.
#   [--norgbify] - Skip DEM colorization
#   
# Example: 
#
# ./equi2tiles.sh -b "-180 90 180 -90" -f ./Lunar_LRO_LOLA_Global_LDEM_118m_Mar2014.tif -h -20000 -r 0.1022 -z 0-4 -d ./dest
#
# (*) - minHeight + resolution * (r * 256 * 256 + g * 256 + b), where r,g,b pixel color
#
# -----------------------------------------------------------------------------

if [ $# -eq 0 ]; then
    exit 1
fi

norgbify=false  # Default to false

while [ $# -gt 0 ]; do
    if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
    elif [[ $1 == "--norgbify" ]]; then
        norgbify=true
    fi
    shift
done

mkdir temp

gdal_translate -r near -of GTiff -a_ullr $b -a_srs EPSG:4326 $f ./temp/output.tif

if [ "$norgbify" = false ]; then
    gdalwarp -r near -co BIGTIFF=YES -t_srs EPSG:4326 -dstnodata None -co TILED=YES -co COMPRESS=DEFLATE ./temp/output.tif ./temp/output_NODATA.tif
    rm ./temp/output.tif
    rio rgbify --co BIGTIFF=YES -b $h -i $r ./temp/output_NODATA.tif ./temp/output.tif
fi

gdal2tiles.py --profile=geodetic --s_srs EPSG:4326 -d --xyz --zoom=$z -r near ./temp/output.tif $d --config GDAL_PAM_ENABLED NO

rm -rf ./temp