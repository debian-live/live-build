#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2015 Daniel Baumann <mail@daniel-baumann.ch>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


Help ()
{
        Echo "%s - %s" "${PROGRAM}" "${DESCRIPTION}"
	echo
	Echo "Usage:"
	echo

	if [ -n "${USAGE}" ]
	then
		Echo "${USAGE}"
		echo
	fi
	Echo "  %s [-h|--help]" "${PROGRAM}"
	Echo "  %s [-u|--usage]" "${PROGRAM}"
	Echo "  %s [-v|--version]" "${PROGRAM}"
	echo

	if [ -n "${HELP}" ]
	then
		Echo "${HELP}"
		echo
	fi

	Echo "Report bugs to the Live Systems project <http://live-systems.org/>."
	exit 0
}
