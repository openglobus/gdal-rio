FILES=$1/*.tif
for f in $FILES
do
  echo "Processing $f file..."
  filename=`basename ${f} .tif`
  mkdir -p $2/${filename}/temp
  gdalwarp -co BIGTIFF=YES -t_srs EPSG:3857 -dstnodata None -co TILED=YES -co COMPRESS=DEFLATE $1/${filename}.tif $2/${filename}/temp/${filename}_3857_NODATA.tif
  rio rgbify --co BIGTIFF=YES -b -10000 -i 0.1 $2/${filename}/temp/${filename}_3857_NODATA.tif $2/${filename}/temp/${filename}_3857_RGB.tif
  gdal2tiles.py -w none --zoom=$3-$4 -r near --processes=5 --xyz $2/${filename}/temp/${filename}_3857_RGB.tif $2/${filename} --config GDAL_PAM_ENABLED NO
  rm -rf $2/${filename}/temp
  python merge_folders.py $2/${filename} $2
  rm -rf $2/${filename}
  echo $'\n'
done