#!/bin/sh

# This is a hook for live-helper(7) to install sun-java.
#
# To enable it, copy this hook into your config/chroot_local-hooks directory and
# don't forget to enable non-free in LIVE_SECTIONS.
#
# live-helper sets DEBIAN_FRONTEND to 'noninteractive' to advise debconf to not
# ask any questions while installing packages. Suns redistribution terms for
# Java do not allow this, therefore we need to overwrite DEBIAN_FRONTEND for
# this apt-get call only.

DEBIAN_FRONTEND="dialog" apt-get install --yes sun-java6-bin sun-java6-demo \
	sun-java6-doc sun-java6-fonts sun-java6-jdk sun-java6-jre \
	sun-java6-plugin sun-java6-source
