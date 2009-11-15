#!/bin/sh -e

# Static variables
if [ -n "${1}" ]
then
	PACKAGES="${@}"
else
	PACKAGES="live-helper live-initramfs live-initscripts live-webhelper live-magic debian-unofficial-archive-keyring"
fi

DEBEMAIL="debian-live-devel@lists.alioth.debian.org"
EMAIL="debian-live-devel@lists.alioth.debian.org"
DEBFULLNAME="Debian Live Autobuilder"
NAME="Debian Live Autobuilder"
KEY="FDB8D39A"

export DEBEMAIL EMAIL DEBFULLNAME NAME KEY

TEMPDIR="$(mktemp -d -t debian-live.XXXXXXXX)"
SERVER="/mnt/daniel1/srv/debian-unofficial/live/debian"
LOGFILE="${SERVER}/build.log"

DATE_START="$(date -R)"

# Checking lock file
if [ -f "${SERVER}"/Archive-Update-in-Progress ]
then
	echo "E: locked."
	exit 1
fi

# Creating server directory
if [ ! -d "${SERVER}" ]
then
	mkdir -p "${SERVER}"
fi

# Creating lock trap
trap "test -f ${SERVER}/Archive-Update-in-Progress && rm -f ${SERVER}/Archive-Update-in-Progress; exit 0" 0 1 2 3 9 15

# Creating lock file
echo "${DATE_START}" > "${SERVER}"/Archive-Update-in-Progress

echo "$(date +%b\ %d\ %H:%M:%S) ${HOSTNAME} live-snapshots: begin build." >> "${LOGFILE}"

# Processing packages
for PACKAGE in ${PACKAGES}
do
	# Cleaning build directory
	if [ -d "${TEMPDIR}" ]
	then
		rm -rf "${TEMPDIR}"
	fi

	# Creating build directory
	mkdir -p "${TEMPDIR}"

	# Getting sources
	cd "${TEMPDIR}"

	case "${PACKAGE}" in
		debian-unofficial-archive-keyring)
			git clone git://git.debian.net/git/${PACKAGE}.git
			;;

		live-magic)
			git clone git://git.debian.org/git/users/lamby-guest/${PACKAGE}.git
			;;

		*)
			git clone git://git.debian.org/git/users/daniel/${PACKAGE}.git
			;;
	esac

	# Getting version
	cd "${TEMPDIR}"/${PACKAGE}

	for BRANCH in debian
	do
		if [ -n "$(git branch -r | grep ${BRANCH})" ]
		then
			git checkout -b ${BRANCH} origin/${BRANCH} || true
		fi
	done

	VERSION="$(dpkg-parsechangelog | awk '/Version:/ { print $2 }' | awk -F- '{ print $1 }')"

	# Getting revision
	cd "${TEMPDIR}"/${PACKAGE}
	REVISION="$(git log | grep -m1 Date | awk -FDate: '{ print $2 }' | awk '{ print $1 ",", $3, $2, $5, $4, $6 }')"
	REVISION="$(date -d "${REVISION}" +%Y%m%d.%H%M%S)"

	# Check for existing package
	if [ ! -f "${SERVER}"/${PACKAGE}_${VERSION}+${REVISION}.dsc ] || [ "${1}" = "--force" ]
	then
		UPDATE_INDICES="true"

		# Renaming directory
		mv "${TEMPDIR}"/${PACKAGE} "${TEMPDIR}"/${PACKAGE}-${VERSION}+${REVISION}

		# Building package
		cd "${TEMPDIR}"/${PACKAGE}-${VERSION}+${REVISION}
		rm -rf .git
		dch --force-bad-version --newversion ${VERSION}+${REVISION} --distribution UNRELEASED Autobuild snapshot of git ${REVISION}.
		dpkg-buildpackage -rfakeroot -k${KEY} -sa

		# Removing sources
		rm -rf "${TEMPDIR}"/${PACKAGE}-${VERSION}+${REVISION}

		# Creating directory
		mkdir -p "${SERVER}"

		# Removing old packages
		if [ -f "${SERVER}"/"${PACKAGE}"*.changes ]
		then
			for FILE in $(awk {'print $5'} "${SERVER}"/"${PACKAGE}"*.changes | grep -e ".*\.deb$" -e ".*\.diff.gz$" -e ".*\.dsc$" -e ".*\.tar.gz$" -e ".*\.udeb$")
			do
				rm -f "${SERVER}"/"${FILE}"
			done
		fi

		rm -f "${SERVER}"/"${PACKAGE}"*.changes

		# Installing new packages
		for FILE in $(awk {'print $5'} "${TEMPDIR}"/"${PACKAGE}"*.changes | grep -e ".*\.deb$" -e ".*\.diff.gz$" -e ".*\.dsc$" -e ".*\.tar.gz$" -e ".*\.udeb$")
		do
			mv "${TEMPDIR}"/"${FILE}" "${SERVER}"
		done

		mv "${TEMPDIR}"/"${PACKAGE}"*.changes "${SERVER}"
	else
		# Remove sources
		rm -rf "${TEMPDIR}"/${PACKAGE}
	fi
done

if [ "${UPDATE_INDICES}" = "true" ]
then
	LAST_UPDATE="$(date -R)"

	cd "${SERVER}"

	apt-ftparchive packages . /dev/null > Packages
	gzip -9 -c Packages > Packages.gz
	bzip2 -9 -c Packages > Packages.bz2

	apt-ftparchive sources . /dev/null > Sources
	gzip -9 -c Sources > Sources.gz
	bzip2 -9 -c Sources > Sources.bz2

	if [ -f release.conf ]
	then
		apt-ftparchive -c release.conf -o APT::FTPArchive::Release::Description="Last updated: `date -R`" release ./ >> Release.tmp
		mv Release.tmp Release

		rm -f Release.gpg
		gpg --default-key ${KEY} --quiet --output Release.gpg -ba Release
	fi
fi

# Reading timestamp
if [ -z "${LAST_UPDATE}" ]
then
	LAST_UPDATE="$(awk -F: '/Last update:/ { print $2":"$3":"$4 }' ${SERVER}/LAST_BUILD | sed -e 's/    //')"
fi

# Writing timestamp
cat > "${SERVER}"/LAST_BUILD << EOF
Last run begin: ${DATE_START}
Last run end:   $(date -R)

Last update:    ${LAST_UPDATE}
EOF

# Removing build directory
rm -rf "${TEMPDIR}"

# Fixing permissions
chmod 0644 "${SERVER}"/*
chmod 0766 "${SERVER}"/*.sh

echo "$(date +%b\ %d\ %H:%M:%S) ${HOSTNAME} live-snapshots: end build." >> "${LOGFILE}"
