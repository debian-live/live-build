#!/bin/sh

# conffile.sh - handle configuration files
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Read_conffile ()
{
	CONFFILE="${1}"

	# Reading configuration file
	if [ -f "${CONFFILE}" ]
	then
		if [ -r "${CONFFILE}" ]
		then
			# Sourcing configurationfile
			. "${CONFFILE}"
		else
			echo "W: failed to read ${CONFFILE}"
		fi
	fi
}
