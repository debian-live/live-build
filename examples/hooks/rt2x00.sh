#!/bin/sh

# This is a hook for live-helper(7) to install ralink rt2x00 drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.
#
# FIXME: it runs in interactive mode

# Building kernel modules
which module-assistant || apt-get install --yes module-assistant
module-assistant update
module-assistant auto-install rt2x00-source
module-assistant clean rt2x00-source

# Installing firmware for rt73usb
wget "http://www.ralinktech.com.tw/data/RT73_Linux_STA_Drv1.0.4.0.tar.gz" -O /tmp/RT73_Linux_STA_Drv1.0.4.0.tar.gz

cd /tmp
tar xfvz RT73_Linux_STA_Drv1.0.4.0.tar.gz
cp RT73_Linux_STA_Drv1.0.4.0/Module/rt73.bin /lib/firmware
rm -rf RT73_Linux_STA_Drv*
cd ${OLDPWD}
