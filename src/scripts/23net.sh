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
		mkdir -p "${LIVE_ROOT}"/binary/casper
		cp -r "${LIVE_TEMPLATES}"/common/* "${LIVE_ROOT}"/binary
		
		for manifest in "${LIVE_ROOT}"/filesystem.manifest*
		do
			mv "${manifest}" "${LIVE_ROOT}"/binary/casper/
		done

		# Installing smbfs
		Chroot_exec "apt-get install --yes smbfs"

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

		# Switching package indices to default
		if [ "${LIVE_GENERIC_INDICES}" = "yes" ]
		then
			Indices default
		fi
	
		# Generating rootfs image
		Genrootfs

		# Switching package indices to custom
		if [ "${LIVE_GENERIC_INDICES}" = "yes" ]
		then
			Indices custom
		fi

		# Installing syslinux
		Syslinux net

		# Installing linux-image
		Linuximage net

		# Installing memtest
		Memtest net

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
		# Downloading sources
		Sources

		# Creating tarball
		tar cfz source.tar.gz "${LIVE_ROOT}"/source

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/image_source
	fi
}
