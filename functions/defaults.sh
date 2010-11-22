#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2010 Daniel Baumann <daniel@debian.org>
##
## live-build comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


Set_defaults ()
{
	## config/common

	LB_BASE="${LB_BASE:-/usr/share/live/build}"

	# Setting mode
	if [ -z "${LB_MODE}" ]
	then
		LB_MODE="debian"
	fi

	# Setting distribution name
	if [ -z "${LB_DISTRIBUTION}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				LB_DISTRIBUTION="squeeze"
				;;

			emdebian)
				LB_DISTRIBUTION="sid"
				;;

			ubuntu)
				LB_DISTRIBUTION="karmic"
				;;
		esac
	fi

	# Setting package manager
	LB_APT="${LB_APT:-apt}"

	# Setting apt ftp proxy
	if [ -z "${LB_APT_FTP_PROXY}" ] && [ -n "${ftp_proxy}" ]
	then
		LB_APT_FTP_PROXY="${ftp_proxy}"
	else
		if [ -n "${LB_APT_FTP_PROXY}" ] && [ "${LB_APT_FTP_PROXY}" != "${ftp_proxy}" ]
		then
			ftp_proxy="${LB_APT_FTP_PROXY}"
		fi
	fi

	# Setting apt http proxy
	if [ -z "${LB_APT_HTTP_PROXY}" ] && [ -n "${http_proxy}" ]
	then
		LB_APT_HTTP_PROXY="${http_proxy}"
	else
		if [ -n "${LB_APT_HTTP_PROXY}" ] && [ "${LB_APT_HTTP_PROXY}" != "${http_proxy}" ]
		then
			http_proxy="${LB_APT_HTTP_PROXY}"
		fi
	fi

	# Setting apt pdiffs
	LB_APT_PDIFFS="${LB_APT_PDIFFS:-true}"

	# Setting apt pipeline
	# LB_APT_PIPELINE

	APT_OPTIONS="${APT_OPTIONS:---yes}"
	APTITUDE_OPTIONS="${APTITUDE_OPTIONS:---assume-yes}"

	GZIP_OPTIONS="${GZIP_OPTIONS:---best}"

	if gzip --help | grep -qs "\-\-rsyncable"
	then
		GZIP_OPTIONS="$(echo ${GZIP_OPTIONS} | sed -e 's|--rsyncable||') --rsyncable"
	fi

	# Setting apt recommends
	case "${LB_MODE}" in
		debian|debian-release|ubuntu)
			LB_APT_RECOMMENDS="${LB_APT_RECOMMENDS:-true}"
			;;

		emdebian)
			LB_APT_RECOMMENDS="${LB_APT_RECOMMENDS:-false}"
			;;
	esac

	# Setting apt secure
	LB_APT_SECURE="${LB_APT_SECURE:-true}"

	# Setting bootstrap program
	if [ -z "${LB_BOOTSTRAP}" ] || ( [ ! -x "$(which ${LB_BOOTSTRAP} 2>/dev/null)" ] && [ "${LB_BOOTSTRAP}" != "copy" ] )
	then
		if [ -x "/usr/sbin/debootstrap" ]
		then
			LB_BOOTSTRAP="debootstrap"
		elif [ -x "/usr/bin/cdebootstrap" ]
		then
			LB_BOOTSTRAP="cdebootstrap"
		else
			Echo_error "Cannot find /usr/sbin/debootstrap or /usr/bin/cdebootstrap. Please install debootstrap or cdebootstrap, or specify an alternative bootstrapping utility."
			exit 1
		fi
	fi

	# Setting cache option
	LB_CACHE="${LB_CACHE:-true}"
	LB_CACHE_INDICES="${LB_CACHE_INDICES:-false}"
	LB_CACHE_PACKAGES="${LB_CACHE_PACKAGES:-true}"
	LB_CACHE_STAGES="${LB_CACHE_STAGES:-bootstrap}"

	# Setting debconf frontend
	LB_DEBCONF_FRONTEND="${LB_DEBCONF_FRONTEND:-noninteractive}"
	LB_DEBCONF_NOWARNINGS="${LB_DEBCONF_NOWARNINGS:-yes}"
	LB_DEBCONF_PRIORITY="${LB_DEBCONF_PRIORITY:-critical}"

	case "${LB_DEBCONF_NOWARNINGS}" in
		true)
			LB_DEBCONF_NOWARNINGS="yes"
			;;

		false)
			LB_DEBCONF_NOWARNINGS="no"
			;;
	esac

	# Setting initramfs hook
	if [ -z "${LB_INITRAMFS}" ]
	then
		LB_INITRAMFS="auto"
	else
		if [ "${LB_INITRAMFS}" = "auto" ]
		then
			case "${LB_MODE}" in
				ubuntu)
					LB_INITRAMFS="casper"
					;;

				*)
					case "${LB_DISTRIBUTION}" in
						wheezy)
							LB_INITRAMFS="live-boot"
							;;

						*)
							LB_INITRAMFS="live-initramfs"
							;;
					esac
					;;
			esac
		fi
	fi

	# Setting fdisk
	if [ -z "${LB_FDISK}" ] || [ ! -x "${LB_FDISK}" ]
	then
		# Workaround for gnu-fdisk divertion
		# (gnu-fdisk is buggy, #445304).
		if [ -x /sbin/fdisk.distrib ]
		then
			LB_FDISK="fdisk.distrib"
		elif [ -x /sbin/fdisk ]
		then
			LB_FDISK="fdisk"
		else
			Echo_error "Can't process file /sbin/fdisk"
		fi
	fi

	# Setting losetup
	if [ -z "${LB_LOSETUP}" ] || [ "${LB_LOSETUP}" != "/sbin/losetup.orig" ]
	then
		# Workaround for loop-aes-utils divertion
		# (loop-aes-utils' losetup lacks features).
		if [ -x /sbin/losetup.orig ]
		then
			LB_LOSETUP="losetup.orig"
		elif [ -x /sbin/losetup ]
		then
			LB_LOSETUP="losetup"
		else
			Echo_error "Can't process file /sbin/losetup"
		fi
	fi

	if [ "$(id -u)" = "0" ]
	then
		# If we are root, disable root command
		LB_ROOT_COMMAND=""
	else
		if [ -x /usr/bin/sudo ]
		then
			# FIXME: this is false until considered safe
			#LB_ROOT_COMMAND="sudo"
			LB_ROOT_COMMAND=""
		fi
	fi

	# Setting tasksel
	LB_TASKSEL="${LB_TASKSEL:-tasksel}"

	# Setting root directory
	if [ -z "${LB_ROOT}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				LB_ROOT="debian-live"
				;;

			emdebian)
				LB_ROOT="emdebian-live"
				;;

			ubuntu)
				LB_ROOT="ubuntu-live"
				;;
		esac
	fi

	# Setting includes
	if [ -z "${LB_INCLUDES}" ]
	then
		LB_INCLUDES="${LB_BASE}/includes"
	fi

	# Setting templates
	if [ -z "${LB_TEMPLATES}" ]
	then
		LB_TEMPLATES="${LB_BASE}/templates"
	fi

	# Setting live build options
	_BREAKPOINTS="${_BREAKPOINTS:-false}"
	_COLOR="${_COLOR:-false}"
	_DEBUG="${_DEBUG:-false}"
	_FORCE="${_FORCE:-false}"
	_QUIET="${_QUIET:-false}"
	_VERBOSE="${_VERBOSE:-false}"

	## config/bootstrap

	# Setting architecture value
	if [ -z "${LB_ARCHITECTURE}" ]
	then
		if [ -x "/usr/bin/dpkg" ]
		then
			LB_ARCHITECTURE="$(dpkg --print-architecture)"
		else
			case "$(uname -m)" in
				sparc|powerpc)
					LB_ARCHITECTURE="$(uname -m)"
					;;
				x86_64)
					LB_ARCHITECTURE="amd64"
					;;
				*)
					Echo_warning "Can't determine architecture, assuming i386"
					LB_ARCHITECTURE="i386"
					;;
			esac
		fi
	fi

	# Include packages on base
	# LB_BOOTSTRAP_INCLUDE

	# Exclude packages on base
	# LB_BOOTSTRAP_EXCLUDE

	# Setting distribution configuration value
	# LB_BOOTSTRAP_CONFIG

	# Setting flavour value
	case "${LB_BOOTSTRAP}" in
		cdebootstrap)
			LB_BOOTSTRAP_FLAVOUR="${LB_BOOTSTRAP_FLAVOUR:-standard}"
			;;
	esac

	# Setting bootstrap keyring
	# LB_BOOTSTRAP_KEYRING

	# Setting mirror to fetch packages from
	if [ -z "${LB_MIRROR_BOOTSTRAP}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				LB_MIRROR_BOOTSTRAP="http://ftp.de.debian.org/debian/"
				;;

			emdebian)
				LB_MIRROR_BOOTSTRAP="http://buildd.emdebian.org/grip/"
				;;

			ubuntu)
				case "${LB_ARCHITECTURE}" in
					amd64|i386)
						LB_MIRROR_BOOTSTRAP="http://archive.ubuntu.com/ubuntu/"
						;;

					*)
						LB_MIRROR_BOOTSTRAP="http://ports.ubuntu.com/"
						;;
				esac
				;;
		esac
	fi

	LB_MIRROR_CHROOT="${LB_MIRROR_CHROOT:-${LB_MIRROR_BOOTSTRAP}}"

	# Setting security mirror to fetch packages from
	if [ -z "${LB_MIRROR_CHROOT_SECURITY}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				LB_MIRROR_CHROOT_SECURITY="http://security.debian.org/"
				;;

			emdebian)
				LB_MIRROR_CHROOT_SECURITY="none"
				;;

			ubuntu)
				case "${LB_ARCHITECTURE}" in
					amd64|i386)
						LB_MIRROR_CHROOT_SECURITY="http://security.ubuntu.com/ubuntu/"
						;;

					*)
						LB_MIRROR_CHROOT_SECURITY="http://ports.ubuntu.com/"
						;;
				esac
				;;
		esac
	fi

	# Setting volatile mirror to fetch packages from
	if [ -z "${LB_MIRROR_CHROOT_VOLATILE}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				case "${LB_DISTRIBUTION}" in
					lenny)
						LB_MIRROR_CHROOT_VOLATILE="http://volatile.debian.org/debian-volatile/"
						;;

					squeeze)
						LB_MIRROR_CHROOT_VOLATILE="${LB_MIRROR_CHROOT}"
						;;
				esac
				;;

			ubuntu)
				case "${LB_ARCHITECTURE}" in
					amd64|i386)
						LB_MIRROR_CHROOT_VOLATILE="http://security.ubuntu.com/ubuntu/"
						;;

					*)
						LB_MIRROR_CHROOT_VOLATILE="http://ports.ubuntu.com/"
						;;
				esac
				;;
		esac

		LB_MIRROR_CHROOT_VOLATILE="${LB_MIRROR_CHROOT_VOLATILE:-none}"
	fi

	# Setting backports mirror to fetch packages from
	if [ -z "${LB_MIRROR_CHROOT_BACKPORTS}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				case "${LB_DISTRIBUTION}" in
					lenny|squeeze)
						LB_MIRROR_CHROOT_BACKPORTS="http://backports.debian.org/debian-backports/"
						;;
				esac
				;;
		esac

		LB_MIRROR_CHROOT_BACKPORTS="${LB_MIRROR_CHROOT_BACKPORTS:-none}"
	fi

	# Setting mirror which ends up in the image
	if [ -z "${LB_MIRROR_BINARY}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				LB_MIRROR_BINARY="http://cdn.debian.net/debian/"
				;;

			emdebian)
				LB_MIRROR_BINARY="http://buildd.emdebian.org/grip/"
				;;

			ubuntu)
				case "${LB_ARCHITECTURE}" in
					amd64|i386)
						LB_MIRROR_BINARY="http://archive.ubuntu.com/ubuntu/"
						;;

					*)
						LB_MIRROR_BINARY="http://ports.ubuntu.com/"
						;;
				esac
				;;
		esac
	fi

	# Setting security mirror which ends up in the image
	if [ -z "${LB_MIRROR_BINARY_SECURITY}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				LB_MIRROR_BINARY_SECURITY="http://security.debian.org/"
				;;

			emdebian)
				LB_MIRROR_BINARY_SECURITY="none"
				;;

			ubuntu)
				case "${LB_ARCHITECTURE}" in
					amd64|i386)
						LB_MIRROR_BINARY_SECURITY="http://archive.ubuntu.com/ubuntu/"
						;;

					*)
						LB_MIRROR_BINARY_SECURITY="http://ports.ubuntu.com/"
						;;
				esac
				;;
		esac
	fi

	# Setting volatile mirror which ends up in the image
	if [ -z "${LB_MIRROR_BINARY_VOLATILE}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				case "${LB_DISTRIBUTION}" in
					lenny)
						LB_MIRROR_BINARY_VOLATILE="http://volatile.debian.org/debian-volatile/"
						;;

					squeeze)
						LB_MIRROR_BINARY_VOLATILE="${LB_MIRROR_BINARY}"
				esac
				;;

			ubuntu)
				case "${LB_ARCHITECTURE}" in
					amd64|i386)
						LB_MIRROR_BINARY_VOLATILE="http://security.ubuntu.com/ubuntu/"
						;;

					*)
						LB_MIRROR_BINARY_VOLATILE="http://ports.ubuntu.com/"
						;;
				esac
				;;
		esac

		LB_MIRROR_BINARY_VOLATILE="${LB_MIRROR_BINARY_VOLATILE:-none}"
	fi

	# Setting backports mirror which ends up in the image
	if [ -z "${LB_MIRROR_BINARY_BACKPORTS}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				case "${LB_DISTRIBUTION}" in
					lenny|squeeze)
						LB_MIRROR_BINARY_BACKPORTS="http://backports.debian.org/debian-backports/"
						;;
				esac
				;;
		esac

		LB_MIRROR_BINARY_BACKPORTS="${LB_MIRROR_BINARY_BACKPORTS:-none}"
	fi

	LB_MIRROR_DEBIAN_INSTALLER="${LB_MIRROR_DEBIAN_INSTALLER:-${LB_MIRROR_BOOTSTRAP}}"

	# Setting archive areas value
	if [ -z "${LB_ARCHIVE_AREAS}" ]
	then
		case "${LB_MODE}" in
			ubuntu)
				LB_ARCHIVE_AREAS="main restricted"
				;;

			*)
				LB_ARCHIVE_AREAS="main"
				;;
		esac
	fi

	## config/chroot

	# Setting chroot filesystem
	LB_CHROOT_FILESYSTEM="${LB_CHROOT_FILESYSTEM:-squashfs}"

	# Setting virtual root size
	LB_VIRTUAL_ROOT_SIZE="${LB_VIRTUAL_ROOT_SIZE:-10000}"

	# Setting whether to expose root filesystem as read only
	LB_EXPOSED_ROOT="${LB_EXPOSED_ROOT:-false}"

	# Setting union filesystem
	LB_UNION_FILESYSTEM="${LB_UNION_FILESYSTEM:-aufs}"

	# LB_HOOKS

	# Setting interactive shell/X11/Xnest
	LB_INTERACTIVE="${LB_INTERACTIVE:-false}"

	# Setting keyring packages
	case "${LB_MODE}" in
		debian|debian-release)
			LB_KEYRING_PACKAGES="${LB_KEYRING_PACKAGES:-debian-archive-keyring}"
			;;

		emdebian)
			LB_KEYRING_PACKAGES="${LB_KEYRING_PACKAGES:-debian-archive-keyring}"
			;;

		ubuntu)
			LB_KEYRING_PACKAGES="${LB_KEYRING_PACKAGES:-ubuntu-keyring}"
			;;
	esac

	# Setting language string
	LB_LANGUAGE="${LB_LANGUAGE:-en}"

	# Setting linux flavour string
	if [ -z "${LB_LINUX_FLAVOURS}" ]
	then
		case "${LB_ARCHITECTURE}" in
			arm|armel)
				Echo_error "There is no default kernel flavour defined for your architecture."
				Echo_error "Please configure it manually with 'lb config -k FLAVOUR'."
				exit 1
				;;

			alpha)
				case "${LB_MODE}" in
					ubuntu)
						Echo_error "Architecture ${LB_ARCHITECTURE} not supported on Ubuntu."
						exit 1
						;;

					*)
						LB_LINUX_FLAVOURS="alpha-generic"
						;;
				esac
				;;

			amd64)
				case "${LB_MODE}" in
					ubuntu)
						LB_LINUX_FLAVOURS="generic"
						;;

					*)
						LB_LINUX_FLAVOURS="amd64"
						;;
				esac
				;;

			hppa)
				case "${LB_MODE}" in
					ubuntu)
						LB_LINUX_FLAVOURS="hppa32 hppa64"
						;;

					*)
						LB_LINUX_FLAVOURS="parisc"
						;;
				esac
				;;

			i386)
				case "${LB_MODE}" in
					ubuntu)
						LB_LINUX_FLAVOURS="generic"
						;;

					*)
						case "${LIST}" in
							stripped|minimal)
								LB_LINUX_FLAVOURS="486"
								;;

							*)
								LB_LINUX_FLAVOURS="486 686"
								;;
						esac
						;;
				esac
				;;

			ia64)
				LB_LINUX_FLAVOURS="itanium"
				;;

			powerpc)
				case "${LIST}" in
					stripped|minimal)
						LB_LINUX_FLAVOURS="powerpc"
						;;

					*)
						LB_LINUX_FLAVOURS="powerpc powerpc64"
						;;
				esac
				;;

			s390)
				case "${LB_MODE}" in
					ubuntu)
						Echo_error "Architecture ${LB_ARCHITECTURE} not supported on Ubuntu."
						exit 1
						;;

					*)
						LB_LINUX_FLAVOURS="s390"
						;;
				esac
				;;

			sparc)
				LB_LINUX_FLAVOURS="sparc64"
				;;

			*)
				Echo_error "Architecture ${LB_ARCHITECTURE} not yet supported (FIXME)"
				exit 1
				;;
		esac
	fi

	# Set linux packages
	if [ -z "${LB_LINUX_PACKAGES}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release|embedian)
				case "${LB_DISTRIBUTION}" in
					lenny)
						LB_LINUX_PACKAGES="linux-image-2.6 \${LB_UNION_FILESYSTEM}-modules-2.6"
						;;

					*)
						LB_LINUX_PACKAGES="linux-image-2.6"
						;;
				esac

				if [ "${LB_CHROOT_FILESYSTEM}" = "squashfs" ]
				then
					case "${LB_DISTRIBUTION}" in
						lenny)
							LB_LINUX_PACKAGES="${LB_LINUX_PACKAGES} squashfs-modules-2.6"
							;;
					esac
				fi

				case "${LB_ENCRYPTION}" in
					""|false)

						;;

					*)
						LB_LINUX_PACKAGES="${LB_LINUX_PACKAGES} loop-aes-modules-2.6"
						;;
				esac
				;;

			ubuntu)
				LB_LINUX_PACKAGES="linux"
				;;
		esac
	fi

	# Setting packages string
	case "${LB_MODE}" in
		ubuntu)
			LB_PACKAGES="${LB_PACKAGES:-ubuntu-minimal}"
			;;

		*)
			LB_PACKAGES_LISTS="${LB_PACKAGES_LISTS:-standard}"
			;;
	esac

	case "${LB_ENCRYPTION}" in
		""|false)

			;;

		*)
			if ! In_list loop-aes-utils "${LB_PACKAGES}"
			then
				LB_PACKAGES="${LB_PACKAGES} loop-aes-utils"
			fi
			;;
	esac

	# Setting tasks string
	for LIST in ${LB_PACKAGES_LISTS}
	do
		case "${LIST}" in
			stripped|minimal)
				LB_APT="apt-get"
				;;

			gnome-desktop)
				LB_PACKAGES_LISTS="$(echo ${LB_PACKAGES_LISTS} | sed -e 's|gnome-desktop||') standard-x11"
				case "${LB_DISTRIBUTION}" in
					lenny)
						LB_TASKS="$(echo ${LB_TASKS} | sed -e 's|standard||' -e 's|gnome-desktop||' -e 's|desktop||') standard gnome-desktop desktop"
						;;

					*)
						LB_TASKS="$(echo ${LB_TASKS} | sed -e 's|standard||' -e 's|gnome-desktop||' -e 's|desktop||' -e 's|laptop||') standard gnome-desktop desktop laptop"
						;;
				esac
				;;

			kde-desktop)
				LB_PACKAGES_LISTS="$(echo ${LB_PACKAGES_LISTS} | sed -e 's|kde-desktop||') standard-x11"

				case "${LB_DISTRIBUTION}" in
					lenny)
						LB_TASKS="$(echo ${LB_TASKS} | sed -e 's|standard||' -e 's|kde-desktop||' -e 's|desktop||') standard kde-desktop desktop"
						;;

					*)
						LB_TASKS="$(echo ${LB_TASKS} | sed -e 's|standard||' -e 's|kde-desktop||' -e 's|desktop||' -e 's|laptop||') standard kde-desktop desktop laptop"
				esac
				;;

			lxde-desktop)
				LB_PACKAGES_LISTS="$(echo ${LB_PACKAGES_LISTS} | sed -e 's|lxde-desktop||') standard-x11"

				case "${LB_DISTRIBUTION}" in
					lenny)
						LB_TASKS="$(echo ${LB_TASKS} | sed -e 's|standard||' -e 's|lxde-desktop||' -e 's|desktop||') standard lxde-desktop desktop"
						;;

					*)
						LB_TASKS="$(echo ${LB_TASKS} | sed -e 's|standard||' -e 's|lxde-desktop||' -e 's|desktop||' -e 's|laptop||') standard lxde-desktop desktop laptop"
						;;
				esac
				;;

			xfce-desktop)
				LB_PACKAGES_LISTS="$(echo ${LB_PACKAGES_LISTS} | sed -e 's|xfce-desktop||') standard-x11"

				case "${LB_DISTRIBUTION}" in
					lenny)
						LB_TASKS="$(echo ${LB_TASKS} | sed -e 's|standard||' -e 's|xfce-desktop||' -e 's|desktop||') standard xfce-desktop desktop"
						;;

					*)
						LB_TASKS="$(echo ${LB_TASKS} | sed -e 's|standard||' -e 's|xfce-desktop||' -e 's|desktop||' -e 's|laptop||') standard xfce-desktop desktop laptop"
						;;
				esac
				;;
		esac
	done

	LB_PACKAGES_LISTS="$(echo ${LB_PACKAGES_LISTS} | sed -e 's|  ||g')"
	LB_TASKS="$(echo ${LB_TASKS} | sed -e 's|  ||g')"

	# Setting security updates option
	if [ "${LB_MIRROR_CHROOT_SECURITY}" = "none" ] || [ "${LB_MIRROR_BINARY_SECURITY}" = "none" ]
	then
		LB_SECURITY="false"
	fi

	LB_SECURITY="${LB_SECURITY:-true}"

	# Setting volatile updates option
	if [ "${LB_MIRROR_CHROOT_VOLATILE}" = "none" ] || [ "${LB_MIRROR_BINARY_VOLATILE}" = "none" ]
	then
		LB_VOLATILE="false"
	fi

	LB_VOLATILE="${LB_VOLATILE:-true}"

	# Setting symlink convertion option
	LB_SYMLINKS="${LB_SYMLINKS:-false}"

	# Setting sysvinit option
	LB_SYSVINIT="${LB_SYSVINIT:-false}"

	## config/binary

	# Setting image filesystem
	case "${LB_ARCHITECTURE}" in
		sparc)
			LB_BINARY_FILESYSTEM="${LB_BINARY_FILESYSTEM:-ext2}"
			;;

		*)
			LB_BINARY_FILESYSTEM="${LB_BINARY_FILESYSTEM:-fat16}"
			;;
	esac

	# Setting image type
	case "${LB_DISTRIBUTION}" in
		squeeze|sid)
			case "${LB_ARCHITECTURE}" in
				amd64|i386)
					LB_BINARY_IMAGES="${LB_BINARY_IMAGES:-iso-hybrid}"
					;;

				*)
					LB_BINARY_IMAGES="${LB_BINARY_IMAGES:-iso}"
					;;
			esac
			;;

		*)
			LB_BINARY_IMAGES="${LB_BINARY_IMAGES:-iso}"
			;;
	esac

	# Setting apt indices
	if echo ${LB_PACKAGES_LISTS} | grep -qs -E "(stripped|minimal)\b"
	then
		LB_BINARY_INDICES="${LB_BINARY_INDICES:-none}"
	else
		LB_BINARY_INDICES="${LB_BINARY_INDICES:-true}"
	fi

	# Setting bootloader
	if [ -z "${LB_BOOTLOADER}" ]
	then
		case "${LB_ARCHITECTURE}" in
			amd64|i386)
				LB_BOOTLOADER="syslinux"
				;;

			powerpc)
				LB_BOOTLOADER="yaboot"
				;;

			sparc)
				LB_BOOTLOADER="silo"
				;;
		esac
	fi

	# Setting checksums
	LB_CHECKSUMS="${LB_CHECKSUMS:-md5}"

	# Setting chroot option
	LB_BUILD_WITH_CHROOT="${LB_BUILD_WITH_CHROOT:-true}"

	# Setting debian-installer option
	LB_DEBIAN_INSTALLER="${LB_DEBIAN_INSTALLER:-false}"

	# Setting debian-installer distribution
	LB_DEBIAN_INSTALLER_DISTRIBUTION="${LB_DEBIAN_INSTALLER_DISTRIBUTION:-${LB_DISTRIBUTION}}"

	# Setting debian-installer-gui
	case "${LB_MODE}" in
		debian)
			LB_DEBIAN_INSTALLER_GUI="${LB_DEBIAN_INSTALLER_GUI:-true}"
			;;

		ubuntu)
			case "${LB_DEBIAN_INSTALLER_DISTRIBUTION}" in
				karmic)
					# Not available for Karmic currently.
					LB_DEBIAN_INSTALLER_GUI="${LB_DEBIAN_INSTALLER_GUI:-false}"
					;;

				*)
					LB_DEBIAN_INSTALLER_GUI="${LB_DEBIAN_INSTALLER_GUI:-true}"
					;;
			esac
			;;

		*)
			LB_DEBIAN_INSTALLER_GUI="${LB_DEBIAN_INSTALLER_GUI:-false}"
			;;
	esac

	# Setting debian-installer preseed filename
	if [ -z "${LB_DEBIAN_INSTALLER_PRESEEDFILE}" ]
	then
		if Find_files config/binary_debian-installer/preseed.cfg
		then
			LB_DEBIAN_INSTALLER_PRESEEDFILE="/preseed.cfg"
		fi

		if Find_files config/binary_debian-installer/*.cfg && [ ! -e config/binary_debian-installer/preseed.cfg ]
		then
			Echo_warning "You have placed some preseeding files into config/binary_debian-installer but you didn't specify the default preseeding file through LB_DEBIAN_INSTALLER_PRESEEDFILE. This means that debian-installer will not take up a preseeding file by default."
		fi
	fi

	# Setting boot parameters
	# LB_BOOTAPPEND_LIVE
	if [ -n "${LB_DEBIAN_INSTALLER_PRESEEDFILE}" ]
	then
		case "${LB_BINARY_IMAGES}" in
			iso*)
				_LB_BOOTAPPEND_PRESEED="file=/cdrom/install/${LB_DEBIAN_INSTALLER_PRESEEDFILE}"
				;;

			usb*)
				if [ "${LB_MODE}" = "ubuntu" ] || [ "${LB_DEBIAN_INSTALLER}" = "live" ]
				then
					_LB_BOOTAPPEND_PRESEED="file=/cdrom/install/${LB_DEBIAN_INSTALLER_PRESEEDFILE}"
				else
					_LB_BOOTAPPEND_PRESEED="file=/hd-media/install/${LB_DEBIAN_INSTALLER_PRESEEDFILE}"
				fi
				;;

			net)
				case "${LB_DEBIAN_INSTALLER_PRESEEDFILE}" in
					*://*)
						_LB_BOOTAPPEND_PRESEED="file=${LB_DEBIAN_INSTALLER_PRESEEDFILE}"
						;;

					*)
						_LB_BOOTAPPEND_PRESEED="file=/${LB_DEBIAN_INSTALLER_PRESEEDFILE}"
						;;
				esac
				;;
		esac
	fi

	if [ -n ${_LB_BOOTAPPEND_PRESEED} ]
	then
		LB_BOOTAPPEND_INSTALL="${LB_BOOTAPPEND_INSTALL} ${_LB_BOOTAPPEND_PRESEED}"
	fi

	LB_BOOTAPPEND_INSTALL="$(echo ${LB_BOOTAPPEND_INSTALL} | sed -e 's/[ \t]*$//')"

	# Setting encryption
	LB_ENCRYPTION="${LB_ENCRYPTION:-false}"

	# Setting grub splash
	# LB_GRUB_SPLASH

	# Setting hostname
	if [ -z "${LB_HOSTNAME}" ]
	then
		case "${LB_MODE}" in
			embedian)
				LB_HOSTNAME="embedian"
				;;

			ubuntu)
				LB_HOSTNAME="ubuntu"
				;;

			*)
				LB_HOSTNAME="debian"
				;;
		esac
	fi

	# Setting iso author
	if [ -z "${LB_ISO_APPLICATION}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				LB_ISO_APPLICATION="Debian Live"
				;;

			emdebian)
				LB_ISO_APPLICATION="Emdebian Live"
				;;

			ubuntu)
				LB_ISO_APPLICATION="Ubuntu Live"
				;;
		esac
	fi

	# Set iso preparer
	LB_ISO_PREPARER="${LB_ISO_PREPARER:-live-build \$VERSION; http://packages.qa.debian.org/live-build}"

	# Set iso publisher
	LB_ISO_PUBLISHER="${LB_ISO_PUBLISHER:-Debian Live project; http://live.debian.net/; debian-live@lists.debian.org}"

	# Setting iso volume
	if [ -z "${LB_ISO_VOLUME}" ]
	then
		case "${LB_MODE}" in
			debian)
				LB_ISO_VOLUME="Debian ${LB_DISTRIBUTION} \$(date +%Y%m%d-%H:%M)"
				;;

			debian-release)
				eval VERSION="$`echo RELEASE_${LB_DISTRIBUTION}`"
				LB_ISO_VOLUME="Debian ${VERSION} ${LB_ARCHITECTURE} live"
				;;

			emdebian)
				LB_ISO_VOLUME="Emdebian ${LB_DISTRIBUTION} \$(date +%Y%m%d-%H:%M)"
				;;

			ubuntu)
				LB_ISO_VOLUME="Ubuntu ${LB_DISTRIBUTION} \$(date +%Y%m%d-%H:%M)"
				;;
		esac
	fi

	# Setting memtest option
	LB_MEMTEST="${LB_MEMTEST:-memtest86+}"

	# Setting win32-loader option
	if [ "${LB_MODE}" != "ubuntu" ]
	then
		case "${LB_ARCHITECTURE}" in
			amd64|i386)
				if [ "${LB_DEBIAN_INSTALLER}" != "false" ]
				then
					LB_WIN32_LOADER="${LB_WIN32_LOADER:-true}"
				else
					LB_WIN32_LOADER="${LB_WIN32_LOADER:-false}"
				fi
				;;

			*)
				LB_WIN32_LOADER="${LB_WIN32_LOADER:-false}"
				;;
		esac
	fi

	# Setting netboot filesystem
	LB_NET_ROOT_FILESYSTEM="${LB_NET_ROOT_FILESYSTEM:-nfs}"

	# Setting netboot server path
	if [ -z "${LB_NET_ROOT_PATH}" ]
	then
		case "${LB_MODE}" in
			debian|debian-release)
				LB_NET_ROOT_PATH="/srv/debian-live"
				;;

			emdebian)
				LB_NET_ROOT_PATH="/srv/emdebian-live"
				;;

			ubuntu)
				LB_NET_ROOT_PATH="/srv/ubuntu-live"
				;;
		esac
	fi

	# Setting netboot server address
	LB_NET_ROOT_SERVER="${LB_NET_ROOT_SERVER:-192.168.1.1}"

	# Setting net cow filesystem
	LB_NET_COW_FILESYSTEM="${LB_NET_COW_FILESYSTEM:-nfs}"

	# Setting net tarball
	LB_NET_TARBALL="${LB_NET_TARBALL:-gzip}"

	# Setting syslinux configuration file
	# LB_SYSLINUX_CFG

	# Setting syslinux splash
	# LB_SYSLINUX_SPLASH

	LB_SYSLINUX_TIMEOUT="${LB_SYSLINUX_TIMEOUT:-0}"

	# Setting syslinux menu
	LB_SYSLINUX_MENU="${LB_SYSLINUX_MENU:-true}"

	# Setting syslinux menu live entries
	case "${LB_MODE}" in
		debian|debian-release)
			LB_SYSLINUX_MENU_LIVE_ENTRY="${LB_SYSLINUX_MENU_LIVE_ENTRY:-Live}"
			LB_SYSLINUX_MENU_LIVE_ENTRY_FAILSAFE="${LB_SYSLINUX_MENU_LIVE_ENTRY_FAILSAFE:-${LB_SYSLINUX_MENU_LIVE_ENTRY} (failsafe)}"
			;;

		*)
			LB_SYSLINUX_MENU_LIVE_ENTRY="${LB_SYSLINUX_MENU_LIVE_ENTRY:-Start ${LB_ISO_APPLICATION}}"
			LB_SYSLINUX_MENU_LIVE_ENTRY_FAILSAFE="${LB_SYSLINUX_MENU_LIVE_ENTRY_FAILSAFE:-${LB_SYSLINUX_MENU_LIVE_ENTRY} (failsafe)}"
			;;
	esac

	# Settings memtest menu entry
	LB_SYSLINUX_MENU_MEMTEST_ENTRY="${LB_SYSLINUX_MENU_MEMTEST_ENTRY:-Memory test}"

	# Setting username
	case "${LB_MODE}" in
		ubuntu)
			LB_USERNAME="${LB_USERNAME:-ubuntu}"
			;;

		*)
			LB_USERNAME="${LB_USERNAME:-user}"
			;;
	esac

	## config/source

	# Setting source option
	LB_SOURCE="${LB_SOURCE:-false}"

	# Setting image type
	LB_SOURCE_IMAGES="${LB_SOURCE_IMAGES:-tar}"

	# Setting fakeroot/fakechroot
	LB_USE_FAKEROOT="${LB_USE_FAKEROOT:-false}"
}

Check_defaults ()
{
	if [ "${LB_CONFIG_VERSION}" ]
	then
		# We're only checking when we're actually running the checks
		# that's why the check for emptyness of the version;
		# however, as live-build always declares LB_CONFIG_VERSION
		# internally, this is safe assumption (no cases where it's unset,
		# except when bootstrapping the functions/defaults etc.).
		CURRENT_CONFIG_VERSION="$(echo ${LB_CONFIG_VERSION} | awk -F. '{ print $1 }')"

		if [ ${CURRENT_CONFIG_VERSION} -ge 3 ]
		then
			Echo_error "This config tree is too new for this version of live-build (${VERSION})."
			Echo_error "Aborting build, please get a new version of live-build."

			exit 1
		elif [ ${CURRENT_CONFIG_VERSION} -eq 1 ]
		then
			Echo_error "This config tree is too old for this version of live-build (${VERSION})."
			Echo_error "Aborting build, please repopulate the config tree."
			exit 1
		elif [ ${CURRENT_CONFIG_VERSION} -lt 1 ]
		then
			Echo_warning "This config tree does not specify a format version or has an unknown version number."
			Echo_warning "Continuing build, but it could lead to errors or different results. Please repopulate the config tree."
		fi
	fi

	if echo ${LB_PACKAGES_LISTS} | grep -qs -E "(stripped|minimal)\b"
	then
		# aptitude + stripped|minimal
		if [ "${LB_APT}" = "aptitude" ]
		then
			Echo_warning "You selected LB_PACKAGES_LISTS='%s' and LB_APT='aptitude'" "${LB_PACKAGES_LIST}. This configuration is potentially unsafe, as aptitude is not used in the stripped/minimal package lists."
		fi
	fi

	if [ "${LB_DEBIAN_INSTALLER}" != "false" ]
	then
		# d-i true, no caching
		if ! echo ${LB_CACHE_STAGES} | grep -qs "bootstrap\b" || [ "${LB_CACHE}" != "true" ] || [ "${LB_CACHE_PACKAGES}" != "true" ]
		then
			Echo_warning "You have selected values of LB_CACHE, LB_CACHE_PACKAGES, LB_CACHE_STAGES and LB_DEBIAN_INSTALLER which will result in 'bootstrap' packages not being cached. This configuration is potentially unsafe as the bootstrap packages are re-used when integrating the Debian Installer."
		fi
	fi

	if [ "${LB_BOOTLOADER}" = "syslinux" ]
	then
		# syslinux + fat
		case "${LB_BINARY_FILESYSTEM}" in
			fat*)
				;;
			*)
				Echo_warning "You have selected values of LB_BOOTLOADER and LB_BINARY_FILESYSTEM which are incompatible - syslinux only supports FAT filesystems."
				;;
		esac
	fi

	case "${LB_BINARY_IMAGES}" in
		usb*)
			# grub or yaboot + usb
			case "${LB_BOOTLOADER}" in
				grub|yaboot)
					Echo_error "You have selected a combination of bootloader and image type that is currently not supported by live-build. Please use either another bootloader or a different image type."
					exit 1
					;;
			esac
			;;
	esac

	if [ "$(echo ${LB_ISO_APPLICATION} | wc -c)" -gt 128 ]
	then
		Echo_warning "You have specified a value of LB_ISO_APPLICATION that is too long; the maximum length is 128 characters."
	fi

	if [ "$(echo ${LB_ISO_PREPARER} | wc -c)" -gt  128 ]
	then
		Echo_warning "You have specified a value of LB_ISO_PREPARER that is too long; the maximum length is 128 characters."
	fi

	if [ "$(echo ${LB_ISO_PUBLISHER} | wc -c)" -gt 128 ]
	then
		Echo_warning "You have specified a value of LB_ISO_PUBLISHER that is too long; the maximum length is 128 characters."
	fi

	if [ "$(eval "echo ${LB_ISO_VOLUME}" | wc -c)" -gt 32 ]
	then
		Echo_warning "You have specified a value of LB_ISO_VOLUME that is too long; the maximum length is 32 characters."
	fi

	if echo ${LB_PACKAGES_LISTS} | grep -qs -E "(stripped|minimal)\b"
	then
		if [ "${LB_BINARY_INDICES}" = "true" ]
		then
			Echo_warning "You have selected hook to minimise image size but you are still including package indices with your value of LB_BINARY_INDICES."
		fi
	fi

}
