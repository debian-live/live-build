# scripts/01-bootstrap.sh

Bootstrap ()
{
	if [ -z "${LIVE_ROOTFS}" ]
	then
		# Create chroot directory
		mkdir -p "${LIVE_CHROOT}"

		if [ -z "${LIVE_VERBOSE}" ]
		then
			if [ -x /usr/bin/cdebootstrap ]
			then
				# Bootstrap with cdebootstrap
				cdebootstrap --arch="${LIVE_ARCHITECTURE}" \
					--flavour="${LIVE_FLAVOUR}" \
					"${LIVE_DISTRIBUTION}" \
					"${LIVE_CHROOT}" "${LIVE_MIRROR}"
			elif [ -x /usr/sbin/debootstrap ]
			then
				# Bootstrap with debootstrap
				debootstrap --arch="${LIVE_ARCHITECTURE}" \
					"${LIVE_DISTRIBUTION}" \
					"${LIVE_CHROOT}" "${LIVE_MIRROR}"
			fi
		else
			if [ -x /usr/bin/cdebootstrap ]
			then
				# Bootstrap with cdebootstrap (debug)
				cdebootstrap --arch="${LIVE_ARCHITECTURE}" \
					--debug --flavour="${LIVE_FLAVOUR}" \
					"${LIVE_DISTRIBUTION}" \
					"${LIVE_CHROOT}" "${LIVE_MIRROR}"
			elif [ -x /usr/sbin/debootstrap ]
			then
				# Bootstrap with debootstrap (debug)
				debootstrap --arch="${LIVE_ARCHITECTURE}" \
					--verbose "${LIVE_DISTRIBUTION}" \
					"${LIVE_CHROOT}" "${LIVE_MIRROR}"
			fi
		fi
	fi
}
