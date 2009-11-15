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

DEBIAN_FRONTEND="dialog" apt-get install --yes sun-java5-bin sun-java5-demo \
	sun-java5-doc sun-java5-fonts sun-java5-jdk sun-java5-jre \
	sun-java5-plugin sun-java5-source
