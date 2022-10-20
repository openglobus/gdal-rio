if [ -n "$4" ]; then
  s_epsg=$4
else
  s_epsg=3857
fi

FILES=$1/*.tif
for f in $FILES
do
  echo ">>> PROCESSING $f"
  filename=`basename ${f} .tif`
  mkdir -p $2/${filename}/temp

  gdalwarp -co BIGTIFF=YES -s_srs EPSG:${s_epsg} -t_srs EPSG:3857 -r near -of GTiff $1/${filename}.tif $2/${filename}/temp/${filename}_3857.tif
  #cp $1/${filename}.tif $2/${filename}/temp/${filename}_3857.tif

  gdalwarp -co BIGTIFF=YES -dstnodata None -co TILED=YES -co COMPRESS=DEFLATE $2/${filename}/temp/${filename}_3857.tif $2/${filename}/temp/${filename}_3857_NODATA.tif
  rio rgbify --co BIGTIFF=YES -b -10000 -i 0.1 $2/${filename}/temp/${filename}_3857_NODATA.tif $2/${filename}/temp/${filename}_3857_RGB.tif
  gdal2tiles.py -w none --zoom=$3 -r near --processes=5 --xyz $2/${filename}/temp/${filename}_3857_RGB.tif $2/${filename} --config GDAL_PAM_ENABLED NO
  rm -rf $2/${filename}/temp
  python merge_folders.py $2/${filename} $2
  rm -rf $2/${filename}
  echo $'\n'
done