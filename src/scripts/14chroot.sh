#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Chroot_exec ()
{
	# Execute commands chrooted
	chroot "${LIVE_CHROOT}" /usr/bin/env -i HOME="/root" PATH="/usr/sbin:/usr/bin:/sbin:/bin" TERM="${TERM}" ftp_proxy="${LIVE_PROXY_FTP}" http_proxy="${LIVE_PPROXY_HTTP}" DEBIAN_FRONTEND="noninteractive" DEBIAN_PRIORITY="critical" ${1}
}

Chroot ()
{
	if [ ! -f "${LIVE_ROOT}"/.stage/chroot ]
	then
		# Configure chroot
		Patch_chroot apply
		#Patch_runlevel apply

		# Configure network
		Patch_network apply

		# Configure sources.list
		Indices custom

		# Install secure apt
		if [ "${LIVE_DISTRIBUTION}" = "${CODENAME_TESTING}" ] || [ "${LIVE_DISTRIBUTION}" = "${CODENAME_UNSTABLE}" ]
		then
			Chroot_exec "apt-get install --yes --force-yes debian-archive-keyring"
		fi

		# Update indices
		Chroot_exec "apt-get update"

		# Configure linux-image
		Patch_linux apply

		# Install linux-image, modules and casper
		Chroot_exec "apt-get install --yes linux-image-2.6-${LIVE_KERNEL} squashfs-modules-2.6-${LIVE_KERNEL} unionfs-modules-2.6-${LIVE_KERNEL} casper"

		# Rebuild initial ramdisk
		Chroot_exec "dpkg-reconfigure `basename ${LIVE_CHROOT}/var/lib/dpkg/info/linux-image-2.6.*-${LIVE_KERNEL}.postinst .postinst`"

		# Deconfigure linux-image
		Patch_linux deapply

		# Install packages list
		if [ -n "${LIVE_PACKAGE_LIST}" ]
		then
			Chroot_exec "apt-get install --yes `cat ${LIVE_PACKAGE_LIST}`"
		fi

		# Install extra packages
		if [ -n "${LIVE_PACKAGES}" ]
		then
			Chroot_exec "apt-get install --yes ${LIVE_PACKAGES}"
		fi

		# Copy external directory into the chroot
		if [ -d "${LIVE_INCLUDE_CHROOT}" ]
		then
			cd "${LIVE_INCLUDE_CHROOT}"
			find . | cpio -pumd "${LIVE_CHROOT}"
			cd "${OLDPWD}"
		fi

		# Execute extra command in the chroot
		if [ -n "${LIVE_HOOK}" ]
		then
			Chroot_exec "${LIVE_HOOK}"
		fi

		# Temporary hacks for broken packages
		Hack_xorg

		# Clean apt packages cache
		rm -f "${LIVE_CHROOT}"/var/cache/apt/archives/*.deb
		rm -f "${LIVE_CHROOT}"/var/cache/apt/archives/partial/*.deb

		# Clean apt indices cache
		rm -f "${LIVE_CHROOT}"/var/cache/apt/*pkgcache.bin

		# Remove cdebootstrap packages cache
		rm -rf "${LIVE_CHROOT}"/var/cache/bootstrap

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		#Patch_runlevel deapply
		Patch_chroot deapply

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/chroot

		echo "done."
	fi
}
