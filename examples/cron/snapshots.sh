#!/bin/sh

# Needs: build-essential fakeroot lsb-release git-core [...]

# Static variables
PACKAGES="live-helper live-initramfs live-initscripts live-webhelper"

DEBEMAIL="debian-live-devel@lists.alioth.debian.org"
EMAIL="debian-live-devel@lists.alioth.debian.org"
DEBFULLNAME="Debian Live Autobuilder"
NAME="Debian Live Autobuilder"

export DEBEMAIL EMAIL DEBFULLNAME NAME

TEMPDIR="/srv/tmp/snapshots"
SERVER="/srv/debian-unofficial/ftp/debian-live-snapshots"

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

echo "$(date +%b\ %d\ %H:%M:%S) ${HOSTNAME} live-helper: begin snapshot build." >> /var/log/live

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
	git clone git://git.debian.org/git/users/daniel/${PACKAGE}.git

	# Getting version
	cd "${TEMPDIR}"/${PACKAGE}
	VERSION="$(dpkg-parsechangelog | awk '/Version:/ { print $2 }' | awk -F- '{ print $1 }')"

	# Getting revision
	cd "${TEMPDIR}"/${PACKAGE}
	REVISION="$(git log | grep -m1 Date | awk -FDate: '{ print $2 }' | sed -e 's/+.*$//')"
	REVISION="$(date -d "${REVISION}" +%Y%m%d.%H%M%S)"

	# Check for existing package
	if [ ! -f "${SERVER}"/${PACKAGE}_${VERSION}~${REVISION}.dsc ] || [ "${1}" = "--force" ]
	then
		UPDATE_INDICES="true"

		# Renaming directory
		mv "${TEMPDIR}"/${PACKAGE} "${TEMPDIR}"/${PACKAGE}-${VERSION}~${REVISION}

		# Building package
		cd "${TEMPDIR}"/${PACKAGE}-${VERSION}~${REVISION}
		rm -rf .git
		dch --force-bad-version --newversion ${VERSION}~${REVISION} --distribution UNRELEASED Autobuild snapshot of SVN r${REVISION}.
		dpkg-buildpackage -rfakeroot -sa -uc -us

		# Removing sources
		rm -rf "${TEMPDIR}"/${PACKAGE}-${VERSION}~${REVISION}

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

	# Updating binary indices
	apt-ftparchive packages ./ > Packages
	gzip -9 -c Packages > Packages.gz

	# Updating source indices
	apt-ftparchive sources ./ > Sources
	gzip -9 -c Sources > Sources.gz
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

echo "$(date +%b\ %d\ %H:%M:%S) ${HOSTNAME} live-helper: end snapshot build." >> /var/log/live
