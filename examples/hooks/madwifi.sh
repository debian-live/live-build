#!/bin/sh

# This is a hook for live-helper(7) to install madwifi drivers
# To enable it, copy this hook into your config/chroot_localhooks directory.
#
# Note: This hook requires packages from the contrib category. Make sure you enabled
# it in your configuration.

# Building kernel module
which module-assistant || apt-get install --yes module-assistant
module-assistant update

for KERNEL in /boot/vmlinuz-*
do
	VERSION="$(basename ${KERNEL} | sed -e 's|vmlinuz-||')"

	module-assistant --non-inter --quiet auto-install madwifi -l ${VERSION}
done

module-assistant clean madwifi

# Installing additional stuff
apt-get install --yes madwifi-tools madwifi-doc
