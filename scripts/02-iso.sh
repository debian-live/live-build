# scripts/02-iso.sh

Iso ()
{
	mkdir -p "${LIVE_ROOT}"/image/casper

	if [ "${LIVE_FILESYSTEM}" = "ext2" ]
	then
		DU_DIM="`du -ks ${LIVE_CHROOT} | cut -f1`"
		REAL_DIM="`expr ${DU_DIM} + ${DU_DIM} / 20`" # Just 5% more to be sure, need something more sophistcated here...

		genext2fs --size-in-blocks=${REAL_DIM} --reserved-blocks=0 \
			\--root="${LIVE_CHROOT}" \
			"${LIVE_ROOT}"/image/casper/filesystem.ext2
	else
		if [ -f "${LIVE_ROOT}"/image/casper/filesystem.squashfs ]
		then
			rm "${LIVE_ROOT}"/image/casper/filesystem.squashfs
		fi

		if [ -z "${LIVE_VERBOSE}" ]
		then
			mksquashfs "${LIVE_CHROOT}" "${LIVE_ROOT}"/image/casper/filesystem.squashfs
		else
			mksquashfs -info "${LIVE_CHROOT}" "${LIVE_ROOT}"/image/casper/filesystem.squashfs
		fi
	fi

	# Installing syslinux
	Syslinux iso

	# Installing linux-image
	Linuximage iso

	# Installing memtest
	Memtest iso

	# Installing templates
	cp -a "${LIVE_TEMPLATES}"/iso/* "${LIVE_ROOT}"/image

	# Calculating md5sums
	md5sums

	# Creating image
	mkisofss
}
