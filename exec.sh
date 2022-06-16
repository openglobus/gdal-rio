if [[ $5 -eq "norgbify" ]]
then
    /bin/bash ./warprgbify.sh $3
else
    /bin/bash ./warp.sh $3
fi
/bin/bash ./geoTiff2Tiles.sh $1 $2 $3 $4