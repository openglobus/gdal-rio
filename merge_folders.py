"""
    Merge elevation png data folders
"""
import os
import sys
import shutil
import numpy as np
import cv2

NODATA = -10000
ZERO = 0

R = 2
G = 1
B = 0


def height(rgb):
    """Returns elevation value from color."""
    return -10000.0 + 0.1 * (rgb[R] * 256 * 256 + rgb[G] * 256 + rgb[B])


def is_nodata(rgb):
    """Returns True if rgb color contents NODATA value."""
    return height(rgb) == NODATA


def is_zero(rgb):
    """Returns True if rgb color contents ZERO value."""
    return height(rgb) == ZERO


def is_updated(src_rgb):
    """Return True if destination data must be updated"""
    return not (is_nodata(src_rgb) or is_zero(src_rgb))


def merge_img(srcimg, dstimg):
    """Merge two elevation data images."""
    for i, j in np.ndindex(dstimg.shape[:-1]):
        if is_updated(srcimg[i, j]):
            dstimg[i, j] = srcimg[i, j]


def movefolder(src, dst):
    """move folder"""
    os.rename(src, dst)


def movefile(src, dst):
    """move one file"""
    os.rename(src, dst)


def merge_folders(src_path, dst_path):
    """Copy and merge source folder files to destination folder."""
    for item in os.listdir(src_path):
        src_p = os.path.join(src_path, item)
        dst_p = os.path.join(dst_path, item)

        if not os.path.exists(dst_p):
            if os.path.isfile(src_p):
                movefile(src_p, dst_p)
            else:
                movefolder(src_p, dst_p)

        elif os.path.isdir(src_p):
            merge_folders(src_p, dst_p)
        else:
            src_image = cv2.imread(src_p, cv2.IMREAD_UNCHANGED)
            dst_image = cv2.imread(dst_p, cv2.IMREAD_UNCHANGED)
            merge_img(src_image, dst_image)
            cv2.imwrite(dst_p, dst_image)


def main() -> int:
    """Start is here."""
    print('Merge folders:...')
    merge_folders(sys.argv[1], sys.argv[2])
    print('Done.')
    return 0


if __name__ == "__main__":
    exit(main())
