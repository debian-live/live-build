#!/bin/sh

# make-live - An utility for building Debian Live systems.
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
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

set -e

PROGRAM="`basename ${0}`"
VERSION="0.99"

# Source default configuration
if [ -r /etc/make-live.conf ]
then
	. /etc/make-live.conf
fi

# Source alternate configuration
if [ ! -z "${LIVE_CONFFILE}" ]
then
	if [ -r "${LIVE_CONFFILE}" ]
	then
		. "${LIVE_CONFFILE}"
	else
		echo "W: could not read ${LIVE_CONFFILE}, using defaults."
	fi
fi

# Source scriptlets
for SCRIPT in /usr/share/make-live/scripts/*.sh
do
	. "${SCRIPT}"
done

Help ()
{
	echo "make-live - An utility for building Debian Live systems."
	echo
	echo "Usage: ${PROGRAM} [-a ARCHITECTURE] [-c FILE] [--clone DIRECTORY] [-d DISTRIBUTION] [--debug] [-f FILESYSTEM] [--flavour FLAVOUR] [--hook \"COMMAND...\"] [--include-image FILE|DIRECTORY] [--include-rootfs FILE|DIRECTORY] [--interactive] [--linux-image FLAVOUR] [--logfile FILE] [-p|--package-list FILE] [--preseed FILE] [--rootfs DIRECTORY] [-s|--section \"SECTION...\"] [--splashy [THEME]] [-t|--type TYPE] [--templates DIRECTORY] [--verbose] [LIST]"
	echo
	echo "Values:"
	echo "  Architectures: alpha, amd64, arm, hppa, i386, ia64, m68k, powerpc, s390, sparc."
	echo "  Distributions: oldstable, stable, testing, unstable."
	echo "  Filesystems: ext2, squashfs, xfs."
	echo "  Flavours: bootable, build, minimal, standard."
	echo "  Linux Images: alpha-generic, alpha-smp, alpha-legacy, amd64-k8, amd64-k8-smp, em64t-p4, em64t-p4-smp, footbridge, ixp4xx, nslu2, rpc, s3c2410, parisc, parisc-smp, parisc64, parisc64-smp, 486, 686, k7, itanium, itanium-smp, mckinley, mckinley-smp, amiga, mac, r4k-ip22, r5k-ip32, sb1-bcm91250a, sb1a-bcm91480b, r5k-cobalt, r3k-kn02, r4k-kn04, powerpc, powerpc-smp, powerpc-miboot, powerpc64, s390, s390x, sparc32, sparc64, sparc64-smp."
	echo "  Sections: main, contrib, non-free."
	echo "  Types: iso, net."
	echo "  Lists: gnome, gnome-core, gnome-full, kde, kde-core, kde-core-i18n, kde-extra, kde-extra-i18n, kde-full, kde-full-i18n, kde-18n, standard-i18n, x11, x11-core, xfce."
	echo
	echo "Options:"
	echo "  -h, --help:    display this help and exit."
	echo "  -u, --usage:   show usage and exit."
	echo "  -v, --version: output version information and exit."
	echo
	echo "Environment:"
	echo "  All settings can also be done through environment variables. Please see make-live.conf(8) for more information."
	echo
	echo "Report bugs to Debian Live project <http://live.debian.net>."
	exit 1
}

Usage ()
{
	echo "make-live - An utility for building Debian Live systems."
	echo
	echo "Usage: ${PROGRAM} [-a ARCHITECTURE] [-c FILE] [--clone DIRECTORY] [-d DISTRIBUTION] [--debug] [-f FILESYSTEM] [--flavour FLAVOUR] [--hook "COMMAND..."] [--include-image FILE|DIRECTORY] [--include-rootfs FILE|DIRECTORY] [--linux-image FLAVOUR] [--logfile FILE] [-p|--package-list FILE] [--preseed FILE] [--rootfs DIRECTORY] [-s|--section "SECTION..."] [--splashy [THEME]] [-t|--type TYPE] [--templates DIRECTORY] [--verbose] [LIST]"
	echo
	echo "Try \"${PROGRAM} --help\" for more information."
	exit 1
}

Version ()
{
	echo "make-live, version ${VERSION}"
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
	echo "Homepage: Debian Live project <http://live.debian.net/>"
	exit 1
}

Main ()
{
	ARGUMENTS=`getopt --shell=sh --name="${PROGRAM}" \
		--options="a:c:d:f:p:s:t:huv" \
		--longoptions="architecture:,conffile:,clone:,distribution:,debug,filesystem:,flavour:,hook:,include-image:,include-rootfs:,interactive,linux-image:,logfile:,package-list:,preseed:,rootfs:,section:,splashy::,type:,templates:,verbose,help,usage,version" \
		-- "${@}"`

	if [ "${?}" != "0" ]
	then
		echo "Terminating..." >&2
		exit 1
	fi

	eval set -- "${ARGUMENTS}"

	while true
	do
		case "${1}" in
			-a|--architecture)
				LIVE_ARCHITECTURE="${2}"; shift 2
				;;

			-c|--conffile)
				LIVE_CONFIG="${2}"; shift 2
				;;

			--clone)
				LIVE_CLONE="${2}"; shift 2
				;;

			-d|--distribution)
				LIVE_DISTRIBUTION="${2}"; shift 2
				;;

			--debug)
				LIVE_DEBUG="1"
				LIVE_VERBOSE="1"; shift
				;;

			-f|--filesystem)
				LIVE_FILESYSTEM="${2}"; shift 2
				;;

			--flavour)
				LIVE_FLAVOUR="${2}"; shift 2
				;;

			--hook)
				LIVE_HOOK="${2}"; shift 2
				;;

			--include-image)
				LIVE_INCLUDE_IMAGE="${2}"; shift 2
				;;

			--include-rootfs)
				LIVE_INCLUDE_ROOTFS="${2}"; shift 2
				;;

			--interactive)
				LIVE_INTERACTIVE="1"; shift
				;;

			--linux-image)
				LIVE_LINUX="${2}"; shift 2
				;;

			--logfile)
				LIVE_LOGFILE="${2}"; shift 2
				;;

			-p|--package-list)
				LIVE_PACKAGE_LIST="${2}"; shift 2
			    ;;

			--preseed)
				LIVE_PRESEED="${2}"; shift 2
				;;

			--rootfs)
				LIVE_ROOTFS="${2}"; shift 2
				;;

			-s|--section)
				LIVE_SECTIONS="${2}"; shift 2
				;;

			--splashy)
				LIVE_SPLASHY="1" 
				case "${2}" in
					"") 
						shift 2;
						;;
					*)
						LIVE_SPLASHY_THEME=${2} ; shift 2
						;;
				esac
				;;

			-t|--type)
				LIVE_TYPE="${2}"; shift 2
				;;

			--templates)
				LIVE_TEMPLATES="${2}"; shift 2
				;;

			--verbose)
				LIVE_VERBOSE="1"; shift
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
				echo "Internal error!"
				exit 1
				;;
		esac
	done

	LIVE_LIST="${1}"

	# Enabling debug
	if [ "${LIVE_DEBUG}" ]
	then
		set +x
	fi

	# Setting defaults
	Defaults

	# Initial checks
	Init

	# Bootstrap chroot
	Bootstrap

	# Customize chroot
	Chroot

	# Create type
	if [ "${LIVE_TYPE}" ]
	then
		case ${LIVE_TYPE} in
			iso)
				LIVE_TYPE="Iso"
				;;

			net)
				LIVE_TYPE="Net"
				;;

			*)
				echo "You specified a wrong image type"
				Help
				;;
		esac

		${LIVE_TYPE}
	else
		Iso
	fi
}

Main "${@}"
