#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2015 Daniel Baumann <mail@daniel-baumann.ch>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


Exit ()
{
	VALUE="${?}"

	if [ "${_DEBUG}" = "true" ]
	then
		# Dump variables
		set | grep -e ^LB
	fi

	# Always exit true in case we are not able to unmount
	# (e.g. due to running processes in chroot from user customizations)
	Echo_message "Begin unmounting filesystems..."

	if [ -e /proc/mounts ]
	then
		for DIRECTORY in $(awk -v dir="${PWD}/chroot/" '$2 ~ dir { print $2 }' /proc/mounts | sort -r)
		do
			umount ${DIRECTORY} > /dev/null 2>&1 || true
		done
	else
		for DIRECTORY in /dev/shm /dev/pts /dev /proc /selinux /sys /root/config
		do
			umount -f chroot/${DIRECTORY} > /dev/null 2>&1 || true
		done
	fi

	rm -f .build/chroot_devpts
	rm -f .build/chroot_proc
	rm -f .build/chroot_selinuxfs
	rm -f .build/chroot_sysfs

	Echo_message "Saving caches..."

	# We can't really know at which part we're failing,
	# but let's assume that if there's any binary stage file arround
	# we are in binary stage.

	if ls .build/binary* > /dev/null 2>&1
	then
		Save_cache cache/packages.binary
	else
		Save_cache cache/packages.chroot
	fi

	return ${VALUE}
}

Setup_cleanup ()
{
	Echo_message "Setting up cleanup function"
	trap 'Exit' EXIT HUP INT QUIT TERM
}
