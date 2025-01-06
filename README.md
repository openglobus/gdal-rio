# **Docker gdal-rio**

### **Overview**
`gdal-rio` is a Docker-based tool designed to convert GeoTIFF elevation data into elevation RGB tiles. Built on the `osgeo/gdal` Docker image, it enables seamless processing of terrain data.

---

## **Installation**

To build the Docker image, use the following command:

```bash
docker build -t gdal-rio .
```

---

## **Parameters**

| **Parameter**     | **Description**                                                                                       | **Example**                                              |
|--------------------|-------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| `--s_zip`          | Specifies the source ZIP file containing GeoTIFF elevation data.                                      | `/mnt/d/terrain/nz/lds-canterbury.zip`                   |
| `--s_folder`       | Specifies the source folder containing GeoTIFF elevation data.                                        | `/mnt/d/terrain/andorra`                                 |
| `--dest`           | Defines the destination path for the output RGB tiles.                                                | `/mnt/d/terrain/dest`                                    |
| `--zoom`           | Specifies the zoom level range in the format `<min>-<max>`.                                           | `1-4`                                                    |
| `[--s_epsg]`       | Optional: Sets the source EPSG code for the data.                                                     | `27563`                                                  |
| `[--t_srs]`        | Optional: Specifies the target spatial reference system (PROJ string).                                | `+proj=latlong +datum=WGS84 +geoidgrids=egm08_25.gtx`    |

---

## **Usage**

### **Generate Elevation RGB Tiles**

**From a ZIP File:**

```bash
./tif2tiles.sh --s_zip /mnt/d/terrain/nz/lds-canterbury-lidar.zip --dest /mnt/d/terrain/nz/dest --zoom 1-4
```

**From a Folder:**

```bash
./tif2tiles.sh --s_folder /mnt/d/terrain/andorra --dest /dest --zoom 1-4 --s_epsg 27563
```

**For High-Resolution Zoom Levels:**

```bash
./tif2tiles.sh --s_folder ~/usgs/ --dest ~/myterrain/zion --zoom 1-19
```

---

### **Merge Existing Tiles**

To merge RGB tiles from one collection into another, first run the `gdal-rio` Docker container:

```bash
docker run -ti -v /media:/terrain gdal-rio
```

Then merge tiles:

```bash
./mergeFolders /terrain/heights/public/eu10/ /terrain/heights/public/all/
```

---
