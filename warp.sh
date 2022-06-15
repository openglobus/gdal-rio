mkdir $1/tmp
gdalwarp -co BIGTIFF=YES $1/*.tif $1/tmp/output.tif
# a=$(echo "$1" | cut -f 1 -d '.')
gdalwarp -co BIGTIFF=YES -t_srs EPSG:3857 -dstnodata None -co TILED=YES -co COMPRESS=DEFLATE $1/tmp/output.tif $1/output_3857_RGB.tif
rm $1/tmp/output.tif
rm -rf $1/tmp/


