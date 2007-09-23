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
		if [ -x /usr/bin/lsb_release ]
		then
			case "`lsb_release --short --id`" in
				Debian)
					LH_MODE="debian"
					;;

				Ubuntu)
					LH_MODE="ubuntu"
					;;

				*)
					Echo_verbose "Unexpected output from lsb_release"
					Echo_verbose "Setting mode to debian."
					LH_MODE="debian"
					;;
			esac
		else
			LH_MODE="debian"
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

	# Setting package manager
	LH_APT="${LH_APT:-aptitude}"

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

	# Setting apt pdiffs
	LH_APT_PDIFFS="${LH_APT_PDIFFS:-enabled}"

	# Setting apt pipeline
	# LH_APT_PIPELINE

	# Setting apt recommends
	LH_APT_RECOMMENDS="${LH_APT_RECOMMENDS:-enabled}"

	# Setting apt secure
	LH_APT_SECURE="${LH_APT_SECURE:-enabled}"

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
				if [ -x "/usr/bin/cdebootstrap" ] && [ -d /usr/share/cdebootstrap/generic-ubuntu ]
				then
					LH_BOOTSTRAP="cdebootstrap"
				elif [ -x "/usr/sbin/debootstrap" ] && [ -f /usr/lib/debootstrap/scripts/feisty ]
				then
					LH_BOOTSTRAP="debootstrap"
				else
					echo "E: Your version of debootstrap or cdebootstrap is outdated and does not support ubuntu."
					exit 1
				fi
				;;
		esac
	fi

	# Setting cache option
	LH_CACHE_INDICES="${LH_CACHE_INDICES:-disabled}"
	LH_CACHE_PACKAGES="${LH_CACHE_PACKAGES:-enabled}"
	LH_CACHE_STAGES="${LH_CACHE_STAGES:-bootstrap}"

	# Setting debconf frontend
	LH_DEBCONF_FRONTEND="${LH_DEBCONF_FRONTEND:-noninteractive}"
	LH_DEBCONF_NOWARNINGS="${LH_DEBCONF_NOWARNINGS:-yes}"
	LH_DEBCONF_PRIORITY="${LH_DEBCONF_PRIORITY:-critical}"

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

	# Setting initramfs hook
	if [ -z "${LH_INITRAMFS}" ]
	then
		if [ "${LIVE_DISTRIBUTION}" = "etch" ]
		then
			LH_INITRAMFS="casper"
		else
			LH_INITRAMFS="live-initramfs"
		fi
	fi

	# Setting losetup
	if [ -z "${LH_LOSETUP}" ] || [ ! -x "${LH_LOSETUP}" ]
	then
		# Workaround for loop-aes-utils divertion
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

	if [ "`id -u`" = "0" ]
	then
		# If we are root, disable root command
		LIVE_ROOT_COMMAND=""
	else
		if [ -x /usr/bin/sudo ]
		then
			# FIXME: this is disabled until considered safe
			#LIVE_ROOT_COMMAND="sudo"
			LIVE_ROOT_COMMAND=""
		fi
	fi

	# Setting tasksel
	LH_TASKSEL="${LH_TASKSEL:-aptitude}"

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
		LIVE_INCLUDES="${LH_BASE:-/usr/share/live-helper}/includes"
	fi

	# Setting templates
	if [ -z "${LIVE_TEMPLATES}" ]
	then
		LIVE_TEMPLATES="${LH_BASE:-/usr/share/live-helper}/templates"
	fi

	# Setting live helper options
	LH_BREAKPOINTS="${LH_BREAKPOINTS:-disabled}"
	LH_DEBUG="${LH_DEBUG:-disabled}"
	LH_FORCE="${LH_FORCE:-disabled}"
	LH_QUIET="${LH_QUIET:-disabled}"
	LH_VERBOSE="${LH_VERBOSE:-disabled}"

	## config/bootstrap

	# Setting architecture value
	if [ -z "${LIVE_ARCHITECTURE}" ]
	then
		if [ -x "/usr/bin/dpkg" ]
		then
			LIVE_ARCHITECTURE="`dpkg --print-architecture`"
		else
			echo "W: Can't process file /usr/bin/dpkg, setting architecture to i386"
			LIVE_ARCHITECTURE="i386"
		fi
	fi

	# Setting distribution configuration value
	# LIVE_BOOTSTRAP_CONFIG

	# Setting flavour value
	LIVE_BOOTSTRAP_FLAVOUR="${LIVE_BOOTSTRAP_FLAVOUR:-standard}"

	# Setting boostrap keyring
	# LIVE_BOOTSTRAP_KEYRING

	# Setting mirror to fetch packages from
	if [ -z "${LIVE_MIRROR_BOOTSTRAP}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_MIRROR_BOOTSTRAP="http://ftp.debian.org/debian/"
				;;

			ubuntu)
				LIVE_MIRROR_BOOTSTRAP="http://archive.ubuntu.com/ubuntu/"
				;;
		esac
	fi

	# Setting security mirror to fetch packages from
	if [ -z "${LIVE_MIRROR_BOOTSTRAP_SECURITY}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_MIRROR_BOOTSTRAP_SECURITY="http://security.debian.org/"
				;;

			ubuntu)
				LIVE_MIRROR_BOOTSTRAP_SECURITY="http://security.ubuntu.org/ubuntu/"
				;;
		esac
	fi

	# Setting mirror which ends up in the image
	if [ -z "${LIVE_MIRROR_BINARY}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_MIRROR_BINARY="http://ftp.debian.org/debian/"
				;;

			ubuntu)
				LIVE_MIRROR_BINARY="http://archive.ubuntu.com/ubuntu/"
				;;
		esac
	fi

	# Setting security mirror which ends up in the image
	if [ -z "${LIVE_MIRROR_BINARY_SECURITY}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_MIRROR_BINARY_SECURITY="http://security.debian.org/"
				;;

			ubuntu)
				LIVE_MIRROR_BINARY_SECURITY="http://security.ubuntu.com/ubuntu/"
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

	# Setting chroot filesystem
	LIVE_CHROOT_FILESYSTEM="${LIVE_CHROOT_FILESYSTEM:-squashfs}"

	# LIVE_HOOKS

	# Setting interactive shell/X11/Xnest
	LIVE_INTERACTIVE="${LIVE_INTERACTIVE:-disabled}"

	# Setting keyring packages
	# LIVE_KEYRING_PACKAGES

	# Setting language string
	# LIVE_LANGUAGE

	# Setting linux flavour string
	if [ -z "${LIVE_LINUX_FLAVOURS}" ]
	then
		case "${LIVE_ARCHITECTURE}" in
			alpha)
				LIVE_LINUX_FLAVOURS="alpha-generic"
				;;

			amd64)
				case "${LH_MODE}" in
					debian)
						LIVE_LINUX_FLAVOURS="amd64"
						;;

					ubuntu)
						LIVE_LINUX_FLAVOURS="amd64-generic"
						;;
				esac
				;;

			arm)
				echo "E: You need to specify the linux kernel flavour manually on arm (FIXME)."
				exit 1
				;;

			hppa)
				LIVE_LINUX_FLAVOURS="parisc"
				;;

			i386)
				case "${LH_MODE}" in
					debian)
						LIVE_LINUX_FLAVOURS="486"
						;;

					ubuntu)
						LIVE_LINUX_FLAVOURS="386"
						;;
				esac
				;;

			ia64)
				LIVE_LINUX_FLAVOURS="itanium"
				;;

			m68k)
				LIVE_LINUX_FLAVOURS="E: You need to specify the linux kernel flavour manually on m68k."
				exit 1
				;;

			powerpc)
				LIVE_LINUX_FLAVOURS="powerpc"
				;;

			s390)
				LIVE_LINUX_FLAVOURS="s390"
				;;

			sparc)
				case "${LH_MODE}" in
					debian)
						LIVE_LINUX_FLAVOURS="sparc32"
						# FIXME: needs update after etch
						;;

					ubuntu)
						LIVE_LINUX_FLAVOURS="sparc64"
						;;
				esac
				;;

			*)
				echo "E: Architecture notyet supported (FIXME)"
				;;
		esac
	fi

	# Set linux packages
	if [ -z "${LIVE_LINUX_PACKAGES}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_LINUX_PACKAGES="linux-image-2.6 squashfs-modules-2.6 unionfs-modules-2.6"
				;;

			ubuntu)
				LIVE_LINUX_PACKAGES="linux-image"
				;;
		esac

		if [ -n "${LIVE_ENCRYPTION}" ]
		then
			LIVE_LINUX_PACKAGES="${LIVE_LINUX_PACKAGES} loop-aes-modules-2.6"
		fi
	fi

	# Setting packages string
	# LIVE_PACKAGES

	# Setting packages list string
	LIVE_PACKAGES_LISTS="${LIVE_PACKAGES_LISTS:-standard}"

	# Setting package preseed
	# LIVE_PRESEED

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

	# Setting tasks
	# LIVE_TASKS

	# Setting security updates option
	LIVE_SECURITY="${LIVE_SECURITY:-enabled}"

	# Setting symlink convertion option
	LIVE_SYMLINKS="${LIVE_SYMLINKS:-disabled}"

	# Setting sysvinit option
	LIVE_SYSVINIT="${LIVE_SYSVINIT:-disabled}"

	## config/binary

	# Setting image type
	LIVE_BINARY_IMAGES="${LIVE_BINARY_IMAGES:-iso}"

	# Setting apt indices
	LIVE_BINARY_INDICES="${LIVE_BINARY_INDICES:-enabled}"

	# Setting boot parameters
	# LIVE_BOOTAPPEND

	# Setting bootloader
	if [ -z "${LIVE_BOOTLOADER}" ]
	then
		case "${LIVE_ARCHITECTURE}" in
			amd64|i386)
				LIVE_BOOTLOADER="syslinux"
				;;

			powerpc)
				LIVE_BOOTLOADER="yaboot"
				;;
		esac
	fi

	# Setting debian-installer option
	LIVE_DEBIAN_INSTALLER="${LIVE_DEBIAN_INSTALLER:-disabled}"

	# Setting encryption
	# LIVE_ENCRYPTION

	# Setting grub splash
	# LIVE_GRUB_SPLASH

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

	# Setting iso author
	if [ -z "${LIVE_ISO_APPLICATION}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_ISO_APPLICATION="Debian Live"
				;;

			ubuntu)
				LIVE_ISO_APPLICATION="Ubuntu Live"
				;;
		esac
	fi

	# Set iso preparer
	LIVE_ISO_PREPARER="${LIVE_ISO_PREPARER:-live-helper ${VERSION}; http://packages.qa.debian.org/live-helper}"

	# Set iso publisher
	LIVE_ISO_PUBLISHER="${LIVE_ISO_PUBLISHER:-Debian Live project; http://debian-live.alioth.debian.org/; debian-live-devel@lists.alioth.debian.org}"

	# Setting iso volume
	if [ -z "${LIVE_ISO_VOLUME}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_ISO_VOLUME="Debian Live \`date +%Y%m%d-%H:%M\`"
				;;

			ubuntu)
				LIVE_ISO_VOLUME="Ubuntu Live \`date +%Y%m%d-%H:%M\`"
				;;
		esac
	fi

	# Setting memtest option
	LIVE_MEMTEST="${LIVE_MEMTEST:-memtest86+}"

	# Setting netboot server path
	if [ -z "${LIVE_NET_PATH}" ]
	then
		case "${LH_MODE}" in
			debian)
				LIVE_NET_PATH="/srv/debian-live"
				;;

			ubuntu)
				LIVE_NET_PATH="/srv/ubuntu-live"
				;;
		esac
	fi

	# Setting netboot server address
	LIVE_NET_SERVER="${LIVE_NET_SERVER:-192.168.1.1}"

	# Setting syslinux splash
	# LIVE_SYSLINUX_SPLASH

	# Setting username
	LIVE_USERNAME="${LIVE_USERNAME:-user}"

	## config/source

	# Setting source option
	LIVE_SOURCE="${LIVE_SOURCE:-disabled}"

	# Setting image type
	LIVE_SOURCE_IMAGES="${LIVE_SOURCE_IMAGES:-tar}"
}
