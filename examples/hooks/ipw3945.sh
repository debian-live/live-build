#!/bin/sh

# This is a hook for live-helper(7) to install ipw3945 drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.

# IMPORTANT: for apt-get to locate the required packages you need to
# add "non-free" sections
#
# e.g with make-live : --sections "main non-free"

# Updating indices
apt-get update

# Building kernel module
which module-assistant || apt-get install --yes module-assistant
module-assistant update
module-assistant auto-install ipw3945 # interactive mode for now
module-assistant clean ipw3945

apt-get install ipw3945d firmware-ipw3945

# hackish, autorun regulatory daemon, update-rc.d will reject that
ln -s /etc/init.d/ipw3945d /etc/rc2.d/S19ipw3945d
