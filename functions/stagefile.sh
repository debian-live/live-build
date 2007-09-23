#!/bin/sh

# stagefile.sh - handle stage files
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Check_stagefile ()
{
	STAGEFILE="${1}"
	STAGENAME="`basename ${1}`"

	# Checking stage file
	if [ -f "${STAGEFILE}" ]
	then
		if [ "${FORCE}" = "true" ]
		then
			# Forcing execution
			rm -f "${STAGEFILE}"
		else
			# Skipping execution
			echo "W: skipping ${STAGENAME}"
			exit 0
		fi
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
