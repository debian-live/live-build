#!/bin/sh

# lockfile.sh - handle lock files
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
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
	DIRECTORY="$(dirname ${1})"

	# Creating lock directory
	mkdir -p "${DIRECTORY}"

	# Creating lock trap
	trap 'ret=${?}; '"rm -f \"${FILE}\";"' exit ${ret}' EXIT

	# Creating lock file
	touch "${FILE}"
}
