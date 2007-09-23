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
	return ${?}
}

Chroot ()
{
	if [ ! -f "${LIVE_ROOT}"/.stage/chroot ]
	then
		# Configure chroot
		Patch_chroot apply
		Patch_runlevel apply

		# Configure network
		Patch_network apply

		# Mount proc
		mount proc-live -t proc "${LIVE_CHROOT}"/proc

		# Configure sources.list
		Indices custom

		# Install secure apt
		if [ "${LIVE_DISTRIBUTION}" = "testing" ] || [ "${LIVE_DISTRIBUTION}" = "unstable" ]
		then
			if [ "${LIVE_FLAVOUR}" != "minimal" ]
			then
				Chroot_exec "apt-get install --yes --force-yes debian-archive-keyring"

				for NAME in ${LIVE_REPOSITORIES}
				do
					eval REPOSITORY_KEY="$`echo LIVE_REPOSITORY_KEY_$NAME`"
					eval REPOSITORY_KEYRING="$`echo LIVE_REPOSITORY_KEYRING_$NAME`"

					if [ -n "${REPOSITORY_KEYRING}" ]
					then
						Chroot_exec "apt-get install ${REPOSITORY_KEYRING}"
					elif [ -n "${REPOSITORY_KEY}" ]
					then
						Chroot_exec "wget ${REPOSITORY_KEY}"
						Chroot_exec "apt-key add `basename ${REPOSITORY_KEY}`"
						Chroot_exec "rm -f `basename ${REPOSITORY_KEY}`"
					fi
				done
			fi
		fi

		# Update indices
		Chroot_exec "apt-get update"

		# Configure linux-image
		Patch_linux apply

		# Install linux-image, modules and casper
		Chroot_exec "apt-get install --yes --force-yes linux-image-2.6-${LIVE_KERNEL} squashfs-modules-2.6-${LIVE_KERNEL} unionfs-modules-2.6-${LIVE_KERNEL} casper"

		# Deconfigure linux-image
		Patch_linux deapply

		# Install packages list
		if [ -n "${LIVE_PACKAGE_LIST}" ]
		then
			grep -v "^#" "${LIVE_PACKAGE_LIST}" > "${LIVE_CHROOT}"/root/"`basename ${LIVE_PACKAGE_LIST}`"
			Chroot_exec "xargs --arg-file=/root/`basename ${LIVE_PACKAGE_LIST}` apt-get install --yes --force-yes"
			rm -f "${LIVE_CHROOT}"/root/"`basename ${LIVE_PACKAGE_LIST}`"
		fi

		# Install extra packages
		if [ -n "${LIVE_PACKAGES}" ]
		then
			Chroot_exec "apt-get install --yes --force-yes ${LIVE_PACKAGES}"
		fi

		# Copy external directory into the chroot
		if [ -d "${LIVE_INCLUDE_CHROOT}" ]
		then
			cd "${LIVE_INCLUDE_CHROOT}"
			find . | cpio -pumd "${LIVE_CHROOT}"
			cd "${OLDPWD}"
		fi

		# Process flavour specific hooks
		if [ -r "${BASE}"/hooks/"${LIVE_FLAVOUR}" ]
		then
			grep -v "^#" "${BASE}"/hooks/"${LIVE_FLAVOUR}" > "${LIVE_CHROOT}"/root/"${LIVE_FLAVOUR}"
			Chroot_exec "sh /root/${LIVE_FLAVOUR}"
			rm -f "${LIVE_CHROOT}"/root/"${LIVE_FLAVOUR}"
		fi

		# Execute extra command in the chroot
		if [ -r "${LIVE_HOOK}" ]
		then
			# FIXME
			Chroot_exec "`cat ${LIVE_HOOK}`"
		elif [ -n "${LIVE_HOOK}" ]
		then
			Chroot_exec "${LIVE_HOOK}"
		fi

		# Temporary hacks for broken packages
		Hack_xorg

		# Add filesystem.manifest
		Chroot_exec "dpkg-query -W \*" | awk '$2 ~ /./ {print $1 " " $2 }' > "${LIVE_ROOT}"/filesystem.manifest

		if [ ! -z "${LIVE_MANIFEST}" ]
		then
			Chroot_exec "apt-get install --yes --force-yes ${LIVE_MANIFEST}"
			Chroot_exec "dpkg-query -W \*" | awk '$2 ~ /./ {print $1 " " $2 }' > "${LIVE_ROOT}"/filesystem.manifest-desktop
		fi

		# Remove unused packages
		Chroot_exec "apt-get remove --purge --yes cdebootstrap-helper-diverts"

		# Clean apt packages cache
		rm -rf "${LIVE_CHROOT}"/var/cache/apt
		mkdir -p "${LIVE_CHROOT}"/var/cache/apt/archives/partial

		# Remove cdebootstrap packages cache
		rm -rf "${LIVE_CHROOT}"/var/cache/bootstrap

		# Unmount proc
		umount "${LIVE_CHROOT}"/proc

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		Patch_runlevel deapply
		Patch_chroot deapply

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/chroot
	fi
}
