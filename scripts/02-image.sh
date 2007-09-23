# scripts/02-image.sh

md5sums ()
{
	# Calculating md5sums
        cd "${LIVE_ROOT}"/image
        find . -type f -print0 | xargs -0 md5sum > "${LIVE_ROOT}"/md5sum.txt
        cd "${OLDPWD}"

        if [ -d "${LIVE_INCLUDE_IMAGE}" ]
        then
        	cd "${LIVE_INCLUDE_IMAGE}"
                find . -type f -print0 | xargs -0 md5sum >> \
			"${LIVE_ROOT}"/md5sum.txt
                cd "${OLDPWD}"
        fi

	mv "${LIVE_ROOT}"/md5sum.txt "${LIVE_ROOT}"/image
}

mkisofss ()
{
	if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
	then
		# Create image
		if [ -z "${LIVE_VERBOSE}" ]
		then
			mkisofs -quiet -A "Debian Live" -p "Debian Live; http://live.debian.net/; live@lists.debian-unofficial.org" -publisher "Debian Live; http://live.debian.net/; live@lists.debian-unofficial.org" -o "${LIVE_ROOT}"/image.iso -r -J -l -V "Debian Live `date +%Y%m%d`" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table "${LIVE_ROOT}"/image ${LIVE_INCLUDE_IMAGE}
		else
			mkisofs -A "Debian Live" -p "Debian Live; http://live.debian.net/; live@lists.debian-unofficial.org" -publisher "Debian Live; http://live.debian.net/; live@lists.debian-unofficial.org" -o "${LIVE_ROOT}"/image.iso -r -J -l -V "Debian Live `date +%Y%m%d`" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table "${LIVE_ROOT}"/image ${LIVE_INCLUDE_IMAGE}
		fi
	else
		echo "FIXME: Bootloader on your architecture not yet supported (Continuing in 5 seconds)."
		sleep 5

		if [ -z "${LIVE_VERBOSE}" ]
		then
			# Create image
			mkisofs -quiet -o "${LIVE_ROOT}"/image.iso -r -J -l -V "Debian Live `date +%Y%m%d`" "${LIVE_ROOT}"/image ${LIVE_INCLUDE_IMAGE}
		else
			# Create image (debug)
			mkisofs -o "${LIVE_ROOT}"/image.iso -r -J -l -V "Debian Live `date +%Y%m%d`" "${LIVE_ROOT}"/image ${LIVE_INCLUDE_IMAGE}
		fi
	fi
}


Linuximage ()
{
	case "${1}" in
		iso)
			# Copy linux-image
			cp "${LIVE_CHROOT}"/boot/vmlinuz-* \
				"${LIVE_ROOT}"/image/isolinux/vmlinuz
			cp "${LIVE_CHROOT}"/boot/initrd.img-* \
				"${LIVE_ROOT}"/image/isolinux/initrd.gz
			;;

		net)
			# Copy linux-image
			cp "${LIVE_ROOT}"/chroot/boot/vmlinuz-* \
				"${LIVE_ROOT}"/tftpboot/vmlinuz
			cp "${LIVE_ROOT}"/chroot/boot/initrd.img-* \
				"${LIVE_ROOT}"/tftpboot/initrd.gz
			;;
	esac
}

Memtest ()
{
	if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
	then
		# Install memtest
		Patch_network apply
		chroots "apt-get install --yes memtest86+"

		case "$1" in
			iso)
				# Copy memtest
				cp "${LIVE_ROOT}"/chroot/boot/memtest86+.bin \
					"${LIVE_ROOT}"/image/isolinux/memtest
				;;

			net)
				# Copy memtest
				cp "${LIVE_ROOT}"/chroot/boot/memtest86+.bin \
					"${LIVE_ROOT}"/tftpboot/memtest
				;;
		esac

		# Remove memtest
		chroots "apt-get remove --purge --yes memtest86+"
		Patch_network deapply
	fi
}

Syslinux ()
{
	if [ "${LIVE_ARCHITECTURE}" = "amd64" ] || [ "${LIVE_ARCHITECTURE}" = "i386" ]
	then
		# Install syslinux
		Patch_network apply
		chroots "apt-get install --yes syslinux"

		case "${1}" in
			iso)
				# Copy syslinux
				mkdir -p "${LIVE_ROOT}"/image/isolinux
				cp "${LIVE_CHROOT}"/usr/lib/syslinux/isolinux.bin "${LIVE_ROOT}"/image/isolinux

				# Install syslinux templates
				cp -a "${LIVE_TEMPLATES}"/syslinux/* \
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
				cp -a "${LIVE_TEMPLATES}"/syslinux/* \
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
		chroots "apt-get remove --purge --yes syslinux"
		Patch_network deapply
	fi
}
