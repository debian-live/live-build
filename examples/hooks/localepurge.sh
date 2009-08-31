#!/bin/sh

# This is a hook for live-helper(7) to install localepurge.
# To enable it, copy or symlink this hook into your config/chroot_local-hooks
# directory.
#

apt-get install --yes localepurge

cat > /tmp/localepurge.preseed << EOF
localepurge localepurge/nopurge en
#localepurge localepurge/mandelete true
#localepurge localepurge/dontbothernew false
localepurge localepurge/showfreedspace false
#localepurge localepurge/quickndirtycalc true
#localepurge localepurge/verbose false
EOF

debconf-set-selections < /tmp/localepurge.preseed
rm -f /tmp/localepurge.preseed

dpkg-reconfigure localepurge

localepurge
