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
	if [ ! -f "${LIVE_ROOT}"/.stage/image_binary ]
	then
		mkdir -p "${LIVE_ROOT}"/binary/casper
		mv "${LIVE_ROOT}"/filesystem.manifest* "${LIVE_ROOT}"/binary/casper/

		# Switching package indices to default
		if [ "${LIVE_GENERIC_INDICES}" = "yes" ]
		then
			Indices default
		fi
	
		# Generating rootfs image
		Genrootfs

		# Switching package indices to custom
		if [ "${LIVE_GENERIC_INDICES}" = "yes" ]
		then
			Indices custom
		fi

		# Installing syslinux
		Syslinux iso

		# Installing linux-image
		Linuximage iso

		# Installing memtest
		Memtest iso

		# Installing templates
		if [ "${LIVE_FLAVOUR}" != "minimal" ]
		then
			cp -r "${LIVE_TEMPLATES}"/iso/* "${LIVE_ROOT}"/binary
			cp -r "${LIVE_TEMPLATES}"/common/* "${LIVE_ROOT}"/binary
		fi

		# Calculating md5sums
		Md5sum

		# Creating image
		Mkisofs binary

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/image_binary
	fi

	if [ ! -f "${LIVE_ROOT}"/.stage/image_source ] && [ "${LIVE_SOURCE}" = "yes" ]
	then
		# Downloading sources
		Sources

		# Creating image
		Mkisofs source

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/image_source
	fi
}
