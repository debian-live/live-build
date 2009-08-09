#!/bin/sh

# This is an binary hook for live-helper(7) to overwrite the banner
# in the graphical Debian Installer.
# To enable it, coppy or symlink this hook into your config/binary_local-hooks
# directory and add a replacement banner.png at:
#
#  config/binary_local-includes/binary/install/banner.png
#
# The file should be a PNG image of dimensions 800 x 75.

set -e

TARGET_INITRD="binary/install/gtk/initrd.gz"
REPACK_TMPDIR="unpacked-initrd"

# cpio does not have a "extract to directory", so we must change directory
mkdir -p ${REPACK_TMPDIR}
cd ${REPACK_TMPDIR}
gzip -d < ../${TARGET_INITRD} | cpio -i --make-directories --no-absolute-filenames

# Overwrite banner
mv ../binary/install/banner.png ./usr/share/graphics/logo_debian.png

find | cpio -H newc -o | gzip -9 > ../${TARGET_INITRD}
cd ..
rm -rf ${REPACK_TMPDIR}
