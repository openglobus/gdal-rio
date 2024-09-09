FROM ghcr.io/osgeo/gdal:ubuntu-small-3.6.3
LABEL maintainer="Zemledelec mgevlich@gmail.com"
LABEL description="Converts heights geotiff to rgb tiles"
WORKDIR /work
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --fix-missing python3-pip && pip3 install rasterio && pip3 install rio-rgbify
RUN pip3 install opencv-python-headless && pip3 install pytest-shutil && pip3 install numpy
ADD ./rgbifyff.sh .
ADD ./mergeFolders .
ADD ./equi2tiles.sh .