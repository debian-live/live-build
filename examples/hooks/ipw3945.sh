#!/bin/sh

# This is a hook for live-helper(7) to install ipw3945 drivers
# To enable it, copy or symlink this hook into your config/chroot_local-hooks
# directory.
#
# Note: This hook requires packages from the contrib and non-free category. Make
# sure you enabled it in your configuration.

apt-get install --yes build-essential

# Building kernel module
which module-assistant || apt-get install --yes module-assistant
module-assistant update

for KERNEL in /boot/vmlinuz-*
do
	VERSION="$(basename ${KERNEL} | sed -e 's|vmlinuz-||')"

	module-assistant --non-inter --quiet auto-install ipw3945 -l ${VERSION}
done

module-assistant clean ipw3945

# Installing additional stuff
apt-get install firmware-ipw3945 ipw3945d

# hackish, autorun regulatory daemon, update-rc.d will reject that
ln -s /etc/init.d/ipw3945d /etc/rc2.d/S19ipw3945d
