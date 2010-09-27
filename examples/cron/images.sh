#!/bin/sh

set -e

# Static variables
DISTRIBUTIONS="${DISTRIBUTIONS:-lenny squeeze sid}"
FLAVOURS="${FLAVOURS:-standard rescue gnome-desktop kde-desktop lxde-desktop xfce-desktop}"
SOURCE="${SOURCE:-true}"

MIRROR="${MIRROR:-http://cdn.debian.net/debian/}"
MIRROR_SECURITY="${MIRROR_SECURITY:-http://security.debian.org/}"

# Dynamic variables
ARCHITECTURE="$(dpkg --print-architecture)"
DATE="$(date +%Y%m%d)"

Set_defaults ()
{
	# Distribution defaults
	APT_RECOMMENDS="true"
	BINARY_INDICES="true"
	DEBIAN_INSTALLER="live"
	TASKSEL="tasksel"

	# Distribution specific options (ugly!)
	case "${DISTRIBUTION}" in
		lenny)
			APT_RECOMMENDS="false"
			BINARY_INDICES="true"
			DEBIAN_INSTALLER="false"
			TASKSEL="aptitude"

			case "${ARCHITECTURE}" in
				amd64)
					case "${FLAVOUR}" in
						gnome-desktop)
							BINARY_INDICES="false"

							mkdir -p config/chroot_local-hooks
							cd config/chroot_local-hooks
							echo "apt-get remove --yes --purge openoffice.org-help-en-us" > package-removals
							echo "apt-get remove --yes --purge epiphany-browser epiphany-browser-data epiphany-extensions epiphany-gecko" >> package-removals
							echo "apt-get remove --yes --purge gnome-user-guide" >> package-removals
							cd -
							;;

						kde-desktop)
							BINARY_INDICES="false"
							;;
					esac
					;;

				i386)
					case "${FLAVOUR}" in
						gnome-desktop|kde-desktop)
							BINARY_INDICES="false"
							KERNEL="-k 686"
							;;
					esac
					;;
			esac
			;;

		squeeze)
			DEBIAN_INSTALLER_DISTRIBUTION="daily"

			LIVE_BOOT="2.0.6-1"
			LIVE_CONFIG="2.0.7-1"
			LIVE_INSTALLER="26"
			DI_LAUNCHER="3"

			mkdir -p config/chroot_local-packages
			cd config/chroot_local-packages

			# live-boot
			if [ -n "${LIVE_BOOT}" ]
			then
				wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot_${LIVE_BOOT}.dsc
				wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot_${LIVE_BOOT}.diff.gz
				wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot_$(echo ${LIVE_BOOT} | awk -F- '{ print $1 }').orig.tar.gz
				wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot_${LIVE_BOOT}_all.deb
				wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot-initramfs-tools_${LIVE_BOOT}_all.deb
				wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-initramfs_${LIVE_BOOT}_all.deb
			fi

			# live-config
			if [ -n "${LIVE_CONFIG}" ]
			then
				wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config_${LIVE_CONFIG}.dsc
				wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config_${LIVE_CONFIG}.diff.gz
				wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config_$(echo ${LIVE_CONFIG} | awk -F- '{ print $1 }').orig.tar.gz
				wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config_${LIVE_CONFIG}_all.deb
				wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config-sysvinit_${LIVE_CONFIG}_all.deb
			fi

			cd ${OLDPWD}

			mkdir -p config/binary_local-udebs
			cd config/binary_local-udebs

			# live-installer
			if [ -n "${LIVE_INSTALLER}" ]
			then
				wget -c http://ftp.debian.org/debian/pool/main/l/live-installer/live-installer_${LIVE_INSTALLER}.dsc
				wget -c http://ftp.debian.org/debian/pool/main/l/live-installer/live-installer_${LIVE_INSTALLER}.tar.gz
				wget -c http://ftp.debian.org/debian/pool/main/l/live-installer/live-installer_${LIVE_INSTALLER}_${ARCHITECTURE}.udeb
				wget -c http://ftp.debian.org/debian/pool/main/b/base-installer/base-installer_1.113.dsc
				wget -c http://ftp.debian.org/debian/pool/main/b/base-installer/base-installer_1.113.tar.gz
				wget -c http://ftp.debian.org/debian/pool/main/b/base-installer/base-installer_1.113_all.udeb
				wget -c http://ftp.debian.org/debian/pool/main/b/base-installer/bootstrap-base_1.113_${ARCHITECTURE}.udeb
			fi

			cd -

			mkdir -p config/chroot_local-packages
			cd config/chroot_local-packages

			# debian-installer-launcher
			if [ -n "${DI_LAUNCHER}" ]
			then
				wget http://ftp.debian.org/debian/pool/main/d/debian-installer-launcher/debian-installer-launcher_${DI_LAUNCHER}.dsc
				wget http://ftp.debian.org/debian/pool/main/d/debian-installer-launcher/debian-installer-launcher_${DI_LAUNCHER}.tar.gz
				wget http://ftp.debian.org/debian/pool/main/d/debian-installer-launcher/debian-installer-launcher_${DI_LAUNCHER}_all.deb
			fi

			cd -
			;;
		esac
}

# Build images
for DISTRIBUTION in ${DISTRIBUTIONS}
do
	rm -rf cache/stages*

	for FLAVOUR in ${FLAVOURS}
	do
		if [ -e .stage ]
		then
			lb clean
		fi

		if [ -e config ]
		then
			rm -f config/* || true
			rmdir --ignore-fail-on-non-empty config/* || true
		fi

		rm -rf cache/packages*
		rm -rf cache/stages_rootfs

		Set_defaults

		lb config \
			--apt-recommends ${APT_RECOMMENDS} \
			--binary-indices ${BINARY_INDICES} \
			--bootstrap cdebootstrap \
			--cache-stages "bootstrap rootfs" \
			--debian-installer ${DEBIAN_INSTALLER} \
			--debian-installer-distribution ${DEBIAN_INSTALLER_DISTRIBUTION} \
			--distribution ${DISTRIBUTION} \
			--mirror-bootstrap ${MIRROR} \
			--mirror-chroot ${MIRROR} \
			--mirror-chroot-security ${MIRROR_SECURITY} \
			--packages-lists ${FLAVOUR} \
			--tasksel ${TASKSEL} ${KERNEL}

		lb build 2>&1 | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.log

		mv binary*.iso debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso
		mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.list
		mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.packages

		if [ "${ARCHITECTURE}" != "powerpc" ]
		then
			lb clean --binary
			lb config -binary-images usb-hdd
			lb binary 2>&1 | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.log

			mv binary.img debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img
			mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.list
			mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.packages
		fi

		if [ "${ARCHITECTURE}" != "powerpc" ]
		then
			lb clean
			rm -rf cache/stages_rootfs
			lb config --binary-images net

			lb build 2>&1 | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.tar.gz.log

			mv binary-net.tar.gz debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.tar.gz
			mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.tar.gz.list
			mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.tar.gz.packages

			mv binary/*/filesystem.squashfs debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.squashfs
			for memtest in tftpboot/debian-live/${ARCHITECTURE}/memtest*; do cp -f ${memtest} debian-live-${DISTRIBUTION}-${ARCHITECTURE}.$(basename ${memtest}); done || true
			for kernel in tftpboot/debian-live/${ARCHITECTURE}/vmlinuz*; do cp -f ${kernel} debian-live-${DISTRIBUTION}-${ARCHITECTURE}.$(basename ${kernel}); done
			for initrd in tftpboot/debian-live/${ARCHITECTURE}/initrd*; do cp ${initrd} debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.$(basename ${initrd}); done
		fi

		if [ "${SOURCE}" = "true" ]
		then
			lb config --source true

			lb source 2>&1 | tee debian-live-${DISTRIBUTION}-source-${FLAVOUR}.log

			mv source.debian.tar.gz debian-live-${DISTRIBUTION}-source-${FLAVOUR}.debian.tar.gz
			mv source.debian.list debian-live-${DISTRIBUTION}-source-${FLAVOUR}.debian.tar.gz.list
			mv source.debian-live.tar.gz debian-live-${DISTRIBUTION}-source-${FLAVOUR}.debian-live.tar.gz
			mv source.debian-live.list debian-live-${DISTRIBUTION}-source-${FLAVOUR}.debian-live.tar.gz.list
		fi
	done
done
