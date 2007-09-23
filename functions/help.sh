#!/bin/sh

# help.sh - print help information
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Help ()
{
	echo "${PROGRAM} - ${DESCRIPTION}"
	echo
	echo "Usage:"
	echo

	if [ -n "${USAGE}" ]
	then
		echo -e "${USAGE}"
		echo
	fi

	echo "  ${PROGRAM} [-h|--help]"
	echo "  ${PROGRAM} [-u|--usage]"
	echo "  ${PROGRAM} [-v|--version]"
	echo

	if [ -n "${HELP}" ]
	then
		echo "${HELP}"
		echo
	fi

	echo "Report bugs to Debian Live project <http://debian-live.alioth.debian.org/>."
	exit 0
}
