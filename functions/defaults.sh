#!/bin/sh

# defaults.sh - handle default values
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Set_defaults ()
{
	## config/common

	# Setting mode
	if [ -z "${LH_MODE}" ]
	then
		LH_MODE="debian"
	fi

	# Setting distribution name
	if [ -z "${LH_DISTRIBUTION}" ]
	then
		case "${LH_MODE}" in
			debian)
				LH_DISTRIBUTION="lenny"
				;;

			emdebian)
				LH_DISTRIBUTION="sid"
				;;
		esac
	fi

	# Setting package manager
	if [ "${LH_DISTRIBUTION}" = "etch" ]
	then
		LH_APT="${LH_APT:-aptitude}"
	else
		LH_APT="${LH_APT:-apt}"
	fi

	# Setting apt ftp proxy
	if [ -z "${LH_APT_FTP_PROXY}" ] && [ -n "${ftp_proxy}" ]
	then
		LH_APT_FTP_PROXY="${ftp_proxy}"
	else
		if [ -n "${LH_APT_FTP_PROXY}" ] && [ "${LH_APT_FTP_PROXY}" != "${ftp_proxy}" ]
		then
			ftp_proxy="${LH_APT_FTP_PROXY}"
		fi
	fi

	# Setting apt http proxy
	if [ -z "${LH_APT_HTTP_PROXY}" ] && [ -n "${http_proxy}" ]
	then
		LH_APT_HTTP_PROXY="${http_proxy}"
	else
		if [ -n "${LH_APT_HTTP_PROXY}" ] && [ "${LH_APT_HTT_PROXY}" != "${http_proxy}" ]
		then
			http_proxy="${LH_APT_HTTP_PROXY}"
		fi
	fi

	# Setting apt pdiffs
	LH_APT_PDIFFS="${LH_APT_PDIFFS:-enabled}"

	# Setting apt pipeline
	# LH_APT_PIPELINE

	APT_OPTIONS="${APT_OPTIONS:---yes}"
	APTITUDE_OPTIONS="${APTITUDE_OPTIONS:---assume-yes}"

	# Setting apt recommends
	case "${LH_MODE}" in
		debian)
			LH_APT_RECOMMENDS="${LH_APT_RECOMMENDS:-enabled}"
			;;

		emdebian)
			LH_APT_RECOMMENDS="${LH_APT_RECOMMENDS:-disabled}"
			;;
	esac

	# Setting apt secure
	LH_APT_SECURE="${LH_APT_SECURE:-enabled}"

	# Setting bootstrap program
	if [ -z "${LH_BOOTSTRAP}" ]
	then
		if [ -x "/usr/sbin/debootstrap" ]
		then
			LH_BOOTSTRAP="debootstrap"
		elif [ -x "/usr/bin/cdebootstrap" ]
		then
			LH_BOOTSTRAP="cdebootstrap"
		else
			Echo_error "Cannot find /usr/sbin/debootstrap or /usr/bin/cdebootstrap. Please install"
			Echo_error "debootstrap or cdebootstrap, or specify an alternative bootstrapping utility."
			exit 1
		fi
	fi

	# Setting cache option
	LH_CACHE="${LH_CACHE:-enabled}"
	LH_CACHE_INDICES="${LH_CACHE_INDICES:-disabled}"
	LH_CACHE_PACKAGES="${LH_CACHE_PACKAGES:-enabled}"
	LH_CACHE_STAGES="${LH_CACHE_STAGES:-bootstrap}"

	# Setting debconf frontend
	LH_DEBCONF_FRONTEND="${LH_DEBCONF_FRONTEND:-noninteractive}"
	LH_DEBCONF_NOWARNINGS="${LH_DEBCONF_NOWARNINGS:-yes}"
	LH_DEBCONF_PRIORITY="${LH_DEBCONF_PRIORITY:-critical}"

	case "${LH_DEBCONF_NOWARNINGS}" in
		enabled)
			LH_DEBCONF_NOWARNINGS="yes"
			;;

		disabled)
			LH_DEBCONF_NOWARNINGS="no"
			;;
	esac

	# Setting initramfs hook
	if [ -z "${LH_INITRAMFS}" ]
	then
		LH_INITRAMFS="auto"
	else
		if [ "${LH_INITRAMFS}" = "auto" ]
		then
			case "${LH_MODE}" in
				debian)
					if [ "${LH_DISTRIBUTION}" = "etch" ]
					then
						LH_INITRAMFS="casper"
					else
						LH_INITRAMFS="live-initramfs"
					fi
					;;

				*)
					LH_INITRAMFS="live-initramfs"
					;;
			esac
		fi
	fi

	# Setting fdisk
	if [ -z "${LH_FDISK}" ]
	then
		# Workaround for gnu-fdisk divertion
		# (gnu-fdisk is buggy, #445304).
		if [ -x /sbin/fdisk.distrib ]
		then
			LH_FDISK="fdisk.distrib"
		elif [ -x /sbin/fdisk ]
		then
			LH_FDISK="fdisk"
		else
			Echo_error "Can't process file /sbin/fdisk"
		fi
	fi

	# Setting losetup
	if [ -z "${LH_LOSETUP}" ] || [ "${LH_LOSETUP}" != "/sbin/losetup.orig" ]
	then
		# Workaround for loop-aes-utils divertion
		# (loop-aes-utils' losetup lacks features).
		if [ -x /sbin/losetup.orig ]
		then
			LH_LOSETUP="losetup.orig"
		elif [ -x /sbin/losetup ]
		then
			LH_LOSETUP="losetup"
		else
			Echo_error "Can't process file /sbin/losetup"
		fi
	fi

	if [ "$(id -u)" = "0" ]
	then
		# If we are root, disable root command
		LH_ROOT_COMMAND=""
	else
		if [ -x /usr/bin/sudo ]
		then
			# FIXME: this is disabled until considered safe
			#LH_ROOT_COMMAND="sudo"
			LH_ROOT_COMMAND=""
		fi
	fi

	# Setting tasksel
	LH_TASKSEL="${LH_TASKSEL:-aptitude}"

	# Setting root directory
	if [ -z "${LH_ROOT}" ]
	then
		case "${LH_MODE}" in
			debian)
				LH_ROOT="debian-live"
				;;

			emdebian)
				LH_ROOT="emdebian-live"
				;;
		esac
	fi

	# Setting includes
	if [ -z "${LH_INCLUDES}" ]
	then
		LH_INCLUDES="${LH_BASE:-/usr/share/live-helper}/includes"
	fi

	# Setting templates
	if [ -z "${LH_TEMPLATES}" ]
	then
		LH_TEMPLATES="${LH_BASE:-/usr/share/live-helper}/templates"
	fi

	# Setting live helper options
	_BREAKPOINTS="${_BREAKPOINTS:-disabled}"
	_COLOR="${_COLOR:-disabled}"
	_DEBUG="${_DEBUG:-disabled}"
	_FORCE="${_FORCE:-disabled}"
	_QUIET="${_QUIET:-disabled}"
	_VERBOSE="${_VERBOSE:-disabled}"

	## config/bootstrap

	# Setting architecture value
	if [ -z "${LH_ARCHITECTURE}" ]
	then
		if [ -x "/usr/bin/dpkg" ]
		then
			LH_ARCHITECTURE="$(dpkg --print-architecture)"
		else
			case "$(uname -m)" in
				sparc|powerpc)
					LH_ARCHITECTURE="$(uname -m)"
					;;
				x86_64)
					LH_ARCHITECTURE="amd64"
					;;
				*)
					Echo_warning "Can't determine architecture, assuming i386"
					LH_ARCHITECTURE="i386"
					;;
			esac
		fi
	fi

	# Include packages on base
	# LH_BOOTSTRAP_INCLUDE

	# Exclude packages on base
	# LH_BOOTSTRAP_EXCLUDE

	# Setting distribution configuration value
	# LH_BOOTSTRAP_CONFIG

	# Setting flavour value
	case "${LH_BOOTSTRAP}" in
		cdebootstrap)
			LH_BOOTSTRAP_FLAVOUR="${LH_BOOTSTRAP_FLAVOUR:-standard}"
			;;
	esac

	# Setting bootstrap keyring
	# LH_BOOTSTRAP_KEYRING

	# Setting mirror to fetch packages from
	if [ -z "${LH_MIRROR_BOOTSTRAP}" ]
	then
		case "${LH_MODE}" in
			debian)
				case "${LH_ARCHITECTURE}" in
					amd64|i386)
						LH_MIRROR_BOOTSTRAP="http://ftp.us.debian.org/debian/"
						;;

					*)
						LH_MIRROR_BOOTSTRAP="http://ftp.de.debian.org/debian/"
						;;
				esac
				;;

			emdebian)
				LH_MIRROR_BOOTSTRAP="http://buildd.emdebian.org/grip/"
				;;
		esac
	fi

	LH_MIRROR_CHROOT="${LH_MIRROR_CHROOT:-${LH_MIRROR_BOOTSTRAP}}"

	# Setting security mirror to fetch packages from
	if [ -z "${LH_MIRROR_CHROOT_SECURITY}" ]
	then
		case "${LH_MODE}" in
			debian)
				LH_MIRROR_CHROOT_SECURITY="http://security.debian.org/"
				;;

			emdebian)
				LH_MIRROR_CHROOT_SECURITY="none"
				;;
		esac
	fi

	# Setting mirror which ends up in the image
	if [ -z "${LH_MIRROR_BINARY}" ]
	then
		case "${LH_MODE}" in
			debian)
				case "${LH_ARCHITECTURE}" in
					amd64|i386)
						LH_MIRROR_BINARY="http://ftp.us.debian.org/debian/"
						;;

					*)
						LH_MIRROR_BINARY="http://ftp.de.debian.org/debian/"
						;;
				esac
				;;

			emdebian)
				LH_MIRROR_BINARY="http://buildd.emdebian.org/grip/"
				;;
		esac
	fi

	# Setting security mirror which ends up in the image
	if [ -z "${LH_MIRROR_BINARY_SECURITY}" ]
	then
		case "${LH_MODE}" in
			debian)
				LH_MIRROR_BINARY_SECURITY="http://security.debian.org/"
				;;

			emdebian)
				LH_MIRROR_BINARY_SECURITY="none"
				;;
		esac
	fi

	# Setting categories value
	if [ -z "${LH_CATEGORIES}" ]
	then
		LH_CATEGORIES="main"
	fi

	## config/chroot

	# Setting chroot filesystem
	LH_CHROOT_FILESYSTEM="${LH_CHROOT_FILESYSTEM:-squashfs}"

	# Setting whether to expose root filesystem as read only
	LH_EXPOSED_ROOT="${LH_EXPOSED_ROOT:-disabled}"

	# Setting union filesystem
	if [ -z "${LH_UNION_FILESYSTEM}" ]
	then
		if [ "${LH_DISTRIBUTION}" = "etch" ]
		then
			LH_UNION_FILESYSTEM="unionfs"
		else
			LH_UNION_FILESYSTEM="aufs"
		fi
	fi

	# LH_HOOKS

	# Setting interactive shell/X11/Xnest
	LH_INTERACTIVE="${LH_INTERACTIVE:-disabled}"

	# Setting keyring packages
	case "${LH_MODE}" in
		debian)
			LH_KEYRING_PACKAGES="debian-archive-keyring"
			;;

		emdebian)
			LH_KEYRING_PACKAGES="debian-archive-keyring"
			;;
	esac

	# Setting language string
	LH_LANGUAGE="${LH_LANGUAGE:-en}"

	# Setting linux flavour string
	if [ -z "${LH_LINUX_FLAVOURS}" ]
	then
		case "${LH_ARCHITECTURE}" in
			alpha)
				LH_LINUX_FLAVOURS="alpha-generic"
				;;

			amd64)
				LH_LINUX_FLAVOURS="amd64"
				;;

			hppa)
				LH_LINUX_FLAVOURS="parisc"
				;;

			i386)
				case "${LIST}" in
					stripped|minimal)
						LH_LINUX_FLAVOURS="486"
						;;

					*)
						LH_LINUX_FLAVOURS="486 686"
						;;
				esac
				;;

			ia64)
				LH_LINUX_FLAVOURS="itanium"
				;;

			powerpc)
				case "${LIST}" in
					stripped|minimal)
						LH_LINUX_FLAVOURS="powerpc"
						;;

					*)
						LH_LINUX_FLAVOURS="powerpc powerpc64"
						;;
				esac
				;;

			s390)
				LH_LINUX_FLAVOURS="s390"
				;;

			sparc)
				if [ "${LH_DISTRIBUTION}" = "etch" ]
				then
					LH_LINUX_FLAVOURS="sparc32"
				else
					LH_LINUX_FLAVOURS="sparc64"
				fi
				;;

			arm|armel|m68k)
				Echo_error "You need to specify the linux kernel flavour manually on ${LH_ARCHITECTURE} (FIXME)."
				exit 1
				;;

			*)
				Echo_error "Architecture not yet supported (FIXME)"
				;;
		esac
	fi

	# Set linux packages
	if [ -z "${LH_LINUX_PACKAGES}" ]
	then
		LH_LINUX_PACKAGES="linux-image-2.6 \${LH_UNION_FILESYSTEM}-modules-2.6"

		if [ "${LH_CHROOT_FILESYSTEM}" = "squashfs" ]
		then
			LH_LINUX_PACKAGES="${LH_LINUX_PACKAGES} squashfs-modules-2.6"
		fi

		case "${LH_ENCRYPTION}" in
			""|disabled)
				;;
			*)
				LH_LINUX_PACKAGES="${LH_LINUX_PACKAGES} loop-aes-modules-2.6"
				;;
		esac
	fi

	# Setting packages string
	# LH_PACKAGES
	if [ -z "${LH_PACKAGES}" ] && [ "${LH_ENCRYPTION}" != "disabled" ]
	then
		LH_PACKAGES="loop-aes-utils"
	fi

	# Setting packages list string
	LH_PACKAGES_LISTS="${LH_PACKAGES_LISTS:-standard}"

	# Setting tasks string
	for LIST in ${LH_PACKAGES_LISTS}
	do
		case "${LIST}" in
			stripped|minimal)
				LH_APT="apt-get"
				;;

			gnome-desktop)
				LH_PACKAGES_LISTS="$(echo ${LH_PACKAGES_LISTS} | sed -e 's|gnome-desktop||') standard-x11"
				LH_TASKS="$(echo ${LH_TASKS} | sed -e 's|standard||' -e 's|laptop||' -e 's|gnome-desktop||' -e 's|desktop||') standard laptop gnome-desktop desktop"
				;;

			kde-desktop)
				LH_PACKAGES_LISTS="$(echo ${LH_PACKAGES_LISTS} | sed -e 's|kde-desktop||') standard-x11"
				LH_TASKS="$(echo ${LH_TASKS} | sed -e 's|standard||' -e 's|laptop||' -e 's|kde-desktop||' -e 's|desktop||') standard laptop kde-desktop desktop"
				;;

			lxde-desktop)
				LH_PACKAGES_LISTS="$(echo ${LH_PACKAGES_LISTS} | sed -e 's|lxde-desktop||') standard-x11"
				LH_TASKS="$(echo ${LH_TASKS} | sed -e 's|standard||' -e 's|laptop||' -e 's|lxde-desktop||' -e 's|desktop||') standard laptop lxde-desktop desktop"
				;;

			xfce-desktop)
				LH_PACKAGES_LISTS="$(echo ${LH_PACKAGES_LISTS} | sed -e 's|xfce-desktop||') standard-x11"
				LH_TASKS="$(echo ${LH_TASKS} | sed -e 's|standard||' -e 's|laptop||' -e 's|xfce-desktop||' -e 's|desktop||') standard laptop xfce-desktop desktop"
				;;
		esac
	done

	LH_PACKAGES_LISTS="$(echo ${LH_PACKAGES_LISTS} | sed -e 's|  ||g')"
	LH_TASKS="$(echo ${LH_TASKS} | sed -e 's|  ||g')"

	# Setting tasks
	# LH_TASKS

	# Setting security updates option
	if [ "${LH_MIRROR_CHROOT_SECURITY}" = "none" ] || [ "${LH_MIRROR_BINARY_SECURITY}" = "none" ]
	then
		LH_SECURITY="disabled"
	fi

	LH_SECURITY="${LH_SECURITY:-enabled}"

	# Setting symlink convertion option
	LH_SYMLINKS="${LH_SYMLINKS:-disabled}"

	# Setting sysvinit option
	LH_SYSVINIT="${LH_SYSVINIT:-disabled}"

	## config/binary

	# Setting image filesystem
	case "${LH_ARCHITECTURE}" in
		sparc)
			LH_BINARY_FILESYSTEM="${LH_BINARY_FILESYSTEM:-ext2}"
			;;
		*)
			LH_BINARY_FILESYSTEM="${LH_BINARY_FILESYSTEM:-fat16}"
			;;
	esac

	# Setting image type
	LH_BINARY_IMAGES="${LH_BINARY_IMAGES:-iso}"

	# Setting apt indices
	LH_BINARY_INDICES="${LH_BINARY_INDICES:-enabled}"

	# Setting bootloader
	if [ -z "${LH_BOOTLOADER}" ]
	then
		case "${LH_ARCHITECTURE}" in
			amd64|i386)
				LH_BOOTLOADER="syslinux"
				;;

			powerpc)
				LH_BOOTLOADER="yaboot"
				;;

			sparc)
				LH_BOOTLOADER="silo"
				;;
		esac
	fi

	# Setting checksums
	LH_CHECKSUMS="${LH_CHECKSUMS:-enabled}"

	# Setting chroot option
	LH_CHROOT_BUILD="${LH_CHROOT_BUILD:-enabled}"

	# Setting debian-installer option
	LH_DEBIAN_INSTALLER="${LH_DEBIAN_INSTALLER:-disabled}"

	# Setting debian-installer distribution
	LH_DEBIAN_INSTALLER_DISTRIBUTION="${LH_DEBIAN_INSTALLER_DISTRIBUTION:-${LH_DISTRIBUTION}}"

	# Setting debian-installer preseed filename
	if [ -z "${LH_DEBIAN_INSTALLER_PRESEEDFILE}" ]
	then
		if Find_files config/binary_debian-installer/preseed.cfg
		then
			LH_DEBIAN_INSTALLER_PRESEEDFILE="/preseed.cfg"
		fi

		if Find_files config/binary_debian-installer/*.cfg && [ ! -e config/binary_debian-installer/preseed.cfg ]
		then
			Echo_warning "You have placed some preseeding files into config/binary_debian-installer"
			Echo_warning "but you didn't specify the default preseeding file through"
			Echo_warning "LH_DEBIAN_INSTALLER_PRESEEDFILE. This means that debian-installer will not"
			Echo_warning "take up a preseeding file by default."
		fi
	fi

	# Setting boot parameters
	# LH_BOOTAPPEND_LIVE
	if [ -n "${LH_DEBIAN_INSTALLER_PRESEEDFILE}" ]
	then
		case "${LH_BINARY_IMAGES}" in
			iso)
				_LH_BOOTAPPEND_PRESEED="file=/cdrom/install/${LH_DEBIAN_INSTALLER_PRESEEDFILE}"
				;;

			usb-hdd)
				_LH_BOOTAPPEND_PRESEED="file=/hd-media/install/${LH_DEBIAN_INSTALLER_PRESEEDFILE}"
				;;

			net)
				case "${LH_DEBIAN_INSTALLER_PRESEEDFILE}" in
					*://*)
						_LH_BOOTAPPEND_PRESEED="file=${LH_DEBIAN_INSTALLER_PRESEEDFILE}"
						;;

					*)
						_LH_BOOTAPPEND_PRESEED="file=/${LH_DEBIAN_INSTALLER_PRESEEDFILE}"
						;;
				esac
				;;
		esac
	fi

	if [ -z "${LH_BOOTAPPEND_INSTALL}" ]
	then
		if [ -n ${_LH_BOOTAPPEND_PRESEED} ]
		then
			LH_BOOTAPPEND_INSTALL="${_LH_BOOTAPPEND_PRESEED} -- \${LH_BOOTAPPEND_LIVE}"
		else
			LH_BOOTAPPEND_INSTALL=" -- \${LH_BOOTAPPEND_LIVE}"
		fi
	fi

	# Setting encryption
	LH_ENCRYPTION="${LH_ENCRYPTION:-disabled}"

	# Setting grub splash
	# LH_GRUB_SPLASH

	# Setting hostname
	if [ -z "${LH_HOSTNAME}" ]
	then
		LH_HOSTNAME="debian"
	fi

	# Setting iso author
	if [ -z "${LH_ISO_APPLICATION}" ]
	then
		case "${LH_MODE}" in
			debian)
				LH_ISO_APPLICATION="Debian Live"
				;;

			emdebian)
				LH_ISO_APPLICATION="Emdebian Live"
				;;
		esac
	fi

	# Set iso preparer
	LH_ISO_PREPARER="${LH_ISO_PREPARER:-live-helper \$VERSION; http://packages.qa.debian.org/live-helper}"

	# Set iso publisher
	LH_ISO_PUBLISHER="${LH_ISO_PUBLISHER:-Debian Live project; http://debian-live.alioth.debian.org/; debian-live@lists.debian.org}"

	# Setting iso volume
	if [ -z "${LH_ISO_VOLUME}" ]
	then
		case "${LH_MODE}" in
			debian)
				LH_ISO_VOLUME="Debian Live \$(date +%Y%m%d-%H:%M)"
				;;

			emdebian)
				LH_ISO_VOLUME="Emdebian Live \$(date +%Y%m%d-%H:%M)"
				;;
		esac
	fi

	# Setting memtest option
	LH_MEMTEST="${LH_MEMTEST:-memtest86+}"

	# Setting win32-loader option
	case "${LH_ARCHITECTURE}" in
		amd64|i386)
			LH_WIN32_LOADER="${LH_WIN32_LOADER:-enabled}"
			;;

		*)
			LH_WIN32_LOADER="${LH_WIN32_LOADER:-disabled}"
			;;
	esac

	# Setting netboot filesystem
	LH_NET_ROOT_FILESYSTEM="${LH_NET_ROOT_FILESYSTEM:-nfs}"

	# Setting netboot server path
	if [ -z "${LH_NET_ROOT_PATH}" ]
	then
		case "${LH_MODE}" in
			debian)
				LH_NET_ROOT_PATH="/srv/debian-live"
				;;

			emdebian)
				LH_NET_ROOT_PATH="/srv/emdebian-live"
				;;
		esac
	fi

	# Setting netboot server address
	LH_NET_ROOT_SERVER="${LH_NET_ROOT_SERVER:-192.168.1.1}"

	# Setting net cow filesystem
	LH_NET_COW_FILESYSTEM="${LH_NET_COW_FILESYSTEM:-nfs}"

	# Setting net tarball
	LH_NET_TARBALL="${LH_NET_TARBALL:-gzip}"

	# Setting syslinux configuration file
	# LH_SYSLINUX_CFG

	# Setting syslinux splash
	# LH_SYSLINUX_SPLASH

	LH_SYSLINUX_TIMEOUT="${LH_SYSLINUX_TIMEOUT:-0}"

	# Setting syslinux menu
	LH_SYSLINUX_MENU="${LH_SYSLINUX_MENU:-disabled}"

	# Setting syslinux menu live entries
	LH_SYSLINUX_MENU_LIVE_ENTRY="${LH_SYSLINUX_MENU_LIVE_ENTRY:-Start ${LH_ISO_APPLICATION}}"
	LH_SYSLINUX_MENU_LIVE_ENTRY_FAILSAFE="${LH_SYSLINUX_MENU_LIVE_ENTRY_FAILSAFE:-${LH_SYSLINUX_MENU_LIVE_ENTRY} - Fail Safe}"

	# Settings memtest menu entry
	LH_SYSLINUX_MENU_MEMTEST_ENTRY="${LH_SYSLINUX_MENU_MEMTEST_ENTRY:-Memory test}"

	# Setting username
	LH_USERNAME="${LH_USERNAME:-user}"

	## config/source

	# Setting source option
	LH_SOURCE="${LH_SOURCE:-disabled}"

	# Setting image type
	LH_SOURCE_IMAGES="${LH_SOURCE_IMAGES:-tar}"

	# Setting fakeroot/fakechroot
	LH_USE_FAKEROOT="${LH_USE_FAKEROOT:-disabled}"
}

Check_defaults ()
{
	if [ "${LH_DISTRIBUTION}" = "etch" ]
	then
		if [ "${LH_INITRAMFS}" = "live-initramfs" ]
		then
			Echo_warning "You selected LH_DISTRIBUTION='etch' and LH_INITRAMFS='live-initramfs'"
			Echo_warning "This is a possible unsafe configuration as live-initramfs is not"
			Echo_warning "part of the etch distribution."
			Echo_warning "Either make sure that live-initramfs is installable (e.g. through setting up"
			Echo_warning "etch-backports repository as third-party source or putting a valid live-initramfs"
			Echo_warning "deb into config/chroot_local-packages) or switch change your config to etch"
			Echo_warning "default (casper)."
		fi

		if [ "${LH_UNION_FILESYSTEM}" = "aufs" ]
		then
			Echo_warning "You selected LH_DISTRIBUTION='etch' and LH_UNION_FILESYSTEM='aufs'"
			Echo_warning "This is a possible unsafe configuration as aufs is not"
			Echo_warning "part of the etch distribution."
			Echo_warning "Either make sure that aufs modules for your kernel are installable (e.g. through"
			Echo_warning "setting up etch-backports repository as third-party source or putting a valid"
			Echo_warning "aufs-modules deb into config/chroot_local-packages) or switch change your config"
			Echo_warning "to etch default (unionfs)."

		fi
	fi

	if echo ${LH_PACKAGES_LISTS} | grep -qs -E "(stripped|minimal)\b"
	then
		if [ "${LH_APT}" = "aptitude" ]
		then
			Echo_warning "You selected LH_PACKAGES_LISTS='%s' and LH_APT='aptitude'" "${LH_PACKAGES_LIST}"
			Echo_warning "This is a possible unsafe configuration as aptitude is not"
			Echo_warning "used in the stripped/minimal package lists."
		fi
	fi

	if [ "${LH_DEBIAN_INSTALLER}" != "disabled" ]
	then
		if ! echo ${LH_CACHE_STAGES} | grep -qs "bootstrap\b" || [ "${LH_CACHE}" != "enabled" ] || [ "${LH_CACHE_PACKAGES}" != "enabled" ]
		then
			Echo_warning "You have selected values of LH_CACHE, LH_CACHE_PACKAGES, LH_CACHE_STAGES and"
			Echo_warning "LH_DEBIAN_INSTALLER which will result in 'bootstrap' packages not being"
			Echo_warning "cached. This is a possible unsafe configuration as the bootstrap packages"
			Echo_warning "are re-used when integrating the Debian Installer."
		fi
	fi

	if [ "${LH_BOOTLOADER}" = "syslinux" ]
	then
		case "${LH_BINARY_FILESYSTEM}" in
			fat*)
				;;
			*)
				Echo_warning "You have selected values of LH_BOOTLOADER and LH_BINARY_FILESYSTEM"
				Echo_warning "which are incompatible - syslinux only supports FAT filesystems."
				;;
		esac
	fi
}
