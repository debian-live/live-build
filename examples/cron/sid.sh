#!/bin/sh -x

set -e

BUILD="sid"

# Begin custom defaults
AUTOBUILD="enabled"

DATE="`date +%Y%m%d`"
DESTDIR="/srv/debian-unofficial/ftp/debian-live/cdimage"
TEMPDIR="/srv/tmp/live-helper"

OPTIONS="--binary-indices disabled --initramfs live-initramfs"

ARCHITECTURES="`dpkg --print-architecture`"
DISTRIBUTIONS="sid"
MIRROR_BOOTSTRAP="http://ftp.de.debian.org/debian/"
MIRROR_BOOTSTRAP_SECURITY="http://ftp.de.debian.org/debian-security/"
MIRROR_BINARY="http://ftp.debian.org/debian/"
MIRROR_BINARY_SECURITY="http://security.debian.org/"
PACKAGES_LISTS="standard gnome-desktop kde-desktop xfce-desktop"
# End custom defaults

# Checking for live-helper availability
if [ ! -x /usr/bin/make-live ]
then
	exit 0
fi

# Checking for live-helper defaults
#if [ -r /etc/default/live-helper ]
#then
#	. /etc/default/live-helper
#else
#	echo "E: /etc/default/live-helper missing."
#	exit 1
#fi

# Checking for autobuild
if [ "${AUTOBUILD}" != "enabled" ]
then
	exit 0
fi

# Checking for build directory
if [ ! -d "${TEMPDIR}" ]
then
	mkdir -p "${TEMPDIR}"/debian-live
else
	# FIXME: maybe we should just remove the left overs.
	echo "E: ${TEMPDIR} needs cleanup."
	exit 1
fi

echo "`date +%b\ %d\ %H:%M:%S` ${HOSTNAME} live-helper: begin ${BUILD} build." >> /var/log/live

for ARCHITECTURE in ${ARCHITECTURES}
do
	for DISTRIBUTION in ${DISTRIBUTIONS}
	do
		for PACKAGES_LIST in ${PACKAGES_LISTS}
		do
			if [ ! -f "${DESTDIR}"/"${BUILD}"-builds/${DATE}/log/debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${PACKAGES_LIST}_${DATE}-iso-log.txt ]
			then
				# Creating build directory
				mkdir -p "${TEMPDIR}"/debian-live

				cd "${TEMPDIR}"
				echo "Begin: `date -R`" > "${TEMPDIR}"/debian-live/log.txt

				# Generating images
				make-live -b iso -s tar --distribution ${DISTRIBUTION} --packages-lists ${PACKAGES_LIST} --mirror-bootstrap ${MIRROR_BOOTSTRAP} --mirror-bootstrap-security ${MIRROR_BOOTSTRAP_SECURITY} --mirror-binary ${MIRROR_BINARY} --mirror-binary-security ${MIRROR_BINARY_SECURITY} --source enabled ${OPTIONS} >> "${TEMPDIR}"/debian-live/log.txt 2>&1

				echo "End: `date -R`" >> "${TEMPDIR}"/debian-live/log.txt
			fi

			if [ -f "${TEMPDIR}"/debian-live/binary.iso ] && [ -f "${TEMPDIR}"/debian-live/source.tar.gz ]
			then
				# Creating log directory
				mkdir -p "${DESTDIR}"/"${BUILD}"-builds/${DATE}/log

				# Moving logs
				mv "${TEMPDIR}"/debian-live/log.txt "${DESTDIR}"/"${BUILD}"-builds/${DATE}/log/debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${PACKAGES_LIST}_${DATE}-iso-log.txt
				mv "${TEMPDIR}"/debian-live/binary/packages.txt "${DESTDIR}"/"${BUILD}"-builds/${DATE}/log/debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${PACKAGES_LIST}_${DATE}-iso-packages.txt

				# Creating images directory
				mkdir -p "${DESTDIR}"/"${BUILD}"-builds/${DATE}/${ARCHITECTURE}
				mkdir -p "${DESTDIR}"/"${BUILD}"-builds/${DATE}/source

				# Moving images
				mv "${TEMPDIR}"/debian-live/binary.iso "${DESTDIR}"/"${BUILD}"-builds/${DATE}/${ARCHITECTURE}/debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${PACKAGES_LIST}.iso
				mv "${TEMPDIR}"/debian-live/source.tar.gz "${DESTDIR}"/"${BUILD}"-builds/${DATE}/source/debian-live-${DISTRIBUTION}-source-${PACKAGES_LIST}.tar.gz
			fi

			if [ ! -f "${DESTDIR}"/"${BUILD}"-builds/${DATE}/log/debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${PACKAGES_LIST}_${DATE}-usb-hdd-log.txt ]
			then
				# Workaround of missing multi-binary support in live-helper
				mv "${TEMPDIR}"/debian-live/binary/casper "${TEMPDIR}"/debian-live/casper.tmp
				rm -rf "${TEMPDIR}"/debian-live/binary* "${TEMPDIR}"/debian-live/.stage/binary_*
				mkdir "${TEMPDIR}"/debian-live/binary
				mv "${TEMPDIR}"/debian-live/casper.tmp "${TEMPDIR}"/debian-live/binary/casper
				touch "${TEMPDIR}"/debian-live/.stage/binary_chroot
				touch "${TEMPDIR}"/debian-live/.stage/binary_rootfs

				# Creating build directory
				mkdir -p "${TEMPDIR}"/debian-live

				cd "${TEMPDIR}"
				echo "Begin: `date -R`" > "${TEMPDIR}"/debian-live/log.txt

				# Generating images
				make-live -b usb-hdd -s tar --distribution ${DISTRIBUTION} --packages-lists ${PACKAGES_LIST} --mirror-bootstrap ${MIRROR_BOOTSTRAP} --mirror-bootstrap-security ${MIRROR_BOOTSTRAP_SECURITY} --mirror-binary ${MIRROR_BINARY} --mirror-binary-security ${MIRROR_BINARY_SECURITY} --source disabled ${OPTIONS} >> "${TEMPDIR}"/debian-live/log.txt 2>&1

				echo "End: `date -R`" >> "${TEMPDIR}"/debian-live/log.txt
			fi

			if [ -f "${TEMPDIR}"/debian-live/binary.img ]
			then
				# Creating log directory
				mkdir -p "${DESTDIR}"/"${BUILD}"-builds/${DATE}/log

				# Moving logs
				mv "${TEMPDIR}"/debian-live/log.txt "${DESTDIR}"/"${BUILD}"-builds/${DATE}/log/debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${PACKAGES_LIST}_${DATE}-usb-hdd-log.txt
				cp "${DESTDIR}"/"${BUILD}"-builds/${DATE}/log/debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${PACKAGES_LIST}_${DATE}-iso-packages.txt "${DESTDIR}"/"${BUILD}"-builds/${DATE}/log/debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${PACKAGES_LIST}_${DATE}-usb-hdd-packages.txt

				# Creating image directory
				mkdir -p "${DESTDIR}"/"${BUILD}"-builds/${DATE}/${ARCHITECTURE}

				# Moving images
				mv "${TEMPDIR}"/debian-live/binary.img "${DESTDIR}"/"${BUILD}"-builds/${DATE}/${ARCHITECTURE}/debian-live-${DISTRIBUTION}-${ARCHITECTURE}-${PACKAGES_LIST}.img
			fi

			# Cleanup
			cd "${TEMPDIR}"/debian-live
			lh_clean
		done

		# Cleanup
		cd "${TEMPDIR}"/debian-live
		lh_clean purge
	done
done

# Cleaning up
if [ -f "${TEMPDIR}"/debian-live/chroot/proc/version ]
then
	umount "${TEMPDIR}"/debian-live/chroot/proc
fi

if [ -d "${TEMPDIR}"/debian-live/chroot/sys/kernel ]
then
	umount "${TEMPDIR}"/debian-live/chroot/sys
fi

# Removing build directory
rm -rf "${TEMPDIR}"

# Creating md5sums
for DIRECTORY in "${DESTDIR}"/"${BUILD}"-builds/${DATE}/*
do
	cd "${DIRECTORY}"
	md5sum * > MD5SUMS
done

# Creating current symlink
rm -f "${DESTDIR}"/"${BUILD}"-builds/current
ln -s ${DATE} "${DESTDIR}"/"${BUILD}"-builds/current

echo "`date +%b\ %d\ %H:%M:%S` ${HOSTNAME} live-helper: end ${BUILD} build." >> /var/log/live
