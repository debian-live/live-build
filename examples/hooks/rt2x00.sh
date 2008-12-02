#!/bin/sh

# This is a hook for live-helper(7) to install ralink rt2x00 drivers
# To enable it, copy or symlink this hook into your config/chroot_local-hooks
# directory.
#
# FIXME: it runs in interactive mode

apt-get install --yes build-essential

# Building kernel modules
which module-assistant || apt-get install --yes module-assistant
module-assistant update

for KERNEL in /boot/vmlinuz-*
do
	VERSION="$(basename ${KERNEL} | sed -e 's|vmlinuz-||')"

	module-assistant --non-inter --quiet auto-install rt2x00-source -l ${VERSION}
done

module-assistant clean rt2x00-source

# Installing firmware for rt73usb
wget "http://www.ralinktech.com.tw/data/RT73_Linux_STA_Drv1.0.4.0.tar.gz" -O /tmp/RT73_Linux_STA_Drv1.0.4.0.tar.gz

cd /tmp
tar xfvz RT73_Linux_STA_Drv1.0.4.0.tar.gz
cp RT73_Linux_STA_Drv1.0.4.0/Module/rt73.bin /lib/firmware
rm -rf RT73_Linux_STA_Drv*
cd ${OLDPWD}
