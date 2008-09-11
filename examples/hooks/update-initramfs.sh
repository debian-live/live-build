#!/bin/sh

# This is a hook for live-helper(7) to install aufs drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.
#
# Note: You only want to use this hook if you have modified any initramfs-script
# during the build and need to refresh the initrd.img for that purpose.

update-initramfs -k all -t -u
