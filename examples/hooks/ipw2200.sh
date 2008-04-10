#!/bin/sh

# This is a hook for live-helper(7) to install ipw2200 drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.
#
# Note: This hook requires packages from the contrib section. Make sure you enabled
# it in your configuration.

# Building kernel mdoule
which module-assistant || apt-get install --yes module-assistant
module-assistant update

for KERNEL in /boot/vmlinuz-*
do
	VERSION="$(basename ${KERNEL} | sed -e 's|vmlinuz-||')"

	module-assistant --non-inter --quiet auto-install ipw2200 -l ${VERSION}
done

module-assistant clean ipw2200

# Installing firmware (http://ipw2200.sourceforge.net/firmware.php)
wget --referer "http://ipw2200.sourceforge.net/firmware.php" "http://ipw2200.sourceforge.net/firmware.php?i_agree_to_the_license=yes&f=ipw2200-fw-3.0.tgz" -O /tmp/ipw2200-fw-3.0.tgz

cd /tmp
tar xfvz ipw2200-fw-3.0.tgz
cp ipw2200-fw-3.0/*.fw /lib/firmware/
rm -rf ipw2200-fw-3.0*
cd ${OLDPWD}
