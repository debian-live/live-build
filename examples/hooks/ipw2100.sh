#!/bin/sh

# This is a hook for live-helper(7) to install ipw2100 drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.
#
# Note: This hook requires packages from the contrib section. Make sure you enabled
# it in your configuration.

# Building kernel module
which module-assistant || apt-get install --yes module-assistant
module-assistant update
module-assistant --non-inter --quiet auto-install ipw2100
module-assistant clean ipw2100

# Installing firmware (http://ipw2100.sourceforge.net/firmware.php)
wget --referer "http://ipw2100.sourceforge.net/firmware.php" "http://ipw2100.sourceforge.net/firmware.php?i_agree_to_the_license=yes&f=ipw2100-fw-1.3.tgz" -O /tmp/ipw2100-fw-1.3.tgz

cd /tmp
tar xfvz ipw2100-fw-1.3.tgz
mv ipw2100-1.3* /lib/firmware
rm -f ipw2100-fw-1.3.tgz
cd ${OLDPWD}
