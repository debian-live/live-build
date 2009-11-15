#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Net ()
{
	if [ ! -f "${LIVE_ROOT}"/.stage/image_binary ]
	then
		# Configure chroot
		Patch_chroot apply
		Patch_runlevel apply

		# Configure network
		Patch_network apply

		mkdir -p "${LIVE_ROOT}"/binary/casper
		cp -r "${LIVE_TEMPLATES}"/common/* "${LIVE_ROOT}"/binary

		for MANIFEST in "${LIVE_ROOT}"/filesystem.manifest*
		do
			if [ -e "${MANIFEST}" ]; then
				mv "${MANIFEST}" "${LIVE_ROOT}"/binary/casper/
			fi
		done

		# Mount proc
		mount proc-live -t proc "${LIVE_CHROOT}"/proc

		# Installing smbfs
		Chroot_exec "aptitude install --assume-yes smbfs"

		# Unmount proc
		umount "${LIVE_CHROOT}"/proc

		if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
		then
			if [ ! -d "${LIVE_CHROOT}"/etc/initramfs-tools ]
			then
				mkdir "${LIVE_CHROOT}"/etc/initramfs-tools
			fi

			# Configuring initramfs for NFS
cat >> "${LIVE_CHROOT}"/etc/initramfs-tools/initramfs.conf << EOF
MODULES=netboot
BOOT=nfs
NFSROOT=auto
EOF
			Chroot_exec "update-initramfs -tu"
		fi

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

		# Install depends
		if [ -z "${KEEP_MEMTEST86}" ]
		then
			if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
			then
				Patch_network apply
				Chroot_exec "aptitude install --assume-yes memtest86+"
			fi
		fi

		if [ -z "${KEEP_SYSLINUX}" ]
		then
			Patch_network apply
			Chroot_exec "aptitude install --assume-yes syslinux"
		fi

		# Installing syslinux
		Syslinux net

		# Installing linux-image
		Linuximage net

		# Installing memtest
		Memtest net

		# Remove depends
		if [ -z "${KEEP_SYSLINUX}" ]
		then
			if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
			then
				Chroot_exec "aptitude purge --assume-yes syslinux"
			fi
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

		# Creating tarball
		cd "${LIVE_ROOT}" && \
		mv binary "`basename ${LIVE_SERVER_PATH}`" && \
		cd .. && \
		tar cfz binary.tar.gz "`basename ${LIVE_ROOT}`/`basename ${LIVE_SERVER_PATH}`" "`basename ${LIVE_ROOT}`/tftpboot" && \
		mv binary.tar.gz "${LIVE_ROOT}" && \
		cd "${OLDPWD}" && \
		mv "`basename ${LIVE_SERVER_PATH}`" binary

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

		# Creating tarball
		tar cfz source.tar.gz "${LIVE_ROOT}"/source

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/image_source
	fi
}
