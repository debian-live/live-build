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

	export LIVE_ROOT

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

			usb)
				LIVE_TYPE="Usb"
				;;

			*)
				echo "E: image type wrong or not yet supported."
				Usage 1
				;;
		esac
	else
		LIVE_TYPE="Iso"
	fi

	export LIVE_TYPE

	# Set bootstrap architecture
	if [ -z "${LIVE_ARCHITECTURE}" ]
	then
		LIVE_ARCHITECTURE="`dpkg --print-architecture`"
	fi

	export LIVE_ARCHITECTURE

	# Set chroot directory
	if [ -z "${LIVE_CHROOT}" ]
	then
		LIVE_CHROOT="${LIVE_ROOT}/chroot"
	fi

	export LIVE_CHROOT

	# Set debian distribution
	if [ -z "${LIVE_DISTRIBUTION}" ]
	then
		LIVE_DISTRIBUTION="unstable"
	fi

	if [ "${LIVE_DISTRIBUTION}" = "experimental" ]
	then
		LIVE_DISTRIBUTION="unstable"
		LIVE_DISTRIBUTION_EXPERIMENTAL="yes"
	fi

	export LIVE_DISTRIBUTION
	export LIVE_DISTRIBUTION_EXPERIMENTAL

	# Set bootstrap flavour
	if [ -z "${LIVE_FLAVOUR}" ]
	then
		LIVE_FLAVOUR="standard"
	fi

	export LIVE_FLAVOUR

	# Set filesystem
	if [ -z "${LIVE_FILESYSTEM}" ] && [ "${LIVE_TYPE}" = "Iso" ]
	then
		LIVE_FILESYSTEM="squashfs"
	elif [ -z "${LIVE_FILESYSTEM}" ] && [ "${LIVE_TYPE}" = "Usb" ]
	then
		LIVE_FILESYSTEM="squashfs"
	elif [ -z "${LIVE_FILESYSTEM}" ] && [ "${LIVE_TYPE}" = "Net" ]
	then
		LIVE_FILESYSTEM="plain"
	fi

	export LIVE_FILESYSTEM

	# Set kernel flavour
	if [ -z "${LIVE_KERNEL}" ]
	then
		case "${LIVE_ARCHITECTURE}" in
			alpha)
				LIVE_KERNEL="alpha-generic"
				;;

			amd64)
				LIVE_KERNEL="amd64"
				;;

			arm)
				echo "E: You need to specify the linux kernel flavour manually on arm."
				exit 1
				;;

			hppa)
				LIVE_KERNEL="parisc"
				;;

			i386)
				if [ "${LIVE_DISTRIBUTION}" = "oldstable" ] || [ "${LIVE_DISTRIBUTION}" = "${CODENAME_OLDSTABLE}" ] || \
				   [ "${LIVE_DISTRIBUTION}" = "stable" ] || [ "${LIVE_DISTRIBUTION}" = "${CODENAME_STABLE}" ]
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

	export LIVE_KERNEL

	# Set kernel packages
	if [ -z "${LIVE_KERNEL_PACKAGES}" ]
	then
		LIVE_KERNEL_PACKAGES="linux-image-2.6-${LIVE_KERNEL} squashfs-modules-2.6-${LIVE_KERNEL} unionfs-modules-2.6-${LIVE_KERNEL}"

 		if [ -n "${LIVE_ENCRYPTION}" ]
 		then
 			LIVE_KERNEL_PACKAGES="${LIVE_KERNEL_PACKAGES} loop-aes-modules-2.6-${LIVE_KERNEL} loop-aes-utils"
 		fi

	fi

	export LIVE_KERNEL_PACKAGES

	# Set debian mirror
	if [ -z "${LIVE_MIRROR}" ]
	then
		LIVE_MIRROR="http://ftp.debian.org/debian/"
	fi

	export LIVE_MIRROR

	# Set debian keyring
	if [ -z "${LIVE_REPOSITORY_KEYRING}" ]
	then
		LIVE_REPOSITORY_KEYRING="debian-archive-keyring"
	fi

	export LIVE_REPOSITORY_KEYRING

	# Set debian security mirror
	if [ -z "${LIVE_MIRROR_SECURITY}" ]
	then
		LIVE_MIRROR_SECURITY="http://security.debian.org/"
	fi

	export LIVE_MIRROR_SECURITY

	# Set default aptitude tasks
	if [ "${LIVE_PACKAGE_LIST}" = "gnome-desktop" ]
	then
		LIVE_PACKAGE_LIST="gnome"
		LIVE_TASKS="${LIVE_TASKS} standard laptop desktop gnome-desktop"
	elif [ "${LIVE_PACKAGE_LIST}" = "kde-desktop" ]
	then
		LIVE_PACKAGE_LIST="kde"
		LIVE_TASKS="${LIVE_TASKS} standard laptop desktop kde-desktop"
	elif [ "${LIVE_PACKAGE_LIST}" = "xfce-desktop" ]
	then
		LIVE_PACKAGE_LIST="xfce"
		LIVE_TASKS="${LIVE_TASKS} standard laptop desktop xfce-desktop"
	fi

	export LIVE_PACKAGE_LIST LIVE_TASKS

	# Check for package lists
	if [ -z "${LIVE_PACKAGE_LIST}" ]
	then
		if [ "${LIVE_FLAVOUR}" = "minimal" ]
		then
			LIVE_PACKAGE_LIST="${BASE}/lists/minimal"
		elif [ "${LIVE_FLAVOUR}" = "mini" ]
		then
			LIVE_PACKAGE_LISTS="${BASE}/lists/mini"
		else
			LIVE_PACKAGE_LIST="${BASE}/lists/standard"
		fi
	else
		if [ "${LIVE_PACKAGE_LIST}" != "everything" ]
		then
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
	fi

	export LIVE_PACKAGE_LIST

	if [ -n "${LIVE_PACKAGES}" ]
	then
		export LIVE_PACKAGES
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
	if [ -z "${LIVE_SECTIONS}" ]
	then
		LIVE_SECTIONS="main"
	fi

	export LIVE_SECTIONS

	# Set netboot server
	if [ -z "${LIVE_SERVER_ADDRESS}" ]
	then
		LIVE_SERVER_ADDRESS="192.168.1.1"
	fi

	export LIVE_SERVER_ADDRESS

	# Set netboot path
	if [ -z "${LIVE_SERVER_PATH}" ]
	then
		LIVE_SERVER_PATH="/srv/debian-live"
	fi

	export LIVE_SERVER_PATH

	# Set templates directory
	if [ -z "${LIVE_TEMPLATES}" ]
	then
		LIVE_TEMPLATES="${BASE}/templates"
	fi

	export LIVE_TEMPLATES

	# Set package indices
	if [ -z "${LIVE_GENERIC_INDICES}" ] && [ "${LIVE_FLAVOUR}" != "minimal" ] && [ "${LIVE_FLAVOUR}" != "mini" ]
	then
		LIVE_GENERIC_INDICES="yes"
	fi

	export LIVE_GENERIC_INDICES

	# Set recommends
	if [ -z "${LIVE_RECOMMENDS}" ]
	then
		LIVE_RECOMMENDS="no"
	fi

	export LIVE_RECOMMENDS

	# Set source image
	if [ -z "${LIVE_SOURCE}" ]
	then
		LIVE_SOURCE="no"
	fi

	export LIVE_SOURCE

	# Set disk volume
	if [ -z "${LIVE_DISK_VOLUME}" ]
	then
		LIVE_DISK_VOLUME="Debian Live `date +%Y%m%d`"
	fi

	export LIVE_DISK_VOLUME

	if [ -z "${LIVE_DEBCONF_FRONTEND}" ]
	then
		LIVE_DEBCONF_FRONTEND="noninteractive"
	fi

	export LIVE_DEBCONF_FRONTEND

	if [ -z "${LIVE_DEBCONF_PRIORITY}" ]
	then
		LIVE_DEBCONF_PRIORITY="critical"
	fi

	export LIVE_DEBCONF_PRIORITY

	if [ -z "${LIVE_DAEMONS}" ]
	then
		LIVE_DAEMONS="yes"
	fi

	export LIVE_DAEMONS

	# This is a hack because Ubuntu does not ship cdrkit already
	if [ -x /usr/bin/genisoimage ]
	then
		GENISOIMAGE="/usr/bin/genisoimage"
	else
		GENISOIMAGE="/usr/bin/mkisofs"
	fi

	export GENISOIMAGE

	# Variables that do not have defaults but need to be exported to
	# allow other helpers to use their values
	export LIVE_BOOTAPPEND LIVE_BOOTSTRAP_CONFIG LIVE_INCLUDE_CHROOT LIVE_PRESEED
}
