#!/bin/sh

# usage.sh - handle usage information

Usage ()
{
	echo "${PROGRAM} - ${DESCRIPTION}"
	echo
	echo "${USAGE}"
	echo "Usage: ${PROGRAM} [-h|--help]"
	echo "Usage: ${PROGRAM} [-u|--usage]"
	echo "Usage: ${PROGRAM} [-v|--version]"
	echo
	echo "Try \"${PROGRAM} --help\" for more information."
	exit 1
}
