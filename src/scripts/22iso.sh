#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Iso ()
{
	mkdir -p "${LIVE_ROOT}"/image/casper

	# Switching package indices to default
	Indices default
	
	# Generating rootfs image
	Genrootfs

	# Switching package indices to custom
	Indices custom

	# Installing syslinux
	Syslinux iso

	# Installing linux-image
	Linuximage iso

	# Installing memtest
	Memtest iso

	# Installing templates
	cp -r "${LIVE_TEMPLATES}"/iso/* "${LIVE_ROOT}"/image

	# Calculating md5sums
	Md5sum

	# Creating image
	Mkisofs
}
