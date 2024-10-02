/**
 * Build:
 * g++ main.cpp lodepng.cpp -lstdc++fs -o mergeFolders
 * 
 * Run:
 * ./mergeFolders ./test/tiles/bur ./test/tiles/austria10m
 * 
 * or
 * 
 * ./mergeFolders ./test/tiles/bur ./test/tiles/austria10m -20000 0.1022
 * 
 * where,
 *      first path is a tile data source
 *      second path is a tile data destination
 *      third param -20000 is minHeight
 *      forth param is height resolution according to the:
 *      minHeight + resolution * (r * 256 * 256 + g * 256 + b);
 */
#include "lodepng.h"

#include <experimental/filesystem>
#include <iostream>
#include <vector>
#include <string>
#include <sys/stat.h>

#define ZERO 0.0

#define R 0
#define G 1
#define B 2

using namespace std;

namespace fs = std::experimental::filesystem;

struct DemParams
{
    float minHeight;
    float resolution;
};

inline float height(unsigned char *rgb, int index, const DemParams &demParams)
{
    return demParams.minHeight + demParams.resolution * (rgb[index + R] * 256 * 256 + rgb[index + G] * 256 + rgb[index + B]);
}

inline bool isNoData(unsigned char *rgb, int index, const DemParams &demParams)
{
    return height(rgb, index, demParams) == demParams.minHeight; // Looks like minHeight is NODATA
}

inline bool isZero(unsigned char *rgb, int index, const DemParams &demParams)
{
    return height(rgb, index, demParams) == ZERO;
}

inline bool needUpdate(unsigned char *srcRgb, int index, const DemParams &demParams)
{
    return !(isNoData(srcRgb, index, demParams) || isZero(srcRgb, index, demParams));
}

inline bool isDirectory(const char *path)
{
    struct stat sb;
    return stat(path, &sb) != 0 ? false : S_ISDIR(sb.st_mode);
}

inline bool isExists(const char *path)
{
    struct stat sb;
    return stat(path, &sb) == 0 ? true : false;
}

void moveFile(const char *src, const char *dst)
{
    std::cout << '.';
    // std::cout << "...move file: " << src << " to " << dst << '\n';
    fs::rename(src, dst);
}

void moveFolder(const char *src, const char *dst)
{
    std::cout << '=';
    // std::cout << "...move folder: " << src << " to " << dst << '\n';
    fs::rename(src, dst);
}

//
// in case you try to move files for different file systems
//
// void moveFile(const std::string& src, const std::string& dst) {
//     std::string command = "mv " + src + " " + dst;
//     std::system(command.c_str());
// }

// void moveFolder(const std::string& src, const std::string& dst) {
//     std::string command = "mv " + src + " " + dst;
//     std::system(command.c_str());
// }

void mergeImages(const char *src, const char *dst, const DemParams &demParams)
{
    std::cout << '+';

    // std::cout << "...merge: " << src << " into " << dst << '\n';

    std::vector<unsigned char> srcImage;
    std::vector<unsigned char> dstImage;

    unsigned width, height;

    // decode
    unsigned srcError = lodepng::decode(srcImage, width, height, src);
    unsigned dstError = lodepng::decode(dstImage, width, height, dst);

    if (srcError)
    {
        std::cout << "decoder error: " << srcError << ": " << lodepng_error_text(srcError) << std::endl;
        return;
    }

    if (dstError)
    {
        std::cout << "decoder error: " << dstError << ": " << lodepng_error_text(dstError) << std::endl;
        return;
    }

    unsigned char *srcImageArr = srcImage.data();
    unsigned char *dstImageArr = dstImage.data();

    for (int i = 0, size = srcImage.size(); i < size; i += 4)
    {
        if (needUpdate(srcImageArr, i, demParams))
        {
            dstImageArr[i] = srcImageArr[i];
            dstImageArr[i + 1] = srcImageArr[i + 1];
            dstImageArr[i + 2] = srcImageArr[i + 2];
            dstImageArr[i + 3] = srcImageArr[i + 3];
        }
    }

    // Encode the image
    unsigned encodeError = lodepng::encode(dst, dstImage, width, height);

    if (encodeError)
    {
        std::cout << "encoder error: " << encodeError << ": " << lodepng_error_text(encodeError) << std::endl;
        return;
    }
}

void mergeFolders(const std::string &srcPath, const std::string &dstPath, const DemParams &demParams)
{
    for (const auto &entry : fs::directory_iterator(srcPath))
    {
        fs::path src_p = entry.path();

        std::string src_p_str = src_p.string();
        std::string dst_p_str = dstPath + "/" + src_p.filename().string();

        if (!isExists(dst_p_str.c_str()))
        {
            if (isDirectory(src_p_str.c_str()))
            {
                moveFolder(src_p_str.c_str(), dst_p_str.c_str());
            }
            else
            {
                moveFile(src_p_str.c_str(), dst_p_str.c_str());
            }
        }
        else if (isDirectory(src_p_str.c_str()))
        {
            mergeFolders(src_p_str, dst_p_str, demParams);
        }
        else if (src_p.extension() == ".png")
        {
            mergeImages(src_p_str.c_str(), dst_p_str.c_str(), demParams);
        }
    }
}

int main(int argc, char *argv[])
{
    std::cout << "Merge folders:..." << '\n';

    const char *srcPath = argc > 1 ? argv[1] : "./test/tiles/bur",
               *dstPath = argc > 2 ? argv[2] : "./test/tiles/austria10m";

    float minHeight = argc > 3 ? std::stof(argv[3]) : -10000.0f;
    float resolution = argc > 4 ? std::stof(argv[4]) : 0.1f;

    DemParams demParms = {minHeight, resolution};

    std::string srcPath_str = srcPath;
    std::string dstPath_str = dstPath;

    mergeFolders(srcPath_str, dstPath_str, demParms);

    std::cout << '\n' << "Done." << '\n';
}