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
	Indices default
	
	# Generating rootfs image
	Genrootfs

	# Switching package indices to custom
	Indices custom

	# Installing syslinux
	Syslinux net

	# Installing linux-image
	Linuximage net

	# Installing memtest
	Memtest net

	# Creating tarball
	LIVE_BASENAME=`basename "${LIVE_ROOT}"`
	LIVE_BASE_SERVER_PATH=`basename "${LIVE_SERVER_PATH}"`
	cd "${LIVE_ROOT}" && \
	mv image "${LIVE_BASE_SERVER_PATH}" && \
	cd .. && \
	tar cfz netboot.tar.gz "${LIVE_BASENAME}/${LIVE_BASE_SERVER_PATH}" "${LIVE_BASENAME}/tftpboot" && \
	mv netboot.tar.gz "${LIVE_ROOT}" && \
	cd "${OLDPWD}" && \
	mv "${LIVE_BASE_SERVER_PATH}" image
}
