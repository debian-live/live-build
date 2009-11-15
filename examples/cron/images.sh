#!/bin/sh -e

# Static variables
DISTRIBUTIONS="${DISTRIBUTIONS:-etch lenny sid}"
FLAVOURS="${FLAVOURS:-standard gnome-desktop kde-desktop xfce-desktop}"
SOURCE="${SOURCE:-enabled}"

MIRROR="${MIRROR:-http://mirror/ftp.debian.org/debian/}"
MIRROR_SECURITY="${MIRROR_SECURITY:-http://mirror/ftp.debian.org/debian-security/}"

# Dynamic variables
ARCHITECTURE="$(dpkg --print-architecture)"
DATE="$(date +%Y%m%d)"

for DISTRIBUTION in ${DISTRIBUTIONS}
do
	rm -rf cache/stages*

	for FLAVOUR in ${FLAVOURS}
	do
		mkdir -p config

		if [ -e .stage ]
		then
			lh clean
		fi

		rm -rf config
		rm -rf cache/packages*
		rm -rf cache/stages_rootfs

		if [ "${SOURCE}" = "enabled" ]
		then
			lh config -d ${DISTRIBUTION} -p ${FLAVOUR} --cache-stages "bootstrap rootfs" --apt-recommends disabled --source enabled --mirror-bootstrap ${MIRROR} --mirror-chroot ${MIRROR} --mirror-chroot-security ${MIRROR_SECURITY}
		else
			lh config -d ${DISTRIBUTION} -p ${FLAVOUR} --cache-stages "bootstrap rootfs" --apt-recommends disabled --source disabled --mirror-bootstrap ${MIRROR} --mirror-chroot ${MIRROR} --mirror-chroot-security ${MIRROR_SECURITY}
		fi

		if [ "${DISTRIBUTION}" = "sid" ]
		then
			echo 'deb http://live.debian.net/debian/ ./' > config/chroot_sources/live-snapshots.chroot
			echo 'deb http://live.debian.net/debian/ ./' > config/chroot_sources/live-snapshots.boot

			wget http://ftp-master.debian-unofficial.org/other/openpgp/archive-key-2008.asc -O config/chroot_sources/live-snapshots.chroot.gpg
			wget http://ftp-master.debian-unofficial.org/other/openpgp/archive-key-2008.asc -O config/chroot_sources/live-snapshots.binary.gpg

		fi

		lh build | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.log

		mv binary.iso debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso
		mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.list
		mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.iso.packages

		if [ "${SOURCE}" = "enabled" ]
		then
			mv source.tar.gz debian-live-${DISTRIBUTION}-source-${FLAVOUR}-source.tar.gz
			mv source.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}-source.tar.gz.list
		fi

		lh clean --binary
		lh config -b usb-hdd
		lh binary | tee debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.log

		mv binary.img debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img
		mv binary.list debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.list
		mv binary.packages debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${FLAVOUR}.img.packages

		lh clean --binary
		lh config -b net
		lh binary | tee debian-live-${DISTRIBUTION}-i386-${FLAVOUR}-net.tar.gz.log

		mv binary-net.tar.gz debian-live-${DISTRIBUTION}-i386-${FLAVOUR}-net.tar.gz
		mv binary.list debian-live-${DISTRIBUTION}-i386-${FLAVOUR}-net.tar.gz.list
		mv binary.packages debian-live-${DISTRIBUTION}-i386-${FLAVOUR}-net.tar.gz.packages

		mv binary/*/filesystem.squashfs debian-live-${DISTRIBUTION}-i386-${FLAVOUR}.squashfs
	done
done
