#!/bin/sh

# This is a hook for live-helper(7) to install ralink rt2570 drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.

which module-assistant || apt-get install --yes module-assistant
module-assistant update

for KERNEL in /boot/vmlinuz-*
do
	VERSION="$(basename ${KERNEL} | sed -e 's|vmlinuz-||')"

	module-assistant --non-inter --quiet auto-install rt2570-source -l ${VERSION}
done

module-assistant clean rt2570-source
