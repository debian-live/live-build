# scripts/01-patches.sh

Patch_chroot ()
{
	# Some maintainer scripts can detect if they are in a chrooted system.
	# Therefore, we create the corresponding file.

	case "${1}" in
		apply)
			# Create chroot file
			echo "live" > "${LIVE_CHROOT}"/etc/debian_chroot
			;;

		deapply)
			# Remove chroot file
			rm -f "${LIVE_CHROOT}"/etc/debian_chroot
			;;
	esac
}

Patch_network ()
{
	# Packages which are manually installed inside the chroot are installed
	# from the network. Therefore, we need to be able to resolv hosts.

	case "${1}" in
		apply)
			# Save host lookup table
			if [ -f "${LIVE_CHROOT}"/etc/hosts ]
			then
				cp "${LIVE_CHROOT}"/etc/hosts \
					"${LIVE_CHROOT}"/etc/hosts.orig
			fi

			# Save resolver configuration
			if [ -f "${LIVE_CHROOT}"/etc/resolv.conf ]
			then
				cp "${LIVE_CHROOT}"/etc/resolv.conf \
					"${LIVE_CHROOT}"/etc/resolv.conf.orig
			fi

			# Copy host lookup table
			if [ -f /etc/hosts ]
			then
				cp /etc/hosts "${LIVE_CHROOT}"/etc/hosts
			fi

			# Copy resolver configuration
			if [ -f /etc/resolv.conf ]
			then
				cp /etc/resolv.conf \
					"${LIVE_CHROOT}"/etc/resolv.conf
			fi
			;;

		deapply)
			# Restore host lookup table
			if [ -f "${LIVE_CHROOT}"/etc/hosts.orig ]
			then
				mv "${LIVE_CHROOT}"/etc/hosts.orig \
					"${LIVE_CHROOT}"/etc/hosts
			fi

			# Restore resolver configuration
			if [ -f "${LIVE_CHROOT}"/etc/resolv.conf.orig ]
			then
				mv "${LIVE_CHROOT}"/etc/resolv.conf.orig \
					"${LIVE_CHROOT}"/etc/resolv.conf
			fi
			;;
	esac
}

Patch_linuximage ()
{
	# The linux-image package asks interactively for initial ramdisk
	# creation. Therefore, we preconfigure /etc/kernel-img.conf.

	case "${1}" in
		apply)
			# Write configuration option
			echo "do_initrd = Yes"  >> \
				"${LIVE_CHROOT}"/etc/kernel-img.conf
			;;

		deapply)
			# Remove configuration file
			rm -f "${LIVE_CHROOT}"/etc/kernel-img.conf
			;;
	esac
}
