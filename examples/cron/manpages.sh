#!/bin/sh

# Needs: man2html svn

# Static variables
PACKAGES="live-helper live-initramfs live-initscripts live-webhelper"

TEMPDIR="/srv/tmp/manpages"
SERVER="/srv/debian-live/www/other/manpages"

DATE_START="`date -R`"

# Checking lock file
if [ -f "${SERVER}"/lock ]
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
trap "test -f ${SERVER}/lock && rm -f ${SERVER}/lock; exit 0" 0 1 2 3 9 15

# Creating lock file
echo "${DATE_START}" > "${SERVER}"/lock

echo "`date +%b\ %d\ %H:%M:%S` ${HOSTNAME} live-helper: begin manpage build." >> /var/log/live

# Remove old manpages
rm -f "${SERVER}"/*.html

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

	# Building manpages
	for MANPAGE in "${TEMPDIR}"/${PACKAGE}/manpages/*
	do
		man2html -D "${SERVER}"/ -r ${MANPAGE} | \
			sed -e "s#Content-type: text/html##" \
			    -e 's#HREF="../index.html"#HREF="./"#' \
			    -e 's#HREF="../man1/#HREF="#g' \
			    -e 's#HREF="../man2/#HREF="#g' \
			    -e 's#HREF="../man3/#HREF="#g' \
			    -e 's#HREF="../man4/#HREF="#g' \
			    -e 's#HREF="../man5/#HREF="#g' \
			    -e 's#HREF="../man6/#HREF="#g' \
			    -e 's#HREF="../man7/#HREF="#g' \
			    -e 's#HREF="../man8/#HREF="#g' \
			    -e 's#HREF="../man9/#HREF="#g' \
			    -e 's#/cgi-bin/man/man2html#http://packages.debian.org/man2html#' \
			> "${SERVER}"/`basename ${MANPAGE}`.html
	done

	# Removing sources
	rm -rf "${TEMPDIR}"/${PACKAGE}

	cd "${OLDPWD}"
done

# Creating symlinks
for NUMBER in 1 2 3 4 5 6 7 8 9
do
	for MANPAGE in "${SERVER}"/*.en.${NUMBER}.html
	do
		if [ -f "${MANPAGE}" ]
		then
			ln -s `basename ${MANPAGE}` "${SERVER}"/`basename ${MANPAGE} .en.${NUMBER}.html`.${NUMBER}.html
		fi
	done
done

# Writing timestamp
cat > "${SERVER}"/LAST_BUILD << EOF
Last run begin: ${DATE_START}
Last run end:   `date -R`
EOF

# Removing build directory
rm -rf "${TEMPDIR}"

echo "`date +%b\ %d\ %H:%M:%S` ${HOSTNAME} live-helper: end manpage build." >> /var/log/live
