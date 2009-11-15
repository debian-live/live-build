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
		# Configure chroot
		Patch_chroot apply
		Patch_runlevel apply

		# Configure network
		Patch_network apply

		mkdir -p "${LIVE_ROOT}"/binary/casper
		for MANIFEST in "${LIVE_ROOT}"/filesystem.manifest*
		do
			if [ -e "${MANIFEST}" ]; then
				mv "${MANIFEST}" "${LIVE_ROOT}"/binary/casper/
			fi
		done

		# Remove indices
		rm -rf "${LIVE_CHROOT}"/var/cache/apt
		mkdir -p "${LIVE_CHROOT}"/var/cache/apt/archives/partial
		rm -rf "${LIVE_CHROOT}"/var/lib/apt/lists
		mkdir -p "${LIVE_CHROOT}"/var/lib/apt/lists/partial

		# Switching package indices to default
		if [ "${LIVE_GENERIC_INDICES}" = "yes" ]
		then
			Indices default
		fi

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		Patch_runlevel deapply
		Patch_chroot deapply

		# Generating rootfs image
		Genrootfs

		# Configure chroot
		Patch_chroot apply
		Patch_runlevel apply

		# Configure network
		Patch_network apply

		# Remove indices
		rm -rf "${LIVE_CHROOT}"/var/cache/apt
		mkdir -p "${LIVE_CHROOT}"/var/cache/apt/archives/partial
		rm -rf "${LIVE_CHROOT}"/var/lib/apt/lists
		mkdir -p "${LIVE_CHROOT}"/var/lib/apt/lists/partial

		# Switching package indices to custom
		Indices custom

		# Installing syslinux
		Syslinux iso

		# Installing linux-image
		Linuximage iso

		# Installing memtest
		Memtest iso

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		Patch_runlevel deapply
		Patch_chroot deapply

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
		# Configure chroot
		Patch_chroot apply
		Patch_runlevel apply

		# Configure network
		Patch_network apply

		# Downloading sources
		Sources

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		Patch_runlevel deapply
		Patch_chroot deapply

		# Creating image
		Mkisofs source

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/image_source
	fi
}
