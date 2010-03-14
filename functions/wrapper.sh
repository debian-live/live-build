#!/bin/sh

# wrapper.sh - external command wrappers
# Copyright (C) 2006-2010 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Apt ()
{
	case "${LH_APT}" in
		apt|apt-get)
			Chroot chroot apt-get ${APT_OPTIONS} ${@}
			;;

		aptitude)
			Chroot chroot aptitude ${APTITUDE_OPTIONS} ${@}
			;;
	esac
}
