#!/bin/sh

# This is a hook for live-helper(7) to install madwifi drivers
# To enable it, copy this hook into your config/chroot_localhooks directory.
#
# Note: This hook requires packages from the contrib section. Make sure you enabled
# it in your configuration.
#
# FIXME: it runs in interactive mode

# Building kernel module
which module-assistant || apt-get install --yes module-assistant
module-assistant update
module-assistant auto-install madwifi
module-assistant clean madwifi

# Installing additional stuff
apt-get install --yes madwifi-tools madwifi-doc
