#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Indices ()
{
	case "${1}" in
		default)
			# Configure default sources.list
			echo "deb http://ftp.debian.org/debian/ ${LIVE_DISTRIBUTION} ${LIVE_SECTION}" > "${LIVE_CHROOT}"/etc/apt/sources.list

			case "${LIVE_DISTRIBUTION}" in
				"${CODENAME_TESTING}")
					echo "deb http://ftp.debian.org/debian/ ${CODENAME_TESTING}-proposed-updates ${LIVE_SECTION}" >> "${LIVE_CHROOT}"/etc/apt/sources.list
					echo "deb http://security.debian.org/ ${CODENAME_TESTING}/updates ${LIVE_SECTION}" >> "${LIVE_CHROOT}"/etc/apt/sources.list
					;;

				"${CODENAME_STABLE}")
					echo "deb ${LIVE_MIRROR_SECURITY} ${CODENAME_STABLE}/updates ${LIVE_SECTION}" >> "${LIVE_CHROOT}"/etc/apt/sources.list
					;;

				"${CODENAME_OLDSTABLE}")
					echo "deb ${LIVE_MIRROR_SECURITY} ${CODENAME_OLDSTABLE}/updates ${LIVE_SECTION}" >> "${LIVE_CHROOT}"/etc/apt/sources.list
					;;
			esac
			;;

		custom)
			# Configure custom sources.list
			echo "deb ${LIVE_MIRROR} ${LIVE_DISTRIBUTION} ${LIVE_SECTION}" > "${LIVE_CHROOT}"/etc/apt/sources.list

			case "${LIVE_DISTRIBUTION}" in
				"${CODENAME_TESTING}")
					echo "deb ${LIVE_MIRROR} ${CODENAME_TESTING}-proposed-updates ${LIVE_SECTION}" >> "${LIVE_CHROOT}"/etc/apt/sources.list
					echo "deb ${LIVE_MIRROR_SECURITY} ${CODENAME_TESTING}/updates ${LIVE_SECTION}" >> "${LIVE_CHROOT}"/etc/apt/sources.list
					;;

				"${CODENAME_STABLE}")
					echo "deb ${LIVE_MIRROR_SECURITY} ${CODENAME_STABLE}/updates ${LIVE_SECTION}" >> "${LIVE_CHROOT}"/etc/apt/sources.list
					;;

				"${CODENAME_OLDSTABLE}")
					echo "deb ${LIVE_MIRROR_SECURITY} ${CODENAME_OLDSTABLE}/updates ${LIVE_SECTION}" >> "${LIVE_CHROOT}"/etc/apt/sources.list
					;;
			esac
			;;
	esac

	# Update indices
	Chroot_exec "apt-get update"
}

Md5sum ()
{
	# Calculating md5sums
	cd "${LIVE_ROOT}"/image
	find . -type f -print0 | xargs -0 md5sum > "${LIVE_ROOT}"/md5sum.txt
	cd "${OLDPWD}"

	if [ -d "${LIVE_INCLUDE_IMAGE}" ]
	then
		cd "${LIVE_INCLUDE_IMAGE}"
		find . -type f -print0 | xargs -0 md5sum >> "${LIVE_ROOT}"/md5sum.txt
		cd "${OLDPWD}"
	fi

	mv "${LIVE_ROOT}"/md5sum.txt "${LIVE_ROOT}"/image
}

Mkisofs ()
{
	if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
	then
			mkisofs -A "Debian Live" -p "Debian Live; http://live.debian.net/; live@lists.debian-unofficial.org" -publisher "Debian Live; http://live.debian.net/; live@lists.debian-unofficial.org" -o "${LIVE_ROOT}"/image.iso -r -J -l -V "Debian Live `date +%Y%m%d`" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table "${LIVE_ROOT}"/image ${LIVE_INCLUDE_IMAGE}
	else
		echo "W: Bootloader on your architecture not yet supported (Continuing in 5 seconds)."
		sleep 5

			# Create image
			mkisofs -o "${LIVE_ROOT}"/image.iso -r -J -l -V "Debian Live `date +%Y%m%d`" "${LIVE_ROOT}"/image ${LIVE_INCLUDE_IMAGE}
	fi
}

Linuximage ()
{
	case "${1}" in
		iso)
			# Copy linux-image
			cp "${LIVE_CHROOT}"/boot/vmlinuz-* "${LIVE_ROOT}"/image/isolinux/vmlinuz
			cp "${LIVE_CHROOT}"/boot/initrd.img-* "${LIVE_ROOT}"/image/isolinux/initrd.gz
			;;

		net)
			# Copy linux-image
			cp "${LIVE_ROOT}"/chroot/boot/vmlinuz-* "${LIVE_ROOT}"/tftpboot/vmlinuz
			cp "${LIVE_ROOT}"/chroot/boot/initrd.img-* "${LIVE_ROOT}"/tftpboot/initrd.gz
			;;
	esac
}

Memtest ()
{
	if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
	then
		# Install memtest
		Patch_network apply
		Chroot_exec "apt-get install --yes memtest86+"

		case "$1" in
			iso)
				# Copy memtest
				cp "${LIVE_ROOT}"/chroot/boot/memtest86+.bin "${LIVE_ROOT}"/image/isolinux/memtest
				;;

			net)
				# Copy memtest
				cp "${LIVE_ROOT}"/chroot/boot/memtest86+.bin "${LIVE_ROOT}"/tftpboot/memtest
				;;
		esac

		# Remove memtest
		Chroot_exec "apt-get remove --purge --yes memtest86+"
		Patch_network deapply
	fi
}

Genrootfs ()
{
	case "${LIVE_FILESYSTEM}" in
		ext2)
			DU_DIM="`du -ks ${LIVE_CHROOT} | cut -f1`"
			REAL_DIM="`expr ${DU_DIM} + ${DU_DIM} / 20`" # Just 5% more to be sure, need something more sophistcated here...

			genext2fs --size-in-blocks=${REAL_DIM} --reserved-blocks=0 --root="${LIVE_CHROOT}" "${LIVE_ROOT}"/image/casper/filesystem.ext2
			;;

		plain)
			cd "${LIVE_CHROOT}"
			find . | cpio -pumd "${LIVE_ROOT}"/image/casper/filesystem.dir
			cd "${OLDPWD}"
			;;

		squashfs)
			if [ -f "${LIVE_ROOT}"/image/casper/filesystem.squashfs ]
			then
				rm "${LIVE_ROOT}"/image/casper/filesystem.squashfs
			fi

			mksquashfs "${LIVE_CHROOT}" "${LIVE_ROOT}"/image/casper/filesystem.squashfs
			;;
	esac
}

Syslinux ()
{
	if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
	then
		# Install syslinux
		Patch_network apply
		Chroot_exec "apt-get install --yes syslinux"

		case "${1}" in
			iso)
				# Copy syslinux
				mkdir -p "${LIVE_ROOT}"/image/isolinux
				cp "${LIVE_CHROOT}"/usr/lib/syslinux/isolinux.bin "${LIVE_ROOT}"/image/isolinux

				# Install syslinux templates
				cp -r "${LIVE_TEMPLATES}"/syslinux/* \
					"${LIVE_ROOT}"/image/isolinux
				rm -f "${LIVE_ROOT}"/image/isolinux/pxelinux.cfg

				# Configure syslinux templates
				sed -i -e "s#LIVE_BOOTAPPEND#${LIVE_BOOTAPPEND}#" "${LIVE_ROOT}"/image/isolinux/isolinux.cfg
				sed -i -e "s/LIVE_DATE/`date +%Y%m%d`/" "${LIVE_ROOT}"/image/isolinux/f1.txt
				sed -i -e "s/LIVE_VERSION/${VERSION}/" "${LIVE_ROOT}"/image/isolinux/f10.txt
				;;

			net)
				# Copy syslinux
				mkdir -p "${LIVE_ROOT}"/tftpboot
				cp "${LIVE_ROOT}"/chroot/usr/lib/syslinux/pxelinux.0 "${LIVE_ROOT}"/tftpboot

				# Install syslinux templates
				mkdir -p "${LIVE_ROOT}"/tftpboot/pxelinux.cfg
				cp -r "${LIVE_TEMPLATES}"/syslinux/* \
					"${LIVE_ROOT}"/tftpboot/pxelinux.cfg
				mv "${LIVE_ROOT}"/tftpboot/pxelinux.cfg/pxelinux.cfg "${LIVE_ROOT}"/tftpboot/pxelinux.cfg/default
				rm -f "${LIVE_ROOT}"/tftpboot/pxelinux.cfg/isolinux.*

				# Configure syslinux templates
				sed -i -e "s/LIVE_SERVER_ADDRESS/${LIVE_SERVER_ADDRESS}/" -e "s#LIVE_SERVER_PATH#${LIVE_SERVER_PATH}#" -e "s#LIVE_BOOTAPPEND#${LIVE_BOOTAPPEND}#" "${LIVE_ROOT}"/tftpboot/pxelinux.cfg/default
				sed -i -e "s/LIVE_DATE/`date +%Y%m%d`/" "${LIVE_ROOT}"/tftpboot/pxelinux.cfg/f1.txt
				sed -i -e "s/LIVE_VERSION/${VERSION}/" "${LIVE_ROOT}"/tftpboot/pxelinux.cfg/f10.txt
				;;
		esac

		# Remove syslinux
		Chroot_exec "apt-get remove --purge --yes syslinux"
		Patch_network deapply
	fi
}
