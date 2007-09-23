#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Defaults ()
{
	# Set root directory
	if [ -z "${LIVE_ROOT}" ]
	then
		LIVE_ROOT="`pwd`/debian-live"
	fi

	# Set image type
	if [ -n "${LIVE_TYPE}" ]
	then
		case "${LIVE_TYPE}" in
			iso)
				LIVE_TYPE="Iso"
				;;

			net)
				LIVE_TYPE="Net"
				;;

			*)
				echo "E: image type wrong or not yet supported."
				Usage 1
				;;
		esac
	else
		LIVE_TYPE="Iso"
	fi

	# Set bootstrap architecture
	if [ -z "${LIVE_ARCHITECTURE}" ]
	then
		LIVE_ARCHITECTURE="`dpkg --print-architecture`"
	fi

	# Set chroot directory
	if [ -z "${LIVE_CHROOT}" ]
	then
		LIVE_CHROOT="${LIVE_ROOT}/chroot"
	fi

	# Set debian distribution
	if [ -z "${LIVE_DISTRIBUTION}" ]
	then
		LIVE_DISTRIBUTION="testing"
	fi

	if [ "${LIVE_DISTRIBUTION}" = "experimental" ]
	then
		LIVE_DISTRIBUTION="unstable"
		LIVE_DISTRIBUTION_EXPERIMENTAL="yes"
	fi

	# Set bootstrap flavour
	if [ -z "${LIVE_FLAVOUR}" ]
	then
		LIVE_FLAVOUR="standard"
	fi

	# Set filesystem
	if [ -z "${LIVE_FILESYSTEM}" ] && [ "${LIVE_TYPE}" = "Iso" ]
	then
		LIVE_FILESYSTEM="squashfs"
	elif [ -z "${LIVE_FILESYSTEM}" ] && [ "${LIVE_TYPE}" = "Net" ]
	then
		LIVE_FILESYSTEM="plain"
	fi

	# Set kernel flavour
	if [ -z "${LIVE_KERNEL}" ]
	then
		case "${LIVE_ARCHITECTURE}" in
			alpha)
				LIVE_KERNEL="alpha-generic"
				;;

			amd64)
				if [ "${LIVE_DISTRIBUTION}" = "unstable" ] || [ "${LIVE_DISTRIBUTION}" = "testing" ]
				then
					LIVE_KERNEL="amd64"
				else
					LIVE_KERNEL="amd64-generic"
				fi
				;;

			arm)
				echo "E: You need to specify the linux kernel flavour manually on arm."
				exit 1
				;;

			hppa)
				LIVE_KERNEL="parisc"
				;;

			i386)
				if [ "${LIVE_DISTRIBUTION}" = "oldstable" ] || [ "${LIVE_DISTRIBUTION}" = "stable" ]
				then
					LIVE_KERNEL="386"
				else
					LIVE_KERNEL="486"
				fi
				;;

			ia64)
				LIVE_KERNEL="itanium"
				;;

			m68k)
				echo "E: You need to specify the linux kernel flavour manually on m68k."
				exit 1
				;;

			powerpc)
				LIVE_KERNEL="powerpc"
				;;

			s390)
				LIVE_KERNEL="s390"
				;;

			sparc)
				LIVE_KERNEL="sparc32"
				;;

			*)
				echo "FIXME: Architecture not yet supported."
				Usage 1
				;;
		esac
	fi

	# Set kernel packages
	if [ -z "${LIVE_KERNEL_PACKAGES}" ]
	then
		LIVE_KERNEL_PACKAGES="linux-image-2.6-${LIVE_KERNEL} squashfs-modules-2.6-${LIVE_KERNEL} unionfs-modules-2.6-${LIVE_KERNEL}"
	fi

	# Set debian mirror
	if [ -z "${LIVE_MIRROR}" ]
	then
		LIVE_MIRROR="http://ftp.debian.org/debian/"
	fi

	# Set debian security mirror
	if [ -z "${LIVE_MIRROR_SECURITY}" ]
	then
		LIVE_MIRROR_SECURITY="http://security.debian.org/"
	fi

	# Check for package lists
	if [ -z "${LIVE_PACKAGE_LIST}" ]
	then
		if [ "${LIVE_FLAVOUR}" = "minimal" ]
		then
			LIVE_PACKAGE_LIST="${BASE}/lists/minimal"
		else
			LIVE_PACKAGE_LIST="${BASE}/lists/standard"
		fi
	else
		if [ ! -r "${LIVE_PACKAGE_LIST}" ]
		then
			if [ -r "${BASE}/lists/${LIVE_PACKAGE_LIST}" ]
			then
				LIVE_PACKAGE_LIST="${BASE}/lists/${LIVE_PACKAGE_LIST}"
			else
				LIVE_PACKAGE_LIST="${BASE}/lists/standard"
			fi
		fi
	fi

	# Set FTP proxy
	if [ -z "${LIVE_PROXY_FTP}" ] && [ -n "${ftp_proxy}" ]
	then
		LIVE_PROXY_FTP="${ftp_proxy}"
		export LIVE_PROXY_FTP
	else
		if [ -n "${LIVE_PROXY_FTP}" ] && [ "${LIVE_PROXY_FTP}" != "${ftp_proxy}" ]
		then
			ftp_proxy="${LIVE_PROXY_FTP}"
			export ftp_proxy
		fi
	fi

	# Set HTTP proxy
	if [ -z "${LIVE_PROXY_HTTP}" ] && [ -n "${http_proxy}" ]
	then
		LIVE_PROXY_HTTP="${http_proxy}"
		export LIVE_PROXY_HTTP
	else
		if [ -n "${LIVE_PROXY_HTTP}" ] && [ "${LIVE_PROXY_HTTP}" != "${http_proxy}" ]
		then
			http_proxy="${LIVE_PROXY_HTTP}"
			export http_proxy
		fi
	fi

	# Set debian sections
	if [ -z "${LIVE_SECTION}" ]
	then
		LIVE_SECTION="main"
	fi

	# Set netboot server
	if [ -z "${LIVE_SERVER_ADDRESS}" ]
	then
		LIVE_SERVER_ADDRESS="192.168.1.1"
	fi

	# Set netboot path
	if [ -z "${LIVE_SERVER_PATH}" ]
	then
		LIVE_SERVER_PATH="/srv/debian-live"
	fi

	# Set templates directory
	if [ -z "${LIVE_TEMPLATES}" ]
	then
		LIVE_TEMPLATES="${BASE}/templates"
	fi

	# Set package indices
	if [ -z "${LIVE_GENERIC_INDICES}" ] && [ "${LIVE_FLAVOUR}" != "minimal" ]
	then
		LIVE_GENERIC_INDICES="yes"
	fi

	# Set source image
	if [ -z "${LIVE_SOURCE}" ]
	then
		LIVE_SOURCE="no"
	fi
}
