#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2015 Daniel Baumann <mail@daniel-baumann.ch>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


Check_lockfile ()
{
	FILE="${1}"

	if [ -z "${FILE}" ]
	then
		FILE=".build/lock"
	fi

	# Checking lock file
	if [ -f "${FILE}" ]
	then
		Echo_error "${PROGRAM} locked"
		exit 1
	fi
}

Create_lockfile ()
{
	FILE="${1}"

	if [ -z "${FILE}" ]
	then
		FILE=".build/lock"
	fi

	DIRECTORY="$(dirname ${FILE})"

	# Creating lock directory
	mkdir -p "${DIRECTORY}"

	# Creating lock trap
	trap 'ret=${?}; '"rm -f \"${FILE}\";"' exit ${ret}' EXIT HUP INT QUIT TERM

	# Creating lock file
	touch "${FILE}"
}
