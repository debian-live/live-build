#!/bin/sh

# cache.sh - manage package cache
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Restore_cache ()
{
	CACHEDIRECTORY="${1}"

	if [ "${LH_CACHE}" = "enabled" ]
	then
		if [ -d "${CACHEDIRECTORY}" ]
		then
			# Restore old cache
			cp "${CACHEDIRECTORY}"/*.deb chroot/var/cache/apt/archives
		fi
	fi
}

Save_cache ()
{
	CACHEDIRECTORY="${1}"

	if [ "${LH_CACHE}" = "enabled" ]
	then
		# Cleaning current cache
		Chroot "apt-get autoclean"

		if ls chroot/var/cache/apt/archives/*.deb &> /dev/null
		then
			# Creating cache directory
			if [ ! -d "${CACHEDIRECTORY}" ]
			then
				mkdir -p "${CACHEDIRECTORY}"
			fi

			# Saving new cache
			mv -f chroot/var/cache/apt/archives/*.deb "${CACHEDIRECTORY}"
		fi
	else
		# Purging current cache
		rm -f chroot/var/cache/apt/archives/*.deb
	fi
}
