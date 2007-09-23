#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# On Debian systems, the complete text of the GNU General Public License
# can be found in /usr/share/common-licenses/GPL file.

set -e

# Set static variables
BASE="/usr/share/make-live"
CONFIG="/etc/make-live.conf"
PROGRAM="`basename ${0}`"
VERSION="0.99.3"

CODENAME_OLDSTABLE="woody"
CODENAME_STABLE="sarge"
CODENAME_TESTING="etch"
CODENAME_UNSTABLE="sid"

# Source sub scripts
for SCRIPT in "${BASE}"/scripts/*
do
	. "${SCRIPT}"
done

Help ()
{
	echo "${PROGRAM} - utility to build Debian Live systems"
	echo
	echo "Usage: ${PROGRAM} [-a|--architecture ARCHITECTURE] [-b|--bootappend KERNEL_PARAMETER|\"KERNEL_PARAMETERS\"] [--config FILE] [-c|--chroot DIRECTORY] [-d|--distribution DISTRIBUTION] [--filesystem FILESYSTEM] [-f|--flavour BOOTSTRAP_FLAVOUR] [--hook COMMAND|\"COMMANDS\"] [--include-chroot FILE|DIRECTORY] [--include-image FILE|DIRECTORY] [-k|--kernel KERNEL_FLAVOUR] [-m|--mirror URL] [--mirror-security URL] [-p|--packages PACKAGE|\"PACKAGES\"] [--package-list FILE] [--proxy-ftp URL] [--proxy-http URL] [-r|--root DIRECTORY] [-s|--section SECTION|\"SECTIONS\"] [--server-address HOSTNAME|IP] [--server-path DIRECTORY] [--templates DIRECTORY] [-t|--type TYPE] [LIST]"
	echo "Usage: ${PROGRAM} [-h|--help]"
	echo "Usage: ${PROGRAM} [-u|--usage]"
	echo "Usage: ${PROGRAM} [-v|--version]"
	echo
	echo "Lists: gnome, gnome-core, gnome-full, kde, kde-core, kde-core-i18n, kde-extra, kde-extra-i18n, kde-full, kde-full-i18n, kde-i18n, standard-i18n, x11, x11-core, xfce."
	echo
	echo "Values:"
	echo "  Architectures: alpha, amd64, arm, hppa, i386, ia64, m68k, powerpc, s390, sparc."
	echo "  Distributions: etch, sid, or testing, unstable."
	echo "  Filesystems: ext2, plain, squashfs."
	echo "  Boostrap flavours: minimal, standard."
	echo "  Kernel flavours: Debian Kernel flavour of your architecture."
	echo "  Types: iso, net."
	echo
	echo "Options:"
	echo "  -a, --architecture: specifies the bootstrap architecture."
	echo "  -b, --bootappend: specifies the kernel parameter(s)."
	echo "  --config: specifies an alternate configuration file."
	echo "  -c, --chroot: specifies the chroot directory."
	echo "  -d, --distribution: specifies the debian distribution."
	echo "  --filesystem: specifies the chroot filesystem."
	echo "  -f, --flavour: specifies the bootstrap flavour."
	echo "  --hook: specifies extra command(s)."
	echo "  --include-chroot: specifies file or directory for chroot inclusion."
	echo "  --include-image: specifies file or directory for image inclusion."
	echo "  -k, --kernel: specifies debian kernel flavour."
	echo "  -m, --mirror: specifies debian mirror."
	echo "  --mirror-security: specifies debian security mirror."
	echo "  -p, --packages: specifies aditional packages."
	echo "  --package-list: specifies additonal package list."
	echo "  -r, --root: specifies build root."
	echo "  --proxy-ftp: specifies \${ftp_proxy}."
	echo "  --proxy-http: specifies \${http_proxy}."
	echo "  -s, --section: specifies the debian sections."
	echo "  --server-address: specifies the netboot server address."
	echo "  --server-path: specifies the netboot server path for chroot."
	echo "  --templates: specifies location of the templates."
	echo "  -t, --type: specifies live system type."
	echo
	echo "Environment:"
	echo "  All settings can be also specified trough environment variables. Please see make-live.conf(8) for more information."
	echo
	echo "Report bugs to Debian Live project <http://live.debian.net>."
	exit 1
}

Usage ()
{
	echo "${PROGRAM} - utility to build Debian Live systems"
	echo
	echo "Usage: ${PROGRAM} [-a|--architecture ARCHITECTURE] [-b|--bootappend KERNEL_PARAMETER|\"KERNEL_PARAMETERS\"] [--config FILE] [-c|--chroot DIRECTORY] [-d|--distribution DISTRIBUTION] [--filesystem FILESYSTEM] [-f|--flavour BOOTSTRAP_FLAVOUR] [--hook COMMAND|\"COMMANDS\"] [--include-chroot FILE|DIRECTORY] [--include-image FILE|DIRECTORY] [-k|--kernel KERNEL_FLAVOUR] [-m|--mirror URL] [--mirror-security URL] [-p|--packages PACKAGE|\"PACKAGES\"] [--package-list FILE] [--proxy-ftp URL] [--proxy-http URL] [-r|--root DIRECTORY] [-s|--section SECTION|\"SECTIONS\"] [--server-address HOSTNAME|IP] [--server-path DIRECTORY] [--templates DIRECTORY] [-t|--type TYPE] [LIST]"
	echo "Usage: ${PROGRAM} [-h|--help]"
	echo "Usage: ${PROGRAM} [-u|--usage]"
	echo "Usage: ${PROGRAM} [-v|--version]"
	echo
	echo "Try \"${PROGRAM} --help\" for more information."
	exit 1
}

Version ()
{
	echo "${PROGRAM}, version ${VERSION}"
	echo
	echo "Copyright (C) 2006 Daniel Baumann <daniel@debian.org>"
	echo "Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>"
	echo
	echo "This program is free software; you can redistribute it and/or modify"
	echo "it under the terms of the GNU General Public License as published by"
	echo "the Free Software Foundation; either version 2 of the License, or"
	echo "(at your option) any later version."
	echo
	echo "This program is distributed in the hope that it will be useful,"
	echo "but WITHOUT ANY WARRANTY; without even the implied warranty of"
	echo "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the"
	echo "GNU General Public License for more details."
	echo
	echo "You should have received a copy of the GNU General Public License"
	echo "along with this program; if not, write to the Free Software"
	echo "Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA"
	echo
	echo "On Debian systems, the complete text of the GNU General Public License"
	echo "can be found in /usr/share/common-licenses/GPL file."
	echo
	echo "Homepage: <http://live.debian.net/>"
	exit 1
}

Configuration ()
{
	# Source default configuration
	if [ -r "${CONFIG}" ]
	then
		. "${CONFIG}"
	fi

	# Source alternate configuration
	if [ -n "${LIVE_CONFIG}" ]
	then
		if [ -r "${LIVE_CONFIG}" ]
		then
			. "${LIVE_CONFIG}"
		fi
	fi
}

Main ()
{
	ARGUMENTS="`getopt --longoptions root:,type:,architecture:,bootappend:,config:,chroot:,distribution:,filesystem:,flavour:,hook:,include-chroot:,include-image:,kernel:,mirror:,mirror-security:,packages:,package-list:,proxy-ftp:,proxy-http:,section:,server-address:,server-path:,templates:,help,usage,version --name=${PROGRAM} --options r:t:a:b:c:d:f:k:m:p:s:huv --shell sh -- ${@}`"

	if [ "${?}" != "0" ]
	then
		echo "Terminating." >&2
		exit 1
	fi

	eval set -- "${ARGUMENTS}"

	while true
	do
		case "${1}" in
			-r|--root)
				LIVE_ROOT="${2}"; shift 2
				;;

			-t|--type)
				LIVE_TYPE="${2}"; shift 2
				;;

			-a|--architecture)
				LIVE_ARCHITECTURE="${2}"; shift 2
				;;

			-b|--bootappend)
				LIVE_BOOTAPPEND="${2}"; shift 2
				;;

			--config)
				LIVE_CONFIG="${2}"; shift 2
				;;

			-c|--chroot)
				LIVE_CHROOT="${2}"; shift 2
				;;

			-d|--distribution)
				case "${2}" in
					testing)
						LIVE_DISTRIBUTION="${CODENAME_TESTING}"
						;;

					unstable)
						LIVE_DISTRIBUTION="${CODENAME_UNSTABLE}"
						;;

					*)
						LIVE_DISTRIBUTION="${2}"
						;;
				esac

				shift 2
				;;

			--filesystem)
				LIVE_FILESYSTEM="${2}"; shift 2
				;;

			-f|--flavour)
				LIVE_FLAVOUR="${2}"; shift 2
				;;
			--hook)
				LIVE_HOOK="${2}"; shift 2
				;;

			--include-chroot)
				LIVE_INCLUDE_CHROOT="${2}"; shift 2
				;;

			--include-image)
				LIVE_INCLUDE_IMAGE="${2}"; shift 2
				;;

			-k|--kernel)
				LIVE_KERNEL="${2}"; shift 2
				;;

			-m|--mirror)
				LIVE_MIRROR="${2}"; shift 2
				;;

			--mirror-security)
				LIVE_MIRROR_SECURITY="${2}"; shift 2
				;;

			-p|--packages)
				LIVE_PACKAGES="${2}"; shift 2
				;;

			--package-list)
				LIVE_PACKAGE_LIST="${2}"; shift 2
				;;

			--proxy-ftp)
				LIVE_PROXY_FTP="${2}"; shift 2
				;;

			--proxy-http)
				LIVE_PROXY_HTTP="${2}"; shift 2
				;;

			-s|--section)
				LIVE_SECTION="${2}"; shift 2
				;;

			--server-address)
				LIVE_SERVER_ADDRESS="${2}"; shift 2
				;;

			--server-path)
				LIVE_SERVER_PATH="${2}"; shift 2
				;;

			--templates)
				LIVE_TEMPLATES="${2}"; shift 2
				;;

			-h|--help)
				Help; shift
				;;

			-u|--usage)
				Usage; shift
				;;

			-v|--version)
				Version; shift
				;;

			--)
				shift; break
				;;

			*)
				echo "Internal error."
				exit 1
				;;
		esac
	done

	# Check for package lists
	if [ -n "${1}" ]
	then
		LIVE_PACKAGE_LIST="${BASE}/lists/${1}"

		if [ ! -r "${LIVE_PACKAGE_LIST}" ]
		then
			LIVE_PACKAGE_LIST=""
		fi
	fi

	# Initialising
	Init
	Configuration
	Defaults

	# Building live system
	Bootstrap
	Chroot

	# Building live image
	"${LIVE_TYPE}"
}

Main "${@}"
