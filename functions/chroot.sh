#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2012 Daniel Baumann <daniel@debian.org>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


Chroot ()
{
	CHROOT="${1}"; shift
	COMMANDS="${@}"

	# Executing commands in chroot
	Echo_debug "Executing: %s" "${COMMANDS}"

	ENV=""

	for _FILE in config/environment config/environment.chroot
	do
		if [ -e "${_FILE}" ]
		then
			ENV="${ENV} $(grep -v '^#' ${_FILE})"
		fi
	done

	if [ "${LB_USE_FAKEROOT}" != "true" ]
	then
		${LB_ROOT_COMMAND} ${_LINUX32} chroot "${CHROOT}" /usr/bin/env -i HOME="/root" PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" TERM="${TERM}" DEBIAN_FRONTEND="${LB_DEBCONF_FRONTEND}" DEBIAN_PRIORITY="${LB_DEBCONF_PRIORITY}" DEBCONF_NONINTERACTIVE_SEEN="true" DEBCONF_NOWARNINGS="true" ${ENV} ${COMMANDS}
	else
		# Building with fakeroot/fakechroot
		${LB_ROOT_COMMAND} ${_LINUX32} chroot "${CHROOT}" ${ENV} ${COMMANDS}
	fi

	return "${?}"
}
