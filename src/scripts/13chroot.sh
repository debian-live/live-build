#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Chroot ()
{
	if [ ! -f "${LIVE_ROOT}"/.stage/chroot ]
	then
		# Configure chroot
		lh_patchchroot apply
		lh_patchrunlevel apply

		# Configure network
		lh_patchnetwork apply

		# Mount proc
		mount proc-live -t proc "${LIVE_CHROOT}"/proc

		# Configure sources.list
		lh_setupapt custom initial
		lh_configapt apply-proxy
		lh_configapt apply-recommends

		# Install aptitude
		lh_installapt

		# Update indices
		lh_chroot "aptitude update"

		# Configure linux-image
		lh_patchlinux apply

		# Install linux-image, modules and casper
		lh_chroot "aptitude install --assume-yes ${LIVE_KERNEL_PACKAGES} casper"

		# Deconfigure linux-image
		lh_patchlinux deapply

		lh_clone
		lh_preseed

		lh_installtasks
		lh_installpackagelists
		lh_installpackages
		lh_includechroot
		lh_hook

		# Save package list
		lh_chroot "dpkg --get-selections" > "${LIVE_ROOT}"/packages.txt

		lh_config disable-daemons

		lh_manifest

		lh_cleanapt

		# Workaround binfmt-support /proc locking
		umount "${LIVE_CHROOT}"/proc/sys/fs/binfmt_misc > /dev/null || true

		# Unmount proc
		umount "${LIVE_CHROOT}"/proc

		# Deconfigure network
		lh_patchnetwork deapply

		# Deconfigure chroot
		lh_patchrunlevel deapply
		lh_patchchroot deapply

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/chroot
	fi

	# Check depends
	if [ "`grep dosfstools ${LIVE_ROOT}/packages.txt`" ]
	then
		KEEP_DOSFSTOOLS="true"
	fi

	if [ "`grep memtest86+ ${LIVE_ROOT}/packages.txt`" ]
	then
		KEEP_MEMTEST86="true"
	fi

	if [ "`grep mtools ${LIVE_ROOT}/packages.txt`" ]
	then
		KEEP_MTOOLS="true"
	fi

	if [ "`grep parted ${LIVE_ROOT}/packages.txt`" ]
	then
		KEEP_PARTED="true"
	fi

	if [ "`grep syslinux ${LIVE_ROOT}/packages.txt`" ]
	then
		KEEP_SYSLINUX="true"
	fi
}
