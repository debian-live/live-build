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
	chroot "${LIVE_CHROOT}" /usr/bin/env -i HOME="/root" PATH="/usr/sbin:/usr/bin:/sbin:/bin" TERM="${TERM}" ftp_proxy="${LIVE_PROXY_FTP}" http_proxy="${LIVE_PPROXY_HTTP}" DEBIAN_FRONTEND="${LIVE_DEBCONF_FRONTEND}" DEBIAN_PRIORITY="${LIVE_DEBCONF_PRIORITY}" ${1}
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

		# Avoid daemon starting
		cat  > "${LIVE_CHROOT}"/usr/sbin/policy-rc.d <<EOF
#!/bin/sh
echo
echo "Warning: invoke-rc.d policy in action. Skiping daemon starting"

exit 101
EOF
		chmod 755 "${LIVE_CHROOT}"/usr/sbin/policy-rc.d

		# Configure sources.list
		Indices custom initial

		# Install aptitude
		Chroot_exec "apt-get install --yes --force-yes aptitude"

		# Install secure apt
		if [ "${LIVE_DISTRIBUTION}" = "unstable" ] || [ "${LIVE_DISTRIBUTION}" = "${CODENAME_UNSTABLE}" ] || \
		   [ "${LIVE_DISTRIBUTION}" = "testing" ] || [ "${LIVE_DISTRIBUTION}" = "${CODENAME_TESTING}" ]
		then
			if [ "${LIVE_FLAVOUR}" != "minimal" ]
			then
				Chroot_exec "apt-get install --yes --force-yes ${LIVE_REPOSITORY_KEYRING}"

				for NAME in ${LIVE_REPOSITORIES}
				do
					eval REPOSITORY_KEY="$`echo LIVE_REPOSITORY_KEY_$NAME`"
					eval REPOSITORY_KEYRING="$`echo LIVE_REPOSITORY_KEYRING_$NAME`"

					if [ -n "${REPOSITORY_KEYRING}" ]
					then
						Chroot_exec "aptiude install ${REPOSITORY_KEYRING}"
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
		Chroot_exec "aptitude update"

		# Configure linux-image
		Patch_linux apply

		# Install linux-image, modules and casper
		Chroot_exec "aptitude install --assume-yes ${LIVE_KERNEL_PACKAGES} casper"

		# Deconfigure linux-image
		Patch_linux deapply

		# Cloning existing system configuration
		if [ -d "${LIVE_CLONE}" ]
		then
			# Swapping chroot directories
			LIVE_CHROOT_TMP="${LIVE_CHROOT}"
			LIVE_CHROOT="${LIVE_CLONE}"

			# Extract debconf settings
			Chroot_exec "aptitude install --assume-yes debconf-utils"
			Chroot_exec "debconf-get-selections" > "${LIVE_ROOT}"/preseed.cloned

			# Extract package selection
			Chroot_exec "dpkg --get-selections" | grep -v deinstall | cut -f1 > "${LIVE_ROOT}"/package-list.cloned

			# Restoring chroot directories
			LIVE_CHROOT="${LIVE_CHROOT_TMP}"
			LIVE_CHROOT_TMP=""

			LIVE_PRESEED="${LIVE_ROOT}/preseed.cloned"
			LIVE_PACKAGE_LIST_CLONED="${LIVE_ROOT}/package-list.cloned"
		fi

		# Restore preseed configuration
		if [ -f "${LIVE_PRESEED}" ]
		then
			Chroot_exec "aptitude install --assume-yes debconf-utils"
			cp "${LIVE_PRESEED}" "${LIVE_CHROOT}"/root/preseed
			Chroot_exec "debconf-set-selections /root/preseed"
			rm -f "${LIVE_CHROOT}"/root/preseed
		else
			if [ -n "${LIVE_PRESEED}" ]; then
				echo "'${LIVE_PRESEED}' file doesn't exists. Exiting..."
				exit 1
			fi
		fi

		# Restore cloned package selection
		if [ -f "${LIVE_PACKAGE_LIST_CLONED}" ]
		then
			Chroot_exec "xargs --arg-file=/root/`basename ${LIVE_PACKAGE_LIST_CLONED}` aptitude install --assume-yes"
		fi

		# Install packages list
		if [ -n "${LIVE_PACKAGE_LIST}" ]
		then
			grep -v "^#" "${LIVE_PACKAGE_LIST}" > "${LIVE_CHROOT}"/root/"`basename ${LIVE_PACKAGE_LIST}`"
			Chroot_exec "xargs --arg-file=/root/`basename ${LIVE_PACKAGE_LIST}` aptitude install --assume-yes"
			rm -f "${LIVE_CHROOT}"/root/"`basename ${LIVE_PACKAGE_LIST}`"
		fi

		# Install extra packages
		if [ -n "${LIVE_PACKAGES}" ]
		then
			Chroot_exec "aptitude install --assume-yes ${LIVE_PACKAGES}"
		fi

		# Install aptitude tasks
		if [ -n "${LIVE_TASKS}" ]
		then
			for TASK in ${LIVE_TASKS}
			do
				Chroot_exec "aptitude install --assume-yes ${TASK}"
			done
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
			LIVE_DEBCONF_FRONTEND="readline" LIVE_DEBCONF_PRIORITY="low" Chroot_exec "sh /root/${LIVE_FLAVOUR}"
			rm -f "${LIVE_CHROOT}"/root/"${LIVE_FLAVOUR}"
		fi

		# Execute extra command in the chroot
		if [ -r "${LIVE_HOOK}" ]
		then
			# FIXME
			LIVE_DEBCONF_FRONTEND="readline" LIVE_DEBCONF_PRIORITY="low" Chroot_exec "`cat ${LIVE_HOOK}`"
		elif [ -n "${LIVE_HOOK}" ]
		then
			LIVE_DEBCONF_FRONTEND="readline" LIVE_DEBCONF_PRIORITY="low" Chroot_exec "${LIVE_HOOK}"
		fi

		# Save package list
		Chroot_exec "dpkg --get-selections" > "${LIVE_ROOT}"/packages.txt

		# Add filesystem.manifest
		Chroot_exec "dpkg-query -W \*" | awk '$2 ~ /./ {print $1 " " $2 }' > "${LIVE_ROOT}"/filesystem.manifest

		if [ ! -z "${LIVE_MANIFEST}" ]
		then
			Chroot_exec "aptitude install --assume-yes ${LIVE_MANIFEST}"
			Chroot_exec "dpkg-query -W \*" | awk '$2 ~ /./ {print $1 " " $2 }' > "${LIVE_ROOT}"/filesystem.manifest-desktop
		fi

		# Clean apt packages cache
		rm -rf "${LIVE_CHROOT}"/var/cache/apt
		mkdir -p "${LIVE_CHROOT}"/var/cache/apt/archives/partial

		if [ "${LIVE_FLAVOUR}" = "minimal" ]
		then
			rm -f "${LIVE_CHROOT}"/var/lib/apt/lists/*
			rm -f "${LIVE_CHROOT}"/var/lib/dpkg/available-old
			rm -f "${LIVE_CHROOT}"/var/lib/dpkg/diversions-old
			rm -f "${LIVE_CHROOT}"/var/lib/dpkg/statoverride-old
			rm -f "${LIVE_CHROOT}"/var/lib/dpkg/status-old
		fi

		# Workaround binfmt-support /proc locking
		umount "${LIVE_CHROOT}"/proc/sys/fs/binfmt_misc > /dev/null || true

		# Unmount proc
		umount "${LIVE_CHROOT}"/proc

		# Allow daemon starting
		rm "${LIVE_CHROOT}"/usr/sbin/policy-rc.d

		# Deconfigure network
		Patch_network deapply

		# Deconfigure chroot
		Patch_runlevel deapply
		Patch_chroot deapply

		# Touching stage file
		touch "${LIVE_ROOT}"/.stage/chroot
	fi
}
