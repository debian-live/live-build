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
	DEBIAN_INSTALLER_GUI="true"
	PACKAGES="--packages live-installer-launcher"
	TASKSEL="tasksel"

	# Distribution specific options (ugly!)
	case "${DISTRIBUTION}" in
		lenny)
			APT_RECOMMENDS="false"
			BINARY_INDICES="true"
			DEBIAN_INSTALLER="false"
			PACKAGES=""
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
			DEBIAN_INSTALLER_GUI="false"

			LIVE_INSTALLER="20"
			LIVE_BOOT="2.0~a15-1"
			LIVE_CONFIG="2.0~a15-1"

			mkdir -p config/binary_local-udebs
			cd config/binary_local-udebs
			wget -c http://live.debian.net/archive/packages/live-installer/${LIVE_INSTALLER}/live-installer_${LIVE_INSTALLER}.dsc
			wget -c http://live.debian.net/archive/packages/live-installer/${LIVE_INSTALLER}/live-installer_${LIVE_INSTALLER}.tar.gz
			wget -c http://live.debian.net/archive/packages/live-installer/${LIVE_INSTALLER}/live-installer_${LIVE_INSTALLER}_i386.udeb
			cd -

			mkdir -p config/chroot_local-packages
			cd config/chroot_local-packages

			wget -c http://live.debian.net/archive/packages/live-installer/${LIVE_INSTALLER}/live-installer_${LIVE_INSTALLER}.dsc
			wget -c http://live.debian.net/archive/packages/live-installer/${LIVE_INSTALLER}/live-installer_${LIVE_INSTALLER}.tar.gz
			wget -c http://live.debian.net/archive/packages/live-installer/${LIVE_INSTALLER}/live-installer-launcher_${LIVE_INSTALLER}_all.deb

			wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot_${LIVE_BOOT}.dsc
			wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot_${LIVE_BOOT}.diff.gz
			wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot_$(echo ${LIVE_BOOT} | awk -F- '{ print $1 }').orig.tar.gz
			wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot_${LIVE_BOOT}_all.deb
			wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-boot-initramfs-tools_${LIVE_BOOT}_all.deb
			wget -c http://live.debian.net/archive/packages/live-boot/${LIVE_BOOT}/live-initramfs_${LIVE_BOOT}_all.deb

			wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config_${LIVE_CONFIG}.dsc
			wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config_${LIVE_CONFIG}.diff.gz
			wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config_$(echo ${LIVE_CONFIG} | awk -F- '{ print $1 }').orig.tar.gz
			wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config_${LIVE_CONFIG}_all.deb
			wget -c http://live.debian.net/archive/packages/live-config/${LIVE_CONFIG}/live-config-sysvinit_${LIVE_CONFIG}_all.deb

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
			lh clean
		fi

		if [ -e config ]
		then
			rm -f config/* || true
			rmdir --ignore-fail-on-non-empty config/* || true
		fi

		rm -rf cache/packages*
		rm -rf cache/stages_rootfs

		Set_defaults

		lh config \
			--apt-recommends ${APT_RECOMMENDS} \
			--binary-indices ${BINARY_INDICES} \
			--cache-stages "bootstrap rootfs" \
			--debian-installer ${DEBIAN_INSTALLER} \
			--debian-installer-distribution ${DEBIAN_INSTALLER_DISTRIBUTION} \
			--debian-installer-gui ${DEBIAN_INSTALLER_GUI} \
			--distribution ${DISTRIBUTION} \
			--mirror-bootstrap ${MIRROR} \
			--mirror-chroot ${MIRROR} \
			--mirror-chroot-security ${MIRROR_SECURITY} \
			${PACKAGES} \
			--packages-lists ${FLAVOUR} \
			--tasksel ${TASKSEL} ${KERNEL}

		# TEMPORARY HACK until memtest86+ maintainers fixes his package
		if [ ${DISTRIBUTION} = "squeeze" ] && [ ${FLAVOUR} = rescue ]
		then
			lh config --memtest none
		fi

		lh build 2>&1 | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.log

		mv binary*.iso debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso
		mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.list
		mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.packages

		if [ "${DISTRIBUTION}" = "lenny" ] && [ "${ARCHITECTURE}" != "powerpc" ]
		then
			lh clean --binary
			lh config -binary-images usb-hdd
			lh binary 2>&1 | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.log

			mv binary.img debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img
			mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.list
			mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.packages
		fi

		if [ "${ARCHITECTURE}" != "powerpc" ]
		then
			lh clean
			rm -rf cache/stages_rootfs
			lh config --binary-images net

			lh build 2>&1 | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.tar.gz.log

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
			lh config --source true

			lh source 2>&1 | tee debian-live-${DISTRIBUTION}-source-${FLAVOUR}.log

			mv source.debian.tar.gz debian-live-${DISTRIBUTION}-source-${FLAVOUR}.debian.tar.gz
			mv source.debian.list debian-live-${DISTRIBUTION}-source-${FLAVOUR}.debian.tar.gz.list
			mv source.debian-live.tar.gz debian-live-${DISTRIBUTION}-source-${FLAVOUR}.debian-live.tar.gz
			mv source.debian-live.list debian-live-${DISTRIBUTION}-source-${FLAVOUR}.debian-live.tar.gz.list
		fi
	done
done
