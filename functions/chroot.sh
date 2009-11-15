#!/bin/sh

# chroot.sh - /usr/sbin/chroot wrapper script
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Chroot ()
{
	COMMANDS="${@}"

	# Executing commands in chroot
	Echo_debug "Executing: %s" "${COMMANDS}"

	if [ "${LH_USE_FAKEROOT}" != "enabled" ]
	then
		${LH_ROOT_COMMAND} chroot chroot /usr/bin/env -i HOME="/root" PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" TERM="${TERM}" ftp_proxy="${LH_APT_FTP_PROXY}" http_proxy="${LH_APT_HTTP_PROXY}" DEBIAN_FRONTEND="${LH_DEBCONF_FRONTEND}" DEBIAN_PRIORITY="${LH_DEBCONF_PRIORITY}" DEBCONF_NOWARNINGS="${LH_DEBCONF_NOWARNINGS}" XORG_CONFIG="custom" ${COMMANDS}
	else
		# Building with fakeroot/fakechroot
		${LH_ROOT_COMMAND} chroot chroot ${COMMANDS}
	fi

	return "${?}"
}
