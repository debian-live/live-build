#!/bin/sh

# stagefile.sh - handle stage files

set -e

Check_stagefile ()
{
	STAGEFILE="${1}"
	STAGENAME="`basename ${1}`"

	# Checking stage file
	if [ -f "${STAGEFILE}" ]
	then
		echo "W: skipping ${STAGENAME}"
		exit 0
	fi
}

Create_stagefile ()
{
	STAGEFILE="${1}"
	STAGEDIRECTORY="`dirname ${1}`"

	# Creating stage directory
	if [ ! -d "${STAGEDIRECTORY}" ]
	then
		mkdir -p "${STAGEDIRECTORY}"
	fi

	# Creating stage file
	touch "${STAGEFILE}"
}

Require_stagefile ()
{
	STAGEFILE="${1}"
	STAGENAME="`basename ${1}`"

	# Checking stage file
	if [ ! -f "${STAGEFILE}" ]
	then
		echo "E: ${STAGENAME} missing"
		exit 1
	fi
}
