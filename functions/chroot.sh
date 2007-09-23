#!/bin/sh

# chroot.sh - chroot wrapper

set -e

Chroot ()
{
	COMMANDS="${1}"

	# Executing commands in chroot
	chroot chroot /usr/bin/env -i HOME="/root" PATH="/usr/sbin:/usr/bin:/sbin:/bin" TERM="${TERM}" ftp_proxy="${LH_APT_FTPPROXY}" http_proxy="${LH_APT_HTTPPPROXY}" DEBIAN_FRONTEND="${LH_DEBCONF_FRONTEND}" DEBIAN_PRIORITY="${LH_DEBCONF_PRIORITY}" ${COMMANDS}
}
