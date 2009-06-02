#!/bin/sh

# This is a hook for live-helper(7) to configure kpdf to ignore manipulation
# restrcition on "DRM protect" PDF documents.
#
# To enable it, copy or symlink this hook into your config/chroot_local-hooks
# directory.

cat > /etc/kde3/kpdfpartrc << EOF
[General]
ObeyDRM=false
EOF
