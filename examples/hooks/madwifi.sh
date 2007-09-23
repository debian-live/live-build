#!/bin/sh

# This is a hook for live-helper(7) to install madwifi drivers
# To enable it, copy this hook into your config/chroot_localhooks directory.

# IMPORTANT: for apt-get to locate the required packages you need to
# add "non-free" sections
#
# e.g with make-live : --sections "main non-free"

# NOTE: it runs in interactive mode

# Updating indices
apt-get update

# Building kernel module
which module-assistant || apt-get install --yes module-assistant
module-assistant update
module-assistant auto-install madwifi
module-assistant clean madwifi

# Installing aditional stuff
apt-get install --yes madwifi-tools madwifi-doc
