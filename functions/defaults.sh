#!/bin/sh

# defaults.sh - handle default values
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

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

	# Setting apt secure
	if [ -z "${LH_APT_SECURE}" ]
	then
		LH_APT_SECURE="enabled"
	fi

	# Setting bootstrap program
	if [ -z "${LH_BOOTSTRAP}" ] || [ ! -x "${LH_BOOTSTRAP}" ]
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
	if [ -z "${LH_GENISOIMAGE}" ]
	then
		LH_GENISOIMAGE="genisoimage"
	fi

	# Setting losetup
	if [ -z "${LH_LOSETUP}" ] || [ ! -x "${LH_LOSETUP}" ]
	then
		# Check for loop-aes-utils divertion
		if [ -x /sbin/losetup.orig ]
		then
			LH_LOSETUP="losetup.orig"
		elif [ -x /sbin/losetup ]
		then
			LH_LOSETUP="losetup"
		else
			echo "E: Can't process file /sbin/losetup (FIXME)"
		fi
	fi

	# Setting root directory
	if [ -z "${LIVE_ROOT}" ]
	then
		LIVE_ROOT="debian-live"
	fi

	## config/bootstrap

	# Setting architecture value
	if [ -z "${LIVE_ARCHITECTURE}" ]
	then
		if [ -x "/usr/bin/dpkg" ]
		then
			LIVE_ARCHITECTURE="`dpkg --print-architecture`"
		else
			echo "E: Can't process file /usr/bin/dpkg (FIXME)"
		fi
	fi

	# Setting distribution value
	if [ -z "${LIVE_DISTRIBUTION}" ]
	then
		LIVE_DISTRIBUTION="sid"
	fi

	# Setting distribution configuration value
	# LIVE_DISTRIBUTION_CONFIG

	# Setting flavour value
	if [ -z "${LIVE_BOOTSTRAP_FLAVOUR}" ]
	then
			LIVE_BOOTSTRAP_FLAVOUR="standard"
	fi

	# Setting mirror to fetch packages from
	if [ -z "${LIVE_MIRROR_BUILD}" ]
	then
		LIVE_MIRROR_BUILD="http://ftp.debian.org/debian/"
	fi

	# Setting security mirror to fetch packages from
	if [ -z "${LIVE_MIRROR_BUILD_SECURITY}" ]
	then
		LIVE_MIRROR_BUILD_SECURITY="http://security.debian.org/"
	fi

	# Setting mirror which ends up in the image
	if [ -z "${LIVE_MIRROR_IMAGE}" ]
	then
		LIVE_MIRROR_IMAGE="http://ftp.debian.org/debian/"
	fi

	# Setting security mirror which ends up in the image
	if [ -z "${LIVE_MIRROR_IMAGE_SECURITY}" ]
	then
		LIVE_MIRROR_IMAGE_SECURITY="http://security.debian.org/"
	fi

	# Setting sections value
	if [ -z "${LIVE_SECTIONS}" ]
	then
		LIVE_SECTIONS="main"
	fi

	## config/chroot

	# Setting interactive shell/X11/Xnest
	if [ -z "${LIVE_INTERACTIVE}" ]
	then
		LIVE_INTERACTIVE="disabled"
	fi

	# Setting kernel flavour string
	if [ -z "${LIVE_KERNEL_FLAVOUR}" ]
	then
		case "${LIVE_ARCHITECTURE}" in
			alpha)
				LIVE_KERNEL_FLAVOUR="alpha-generic"
				;;

			amd64)
				LIVE_KERNEL_FLAVOUR="amd64"
				;;

			arm)
				echo "E: You need to specify the linux kernel flavour manually on arm (FIXME)."
				exit 1
				;;

			hppa)
				LIVE_KERNEL_FLAVOUR="parisc"
				;;

			i386)
				LIVE_KERNEL_FLAVOUR="486"
				;;

			ia64)
				LIVE_KERNEL_FLAVOUR="itanium"
				;;

			m68k)
				LIVE_KERNEL_FLAVOUR="E: You need to specify the linux kernel flavour manually on m68k."
				exit 1
				;;

			powerpc)
				LIVE_KERNEL_FLAVOUR="powerpc"
				;;

			s390)
				LIVE_KERNEL_FLAVOUR="s390"
				;;

			sparc)
				LIVE_KERNEL_FLAVOUR="sparc32"
				;;

			*)
				echo "E: Architecture notyet supported (FIXME)"
				;;
		esac
	fi

	# Set kernel packages
	if [ -z "${LIVE_KERNEL_PACKAGES}" ]
	then
		LIVE_KERNEL_PACKAGES="linux-image-2.6 squashfs-modules-2.6 unionfs-modules-2.6"

		if [ -n "${LIVE_ENCRYPTION}" ]
		then
			LIVE_KERNEL_PACKAGES="${LIVE_KERNEL_PACKAGES} loop-aes-modules-2.6"
		fi
	fi

	# Setting language string
	# LIVE_LANGUAGE

	# Setting tasks
	# LIVE_TASKS

	# Setting packages string
	# LIVE_PACKAGES

	# Setting packages list string
	if [ -z "${LIVE_PACKAGES_LISTS}" ]
	then
		LIVE_PACKAGES_LISTS="standard"
	fi

	# Setting tasks string
	for LIST in ${LIVE_PACKAGES_LISTS}
	do
		case "${LIST}" in
			gnome-desktop)
				LIVE_PACKAGES_LISTS="`echo ${LIVE_PACKAGES_LISTS} | sed -e 's/gnome-desktop//'` standard-x11"
				LIVE_TASKS="`echo ${LIVE_TASKS} | sed -e 's/standard//' -e 's/laptop//' -e 's/gnome-desktop//' -e 's/desktop//'` standard laptop desktop gnome-desktop"
				;;

			kde-desktop)
				LIVE_PACKAGES_LISTS="`echo ${LIVE_PACKAGES_LISTS} | sed -e 's/kde-desktop//'` standard-x11"
				LIVE_TASKS="`echo ${LIVE_TASKS} | sed -e 's/standard//' -e 's/laptop//' -e 's/kde-desktop//' -e 's/desktop//'` standard laptop desktop kde-desktop"
				;;

			xfce-desktop)
				LIVE_PACKAGES_LISTS="`echo ${LIVE_PACKAGES_LISTS} | sed -e 's/xfce-desktop//'` standard-x11"
				LIVE_TASKS="`echo ${LIVE_TASKS} | sed -e 's/standard//' -e 's/laptop//' -e 's/xfce-desktop//' -e 's/desktop//'` standard laptop desktop xfce-desktop"
				;;
		esac
	done

	LIVE_PACKAGES_LISTS="`echo ${LIVE_PACKAGES_LISTS} | sed -e 's/  //g'`"
	LIVE_TASKS="`echo ${LIVE_TASKS} | sed -e 's/  //g'`"

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
		LIVE_SYSVINIT="disabled"
	fi

	## config/image

	# Setting boot parameters
	# LIVE_BOOTAPPEND

	# Setting encryption
	# LIVE_ENCRYPTION

	# Setting username
	if [ -z "${LIVE_USERNAME}" ]
	then
		LIVE_USERNAME="user"
	fi

	# Setting hostname
	if [ -z "${LIVE_HOSTNAME}" ]
	then
		LIVE_HOSTNAME="debian"
	fi

	# Setting image type
	if [ -z "${LIVE_BINARY_IMAGE}" ]
	then
		LIVE_BINARY_IMAGE="iso"
	fi

	# Setting image type
	if [ -z "${LIVE_SOURCE_IMAGE}" ]
	then
		LIVE_SOURCE_IMAGE="generic"
	fi

	# Setting filesystem
	if [ -z "${LIVE_FILESYSTEM}" ]
	then
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
		LIVE_ISO_VOLUME="Debian Live \`date +%Y%m%d\`"
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

	# Setting grub
	if [ -z "${LIVE_BOOTLOADER}" ]
	then
		LIVE_BOOTLOADER="syslinux"
	fi

	# Setting grub splash
	# LIVE_GRUB_SPLASH

	# Setting syslinux splash
	# LIVE_SYSLINUX_SPLASH

	# Setting includes
	if [ -z "${LIVE_INCLUDES}" ]
	then
		LIVE_INCLUDES="/usr/share/live-helper/includes"
	fi

	# Setting templates
	if [ -z "${LIVE_TEMPLATES}" ]
	then
		LIVE_TEMPLATES="/usr/share/live-helper/templates"
	fi
}
