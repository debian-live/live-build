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

	case "${LIVE_CHROOT_BUILD}" in
		enabled)
			for ITEM in ${PACKAGE}
			do
				if ! `Chroot "dpkg-query -s ${ITEM}"`
				then
					PACKAGES="${PACKAGES} ${ITEM}"
				fi
			done
			;;

		disabled)
			if `which dpkg-query`
			then
				for ITEM in ${PACKAGE}
				do
					if ! `dpkg-query -s ${ITEM}`
					then
						PACKAGES="${PACKAGES} ${ITEM}"
					fi
				done
			else
				FILE="`echo ${FILE} | sed -e 's/chroot//'`"

				if [ ! -f "${FILE}" ] && [ ! -d "${FILE}" ]
				then
					Echo_error "You need to install ${PACKAGE} on your host system."
					exit 1
				fi
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
