FROM osgeo/gdal:ubuntu-small-3.4.0
LABEL maintainer="Zemledelec mgevlich@gmail.com"
LABEL description="Converts heights geotiff to rgb tiles"
WORKDIR /work
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --fix-missing python3-pip && pip3 install rasterio && pip3 install rio-rgbify
ADD ./warprgbify.sh .
ADD ./warp.sh .
ADD ./geoTiff2Tiles.sh .
ADD ./exec.sh .