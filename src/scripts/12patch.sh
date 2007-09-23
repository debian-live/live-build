#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Patch_chroot ()
{
	# Some maintainer scripts can detect if they are in a chrooted system.
	# Therefore, we create the needed file.

	case "${1}" in
		apply)
			# Create chroot file
			echo "debian-live" > "${LIVE_CHROOT}"/etc/debian_chroot
			;;

		deapply)
			# Remove chroot file
			rm -f "${LIVE_CHROOT}"/etc/debian_chroot
			;;
	esac
}

Patch_runlevel ()
{
	# Disabling all init scripts with a blocking policy as in
	# /usr/share/doc/sysv-rc/README.policy-rc.d.gz.

	case "${1}" in
		apply)
			# Create init policy
			cat > "${LIVE_CHROOT}"/usr/sbin/policy-rc.d <<EOF
#!/bin/sh

exit 101
EOF

			chmod 0755 "${LIVE_CHROOT}"/usr/sbin/policy-rc.d
			;;

		deapply)
			# Removing init policy
			rm -f "${LIVE_CHROOT}"/usr/sbin/policy-rc.d
			;;
	esac
}

Patch_network ()
{
	# Packages which are manually installed inside the chroot are installed
	# from the network. Therefore, we need to be able to resolv hosts.

	case "${1}" in
		apply)
			# Save apt configuration
			if [ -f "${LIVE_CHROOT}"/etc/apt/apt.conf ]
			then
				cp "${LIVE_CHROOT}"/etc/apt/apt.conf "${LIVE_CHROOT}"/etc/apt/apt.conf.orig
			fi

			# Configure apt.conf
			if [ -n "${LIVE_PROXY_FTP}" ]
			then
				echo "Acquire::ftp::Proxy \"${LIVE_PROXY_FTP}\";" >> "${LIVE_CHROOT}"/etc/apt/apt.conf
			elif [ -n "${LIVE_PROXY_HTTP}" ]
			then
				echo "Acquire::http::Proxy \"${LIVE_PROXY_HTTP}\";" >> "${LIVE_CHROOT}"/etc/apt/apt.conf
			fi

			# Configure recommends
			if [ "${LIVE_RECOMMENDS}" = "yes" ]
			then
				echo "Aptitude::Recommends-Important \"true\";" >> "${LIVE_CHROOT}"/etc/apt/apt.conf
			else
				echo "Aptitude::Recommends-Important \"false\";" >> "${LIVE_CHROOT}"/etc/apt/apt.conf
			fi

			# Save host lookup table
			if [ -f "${LIVE_CHROOT}"/etc/hosts ]
			then
				cp "${LIVE_CHROOT}"/etc/hosts "${LIVE_CHROOT}"/etc/hosts.orig
			fi

			# Copy host lookup table
			if [ -f /etc/hosts ]
			then
				cp /etc/hosts "${LIVE_CHROOT}"/etc/hosts
			fi

			# Save resolver configuration
			if [ -f "${LIVE_CHROOT}"/etc/resolv.conf ]
			then
				cp "${LIVE_CHROOT}"/etc/resolv.conf "${LIVE_CHROOT}"/etc/resolv.conf.orig
			fi

			# Copy resolver configuration
			if [ -f /etc/resolv.conf ]
			then
				cp /etc/resolv.conf "${LIVE_CHROOT}"/etc/resolv.conf
			fi
			;;

		deapply)
			# Restore apt configuration
			if [ -f "${LIVE_CHROOT}"/etc/apt/apt.conf.orig ]
			then
				mv "${LIVE_CHROOT}"/etc/apt/apt.conf.orig "${LIVE_CHROOT}"/etc/apt/apt.conf
			else
				rm -f "${LIVE_CHROOT}"/etc/apt/apt.conf
			fi

			# Restore host lookup table
			if [ -f "${LIVE_CHROOT}"/etc/hosts.orig ]
			then
				mv "${LIVE_CHROOT}"/etc/hosts.orig "${LIVE_CHROOT}"/etc/hosts
			else
				rm -f "${LIVE_CHROOT}"/etc/hosts
			fi

			# Restore resolver configuration
			if [ -f "${LIVE_CHROOT}"/etc/resolv.conf.orig ]
			then
				mv "${LIVE_CHROOT}"/etc/resolv.conf.orig "${LIVE_CHROOT}"/etc/resolv.conf
			else
				rm -f "${LIVE_CHROOT}"/etc/resolv.conf
			fi
			;;
	esac
}

Patch_linux ()
{
	# The linux-image package asks interactively for initial ramdisk
	# creation. Therefore, we preconfigure /etc/kernel-img.conf.
	# FIXME: preseeding?

	case "${1}" in
		apply)
			# Save kernel configuration
			if [ -f "${LIVE_CHROOT}"/etc/kernel-img.conf ]
			then
				cp "${LIVE_CHROOT}"/etc/kernel-img.conf "${LIVE_CHROOT}"/etc/kernel-img.conf.old
			fi

			# Configure kernel-img.conf
			echo "do_initrd = Yes"  >> "${LIVE_CHROOT}"/etc/kernel-img.conf
			;;

		deapply)
			# Restore kernel configuration
			if [ -f "${LIVE_CHROOT}"/etc/kernel-img.conf.old ]
			then
				mv "${LIVE_CHROOT}"/etc/kernel-img.conf.old "${LIVE_CHROOT}"/etc/kernel-img.conf
			else
				rm -f "${LIVE_CHROOT}"/etc/kernel-img.conf
			fi
			;;
	esac
}
