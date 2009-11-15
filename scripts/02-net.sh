# scripts/02-net.sh

Net ()
{
	# Installing smbfs
	chroots "apt-get install --yes smbfs"

	if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
	then
		mkdir "${LIVE_CHROOT}"/etc/mkinitramfs

		# Configuring initramfs for NFS
cat >> "${LIVE_CHROOT}"/etc/mkinitramfs/initramfs.conf << EOF
MODULES=netboot
BOOT=nfs
EOF
	fi

	# Installing syslinux
	Syslinux net

	# Installing linux-image
	Linuximage net

	# Installing memtest
	Memtest net

	if [ -z "${LIVE_VERBOSE}" ]
	then
		# Creating tarball
		cd "${LIVE_ROOT}" && cd .. && \
			tar cfz netboot.tar.gz `basename "${LIVE_ROOT}"` && \
			mv netboot.tar.gz "${LIVE_ROOT}"
	else
		# Creating tarball (debug)
		cd "${LIVE_ROOT}" && cd .. && \
			tar cfvz netboot.tar.gz `basename "${LIVE_ROOT}"` && \
			mv netboot.tar.gz "${LIVE_ROOT}"
	fi
}
