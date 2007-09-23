#!/bin/sh

# This is a hook for live-helper(7) to install nvidia-legacy drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.

# IMPORTANT: for apt-get to locate the required packages you need to
# add "contrib" sections  and the 686 flavour.
#
# e.g with make-live : --sections "main contrib" --kernel-flavour 686

# Updating indices
apt-get update

# Building kernel mdoule
which module-assistant || apt-get install --yes module-assistant
module-assistant update
module-assistant --non-inter --quiet auto-install ipw2200
module-assistant clean ipw2200

# Installing firmware (http://ipw2200.sourceforge.net/firmware.php)
# grabbing 3.0 (Wed May 16 15:17:38 -- matth)
wget --referer "http://ipw2200.sourceforge.net/firmware.php" "http://ipw2200.sourceforge.net/firmware.php?i_agree_to_the_license=yes&f=ipw2200-fw-3.0.tgz" -O /tmp/ipw2200-fw-3.0.tgz

cd /tmp
tar xfvz ipw2200-fw-3.0.tgz
cp ipw2200-fw-3.0/*.fw /lib/firmware/
rm -rf ipw2200-fw-3.0*
cd ${OLDPWD}
