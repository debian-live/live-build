#!/bin/sh

# Needs: build-essential fakeroot lsb-release svn [...]

# Static variables
PACKAGES="live-helper live-initramfs live-webbuilder"

DEBEMAIL="debian-live-devel@lists.alioth.debian.org"
EMAIL="debian-live-devel@lists.alioth.debian.org"
DEBFULLNAME="Debian Live Autobuilder"
NAME="Debian Live Autobuilder"

export DEBEMAIL EMAIL DEBFULLNAME NAME

TEMPDIR="/srv/tmp/svn-snapshots"
SERVER="/srv/debian-unofficial/ftp/debian-live/debian-snapshots"

DATE_START="`date -R`"

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
	svn co svn://svn.debian.org/debian-live/dists/trunk/${PACKAGE} ${PACKAGE}

	# Getting version
	cd "${TEMPDIR}"/${PACKAGE}
	VERSION="`dpkg-parsechangelog | awk '/Version:/ { print $2 }' | awk -F- '{ print $1 }'`"

	# Getting revision
	cd "${TEMPDIR}"/${PACKAGE}
	REVISION="`svn info | awk '/Last Changed Rev:/ { print $4 }'`"

	# Check for existing package
	if [ ! -f "${SERVER}"/${PACKAGE}_${VERSION}~${REVISION}.dsc ] || [ "${1}" = "--force" ]
	then
		UPDATE_INDICES="true"

		# Renaming directory
		mv "${TEMPDIR}"/${PACKAGE} "${TEMPDIR}"/${PACKAGE}-${VERSION}~${REVISION}

		# Building package
		cd "${TEMPDIR}"/${PACKAGE}-${VERSION}~${REVISION}
		find . -type d -name .svn | xargs rm -rf
		dch --force-bad-version --newversion ${VERSION}~${REVISION} --distribution UNRELEASED Autobuild snapshot of SVN r${REVISION}.
		dpkg-buildpackage -rfakeroot -sa -uc -us

		# Removing sources
		rm -rf "${TEMPDIR}"/${PACKAGE}-${VERSION}~${REVISION}

		# Creating directory
		if [ ! -d "${SERVER}" ]
		then
			mkdir -p "${SERVER}"
		fi

		# Removing old packages
		if ls "${SERVER}"/"${PACKAGE}"* &> /dev/null
		then
			rm -f "${SERVER}"/"${PACKAGE}"*
		fi

		# Moving packages
		mv "${TEMPDIR}"/${PACKAGE}* "${SERVER}"
	else
		# Remove sources
		rm -rf "${TEMPDIR}"/${PACKAGE}
	fi
done

if [ "${UPDATE_INDICES}" = "true" ]
then
	LAST_UPDATE="`date -R`"

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
	LAST_UPDATE="`awk -F: '/Last update:/ { print $2":"$3":"$4 }' ${SERVER}/LAST_BUILD | sed -e 's/    //'`"
fi

# Writing timestamp
cat > "${SERVER}"/LAST_BUILD << EOF
Last run begin: ${DATE_START}
Last run end:   `date -R`

Last update:    ${LAST_UPDATE}
EOF

# Removing build directory
rm -rf "${TEMPDIR}"
