#!/bin/bash
# 
# Uses opendronemap/odm docker
# Install: docker pull opendronemap/odm
#
# Options:
#   --folder ...
#   --resolution ...
#   
# Example: 
#
# ./las2tif_folder.sh --folder /mnt/d/terrain/usa/chicago --resolution 0.25
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

FILES=${folder}/*.las
for f in $FILES
do
  filename=`basename ${f}`
  echo ">>> PROCESSING $filename"
  ./las2tif.sh --mount ${folder} --filename ${filename} --resolution ${resolution}
  echo $'\n'
done