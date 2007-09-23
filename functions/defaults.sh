#!/bin/sh

# defaults.sh - handle default values

set -e

Set_defaults ()
{
	## config/common

	# Setting package manager
	if [ -z "${LH_APT}" ]
	then
		LH_APT="aptitude"
	fi

	# Setting apt ftp proxy
	if [ -z "${LH_APT_FTPPROXY}" ] && [ -n "${ftp_proxy}" ]
	then
		LH_APT_FTPPROXY="${ftp_proxy}"
	else
		if [ -n "${LH_APT_FTPPROXY}" ] && [ "${LH_APT_FTPRPOXY}" != "${ftp_proxy}" ]
		then
			ftp_proxy="${LH_APT_FTPRPOXY}"
		fi
	fi

	# Setting apt http proxy
	if [ -z "${LH_APT_HTTPPROXY}" ] && [ -n "${http_proxy}" ]
	then
		LH_APT_HTTPPROXY="${http_proxy}"
	else
		if [ -n "${LH_APT_HTTPPROXY}" ] && [ "${LH_APT_HTTPRPOXY}" != "${http_proxy}" ]
		then
			http_proxy="${LH_APT_HTTPPROXY}"
		fi
	fi

	# Setting apt indices
	if [ -z "${LH_APT_GENERIC}" ]
	then
		LH_APT_GENERIC="enabled"
	fi

	# Setting apt pdiffs
	if [ -z "${LH_APT_PDIFFS}" ]
	then
		LH_APT_PDIFFS="enabled"
	fi

	# Setting apt recommends
	if [ -z "${LH_APT_RECOMMENDS}" ]
	then
		LH_APT_RECOMMENDS="enabled"
	fi

	# Setting bootstrap program
	if [ -z "${LH_BOOTSTRAP}" ]
	then
		if [ -x "/usr/bin/cdebootstrap" ]
		then
			LH_BOOTSTRAP="cdebootstrap"
		elif [ -x "/usr/sbin/debootstrap" ]
		then
			LH_BOOTSTRAP="debootstrap"
		else
			echo "E: Can't process file /usr/bin/cdebootstrap or /usr/sbin/debootstrap (FIXME)"
			exit 1
		fi
	fi

	# Setting cache option
	if [ -z "${LH_CACHE}" ]
	then
		LH_CACHE="enabled"
	fi

	# Setting debconf frontend
	if [ -z "${LH_DEBCONF_FRONTEND}" ]
	then
		LH_DEBCONF_FRONTEND="noninteractive"
	fi

	if [ -z "${LH_DEBCONF_PRIORITY}" ]
	then
		LH_DEBCONF_PRIORITY="critical"
	fi

	# Setting genisoimage
	if [ -x /usr/bin/genisoimage ]
	then
		LH_GENISOIMAGE="genisoimage"
	elif [ -x /usr/bin/mkisofs ]
	then
		LH_GENISOIMAGE="mkisofs"
	else
		echo "E: cannot find genisoimage nor mkisofs (FIXME)."
		exit 1
	fi

	# Setting root directory
	if [ -z "${LIVE_ROOT}" ]
	then
		LIVE_ROOT="`pwd`/debian-live"
	fi

	# Setting chroot directory
	if [ -z "${LIVE_CHROOT}" ]
	then
		LIVE_CHROOT="${LIVE_ROOT}/chroot"
	fi

	## config/bootstrap

	# Setting architecture string
	if [ -z "${LIVE_ARCHITECTURE}" ]
	then
		if [ -x "/usr/bin/dpkg" ]
		then
			LIVE_ARCHITECTURE="`dpkg --print-architecture`"
		else
			echo "E: Can't process file /usr/bin/dpkg (FIXME)"
		fi
	fi

	# Setting distribution string
	if [ -z "${LIVE_DISTRIBUTION}" ]
	then
		LIVE_DISTRIBUTION="sid"
	fi

	# Setting distribution configuration string
	# LIVE_DISTRIBUTION_CONFIG

	# Setting flavour string
	if [ -z "${LIVE_FLAVOUR}" ]
	then
		LIVE_FLAVOUR="standard"
	fi

	# Setting mirror string
	if [ -z "${LIVE_MIRROR}" ]
	then
		LIVE_MIRROR="http://ftp.debian.org/debian/"
	fi

	# Setting security mirror string
	if [ -z "${LIVE_MIRROR_SECURITY}" ]
	then
		LIVE_MIRROR_SECURITY="http://security.debian.org/"
	fi

	# Setting mirror string
	if [ -z "${LIVE_MIRROR_GENERIC}" ]
	then
		LIVE_MIRROR_GENERIC="http://ftp.debian.org/debian/"
	fi

	# Setting security mirror string
	if [ -z "${LIVE_MIRROR_GENERIC_SECURITY}" ]
	then
		LIVE_MIRROR_GENERIC_SECURITY="http://security.debian.org/"
	fi

	# Setting sections string
	if [ -z "${LIVE_SECTIONS}" ]
	then
		LIVE_SECTIONS="main"
	fi

	## config/chroot

	# Setting kernel flavour string
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
				echo "E: You need to specify the linux kernel flavour manually on arm (FIXME)."
				exit 1
				;;

			hppa)
				LIVE_KERNEL="parisc"
				;;

			i386)
				LIVE_KERNEL="486"
				;;

			ia64)
				LIVE_KERNEL="itanium"
				;;

			m68k)
				LIVE_KERNEL="E: You need to specify the linux kernel flavour manually on m68k."
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
				echo "E: Architecture notyet supported (FIXME)"
				;;
		esac
	fi

	# Set kernel packages
	if [ -z "${LIVE_KERNEL_PACKAGES}" ]
	then
		LIVE_KERNEL_PACKAGES="linux-image-2.6-${LIVE_KERNEL} squashfs-modules-2.6-${LIVE_KERNEL} unionfs-modules-2.6-${LIVE_KERNEL} casper"

		if [ -n "${LIVE_ENCRYPTION}" ]
		then
			LIVE_KERNEL_PACKAGES="${LIVE_KERNEL_PACKAGES} loop-aes-modules-2.6-${LIVE_KERNEL} loop-aes-utils"
		fi
	fi

	# Setting language string
	# LIVE_LANGUAGE

	# Setting tasks
	# LIVE_TASKS

	# Setting packages string
	# LIVE_PACKAGES

	# Setting packages list string
	if [ -z "${LIVE_PACKAGES_LIST}" ]
	then
		if [ "${LIVE_FLAVOUR}" = "mini" ] || [ "${LIVE_FLAVOUR}" = "minimal" ]
		then
			LIVE_PACKAGES_LIST="minimal"
		else
			LIVE_PACKAGES_LIST="standard"
		fi
	fi

	# Setting tasks string
	for LIST in ${LIVE_PACKAGES_LIST}
	do
		case "${LIST}" in
			gnome-desktop)
				LIVE_PACKAGES_LIST="`echo ${LIVE_PACKAGES_LIST} | sed -e 's/gnome-desktop//'` standard-x11"
				LIVE_TASKS="${LIVE_TASKS} standard laptop desktop gnome-desktop"
				;;

			kde-desktop)
				LIVE_PACKAGES_LIST="`echo ${LIVE_PACKAGES_LIST} | sed -e 's/kde-desktop//'` standard-x11"
				LIVE_TASKS="${LIVE_TASKS} standard laptop desktop kde-desktop"
				;;

			xfce-desktop)
				LIVE_PACKAGES_LIST="`echo ${LIVE_PACKAGES_LIST} | sed -e 's/xfce-desktop//'` standard-x11"
				LIVE_TASKS="${LIVE_TASKS} standard laptop desktop xfce-desktop"
				;;
		esac
	done

	# Setting security updates option
	if [ -z "${LIVE_SECURITY}" ]
	then
		LIVE_SECURITY="enabled"
	fi

	# Setting symlink convertion option
	if [ -z "${LIVE_SYMLINKS}" ]
	then
		LIVE_SYMLINKS="disabled"
	fi

	# Setting sysvinit option
	if [ -z "${LIVE_SYSVINIT}" ]
	then
		if [ "${LIVE_FLAVOUR}" = "mini" ]
		then
			LIVE_SYSVINIT="enabled"
		else
			LIVE_SYSVINIT="disabled"
		fi
	fi

	## config/image

	# Setting boot parameters
	# LIVE_BOOTAPPEND

	# Setting encryption
	# LIVE_ENCRYPTION

	# Setting image type
	if [ -z "${LIVE_BINARY_IMAGE}" ]
	then
		LIVE_BINARY_IMAGE="iso"
	fi

	# Setting image type
	if [ -z "${LIVE_SOURCE_IMAGE}" ]
	then
		if [ "${LIVE_BINARY_IMAGE}" = "iso" ]
		then
			LIVE_SOURCE_IMAGE="iso"
		elif [ "${LIVE_BINARY_IMAGE}" = "usb" ]
		then
			LIVE_SOURCE_IMAGE="usb"
		elif [ "${LIVE_BINARY_IMAGE}" = "net" ]
		then
			LIVE_SOURCE_IMAGE="net"
		fi
	fi

	# Setting filesystem
	if [ -z "${LIVE_FILESYSTEM}" ] && [ "${LIVE_BINARY_IMAGE}" = "iso" ]
	then
		LIVE_FILESYSTEM="squashfs"
	elif [ -z "${LIVE_FILESYSTEM}" ] && [ "${LIVE_BINARY_IMAGE}" = "usb" ]
	then
		LIVE_FILESYSTEM="squashfs"
	elif [ -z "${LIVE_FILESYSTEM}" ] && [ "${LIVE_BINARY_IMAGE}" = "net" ]
	then
		LIVE_FILESYSTEM="plain"
	else
		LIVE_FILESYSTEM="squashfs"
	fi

	# Setting memtest86 option
	if [ -z "${LIVE_MEMTEST86}" ]
	then
		LIVE_MEMTEST86="enabled"
	fi

	# Setting iso volume
	if [ -z "${LIVE_ISO_VOLUME}" ]
	then
		LIVE_ISO_VOLUME='Debian Live ${DATE}'
	fi

	# Setting netboot server address
	if [ -z "${LIVE_SERVER_ADDRESS}" ]
	then
		LIVE_SERVER_ADDRESS="192.168.1.1"
	fi

	# Setting netboot server path
	if [ -z "${LIVE_SERVER_PATH}" ]
	then
		LIVE_SERVER_PATH="/srv/debian-live"
	fi

	# Setting source option
	if [ -z "${LIVE_SOURCE}" ]
	then
		LIVE_SOURCE="disabled"
	fi

	# Setting syslinux
	if [ -z "${LIVE_SYSLINUX}" ]
	then
		LIVE_SYSLINUX="enabled"
	fi

	# Setting syslinux splash
	# LIVE_SYSLINUX_SPLASH

	# Setting templates
	if [ -z "${LIVE_TEMPLATES}" ]
	then
		LIVE_TEMPLATES="/usr/share/live-helper/templates"
	fi
}
