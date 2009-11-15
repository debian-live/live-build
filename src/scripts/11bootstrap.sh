#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Bootstrap ()
{
	if [ ! -f "${LIVE_ROOT}"/.stage/bootstrap ]
	then
		# Create chroot directory
		if [ ! -d "${LIVE_CHROOT}" ]
		then
			mkdir -p "${LIVE_CHROOT}"
		fi

		if [ -n "${LIVE_BOOTSTRAP_CONFIG}" ]; then
			SUITE_CONFIG="--suite-config ${LIVE_BOOTSTRAP_CONFIG}"
		fi 

		# Bootstrap system
		cdebootstrap --arch="${LIVE_ARCHITECTURE}" --flavour="${LIVE_FLAVOUR}" ${SUITE_CONFIG} "${LIVE_DISTRIBUTION}" "${LIVE_CHROOT}" "${LIVE_MIRROR}"

		# Remove unused packages
		Chroot_exec "dpkg -P cdebootstrap-helper-diverts"

		# Remove package cache
		rm -rf "${LIVE_CHROOT}"/var/cache/bootstrap

		# Touching stage file
		if [ ! -d "${LIVE_ROOT}"/.stage ]
		then
			mkdir "${LIVE_ROOT}"/.stage
		fi

		touch "${LIVE_ROOT}"/.stage/bootstrap
	fi
}
