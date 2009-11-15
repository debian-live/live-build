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
	ITEM="${1}"
	PACKAGE="${2}"

	case "${LIVE_CHROOT_BUILD}" in
		enabled)
			if [ ! -d "${ITEM}" ] && [ ! -f "${ITEM}" ]
			then
				PACKAGES="${PACKAGES} ${PACKAGE}"
			fi
			;;

		disabled)
			ITEM="`echo ${ITEM} | sed -e 's/chroot//'`"

			if [ ! -d "${ITEM}" ] && [ ! -f "${ITEM}" ]
			then
				Echo_error "You need to install ${PACKAGE} on your host system."
				exit 1
			fi
			;;
	esac
}

Install_package ()
{
	if [ -n "${PACKAGES}" ] && [ "${LIVE_CHROOT_BUILD}" != "disabled" ]
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
	if [ -n "${PACKAGES}" ] && [ "${LIVE_CHROOT_BUILD}" != "disabled" ]
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
