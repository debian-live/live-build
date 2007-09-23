#!/bin/sh

# conffile.sh - handle configuration files

set -e

Read_conffile ()
{
	CONFFILE="${1}"

	# Reading configuration file
	if [ -f "${CONFFILE}" ]
	then
		if [ -r "${CONFFILE}" ]
		then
			. "${CONFFILE}"
		else
			echo "W: failed to read ${CONFFILE}"
		fi
	fi
}
