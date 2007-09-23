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

	# Setting mode
	if [ -z "${LH_MODE}" ]
	then
		if [ -f /usr/bin/lsb_release ]
		then
			case "`lsb_release --short --id`" in
				Debian)
					LH_MODE="debian"
					;;

				Ubuntu)
					LH_MODE="ubuntu"
					;;
			esac
		else
			LH_MODE="debian"
		fi
	fi

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
		case "${LH_MODE}" in
			debian)
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
			;;

			ubuntu)
				if [ -x "/usr/sbin/debootstrap" ]
				then
					if [ -f /usr/lib/debootstrap/scripts/feisty ]
					then
						LH_BOOTSTRAP="debootstrap"
					else
						echo "E: Your version of debootstrap does not support ubuntu."
						exit 1
					fi
				else
					echo "E: You need to install debootstrap from Ubuntu in order to bootstrap ubuntu."
					exit 1
				fi
				;;
		esac
	fi

	# Setting cache option
	if [ -z "${LH_CACHE_INDICES}" ]
	then
		LH_CACHE_INDICES="disabled"
	fi

	if [ -z "${LH_CACHE_PACKAGES}" ]
	then
		LH_CACHE_PACKAGES="enabled"
	fi

	if [ -z "${LH_CACHE_STAGES}" ]
	then
		LH_CACHE_STAGES="bootstrap"
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

	if [ -z "${LH_DEBCONF_NOWARNINGS}" ]
	then
		LH_DEBCONF_NOWARNINGS="yes"
	fi

	# Setting genisoimage
	if [ -z "${LH_GENISOIMAGE}" ]
	then
		case "${LH_MODE}" in
			debian)
				LH_GENISOIMAGE="genisoimage"
				;;

			ubuntu)
				LH_GENISOIMAGE="mkisofs"
				;;
		esac
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

	# Setting tasksel
	if [ -z "${LH_TASKSEL}" ]
	then
		LH_TASKSEL="aptitude"
	fi

	# Setting initramfs generator
	if [ -z "${LH_INITRAMFS}" ]
	then
		LH_INITRAMFS="casper"
	fi

	# Setting root directory
	if [ -z "${LIVE_ROOT}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_ROOT="debian-live"
				;;

			ubuntu)
				LIVE_ROOT="ubuntu-live"
				;;
		esac
	fi

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

	# Setting live helper options
	if [ -z "${LH_BREAKPOINTS}" ]
	then
		LH_BREAKPOINTS="disabled"
	fi

	if [ -z "${LH_DEBUG}" ]
	then
		LH_DEBUG="disabled"
	fi

	if [ -z "${LH_FORCE}" ]
	then
		LH_FORCE="disabled"
	fi

	if [ -z "${LH_QUIET}" ]
	then
		LH_QUIET="disabled"
	fi

	if [ -z "${LH_VERBOSE}" ]
	then
		LH_VERBOSE="disabled"
	fi

	# If we are root, disable root command
	if [ "`id -u`" = "0" ]
	then
		LIVE_ROOT_COMMAND=""
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
		case "${LH_MODE}" in
			debian)
				LIVE_DISTRIBUTION="etch"
				;;

			ubuntu)
				LIVE_DISTRIBUTION="feisty"
				;;
		esac
	fi

	# Setting distribution configuration value
	# LIVE_BOOTSTRAP_CONFIG

	# Setting flavour value
	if [ -z "${LIVE_BOOTSTRAP_FLAVOUR}" ]
	then
			LIVE_BOOTSTRAP_FLAVOUR="standard"
	fi

	# Setting mirror to fetch packages from
	if [ -z "${LIVE_MIRROR_BUILD}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_MIRROR_BUILD="http://ftp.debian.org/debian/"
				;;

			ubuntu)
				LIVE_MIRROR_BUILD="http://archive.ubuntu.com/ubuntu/"
				;;
		esac
	fi

	# Setting security mirror to fetch packages from
	if [ -z "${LIVE_MIRROR_BUILD_SECURITY}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_MIRROR_BUILD_SECURITY="http://security.debian.org/"
				;;

			ubuntu)
				LIVE_MIRROR_BUILD_SECURITY="http://security.ubuntu.org/ubuntu/"
				;;
		esac
	fi

	# Setting mirror which ends up in the image
	if [ -z "${LIVE_MIRROR_IMAGE}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_MIRROR_IMAGE="http://ftp.debian.org/debian/"
				;;

			ubuntu)
				LIVE_MIRROR_IMAGE="http://archive.ubuntu.com/ubuntu/"
				;;
		esac
	fi

	# Setting security mirror which ends up in the image
	if [ -z "${LIVE_MIRROR_IMAGE_SECURITY}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_MIRROR_IMAGE_SECURITY="http://security.debian.org/"
				;;

			ubuntu)
				LIVE_MIRROR_IMAGE_SECURITY="http://security.ubuntu.com/ubuntu/"
				;;
		esac
	fi

	# Setting sections value
	if [ -z "${LIVE_SECTIONS}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_SECTIONS="main"
				;;

			ubuntu)
				LIVE_SECTIONS="main restricted"
				;;
		esac
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
				case "${LH_MODE}" in
					debian)
						LIVE_KERNEL_FLAVOUR="amd64"
						;;

					ubuntu)
						LIVE_KERNEL_FLAVOUR="amd64-generic"
						;;
				esac
				;;

			arm)
				echo "E: You need to specify the linux kernel flavour manually on arm (FIXME)."
				exit 1
				;;

			hppa)
				LIVE_KERNEL_FLAVOUR="parisc"
				;;

			i386)
				case "${LH_MODE}" in
					debian)
						LIVE_KERNEL_FLAVOUR="486"
						;;

					ubuntu)
						LIVE_KERNEL_FLAVOUR="386"
						;;
				esac
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
				case "${LH_MODE}" in
					debian)
						LIVE_KERNEL_FLAVOUR="sparc32"
						;;

					ubuntu)
						LIVE_KERNEL_FLAVOUR="sparc64"
						;;
				esac
				;;

			*)
				echo "E: Architecture notyet supported (FIXME)"
				;;
		esac
	fi

	# Set kernel packages
	if [ -z "${LIVE_KERNEL_PACKAGES}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_KERNEL_PACKAGES="linux-image-2.6 squashfs-modules-2.6 unionfs-modules-2.6"
				;;

			ubuntu)
				LIVE_KERNEL_PACKAGES="linux-image"
				;;
		esac

		if [ -n "${LIVE_ENCRYPTION}" ]
		then
			LIVE_KERNEL_PACKAGES="${LIVE_KERNEL_PACKAGES} loop-aes-modules-2.6"
		fi
	fi

	# Setting keyring packages
	# LIVE_KEYRING_PACKAGES

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
			mini|minimal)
				LH_APT="apt-get"
				;;

			gnome-desktop)
				LIVE_PACKAGES_LISTS="`echo ${LIVE_PACKAGES_LISTS} | sed -e 's/gnome-desktop//'` standard-x11"
				LIVE_TASKS="`echo ${LIVE_TASKS} | sed -e 's/standard//' -e 's/laptop//' -e 's/gnome-desktop//' -e 's/desktop//'` standard laptop gnome-desktop desktop"
				;;

			kde-desktop)
				LIVE_PACKAGES_LISTS="`echo ${LIVE_PACKAGES_LISTS} | sed -e 's/kde-desktop//'` standard-x11"
				LIVE_TASKS="`echo ${LIVE_TASKS} | sed -e 's/standard//' -e 's/laptop//' -e 's/kde-desktop//' -e 's/desktop//'` standard laptop kde-desktop desktop"
				;;

			xfce-desktop)
				LIVE_PACKAGES_LISTS="`echo ${LIVE_PACKAGES_LISTS} | sed -e 's/xfce-desktop//'` standard-x11"
				LIVE_TASKS="`echo ${LIVE_TASKS} | sed -e 's/standard//' -e 's/laptop//' -e 's/xfce-desktop//' -e 's/desktop//'` standard laptop xfce-desktop desktop"
				;;
		esac
	done

	LIVE_PACKAGES_LISTS="`echo ${LIVE_PACKAGES_LISTS} | sed -e 's/  //g'`"
	LIVE_TASKS="`echo ${LIVE_TASKS} | sed -e 's/  //g'`"

	# LIVE_HOOKS

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
		case "${LH_MODE}" in
			debian)
				LIVE_HOSTNAME="debian"
				;;

			ubuntu)
				LIVE_HOSTNAME="ubuntu"
				;;
		esac
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

	# Setting memtest option
	if [ -z "${LIVE_MEMTEST}" ]
	then
		LIVE_MEMTEST="memtest86+"
	fi

	# Setting debian-installer option
	if [ -z "${LIVE_DEBIAN_INSTALLER}" ]
	then
		LIVE_DEBIAN_INSTALLER="disabled"
	fi

	# Setting iso volume
	if [ -z "${LIVE_ISO_VOLUME}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_ISO_VOLUME="Debian Live \`date +%Y%m%d\`"
				;;

			ubuntu)
				LIVE_ISO_VOLUME="Ubuntu Live \`date +%Y%m%d\`"
				;;
		esac
	fi

	# Setting netboot server address
	if [ -z "${LIVE_SERVER_ADDRESS}" ]
	then
		LIVE_SERVER_ADDRESS="192.168.1.1"
	fi

	# Setting netboot server path
	if [ -z "${LIVE_SERVER_PATH}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_SERVER_PATH="/srv/debian-live"
				;;

			ubuntu)
				LIVE_SERVER_PATH="/srv/ubuntu-live"
				;;
		esac
	fi

	# Setting source option
	if [ -z "${LIVE_SOURCE}" ]
	then
		LIVE_SOURCE="disabled"
	fi

	# Setting grub
	if [ -z "${LIVE_BOOTLOADER}" ]
	then
		case "${LIVE_ARCHITECTURE}" in
			i386)
				LIVE_BOOTLOADER="syslinux"
				;;

			powerpc)
				LIVE_BOOTLOADER="yaboot"
				;;
		esac
	fi

	# Setting grub splash
	# LIVE_GRUB_SPLASH

	# Setting syslinux splash
	# LIVE_SYSLINUX_SPLASH
}
