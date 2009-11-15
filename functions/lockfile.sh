#!/bin/sh

# lockfile.sh - handle lock files
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Check_lockfile ()
{
	LOCKFILE="${1}"

	# Checking lock file
	if [ -f "${LOCKFILE}" ]
	then
		echo "E: system locked"
		exit 1
	fi
}

Create_lockfile ()
{
	LOCKFILE="${1}"
	LOCKDIRECTORY="`dirname ${1}`"

	# Creating lock directory
	if [ ! -d "${LOCKDIRECTORY}" ]
	then
		mkdir -p "${LOCKDIRECTORY}"
	fi

	# Creating lock trap
	trap "test -f ${LOCKFILE} && rm -f ${LOCKFILE}; exit 0" 0 2 15

	# Creating lock file
	touch "${LOCKFILE}"
}
