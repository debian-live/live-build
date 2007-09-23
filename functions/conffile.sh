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
	FILE="${1}"

	if [ -f "${FILE}" ]
	then
		if [ -r "${FILE}" ]
		then
			Echo_debug "Reading configuration file ${FILE}"
			. "${FILE}"
		else
			Echo_warning "Failed to read configuration file ${FILE}"
		fi
	fi
}
