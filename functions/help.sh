#!/bin/sh

# help.sh - handle help information

Help ()
{
	echo "${PROGRAM} - ${DESCRIPTION}"
	echo
	echo "${USAGE}"
	echo "Usage: ${PROGRAM} [-h|--help]"
	echo "Usage: ${PROGRAM} [-u|--usage]"
	echo "Usage: ${PROGRAM} [-v|--version]"
	echo
	echo "${HELP}"
	echo
	echo "Report bugs to Debian Live project <http://debian-live.alioth.debian.org/>."
	exit 0
}
