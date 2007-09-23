#!/bin/sh

# This is a hook for live-helper(7) to install ipw2100 drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.

# IMPORTANT: for apt-get to locate the required packages you need to
# add "contrib" sections  and the 686 flavour.
#
# e.g with make-live : --sections "main contrib" --kernel-flavour 686

# Updating indices
apt-get update

# Building kernel module
which module-assistant || apt-get install --yes module-assistant
module-assistant update
module-assistant --non-inter --quiet auto-install ipw2100
module-assistant clean ipw2100

# Installing firmware (http://ipw2100.sourceforge.net/firmware.php)
# grabbing 0.55 (Wed May 16 15:17:38 -- matth)
wget --referer "http://ipw2100.sourceforge.net/firmware.php" "http://ipw2100.sourceforge.net/firmware.php?i_agree_to_the_license=yes&f=ipw2100-fw-1.3.tgz" -O /tmp/ipw2100-fw-1.3.tgz

cd /tmp
tar xfvz ipw2100-fw-1.3.tgz
mv ipw2100-1.3* /lib/firmware
rm -f ipw2100-fw-1.3.tgz
cd ${OLDPWD}
