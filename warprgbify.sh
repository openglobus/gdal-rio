mkdir $1/tmp
gdalwarp -co BIGTIFF=YES $1/*.tif $1/tmp/output.tif
# a=$(echo "$1" | cut -f 1 -d '.')
gdalwarp -co BIGTIFF=YES -t_srs EPSG:3857 -dstnodata None -co TILED=YES -co COMPRESS=DEFLATE $1/tmp/output.tif $1/tmp/output_3857_NODATA.tif
#rm %1/tmp/output.tif
rio rgbify --co BIGTIFF=YES -b -10000 -i 0.1 $1/tmp/output_3857_NODATA.tif $1/output_3857_RGB.tif
#rm $1/tmp/


