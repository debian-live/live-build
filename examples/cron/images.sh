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
			DEBIAN_INSTALLER_GUI="false"

			LIVE_INSTALLER="16"
			LIVE_INITRAMFS="1.173.3-1"

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
			wget -c http://live.debian.net/archive/packages/live-initramfs/${LIVE_INITRAMFS}/live-initramfs_${LIVE_INITRAMFS}.diff.gz
			wget -c http://live.debian.net/archive/packages/live-initramfs/${LIVE_INITRAMFS}/live-initramfs_${LIVE_INITRAMFS}.dsc
			wget -c http://live.debian.net/archive/packages/live-initramfs/${LIVE_INITRAMFS}/live-initramfs_${LIVE_INITRAMFS}_all.deb
			wget -c http://live.debian.net/archive/packages/live-initramfs/${LIVE_INITRAMFS}/live-initramfs_$(echo ${LIVE_INITRAMFS} | awk -F- '{ print $1 }').orig.tar.gz
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
			--debian-installer-gui ${DEBIAN_INSTALLER_GUI} \
			--distribution ${DISTRIBUTION} \
			--mirror-bootstrap ${MIRROR} \
			--mirror-chroot ${MIRROR} \
			--mirror-chroot-security ${MIRROR_SECURITY} \
			${PACKAGES} \
			--packages-lists ${FLAVOUR} \
			--source ${SOURCE} \
			--tasksel ${TASKSEL} ${KERNEL}

		# TEMPORARY HACK until memtest86+ maintainers fixes his package
		if [ ${FLAVOUR} = rescue ]
		then
			lh config --memtest none
		fi

		lh build 2>&1 | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.log

		mv binary*.iso debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso
		mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.list
		mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.packages

		if [ "${SOURCE}" = "true" ]
		then
			mv source.tar.gz debian-live-${DISTRIBUTION}-source-${FLAVOUR}.tar.gz
			mv source.list debian-live-${DISTRIBUTION}-source-${FLAVOUR}.tar.gz.list
		fi

		if [ "${DISTRIBUTION}" = "lenny" ]
		then
			lh clean --binary
			lh config -binary-images usb-hdd
			lh binary 2>&1 | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.log

			mv binary.img debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img
			mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.list
			mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.packages
		fi

		lh clean
		rm -rf cache/stages_rootfs
		lh config --binary-images net

		lh build 2>&1 | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}-net.tar.gz.log

		mv binary-net.tar.gz debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}-net.tar.gz
		mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}-net.tar.gz.list
		mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}-net.tar.gz.packages

		mv binary/*/filesystem.squashfs debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.squashfs
	done
done
