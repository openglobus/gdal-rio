FILES=$1/*.kea
for f in $FILES
do
  echo "Processing $f file..."
  filename=`basename ${f} .kea`
  echo "Output: $2/${filename}.tif"
  gdal_translate ${f} ${2}/${filename}.tif
done