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
	FILE="${1}"

	# Checking lock file
	if [ -f "${FILE}" ]
	then
		Echo_error "system locked"
		exit 1
	fi
}

Create_lockfile ()
{
	FILE="${1}"
	DIRECTORY="`dirname ${1}`"

	# Creating lock directory
	if [ ! -d "${DIRECTORY}" ]
	then
		mkdir -p "${DIRECTORY}"
	fi

	# Creating lock trap
	trap "test -f ${FILE} && rm -f ${FILE}; exit 0" 0 1 2 3 9 15

	# Creating lock file
	touch "${FILE}"
}
