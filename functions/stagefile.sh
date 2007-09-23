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
	FILE="${1}"
	NAME="`basename ${1}`"

	# Checking stage file
	if [ -f "${FILE}" ]
	then
		if [ "${LH_FORCE}" = "enabled" ]
		then
			# Forcing execution
			rm -f "${FILE}"
		else
			# Skipping execution
			Echo_warning "skipping ${NAME}"
			exit 0
		fi
	fi
}

Create_stagefile ()
{
	FILE="${1}"
	DIRECTORY="`dirname ${1}`"

	# Creating stage directory
	if [ ! -d "${DIRECTORY}" ]
	then
		mkdir -p "${DIRECTORY}"
	fi

	# Creating stage file
	touch "${FILE}"
}

Require_stagefile ()
{
	FILE="${1}"
	NAME="`basename ${1}`"

	# Checking stage file
	if [ ! -f "${FILE}" ]
	then
		Echo_error "${NAME} missing"
		exit 1
	fi
}
