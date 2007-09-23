#!/bin/sh

# This is a hook for live-helper(7) to install ipw3945 drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.
#
# Note: This hook requires packages from the contrib and non-free section. Make
# sure you enabled it in your configuration.
#
# FIXME: it runs in interactive mode

# Building kernel module
which module-assistant || apt-get install --yes module-assistant
module-assistant update
module-assistant auto-install ipw3945
module-assistant clean ipw3945

# Installing additional stuff
apt-get install firmware-ipw3945 ipw3945d

# hackish, autorun regulatory daemon, update-rc.d will reject that
ln -s /etc/init.d/ipw3945d /etc/rc2.d/S19ipw3945d
