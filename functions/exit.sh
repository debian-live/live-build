#!/bin/sh

# exit.sh - cleanup
# Copyright (C) 2006-2009 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Exit ()
{
	if [ "${_DEBUG}" = "enabled" ]
	then
		# Dump variables
		set | grep -e ^LH
	fi

	# Always exit true in case we are not able to unmount
	# (e.g. due to running processes in chroot from user customizations)
	Echo_message "Begin unmounting filesystems..."
	for DIRECTORY in $(awk -v dir="${PWD}/chroot/" '$2 ~ dir { print $2 }' /proc/mounts | sort -r)
	do
		umount ${DIRECTORY} > /dev/null 2>&1 || true
	done
}

Setup_cleanup ()
{
	Echo_message "Setting up cleanup function"
	trap 'Exit' EXIT HUP INT QUIT TERM
}
