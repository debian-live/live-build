#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2015 Daniel Baumann <mail@daniel-baumann.ch>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


Apt ()
{
	CHROOT="${1}"
	shift

	case "${LB_APT}" in
		apt|apt-get)
			Chroot ${CHROOT} apt-get ${APT_OPTIONS} ${@}
			;;

		aptitude)
			Chroot ${CHROOT} aptitude ${APTITUDE_OPTIONS} ${@}
			;;
	esac
}
