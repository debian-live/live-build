#!/bin/sh

# cache.sh - manage package cache
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Restore_cache ()
{
	DIRECTORY="${1}"

	if [ "${LH_CACHE}" = "enabled" ] && [ "${LH_CACHE_PACKAGES}" = "enabled" ]
	then
		if [ -d "${DIRECTORY}" ]
		then
			# Restore old cache
			if [ "$(stat --printf %d ${DIRECTORY})" = "$(stat --printf %d chroot/var/cache/apt/archives)" ]
			then
				# with hardlinks
				cp -fl "${DIRECTORY}"/*.deb chroot/var/cache/apt/archives
			else
				# without hardlinks
				cp "${DIRECTORY}"/*.deb chroot/var/cache/apt/archives
			fi
		fi
	fi
}

Save_cache ()
{
	DIRECTORY="${1}"

	if [ "${LH_CACHE}" = "enabled" ] && [ "${LH_CACHE_PACKAGES}" = "enabled" ]
	then
		# Cleaning current cache
		Chroot "apt-get autoclean"

		if ls chroot/var/cache/apt/archives/*.deb > /dev/null 2>&1
		then
			# Creating cache directory
			mkdir -p "${DIRECTORY}"

			# Saving new cache
			for PACKAGE in chroot/var/cache/apt/archives/*.deb
			do
				if [ -e "${DIRECTORY}"/"$(basename ${PACKAGE})" ]
				then
					rm -f "${PACKAGE}"
				else
					mv "${PACKAGE}" "${DIRECTORY}"
				fi
			done
		fi
	else
		# Purging current cache
		rm -f chroot/var/cache/apt/archives/*.deb
	fi
}
