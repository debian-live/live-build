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

	Check_installed "${FILE}" "${PACKAGE}"

	case "${INSTALL_STATUS}" in
		1)
			PACKAGES="${PACKAGES} ${PACKAGE}"
			;;

		2)
			Echo_error "You need to install ${PACKAGE} on your host system."
			exit 1
			;;
	esac
}

Install_package ()
{
	if [ -n "${PACKAGES}" ] && [ "${LH_CHROOT_BUILD}" != "disabled" ]
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
	if [ -n "${PACKAGES}" ] && [ "${LH_CHROOT_BUILD}" != "disabled" ]
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

# Check_installed
# uses as return value global var INSTALL_STATUS
# INSTALL_STATUS : 0 if package is installed
#                  1 if package isn't installed and we're in an apt managed system
#                  2 if package isn't installed and we aren't in an apt managed system
Check_installed ()
{
	FILE="${1}"
	PACKAGE="${2}"

	case "${LH_CHROOT_BUILD}" in
		enabled)
			if Chroot "dpkg-query -s ${PACKAGE}" 2> /dev/null | grep -qs "Status: install"
			then
				INSTALL_STATUS=0
			else
				INSTALL_STATUS=1
			fi
			;;
		disabled)
			if which dpkg-query > /dev/null 2>&1
			then
				if Chroot "dpkg-query -s ${PACKAGE}" 2> /dev/null | grep -qs "Status: install"
				then
					INSTALL_STATUS=0
				else
					INSTALL_STATUS=1
				fi
			else
				FILE="`echo ${FILE} | sed -e 's/chroot//'`"

				if [ ! -e "${FILE}" ]
				then
					INSTALL_STATUS=2
				else
					INSTALL_STATUS=0
				fi
			fi
			;;
	esac
}

