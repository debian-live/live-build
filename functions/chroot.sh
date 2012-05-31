#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2012 Daniel Baumann <daniel@debian.org>
##
## live-build comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


Chroot ()
{
	CHROOT="${1}"; shift
	COMMANDS="${@}"

	# Executing commands in chroot
	Echo_debug "Executing: %s" "${COMMANDS}"

	if [ -e config/environment.chroot ]
	then
		ENV="$(grep -v '^#' config/environment.chroot)"
	else
		ENV=""
	fi

	if [ "${LB_USE_FAKEROOT}" != "true" ]
	then
		${LB_ROOT_COMMAND} ${_LINUX32} chroot "${CHROOT}" /usr/bin/env -i HOME="/root" PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" TERM="${TERM}" DEBIAN_FRONTEND="${LB_DEBCONF_FRONTEND}" DEBIAN_PRIORITY="${LB_DEBCONF_PRIORITY}" DEBCONF_NOWARNINGS="${LB_DEBCONF_NOWARNINGS}" ${ENV} ${COMMANDS}
	else
		# Building with fakeroot/fakechroot
		${LB_ROOT_COMMAND} ${_LINUX32} chroot "${CHROOT}" ${ENV} ${COMMANDS}
	fi

	return "${?}"
}
