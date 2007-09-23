#!/bin/sh

# packages.sh - handle packages installation
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Check_package ()
{
	FILE="${1}"
	PACKAGE="${2}"

	if [ ! -f "${FILE}" ]
	then
		PACKAGES="${PACKAGES} ${PACKAGE}"
	fi
}

Install_package ()
{
	if [ -n "${PACKAGES}" ]
	then
		case "${LH_APT}" in
			apt|apt-get)
				Chroot "apt-get install --yes ${PACKAGES}"
				;;

			aptitude)
				Chroot "aptitude install --assume-yes ${PACKAGES}"
				;;
		esac
	fi
}

Remove_package ()
{
	if [ -n "${PACKAGES}" ]
	then
		case "${LH_APT}" in
			apt|apt-get)
				Chroot "apt-get remove --purge --yes ${PACKAGES}"
				;;

			aptitude)
				Chroot "aptitude purge --assume-yes ${PACKAGES}"
				;;
		esac
	fi
}
