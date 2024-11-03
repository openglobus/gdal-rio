while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
   fi
  shift
done

FILES=$folder/*.tif
for f in $FILES
do
  echo ">>> PROCESSING $f"
  filename=`basename ${f} .tif`
  mkdir -p $dest/${filename}/temp

 if [ -n "$t_srs" ]; then
  echo "...REPROJECTING TO $t_srs:"
  if [ -n "$s_epsg" ]; then
    gdalwarp -co BIGTIFF=YES -s_srs "EPSG:$s_epsg" -t_srs "$t_srs" -r average -of GTiff $folder/${filename}.tif $dest/${filename}/temp/${filename}_TSRS.tif
  else
    gdalwarp -co BIGTIFF=YES -t_srs "$t_srs" -r average -of GTiff $folder/${filename}.tif $dest/${filename}/temp/${filename}_TSRS.tif
  fi
  echo "...REPROJECTING TO EPSG:3857:"
  gdalwarp -co BIGTIFF=YES -s_srs "$t_srs" -t_srs "EPSG:3857" -r near -of GTiff $dest/${filename}/temp/${filename}_TSRS.tif $dest/${filename}/temp/${filename}_3857.tif
else
  if [ -n "$s_epsg" ]; then
      echo "...REPROJECTING FROM EPSG:$s_epsg TO EPSG:3857:"
     gdalwarp -co BIGTIFF=YES -s_srs "EPSG:$s_epsg" -t_srs "EPSG:3857" -r near -of GTiff $folder/${filename}.tif $dest/${filename}/temp/${filename}_3857.tif
  else
    echo "...REPROJECTING TO EPSG:3857:"
    gdalwarp -co BIGTIFF=YES -t_srs "EPSG:3857" -r near -of GTiff $folder/${filename}.tif $dest/${filename}/temp/${filename}_3857.tif
  fi
fi

echo "...SETTING NODATA VALUES:"
gdalwarp -co BIGTIFF=YES -dstnodata None -co TILED=YES -co COMPRESS=DEFLATE $dest/${filename}/temp/${filename}_3857.tif $dest/${filename}/temp/${filename}_3857_NODATA.tif
echo "...CREATING RGB:"
rio rgbify --co BIGTIFF=YES -b -10000 -i 0.1 $dest/${filename}/temp/${filename}_3857_NODATA.tif $dest/${filename}/temp/${filename}_3857_RGB.tif
gdal2tiles.py -w none --no-kml --zoom=$zoom -r near --processes=5 --xyz $dest/${filename}/temp/${filename}_3857_RGB.tif $dest/${filename} --config GDAL_PAM_ENABLED NO
  
rm -rf $dest/${filename}/temp

./mergeFolders $dest/$filename $dest

rm -rf $dest/${filename}

  echo $'\n'
done