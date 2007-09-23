#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Usb ()
{
	if [ ! -f "${LIVE_ROOT}"/.stage/image_binary ]
	then
		# Configure chroot
		Patch_chroot apply
		Patch_runlevel apply

		# Configure network
		Patch_network apply

		mkdir -p "${LIVE_ROOT}"/binary/casper
		for MANIFEST in "${LIVE_ROOT}"/filesystem.manifest*
		do
			if [ -e "${MANIFEST}" ]; then
				mv "${MANIFEST}" "${LIVE_ROOT}"/binary/casper/
			fi
		done

		# Remove indices
		rm -rf "${LIVE_CHROOT}"/var/cache/apt
		mkdir -p "${LIVE_CHROOT}"/var/cache/apt/archives/partial
		rm -rf "${LIVE_CHROOT}"/var/lib/apt/lists
		mkdir -p "${LIVE_CHROOT}"/var/lib/apt/lists/partial

		# Switching package indices to default
		if [ "${LIVE_GENERIC_INDICES}" = "yes" ]
		then
			Indices default
		fi

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		Patch_runlevel deapply
		Patch_chroot deapply

		# Generating rootfs image
		Genrootfs

		# Configure chroot
		Patch_chroot apply
		Patch_runlevel apply

		# Configure network
		Patch_network apply

		# Remove indices
		rm -rf "${LIVE_CHROOT}"/var/cache/apt
		mkdir -p "${LIVE_CHROOT}"/var/cache/apt/archives/partial
		rm -rf "${LIVE_CHROOT}"/var/lib/apt/lists
		mkdir -p "${LIVE_CHROOT}"/var/lib/apt/lists/partial

		# Switching package indices to custom
		Indices custom

		# Installing syslinux
		Syslinux iso

		# Installing linux-image
		Linuximage iso

		# Installing memtest
		Memtest iso

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		Patch_runlevel deapply
		Patch_chroot deapply

		# Calculating md5sums
		Md5sum

		# Creating image
		mv "${LIVE_ROOT}"/binary/isolinux/isolinux.cfg "${LIVE_ROOT}"/binary/syslinux.cfg
		mv "${LIVE_ROOT}"/binary/isolinux/isolinux.bin "${LIVE_ROOT}"/binary/syslinux.bin
		mv "${LIVE_ROOT}"/binary/isolinux/* "${LIVE_ROOT}"/binary

		# Everything which comes here needs to be cleaned up,
		# especially all the parted/syslinux stuff should be done
		# from within the chroot, not on the host system, will do that later.

		DU_DIM="`du -ms ${LIVE_ROOT}/binary | cut -f1`"
		REAL_DIM="`expr ${DU_DIM} + ${DU_DIM} / 20`" # Just 5% more to be sure, need something more sophistcated here...
		dd if=/dev/zero of="${LIVE_ROOT}"/binary.img bs=1024k count=${REAL_DIM}

		echo "!!! The following error/warning messages can be ignored !!!"
		losetup_p "${LIVE_ROOT}"/binary.img 0
		parted -s ${FREELO} mklabel msdos
		set +e
		parted -s ${FREELO} mkpartfs primary fat16 0.0 100%
		parted -s ${FREELO} set 1 boot on
		parted -s ${FREELO} set 1 lba off
		set -e
		cat /usr/lib/syslinux/mbr.bin > ${FREELO}
		losetup -d ${FREELO}
		echo "!!! The above error/warning messages can be ignored !!!"

		losetup_p "${LIVE_ROOT}"/binary.img 1
		mkfs.msdos -n DEBIAN_LIVE ${FREELO}
		mkdir "${LIVE_ROOT}"/binary.tmp
		mount ${FREELO} "${LIVE_ROOT}"/binary.tmp
		cp -r "${LIVE_ROOT}"/binary/* "${LIVE_ROOT}"/binary.tmp
		umount "${LIVE_ROOT}"/binary.tmp
		rmdir "${LIVE_ROOT}"/binary.tmp
		syslinux ${FREELO}
		losetup -d ${FREELO}

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/image_binary
	fi

	if [ ! -f "${LIVE_ROOT}"/.stage/image_source ] && [ "${LIVE_SOURCE}" = "yes" ]
	then
		# Configure chroot
		Patch_chroot apply
		Patch_runlevel apply

		# Configure network
		Patch_network apply

		# Downloading sources
		Sources

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		Patch_runlevel deapply
		Patch_chroot deapply

		# Creating image
		tar cfz source.tar.gz "${LIVE_ROOT}"/source

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/image_source
	fi
}
