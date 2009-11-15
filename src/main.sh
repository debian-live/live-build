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
BASE=${LIVE_BASE:-"/usr/share/make-live"}
CONFIG="/etc/make-live.conf"
PROGRAM="`basename ${0}`"
VERSION="0.99.24"

export VERSION

CODENAME_OLDSTABLE="woody"
CODENAME_STABLE="sarge"
CODENAME_TESTING="etch"
CODENAME_UNSTABLE="sid"

export CODENAME_OLDSTABLE CODENAME_STABLE CODENAME_TESTING CODENAME_UNSTABLE

# Source sub scripts
for SCRIPT in `find ${BASE}/scripts/ -not -name '*~' -not -wholename "${BASE}/scripts/.*" -and -type f`
do
	. "${SCRIPT}"
done

USAGE="Usage: ${PROGRAM} [-a|--architecture ARCHITECTURE] [-b|--bootappend KERNEL_PARAMETER|\"KERNEL_PARAMETERS\"] [--clone DIRECTORY] [--config FILE] [-c|--chroot DIRECTORY] [-d|--distribution DISTRIBUTION] [-e|--encryption ALGORITHM] [--with-generic-indices] [--without-generic-indices] [--with-recommends] [--without-recommends] [--with-daemons] [--without-daemons] [--filesystem FILESYSTEM] [-f|--flavour BOOTSTRAP_FLAVOUR] [--hook COMMAND|\"COMMANDS\"] [--include-chroot FILE|DIRECTORY] [--include-image FILE|DIRECTORY] [-k|--kernel KERNEL_FLAVOUR] [--manifest PACKAGE] [-m|--mirror URL] [-k|--keyring] [--mirror-security URL] [--packages PACKAGE|\"PACKAGES\"] [-p|--package-list LIST|FILE] [--preseed FILE] [--proxy-ftp URL] [--proxy-http URL] [--repositories NAME] [-r|--root DIRECTORY] [-s|--section SECTION|\"SECTIONS\"] [--server-address HOSTNAME|IP] [--server-path DIRECTORY] [--templates DIRECTORY] [-t|--type TYPE] [--tasks TASK]"

Help ()
{
	echo "${PROGRAM} - utility to build Debian Live systems"
	echo
	echo "${USAGE}"
	echo "Usage: ${PROGRAM} [-h|--help]"
	echo "Usage: ${PROGRAM} [-u|--usage]"
	echo "Usage: ${PROGRAM} [-v|--version]"
	echo
	echo "Lists: gnome, gnome-core, gnome-full, kde, kde-core, kde-core-i18n, kde-extra, kde-extra-i18n, kde-full, kde-full-i18n, kde-i18n, standard, standard-i18n, x11, x11-core, xfce."
	echo
	echo "Values:"
	echo "  Architectures: alpha, amd64, arm, hppa, i386, ia64, m68k, powerpc, s390, sparc."
	echo "  Distributions: testing, unstable, experimental or etch, sid".
	echo "  Filesystems: ext2, plain, squashfs."
	echo "  Boostrap flavours: minimal, standard."
	echo "  Kernel flavours: Debian Kernel flavour of your architecture."
	echo "  Types: iso, net, usb."
	echo
	echo "Options:"
	echo "  -a, --architecture: specifies the bootstrap architecture."
	echo "  -b, --bootappend: specifies the kernel parameter(s)."
	echo "  --config: specifies an alternate configuration file."
	echo "  -c, --chroot: specifies the chroot directory."
	echo "  --clone: specifies a chroot directory to clone."
	echo "  -d, --distribution: specifies the debian distribution."
	echo "  -e, --encryption: specifies the filesystem encryption algorithm."
	echo "  --filesystem: specifies the chroot filesystem."
	echo "  -f, --flavour: specifies the bootstrap flavour."
	echo "  --bootstrap-config: specifies the suite configuration to be used for bootstraping."
	echo "  --hook: specifies extra command(s)."
	echo "  --include-chroot: specifies file or directory for chroot inclusion."
	echo "  --include-image: specifies file or directory for image inclusion."
	echo "  -k, --kernel: specifies debian kernel flavour."
	echo "  --manifest: specifies the pivot package to create filesystem.manifest-desktop upon (mostly \"ubuntu-live\")."
	echo "  -m, --mirror: specifies debian mirror."
	echo "  --mirror-security: specifies debian security mirror."
	echo "  --keyring: specifies keyring package."
	echo "  --packages: specifies aditional packages."
	echo "  -p, --package-list: specifies additonal package list."
	echo "  --repositories: specifies custom repositories."
	echo "  -r, --root: specifies build root."
	echo "  --preseed: specifies a debconf preseeding file."
	echo "  --proxy-ftp: specifies \${ftp_proxy}."
	echo "  --proxy-http: specifies \${http_proxy}."
	echo "  -s, --section: specifies the debian sections."
	echo "  --server-address: specifies the netboot server address."
	echo "  --server-path: specifies the netboot server path for chroot."
	echo "  --templates: specifies location of the templates."
	echo "  -t, --type: specifies live system type."
	echo "  --tasks: specifies one or more aptitude tasks."
	echo "  --with-generic-indices: enables generic debian package indices (default)."
	echo "  --without-generic-indices: disables generic debian package indices."
	echo "  --with-recommends: installes recommended packages too."
	echo "  --without-recommends: does not install recommended packages (default)."
	echo "  --with-daemons: don't touch daemons."
	echo "  --without-daemons: disable all non-essential daemons."
	echo
	echo "Environment:"
	echo "  All settings can be also specified trough environment variables. Please see make-live.conf(5) for more information."
	echo
	echo "Report bugs to Debian Live project <http://live.debian.net>."
	exit 0
}

Usage ()
{
	echo "${PROGRAM} - utility to build Debian Live systems"
	echo
	echo "${USAGE}"
	echo "Usage: ${PROGRAM} [-h|--help]"
	echo "Usage: ${PROGRAM} [-u|--usage]"
	echo "Usage: ${PROGRAM} [-v|--version]"
	echo
	echo "Try \"${PROGRAM} --help\" for more information."
	exit ${1}
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
	exit 0
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
	ARGUMENTS="`getopt --longoptions root:,tasks:,type:,architecture:,bootappend:,clone:,config:,chroot:,distribution:,encryption:,filesystem:,flavour:,bootstrap-config:,hook:,include-chroot:,include-image:,kernel:,manifest:,mirror:,keyring:,mirror-security:,output:,packages:,package-list:,proxy-ftp:,preseed:,proxy-http:,repositories:,section:,server-address:,server-path:,templates:,with-generic-indices,without-generic-indices,with-recommends,without-recommends,with-daemons,without-daemons,with-source,without-source,help,usage,version --name=${PROGRAM} --options r:t:a:b:c:d:e:f:k:m:o:p:s:huv --shell sh -- "${@}"`"

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
				export LIVE_ROOT
				;;

			-t|--type)
				LIVE_TYPE="${2}"; shift 2
				export LIVE_TYPE
				;;

			--tasks)
				LIVE_TASKS="${2}"; shift 2
				export LIVE_TASKS
				;;

			-a|--architecture)
				LIVE_ARCHITECTURE="${2}"; shift 2
				export LIVE_ARCHITECTURE
				;;

			-b|--bootappend)
				LIVE_BOOTAPPEND="${2}"; shift 2
				export LIVE_BOOTAPPEND
				;;

			--clone)
				LIVE_CLONE="${2}"; shift 2
				export LIVE_CLONE
				;;

			--config)
				LIVE_CONFIG="${2}"; shift 2
				export LIVE_CONFIG
				;;

			-c|--chroot)
				LIVE_CHROOT="${2}"; shift 2
				export LIVE_CHROOT
				;;

			-d|--distribution)
				LIVE_DISTRIBUTION="${2}"; shift 2
				export LIVE_DISTRIBUTION
				;;

			-e|--encryption)
				LIVE_ENCRYPTION="${2}"; shift 2
				export LIVE_ENCRYPTION
				;;

			--filesystem)
				LIVE_FILESYSTEM="${2}"; shift 2
				export LIVE_FILESYSTEM
				;;

			-f|--flavour)
				LIVE_FLAVOUR="${2}"; shift 2
				export LIVE_FLAVOUR
				;;
			--bootstrap-config)
				LIVE_BOOTSTRAP_CONFIG="${2}"; shift 2
				export LIVE_BOOTSTRAP_CONFIG
				;;
			--hook)
				LIVE_HOOK="${2}"; shift 2
				export LIVE_HOOK
				;;

			--include-chroot)
				LIVE_INCLUDE_CHROOT="${2}"; shift 2
				export LIVE_INCLUDE_CHROOT
				;;

			--include-image)
				LIVE_INCLUDE_IMAGE="${2}"; shift 2
				export LIVE_INCLUDE_IMAGE
				;;

			-k|--kernel)
				LIVE_KERNEL="${2}"; shift 2
				export LIVE_KERNEL
				;;

			--manifest)
				LIVE_MANIFEST="${2}"; shift 2
				export LIVE_MANIFEST
				;;

			-m|--mirror)
				LIVE_MIRROR="${2}"; shift 2
				export LIVE_MIRROR
				;;

			--keyring)
				LIVE_REPOSITORY_KEYRING="${2}"; shift 2
				export LIVE_REPOSITORY_KEYRING
				;;

			--mirror-security)
				LIVE_MIRROR_SECURITY="${2}"; shift 2
				export LIVE_MIRROR_SECURITY
				;;

			-o|--output)
				LIVE_IMAGE="${2}"; shift 2
				export LIVE_IMAGE
				;;

			--packages)
				LIVE_PACKAGES="${2}"; shift 2
				export LIVE_PACKAGES
				;;

			-p|--package-list)
				LIVE_PACKAGE_LIST="${2}"; shift 2
				export LIVE_PACKAGE_LIST
				;;

			--preseed)
				LIVE_PRESEED="${2}"; shift 2
				export LIVE_PRESEED
				;;

			--proxy-ftp)
				LIVE_PROXY_FTP="${2}"; shift 2
				export LIVE_PROXY_FTP
				;;

			--proxy-http)
				LIVE_PROXY_HTTP="${2}"; shift 2
				export LIVE_PROXY_HTTP
				;;

			--repositories)
				LIVE_REPOSITORIES="${2}"; shift 2
				export LIVE_REPOSITORIES
				;;

			-s|--section)
				LIVE_SECTION="${2}"; shift 2
				export LIVE_SECTION
				;;

			--server-address)
				LIVE_SERVER_ADDRESS="${2}"; shift 2
				export LIVE_SERVER_ADDRESS
				;;

			--server-path)
				LIVE_SERVER_PATH="${2}"; shift 2
				export LIVE_SERVER_PATH
				;;

			--templates)
				LIVE_TEMPLATES="${2}"; shift 2
				export LIVE_TEMPLATES
				;;

			--with-generic-indices)
				LIVE_GENERIC_INDICES="yes"; shift
				export LIVE_GENERIC_INDICES
				;;

			--without-generic-indices)
				LIVE_GENERIC_INDICES="no"; shift
				export LIVE_GENERIC_INDIDCES
				;;

			--with-recommends)
				LIVE_RECOMMENDS="yes"; shift
				export LIVE_RECOMMENDS
				;;

			--without-recommends)
				LIVE_RECOMMENDS="no"; shift
				export LIVE_RECOMMENDS
				;;

			--with-daemons)
				LIVE_DAEMONS="yes"; shift
				export LIVE_DAEMONS
				;;

			--without-daemons)
				LIVE_DAEMONS="no"; shift
				export LIVE_DEAMONS
				;;

			--with-source)
				LIVE_SOURCE="yes"; shift
				export LIVE_SOURCE
				;;

			--without-source)
				LIVE_SOURCE="no"; shift
				export LIVE_SOURCE
				;;

			-h|--help)
				Help; shift
				;;

			-u|--usage)
				Usage 0; shift
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

	# Initialising
	lh_testroot
	Configuration
	Defaults

	# Building live system
	lh_cdebootstrap
	Chroot

	# Building live image
	lh_buildbinary
	lh_buildsource
}

Main "${@}"
