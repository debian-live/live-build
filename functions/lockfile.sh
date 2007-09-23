#!/bin/sh

# lockfile.sh - handle lock files

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

	# Creating lock file
	trap "test -f ${LOCKFILE} && \
	rm -f ${LOCKFILE}; exit 0" 0 2 15

	touch "${LOCKFILE}"
}
