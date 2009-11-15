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

		# Manifest
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

		# Mount proc
		mount proc-live -t proc "${LIVE_CHROOT}"/proc

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

		# Install depends
		if [ -z "${KEEP_DOSFSTOOLS}" ]
		then
			Chroot_exec "aptitude install --assume-yes dosfstools"
		fi

		if [ -z "${KEEP_MEMTEST86}" ]
		then
			if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
			then
				Chroot_exec "aptitude install --assume-yes memtest86+"
			fi
		fi

		if [ -z "${KEEP_MTOOLS}" ]
		then
			Chroot_exec "aptitude install --assume-yes mtools"
		fi

		if [ -z "${KEEP_PARTED}" ]
		then
			Chroot_exec "aptitude install --assume-yes parted"
		fi

		if [ -z "${KEEP_SYSLINUX}" ]
		then
			Chroot_exec "aptitude install --assume-yes syslinux"
		fi

		# Installing syslinux
		Syslinux iso

		# Installing linux-image
		Linuximage iso

		# Installing memtest
		Memtest iso

		# Calculating md5sums
		Md5sum

		# Creating image

		# USB hacks
		mv "${LIVE_ROOT}"/binary/isolinux/isolinux.cfg "${LIVE_ROOT}"/binary/syslinux.cfg
		mv "${LIVE_ROOT}"/binary/isolinux/isolinux.bin "${LIVE_ROOT}"/binary/syslinux.bin
		mv "${LIVE_ROOT}"/binary/isolinux/* "${LIVE_ROOT}"/binary
		rmdir "${LIVE_ROOT}"/binary/isolinux/

		# Everything which comes here needs to be cleaned up,
		DU_DIM="`du -ms ${LIVE_ROOT}/binary | cut -f1`"
		REAL_DIM="`expr ${DU_DIM} + ${DU_DIM} / 20`" # Just 5% more to be sure, need something more sophistcated here...
		dd if=/dev/zero of="${LIVE_ROOT}"/binary.img bs=1024k count=${REAL_DIM}

		echo "!!! The following error/warning messages can be ignored !!!"
		losetup_p "${LIVE_ROOT}"/binary.img 0
		set +e
		Chroot_exec "parted -s ${FREELO} mklabel msdos"
		Chroot_exec "parted -s ${FREELO} mkpartfs primary fat16 0.0 100%"
		Chroot_exec "parted -s ${FREELO} set 1 boot on"
		Chroot_exec "parted -s ${FREELO} set 1 lba off"
		set -e
		cat "${LIVE_CHROOT}"/usr/lib/syslinux/mbr.bin > ${FREELO}
		losetup -d ${FREELO}

		losetup_p "${LIVE_ROOT}"/binary.img 1
		Chroot_exec "mkfs.msdos -n DEBIAN_LIVE ${FREELO}"
		mkdir "${LIVE_ROOT}"/binary.tmp
		mount ${FREELO} "${LIVE_ROOT}"/binary.tmp
		cp -r "${LIVE_ROOT}"/binary/* "${LIVE_ROOT}"/binary.tmp
		umount "${LIVE_ROOT}"/binary.tmp
		rmdir "${LIVE_ROOT}"/binary.tmp
		Chroot_exec "syslinux ${FREELO}"
		losetup -d ${FREELO}

		echo "!!! The above error/warning messages can be ignored !!!"

		# Remove depends
		if [ -z "${KEEP_DOSFSTOOLS}" ]
		then
			Chroot_exec "aptitude purge --assume-yes dosfstools"
		fi

		if [ -z "${KEEP_MEMTEST86}" ]
		then
			if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
			then
				Chroot_exec "aptitude purge --assume-yes memtest86+"
			fi
		fi

		if [ -z "${KEEP_MTOOLS}" ]
		then
			Chroot_exec "aptitude purge --assume-yes mtools"
		fi

		if [ -z "${KEEP_PARTED}" ]
		then
			Chroot_exec "aptitude purge --assume-yes parted"
		fi

		if [ -z "${KEEP_SYSLINUX}" ]
		then
			Chroot_exec "aptitude purge --assume-yes syslinux"
		fi

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		Patch_runlevel deapply
		Patch_chroot deapply

		# Unmount proc
		umount "${LIVE_CHROOT}"/proc

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
