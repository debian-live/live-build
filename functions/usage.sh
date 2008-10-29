#!/bin/sh

# usage.sh - print usage information
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Usage ()
{
	Echo "%s - %s" "${PROGRAM}" "${DESCRIPTION}"
	echo
	Echo "Usage:"
	echo

	if [ -n "${USAGE}" ]
	then
		Echo " ${USAGE}"
		echo
	fi

	Echo "  %s [-h|--help]" "${PROGRAM}"
	Echo "  %s [-u|--usage]" "${PROGRAM}"
	Echo "  %s [-v|--version]" "${PROGRAM}"
	echo
	Echo "Try \" %s--help\" for more information." "${PROGRAM}"

	exit 1
}
