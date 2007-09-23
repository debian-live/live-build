#!/bin/sh

# This is a hook for live-helper(7) to install ralink rt2570 drivers
# To enable it, copy this hook into your config/chroot_local-hooks directory.

# NOTE: it runs in interactive mode

# Updating indices
apt-get update

# Building kernel module
which module-assistant || apt-get install --yes module-assistant
module-assistant update
module-assistant auto-install rt2570-source
module-assistant clean rt2570-source
