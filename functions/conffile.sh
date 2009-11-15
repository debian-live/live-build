#!/bin/sh

# conffile.sh - handle configuration files

set -e

Read_conffile ()
{
	CONFFILE="${1}"

	# Reading configuration file
	if [ -r "${CONFFILE}" ]
	then
		. "${CONFFILE}"
	fi
}
