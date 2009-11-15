# scripts/01-chroot.sh

chroots ()
{
	# Execute commands chrooted
	chroot "${LIVE_CHROOT}" /usr/bin/env -i HOME="/root" \
		PATH="/usr/sbin:/usr/bin:/sbin:/bin" TERM="${TERM}" \
		ftp_proxy="${LIVE_FTPPROXY}" http_proxy="${LIVE_HTTPPROXY}" \
		DEBIAN_PRIORITY="critical" ${1}
	#DEBIAN_FRONTEND=non-interactive DEBIAN_PRIORITY=critical
	# FIXME: setting DEBIAN_FRONTEND to non-interactive seems not to work.
}

Chroot ()
{
	# Configure chroot
	Patch_chroot apply

	# Configure network
	Patch_network apply

	# Configure /etc/apt/sources.list
	echo "deb ${LIVE_MIRROR} ${LIVE_DISTRIBUTION} ${LIVE_SECTIONS}" > \
		"${LIVE_CHROOT}"/etc/apt/sources.list
	chroots "apt-get update"

	# Install gnupg
	chroots "apt-get install --yes --force-yes gnupg wget"

	# Import archive signing key
	if [ ! -z "${LIVE_MIRROR_KEY}" ]
	then
		chroots "wget ${LIVE_MIRROR_KEY}"
		chroots "apt-key add `basename ${LIVE_MIRROR_KEY}`"
		chroots "rm -f `basename ${LIVE_MIRROR_KEY}`"
	fi

	# Add other repository
	if [ ! -z "${LIVE_REPOSITORY}" ]
	then
		# Configure /etc/apt/sources.list
		echo "deb ${LIVE_REPOSITORY}" >> \
			"${LIVE_CHROOT}"/etc/apt/sources.list

		# Import archive signing key
		if [ ! -z "${LIVE_REPOSITORY_KEY}" ]
		then
			chroots "wget ${LIVE_REPOSITORY_KEY}"
			chroots "apt-key add `basename ${LIVE_REPOSITORY_KEY}`"
			chroots "rm -f `basename ${LIVE_REPOSITORY_KEY}`"
		fi
	fi

	# Update indices
	chroots "apt-get update"

	# Configure linux-image
	Patch_linuximage apply

	# Install linux-image
	chroots "apt-get install --yes linux-image-2.6-${LIVE_LINUX}"
	chroots "apt-get install --yes --force-yes casper \
		squashfs-modules-2.6-${LIVE_LINUX} \
		unionfs-modules-2.6-${LIVE_LINUX}"

	# Rebuild initial ramdisk
	chroots "dpkg-reconfigure `basename ${LIVE_CHROOT}/var/lib/dpkg/info/linux-image-2.6.*-${LIVE_LINUX}.postinst .postinst`"

	# Deconfigure linux-image
	Patch_linuximage deapply

	# --- Begin FIXME ---
	if [ -d "${LIVE_CLONE}" ]
	then
		# swapping chroots
		LIVE_TMP="${LIVE_CHROOT}"
		LIVE_CHROOT="${LIVE_CLONE}"

		# get info
		chroots "apt-get install --yes debconf-utils"
		chroots "debconf-get-selections" > "${LIVE_ROOT}"/preseed.cloned
		chroots "dpkg --get-selections" | grep -v deinstall | cut -f1 > "${LIVE_ROOT}"/package-list.cloned

		# swapping out
		LIVE_CHROOT="${LIVE_TMP}"

		LIVE_PRESEED="${LIVE_ROOT}"/preseed.cloned 
		LIVE_PACKAGE_LIST="${LIVE_ROOT}"/package-list.cloned
	fi

	if [ -f "${LIVE_PRESEED}" ]
	then
		chroots "apt-get install --yes debconf-utils"
		cp ${LIVE_PRESEED} ${LIVE_CHROOT}/tmp/preseed
		chroots "debconf-set-selections /tmp/preseed"
		rm ${LIVE_CHROOT}/tmp/preseed
	fi

	if [ -z "${LIVE_ROOTFS}" ]
	then
		# Install packages list
		if [ ! -z "${LIVE_PACKAGE_LIST}" ]
		then
			chroots "apt-get install --yes `cat ${LIVE_PACKAGE_LIST}`"
		fi

		# Install extra packages
		if [ ! -z "${LIVE_PACKAGES}" ]
		then
			chroots "apt-get install --yes ${LIVE_PACKAGES}"
		fi
	fi

	# Copy external path into the chroot
	if [ -d "${LIVE_INCLUDE_ROOTFS}" ]
	then
		cd "${LIVE_INCLUDE_ROOTFS}"
		find . | cpio -pumd "${LIVE_CHROOT}"/
		cd "${OLDPWD}"
	fi

	# Execute extra command in the chroot
	if [ ! -z "${LIVE_HOOK}" ]
	then
		chroots "${LIVE_HOOK}"
	fi

	# Add splashy and conditionally a theme
	if [ ! -z "${LIVE_SPLASHY}" ]
        then
		chroots "apt-get install --yes splashy splashy-themes"

		if [ ! -z "${LIVE_SPLASHY_THEME}" ]
		then
			# not already installed ? Then its a new theme to install!
			if [ ! -d "${LIVE_CHROOT}"/etc/splashy/themes/"${LIVE_SPLASHY_THEME}" ]
			then
				if [ -f "${LIVE_SPLASHY_THEME}".tar.gz ]
				then
					cp "${LIVE_SPLASHY_THEME}".tar.gz "${LIVE_CHROOT}"/tmp/"${LIVE_SPLASHY_THEME}".tar.gz # this permits simlink to theme
					chroots "splashy_config -i /tmp/${LIVE_SPLASHY_THEME}.tar.gz"
					rm "${LIVE_CHROOT}"/tmp/"${LIVE_SPLASHY_THEME}".tar.gz
					chroots "splashy_config -s ${LIVE_SPLASHY_THEME}"
				else
					echo "Specify the local splashy theme without extension, it also must be in the cwd"
				fi
			else
				chroots "splashy_config -s ${LIVE_SPLASHY_THEME}"
			fi
		fi
	fi
	# --- End FIXME ---

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
	Patch_chroot deapply
}
