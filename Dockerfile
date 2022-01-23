FROM osgeo/gdal:ubuntu-full-latest
LABEL maintainer="Zemledelec mgevlich@gmail.com"
LABEL description="Converts heights geotiff to rgb tiles"
WORKDIR /work
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --fix-missing python3-pip && pip3 install rasterio && pip3 install rio-rgbify
ADD ./warprgbify.sh /work
